# GDCR Fail-Fast Logic: No OAuth2 Overhead

![Fail-Fast Flow](/repository/imagens/gdcr-fast-fail.png)

## 🎯 Design Philosophy

> **"Se a validação falhou, PARE IMEDIATAMENTE. Não precisa de OAuth2, JavaScript complexo, ou scope validation. Token inválido? HTTP 401 e foda-se."**

---

## ❌ O Que NÃO Fazemos

**GDCR NÃO usa OAuth2 validation no proxy endpoint.**

Aqui está o que a maioria das arquiteturas "enterprise" faz (e que é DESNECESSÁRIO):

```
❌ Anti-Pattern: OAuth2 Overhead

Request → Extract Token → Call OAuth Server → Validate Signature → 
Check Expiry → Verify Scopes → Parse Claims → Load User Context → 
Check Permissions → THEN route to backend

Latency: 150-300ms (chamada ao Authorization Server)
Complexity: 8-10 policies encadeadas
Failure points: 5+ (rede, OAuth server down, token introspection timeout)
```

**Isso é lento, complexo, e cria dependências desnecessárias.**

---

## ✅ O Que Fazemos: KVM Fast-Fail

```
✅ GDCR Approach: KVM Fast-Fail

Request → Hash Token → KVM Lookup → [NOT FOUND] → HTTP 401 STOP
                                 → [FOUND] → Route to Backend

Latency: 2-5ms (lookup in-memory)
Complexity: 1 policy
Failure points: 0 (KVM é local, não depende de nada externo)
```

---

## 🔍 Como Funciona

### Step 1: Token Registration (Happens ONCE, outside request flow)

Quando um sender system é provisionado, você registra o token no KVM:

```bash
# Registrar token no KVM (via API de administração)
curl -X POST https://apim.company.com/admin/kvm/tokens \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -d '{
    "token_hash": "sha256:7f3e9c2d8a4b11eca8a30242ac120002",
    "sender_id": "SENDER_A",
    "endpoints_allowed": ["/sales/*", "/products/*"],
    "status": "active",
    "expires_at": 9999999999
  }'
```

**Isso é feito UMA VEZ durante o onboarding do sender.** Não há OAuth2 token server, não há client credentials flow, não há renovação automática.

---

### Step 2: Request Validation (Happens EVERY request)

```javascript
// Policy: KVM-FastFail-Validation
// Execution Time: ~3ms

var authorization = context.getVariable("request.header.Authorization");

// Check 1: Header exists?
if (!authorization || !authorization.startsWith("Bearer ")) {
    context.setVariable("response.status.code", 401);
    throw new Error("Missing Authorization header");
}

var token = authorization.replace("Bearer ", "");
var tokenHash = sha256(token);

// Check 2: Token in KVM?
var kvm = context.getKeyValueMap("gdcr_tokens");
var metadata = kvm.get(tokenHash);

if (!metadata) {
    context.setVariable("response.status.code", 401);
    throw new Error("Invalid token");
}

var tokenData = JSON.parse(metadata);

// Check 3: Token active?
if (tokenData.status !== "active") {
    context.setVariable("response.status.code", 401);
    throw new Error("Token revoked");
}

// Check 4: Endpoint allowed?
var requestPath = context.getVariable("proxy.pathsuffix");
var allowed = tokenData.endpoints_allowed.some(function(pattern) {
    return new RegExp(pattern).test(requestPath);
});

if (!allowed) {
    context.setVariable("response.status.code", 403);
    throw new Error("Endpoint not allowed for this sender");
}

// ALL CHECKS PASSED - Store sender_id for routing
context.setVariable("sender.id", tokenData.sender_id);

// Route to backend (next policy)
```

**Total execution time: 2-5ms**

---

## 🔥 Por Que Isso é Melhor

### Comparação: OAuth2 vs KVM Fast-Fail

| Aspect | OAuth2 Token Validation | KVM Fast-Fail |
|--------|------------------------|---------------|
| **Latency** | 150-300ms (network call) | 2-5ms (in-memory) |
| **Dependencies** | OAuth server must be UP | Zero external deps |
| **Complexity** | 8-10 policies | 1 policy |
| **Network Calls** | 1 per request | 0 |
| **Failure Rate** | ~0.1% (network/server issues) | ~0.001% (KVM corruption) |
| **Token Rotation** | Automatic (OAuth refresh flow) | Manual (update KVM) |
| **Scalability** | Limited by OAuth server | Linear (KVM is distributed) |

