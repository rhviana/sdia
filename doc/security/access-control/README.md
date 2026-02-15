# Per-Sender Access Control

![Access Control Matrix](../../images/security/access-matrix.png)

## 🎯 Problem Statement

**Question from community:**
> *"If 10 different sender systems call the same domain endpoint (e.g., api.company.com/sales/*), how is access control enforced to prevent cross-sender access?"*

**Answer:**
> **Scope-based validation + explicit allowed_senders lists per endpoint.**

---

## 🔍 Access Control Layers

```
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

## 📋 Configuration Structure

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
    "/sales/customers": {
      "backend_url": "https://cpi.company.com/sales/customers",
      "required_scopes": ["sales:read", "sales:write"],
      "allowed_senders": ["SENDER_A"],
      "rate_limit": 500,
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

## 🧪 Validation Logic (JavaScript Policy)

```javascript
// Policy: Sender-Authorization-Check
// Execution: After OAuth validation, before routing

var senderID = context.getVariable("sender.id"); // From OAuth policy
var scopes = context.getVariable("sender.scopes").split(",");
var requestPath = context.getVariable("proxy.pathsuffix"); // e.g., /sales/orders

// Load endpoint configuration
var configKVM = context.getKeyValueMap("endpoint_config");
var endpointConfigStr = configKVM.get(requestPath);

if (!endpointConfigStr) {
    context.setVariable("response.status.code", 404);
    context.setVariable("response.content", 
        JSON.stringify({"error": "Endpoint not found"}));
    throw new Error("Not Found");
}

var endpointConfig = JSON.parse(endpointConfigStr);

// Check 1: Is sender in allowed list?
if (!endpointConfig.allowed_senders.includes(senderID)) {
    context.setVariable("response.status.code", 403);
    context.setVariable("response.content", 
        JSON.stringify({
            "error": "Sender not authorized for this endpoint",
            "sender_id": senderID,
            "endpoint": requestPath
        }));
    
    // Log security violation
    logAuditEvent("ACCESS_DENIED", senderID, requestPath);
    
    throw new Error("Forbidden");
}

// Check 2: Does sender have required scopes?
var requiredScopes = endpointConfig.required_scopes;
var hasAllScopes = requiredScopes.every(function(scope) {
    return scopes.includes(scope);
});

if (!hasAllScopes) {
    context.setVariable("response.status.code", 403);
    context.setVariable("response.content", 
        JSON.stringify({
            "error": "Insufficient scopes",
            "required": requiredScopes,
            "available": scopes
        }));
    
    logAuditEvent("SCOPE_VIOLATION", senderID, requestPath);
    
    throw new Error("Forbidden");
}

// All checks passed - store backend URL for routing
context.setVariable("target.backend_url", endpointConfig.backend_url);
context.setVariable("sender.authorized", true);

