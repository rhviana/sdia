# Per-Sender Access Control

![Access Control Matrix](../../images/security/access-matrix.png)

---

## Problem Statement

**Question:**  
If 10 different sender systems call the same domain endpoint (e.g., `api.company.com/sales/*`), how is access control enforced to prevent cross-sender access?

**Answer:**  
Scope-based validation combined with explicit `allowed_senders` lists per endpoint.

---

## Access Control Layers

```plaintext
┌──────────────────────────────────────────────────────┐
│ Request: GET /sales/orders                           │
│ Sender: SENDER_A                                     │
│ Token Scopes: ["sales:read"]                         │
└────────────────────┬─────────────────────────────────┘
                     │
                     ▼
          ┌──────────────────────┐
          │ Layer 1: OAuth Valid?│
          └──────────┬───────────┘
                     │ YES
                     ▼
          ┌──────────────────────────────┐
          │ Layer 2: Scope Check         │
          │ Does "sales:read" exist?     │
          └──────────┬───────────────────┘
                     │ YES
                     ▼
          ┌──────────────────────────────────────┐
          │ Layer 3: Sender Authorization        │
          │ Is SENDER_A in allowed_senders list? │
          └──────────┬───────────────────────────┘
                     │ YES
                     ▼
          ┌──────────────────────┐
          │ Route to Backend     │
          └──────────────────────┘
```

---

## Configuration Structure

### Endpoint Configuration (KVM or Config DB)

```json
{
  "endpoints": {
    "/sales/orders": {
      "backend_url": "https://cpi.company.com/sales/orders",
      "required_scopes": ["sales:read"],
      "allowed_senders": ["SENDER_A", "SENDER_C", "SENDER_E"],
      "rate_limit": 1000,
      "audit_level": "full"
    },
    "/finance/invoices": {
      "backend_url": "https://cpi.company.com/finance/invoices",
      "required_scopes": ["finance:admin"],
      "allowed_senders": ["SENDER_B", "SENDER_D"],
      "rate_limit": 200,
      "audit_level": "critical"
    }
  }
}
```

---

## Validation Logic (JavaScript Policy)

```javascript
// Policy: Sender-Authorization-Check
// Execution: After OAuth validation, before routing

var senderID = context.getVariable("sender.id");
var scopes = context.getVariable("sender.scopes").split(",");
var requestPath = context.getVariable("proxy.pathsuffix");

var configKVM = context.getKeyValueMap("endpoint_config");
var endpointConfigStr = configKVM.get(requestPath);

if (!endpointConfigStr) {
    context.setVariable("response.status.code", 404);
    throw new Error("Not Found");
}

var endpointConfig = JSON.parse(endpointConfigStr);

// Check 1: Sender authorization
if (!endpointConfig.allowed_senders.includes(senderID)) {
    context.setVariable("response.status.code", 403);
    logAuditEvent("ACCESS_DENIED", senderID, requestPath);
    throw new Error("Forbidden");
}

// Check 2: Scope validation
var requiredScopes = endpointConfig.required_scopes;
var hasAllScopes = requiredScopes.every(function(scope) {
    return scopes.includes(scope);
});

if (!hasAllScopes) {
    context.setVariable("response.status.code", 403);
    logAuditEvent("SCOPE_VIOLATION", senderID, requestPath);
    throw new Error("Forbidden");
}

context.setVariable("target.backend_url", endpointConfig.backend_url);
context.setVariable("sender.authorized", true);
logAuditEvent("ACCESS_GRANTED", senderID, requestPath);
```

---

## Real-World Example: 10 Senders, 1 Domain

### Access Matrix

| Sender | /orders | /customers | /products | /invoices | /reports |
|--------|---------|------------|-----------|-----------|----------|
| A      | R/W     | R/W        | R         | Blocked   | Blocked  |
| B      | R       | Blocked    | R         | R/W       | Blocked  |
| F      | Blocked | Blocked    | Blocked   | R/W       | R/W      |
| J      | Blocked | Blocked    | R         | R         | R/W      |

---

## Isolation Guarantees

Enforced:

1. A sender cannot call endpoints where it is not explicitly listed.
2. Scope validation blocks unauthorized operations even with valid tokens.
3. Cross-sender access attempts are logged as security violations.
4. Sender context is propagated to the backend for traceability.

Not possible:

1. Token impersonation (token hash bound to sender_id).
2. Bypassing scope validation.
3. Accessing data outside assigned authorization scope.

---

## Testing Cross-Sender Isolation

```bash
# Obtain token for SENDER_A
TOKEN_A=$(curl -X POST https://oauth.company.com/token \
  -d "client_id=SENDER_A" \
  -d "client_secret=SECRET_A" \
  -d "grant_type=client_credentials" | jq -r '.access_token')

# Attempt unauthorized endpoint
curl -X GET https://api.company.com/finance/invoices \
  -H "Authorization: Bearer $TOKEN_A"
```

Expected response:

```
HTTP 403 Forbidden
```

---

## Audit Entry Example

```json
{
  "timestamp": "2026-02-15T13:42:17Z",
  "event_type": "ACCESS_DENIED",
  "sender_id": "SENDER_A",
  "endpoint": "/finance/invoices",
  "reason": "Sender not in allowed_senders list",
  "severity": "WARNING"
}
```

See `AUDIT-COMPLIANCE.md` for full audit model.

---

## Performance Impact

| Operation | Latency | Scaling |
|-----------|---------|---------|
| Load endpoint config | 2–3ms | O(1) lookup |
| Check allowed_senders | <1ms | Array check |
| Scope validation | 1–2ms | Set comparison |
| Total overhead | 3–6ms | Linear with # scopes |

---

## Dynamic Access Updates

Update KVM without redeploying proxies:

```bash
curl -X PUT https://apim.company.com/kvm/endpoint_config/sales/orders \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -d '{
    "allowed_senders": ["SENDER_A", "SENDER_C", "SENDER_E", "SENDER_K"]
  }'
```

Takes effect immediately.

---

## Best Practices

1. Apply least privilege.
2. Avoid wildcard allowed_senders.
3. Review access lists quarterly.
4. Log and alert on violations.
5. Rotate sender credentials regularly (see CREDENTIAL-MANAGEMENT.md).

---
## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** 10.5281/zenodo.xxxxx  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