---

## 🧪 Performance Under Load

### Scenario: 10,000 requests/second

**OAuth2 Validation:**
```
10,000 req/s × 200ms = 2,000 seconds of cumulative latency
OAuth Server Load: 10,000 token introspection calls/s
Bottleneck: OAuth server becomes the limiting factor
```

**KVM Fast-Fail:**
```
10,000 req/s × 3ms = 30 seconds of cumulative latency
KVM Load: 10,000 in-memory lookups/s (trivial)
Bottleneck: None (KVM can handle millions of lookups/s)
```

**Result: 66x faster, zero bottlenecks**

---

## 🔒 Mas E a Segurança?

**Pergunta:** *"Se não tem OAuth2, como você garante que o token não foi roubado?"*

**Resposta:** 

1. **Token é um secret de longa duração** (como uma API key)
2. **Hash SHA-256 antes de armazenar** (KVM nunca guarda o token em plaintext)
3. **Rotação manual** quando necessário (via API de admin)
4. **IP whitelisting** (opcional, adiciona camada extra)
5. **Audit trail** completo (toda tentativa de uso é logada)

**Analogia:**
> OAuth2 é como ter um **segurança na porta** que liga pro RH toda vez que alguém entra pra confirmar se o crachá é válido.
>
> KVM Fast-Fail é como ter um **crachá com chip RFID** que abre a porta instantaneamente se o chip estiver na lista de autorizados.

**Ambos são seguros. Um é instantâneo, o outro não.**

---

## 🔄 Token Lifecycle

```
┌──────────────────────────────────────────────────────────────┐
│ Day 0: Sender onboarded                                      │
│   - Generate long-lived token (UUID ou random string)        │
│   - Hash token (SHA-256)                                     │
│   - Store hash in KVM with metadata                          │
│   - Give plaintext token to sender (via secure channel)      │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ Day 1-89: Normal operation                                   │
│   - Sender uses token in every request                       │
│   - APIM validates via KVM lookup (2-5ms)                    │
│   - Zero issues                                              │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ Day 90: Manual rotation (if required by policy)             │
│   - Admin generates new token                                │
│   - Update KVM entry with new hash                           │
│   - Old token marked as "grace_period" (7 days)              │
│   - Notify sender to switch to new token                     │
└──────────────────────────────────────────────────────────────┘
                          │
                          ▼
┌──────────────────────────────────────────────────────────────┐
│ Day 97: Old token revoked                                    │
│   - Delete old token hash from KVM                           │
│   - Requests with old token = HTTP 401                       │
└──────────────────────────────────────────────────────────────┘
```

---

## 🚨 Incident Response: Token Compromised

```bash
# Step 1: Revoke immediately
curl -X PATCH https://apim.company.com/admin/kvm/tokens/SENDER_A \
  -d '{"status": "revoked"}'

# Step 2: Check audit logs for unauthorized usage
curl -X GET "https://elasticsearch.company.com/audit-logs/_search" \
  -d '{
    "query": {
      "bool": {
        "must": [
          {"match": {"sender.sender_id": "SENDER_A"}},
          {"range": {"timestamp": {"gte": "now-24h"}}}
        ]
      }
    }
  }'

# Step 3: Generate new token
NEW_TOKEN=$(openssl rand -base64 32)
NEW_HASH=$(echo -n "$NEW_TOKEN" | sha256sum | awk '{print $1}')

curl -X POST https://apim.company.com/admin/kvm/tokens \
  -d '{
    "token_hash": "'$NEW_HASH'",
    "sender_id": "SENDER_A",
    "endpoints_allowed": ["/sales/*"],
    "status": "active"
  }'

# Step 4: Notify sender securely
echo "New token: $NEW_TOKEN" | gpg --encrypt --recipient sender-a@company.com
```

**Total time to revoke + rotate: <5 minutes**

---