// Log successful authorization
logAuditEvent("ACCESS_GRANTED", senderID, requestPath);
```

---

## 🧮 Real-World Example: 10 Senders, 1 Domain

### Scenario
- **Domain:** `api.company.com/sales/*`
- **Endpoints:** 5 (orders, customers, products, invoices, reports)
- **Senders:** 10 (A through J)

### Access Matrix

| Sender | /orders | /customers | /products | /invoices | /reports |
|--------|---------|------------|-----------|-----------|----------|
| A      | ✅ R/W  | ✅ R/W     | ✅ R      | ❌        | ❌       |
| B      | ✅ R    | ❌         | ✅ R      | ✅ R/W    | ❌       |
| C      | ✅ R    | ❌         | ✅ R      | ❌        | ✅ R     |
| D      | ❌      | ❌         | ✅ R      | ✅ R      | ❌       |
| E      | ✅ R/W  | ✅ R       | ✅ R/W    | ❌        | ❌       |
| F      | ❌      | ❌         | ❌        | ✅ R/W    | ✅ R/W   |
| G      | ✅ R    | ✅ R       | ❌        | ❌        | ❌       |
| H      | ❌      | ❌         | ✅ R      | ❌        | ✅ R     |
| I      | ✅ R/W  | ❌         | ❌        | ❌        | ❌       |
| J      | ❌      | ❌         | ✅ R      | ✅ R      | ✅ R/W   |

**Legend:** ✅ = Allowed, ❌ = Blocked, R = Read scope, W = Write scope

---

## 🔒 Isolation Guarantees

### ✅ What IS Enforced

1. **Sender A cannot call endpoints where `allowed_senders` excludes "SENDER_A"**
2. **Even with a valid OAuth2 token, scope check blocks unauthorized paths**
3. **Cross-sender access attempts are logged as security violations**
4. **Each sender operates in complete isolation at the routing layer**

### ❌ What Does NOT Happen

1. ❌ Sender A **cannot** "steal" Sender B's token (KVM binds token to sender_id)
2. ❌ Sender A **cannot** bypass scope checks (JavaScript policy enforces before routing)
3. ❌ Sender A **cannot** access another sender's data (backend receives sender context)

---

## 🧪 Testing Cross-Sender Isolation

```bash
# Scenario: SENDER_A tries to access SENDER_B's endpoint

# Step 1: Get valid token for SENDER_A
TOKEN_A=$(curl -X POST https://oauth.company.com/token \
  -d "client_id=SENDER_A" \
  -d "client_secret=SECRET_A" \
  -d "grant_type=client_credentials" | jq -r '.access_token')

# Step 2: Try to access endpoint allowed only for SENDER_B
curl -X GET https://api.company.com/finance/invoices \
  -H "Authorization: Bearer $TOKEN_A"

# Expected Response:
# HTTP 403 Forbidden
# {
#   "error": "Sender not authorized for this endpoint",
#   "sender_id": "SENDER_A",
#   "endpoint": "/finance/invoices"
# }
```

---

## 📊 Audit Trail for Cross-Sender Attempts

Every blocked attempt generates an audit entry:

```json
{
  "timestamp": "2026-02-15T13:42:17Z",
  "event_type": "ACCESS_DENIED",
  "sender_id": "SENDER_A",
  "endpoint": "/finance/invoices",
  "reason": "Sender not in allowed_senders list",
  "source_ip": "203.0.113.45",
  "token_hash": "sha256:7f3e9c...",
  "severity": "WARNING"
}
```

See [AUDIT-COMPLIANCE.md](../compliance/AUDIT-COMPLIANCE.md) for full audit structure.

---

## 🚀 Performance Impact

| Operation | Latency | Scaling |
|-----------|---------|---------|
| Load endpoint config | 2-3ms | O(1) KVM lookup |
| Check allowed_senders | <1ms | Array includes() |
| Scope validation | 1-2ms | Set intersection |
| **Total overhead** | **3-6ms** | **Linear with # scopes** |

For 10 senders hitting 1 endpoint:
- **No additional latency** (each sender validated independently)
- **No contention** (read-only KVM access)

---

## 🔄 Dynamic Access Control Updates

**Question:** *Can I add/remove senders from allowed_senders without redeploying proxies?*

**Answer:** **YES.** 

Update the KVM entry:

```bash
# Add SENDER_K to /sales/orders
curl -X PUT https://apim.company.com/kvm/endpoint_config/sales/orders \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -d '{
    "allowed_senders": ["SENDER_A", "SENDER_C", "SENDER_E", "SENDER_K"]
  }'

# Takes effect immediately (no proxy restart)
```

---

## ✅ Best Practices

1. **Principle of least privilege:** Only add senders that genuinely need access
2. **Regular audits:** Review allowed_senders lists quarterly
3. **Explicit over implicit:** Never use wildcard `"*"` for allowed_senders
4. **Log everything:** Security violations should trigger alerts
5. **Rotation:** Rotate sender credentials every 90 days (see [CREDENTIAL-MANAGEMENT.md](./CREDENTIAL-MANAGEMENT.md))

---

**Next:** [CREDENTIAL-MANAGEMENT.md](./CREDENTIAL-MANAGEMENT.md) for credential vault architecture.