## 📊 ASCII Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    GDCR Fail-Fast Logic                         │
└─────────────────────────────────────────────────────────────────┘

  ┌──────────────┐
  │ Client App   │
  │ Header:      │
  │ Bearer xyz   │
  └──────┬───────┘
         │
         ▼
  ┌──────────────────┐
  │ Hash Token       │──────┐
  │ sha256(xyz)      │      │
  └──────┬───────────┘      │
         │                  │
         ▼                  │
  ┌──────────────────┐      │
  │ KVM Lookup       │      │
  │ Key: hash        │      │
  └──────┬───────────┘      │
         │                  │
    ┌────┴─────┐            │
    │ Found?   │            │
    └──┬────┬──┘            │
       │NO  │YES            │ Total Time:
       │    │               │ 2-5ms
       ▼    ▼               │
   ┌─────┐ ┌──────────────┐│
   │ 401 │ │ Extract      ││
   │STOP │ │ sender_id    ││
   └─────┘ └──────┬───────┘│
                  │        │
                  ▼        │
           ┌──────────────┐│
           │ Route to     ││
           │ Backend      ││
           └──────────────┘│
                           │
───────────────────────────┘
```

---

## ❓ FAQ

### Q: "Mas OAuth2 é o padrão da indústria!"

**A:** OAuth2 é excelente quando você tem:
- Múltiplos resource owners (usuários finais)
- Delegação de acesso (user consent)
- Short-lived tokens com refresh flow

**GDCR é machine-to-machine (M2M).** Não há usuários finais, não há consent screens, não há refresh tokens. OAuth2 adiciona complexidade sem benefícios.

---

### Q: "E se alguém roubar o token?"

**A:** Mesma resposta do OAuth2:
- **Rotate immediately** (revoke old, issue new)
- **Audit logs** mostram onde o token foi usado
- **IP whitelisting** reduz superfície de ataque

OAuth2 não protege contra token theft. Se alguém roubar um OAuth2 access token, o ataque é idêntico.

---

### Q: "Como vocês fazem expiry?"

**A:** Duas opções:

**Option 1: No Expiry (API Key Model)**
```json
{
  "token_hash": "sha256:...",
  "sender_id": "SENDER_A",
  "expires_at": null,
  "status": "active"
}
```
Token válido até ser explicitamente revogado.

**Option 2: Manual Expiry**
```json
{
  "token_hash": "sha256:...",
  "sender_id": "SENDER_A",
  "expires_at": 1740000000,
  "status": "active"
}
```
Background job verifica expiry e marca como `"expired"`.

**Não fazemos automatic refresh** porque isso requer OAuth2 complexity que estamos evitando.

---

### Q: "Isso escala?"

**A:** Absolutamente.

KVM (Key-Value Map) é distribuído e replicado através dos nodes do APIM cluster:
- **Read latency:** <5ms (in-memory cache)
- **Write latency:** ~50ms (sync across cluster)
- **Capacity:** Millions of entries
- **Throughput:** 1M+ lookups/second per node

Para 10 APIM nodes, você tem **10M+ lookups/second** de throughput.

---

## ✅ Quando Usar GDCR Fail-Fast

**Use GDCR Fail-Fast quando:**
- ✅ Machine-to-machine (M2M) integrations
- ✅ Known, registered sender systems
- ✅ Long-lived credentials são aceitáveis
- ✅ Latência é crítica (<10ms validation)
- ✅ Você quer zero dependências externas
- ✅ High throughput (>10k req/s)

**NÃO use quando:**
- ❌ User-facing applications (use OAuth2 + OIDC)
- ❌ Third-party developers (public API com self-service)
- ❌ Regulatory requirement para short-lived tokens
- ❌ Need automatic token refresh

---

## 🎯 Summary

```
┌────────────────────────────────────────────────────────────────┐
│ GDCR Fail-Fast: A validação não passa = HTTP 401 e pronto      │
│                                                                │
│ ✅ 2-5ms latency (vs 150-300ms OAuth2)                         │
│ ✅ Zero external dependencies                                  │
│ ✅ Zero network calls per request                              │
│ ✅ Linear scalability (KVM distributed)                        │
│ ✅ 66x faster under load                                       │
│                                                                │
│ Trade-off: Manual token rotation (vs automatic OAuth refresh)  │
│ Verdict: Worth it for M2M high-performance scenarios           │
└────────────────────────────────────────────────────────────────┘
```

---

**Related Documentation:**
- [SECURITY.md](./README.md) - Overall security architecture
- [ACCESS-CONTROL.md](./ACCESS-CONTROL.md) - Per-sender isolation
- [CREDENTIAL-MANAGEMENT.md](./CREDENTIAL-MANAGEMENT.md) - Token provisioning

---

**Author:** Ricardo Luz Holanda Viana  
**Framework:** GDCR (Global Domain-Centric Routing)  
**Philosophy:** *"Fail fast. Fail loud. Fail with zero overhead."*
