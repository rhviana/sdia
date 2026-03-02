# GDCR Security & Architecture Documentation

---

## Documentation Structure

This documentation addresses enterprise-grade security, compliance, and architectural concerns raised by the community.

---

## Security Documentation

- **SECURITY.md** – Complete security model overview  
- **OAUTH2-FLOW.md** – Fast-fail OAuth2 validation logic  
- **ACCESS-CONTROL.md** – Per-sender isolation mechanisms  

---

## Architecture Documentation

- **ARCHITECTURE.md** – Domain-Centric Routing Pattern (DCRP)  
- **CREDENTIAL-MANAGEMENT.md** – Credential vault architecture  
- **AUDIT-COMPLIANCE.md** – Audit trail & compliance model  

---

# Security Flow Visualization

```plaintext
    ┌───────────────┐
    │ API Request   │
    │ Bearer: xyz   │
    └───────┬───────┘
            │
            ▼
   ┌─────────────────┐
   │ KVM Lookup      │───────┐
   │ Hash(xyz)       │       │ NOT FOUND
   └────────┬────────┘       │
            │ FOUND          ▼
            ▼           ┌──────────┐
   ┌─────────────────┐  │ HTTP 401 │
   │ Extract Metadata│  │ STOP     │
   │ sender_id       │  └──────────┘
   │ scopes          │
   └────────┬────────┘
            │
            ▼
   ┌─────────────────┐
   │ Scope Check     │───────┐
   │ Required vs     │       │ FORBIDDEN
   │ Available       │       │
   └────────┬────────┘       ▼
            │ OK        ┌──────────┐
            │           │ HTTP 403 │
            ▼           │ STOP     │
   ┌─────────────────┐  └──────────┘
   │ Route to Backend│
   └─────────────────┘
```

---

# GDCR Fail-Fast Logic

```plaintext
┌─────────────────────────────────────────────────────────────────┐
│                     GDCR Fail-Fast Logic                        │
└─────────────────────────────────────────────────────────────────┘

  ┌──────────────┐
  │ Client App   │
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
    └──┬────┬──┘            │ Total Time:
       │NO  │YES            │ 2–5ms
       ▼    ▼               │
   ┌─────┐ ┌──────────────┐ │
   │ 401 │ │ Extract      │ │
   │STOP │ │ sender_id    │ │
   └─────┘ └──────┬───────┘ │
                  │         │
                  ▼         │
           ┌──────────────┐ │
           │ Route to     │ │
           │ Backend      │ │
           └──────────────┘ │
                            │
────────────────────────────┘
```

---

# Quick Answers to Common Questions

**Q1: How does GDCR prevent Sender A from calling Sender B's endpoints?**  
A: OAuth2 scope-based validation at the routing engine level. See `ACCESS-CONTROL.md`.

**Q2: Is this just native APIM conditional routing?**  
A: No. GDCR is metadata-driven, multi-vendor, and governance-first. See `ARCHITECTURE.md`.

**Q3: How many credentials exist for 4 proxies serving 40 backends?**  
A: Per-sender credentials (N senders) + backend service accounts (M backends). See `CREDENTIAL-MANAGEMENT.md`.

**Q4: How is audit trail maintained for compliance?**  
A: Every request logs sender ID, endpoint, timestamp, action, and result. See `AUDIT-COMPLIANCE.md`.

---

# 🎯 Design Philosophy

GDCR is **not** about tool-level configuration.

It is an enterprise integration architecture pattern that:

- ✅ Works across SAP APIM, Apigee, AWS API Gateway, Azure APIM  
- ✅ Enforces domain-driven design at the API layer  
- ✅ Scales governance through metadata, not manual proxy duplication  
- ✅ Separates sender identity from backend routing  

---

# Traditional Approach (1:1) vs GDCR

```plaintext
┌─────────────────────────────────────────────────────────────┐
│ Integration Count = N senders × M backends                 │
│                                                             │
│ Example: 10 senders × 40 backends = 400 individual proxies │
│                                                             │
│ Problems:                                                   │
│ ❌ Proxy sprawl                                             │
│ ❌ Duplicate policies                                       │
│ ❌ No centralized governance                                │
│ ❌ Manual configuration per integration                     │
│ ❌ Impossible to audit at scale                             │
└─────────────────────────────────────────────────────────────┘
```

---

# 🔍 GDCR vs Native APIM Conditional Routing

| Aspect | Native Conditional Routing | GDCR Framework |
|--------|----------------------------|----------------|
| Scope | Single proxy configuration | Enterprise governance pattern |
| Routing Logic | Hardcoded policies | Metadata-driven (external config) |
| Multi-Vendor | SAP APIM only | SAP, Apigee, AWS, Azure |
| Governance | Manual per proxy | Centralized domain-level policies |
| Scalability | Manual proxy edits | Metadata updates |
| Security Model | Per-proxy OAuth | Domain-wide isolation |
| Audit Trail | Per-proxy logs | Domain-level consolidated audit |
| Change Management | Redeploy proxy | Update metadata (no redeploy) |

---

# 🧪 Audit Testing

## Test 1: Verify Per-Sender Isolation in Logs

```bash
# Step 1: Make request as SENDER_A
curl -X GET https://api.company.com/sales/orders \
  -H "Authorization: Bearer $TOKEN_A"

# Step 2: Query audit logs
curl -X GET "https://elasticsearch.company.com/audit-logs/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "bool": {
        "must": [
          {"match": {"sender.sender_id": "SENDER_A"}},
          {"match": {"request.endpoint": "/sales/orders"}}
        ]
      }
    }
  }'
```

---

## Test 2: Verify Security Violation Logging

```bash
# Attempt unauthorized access
curl -X GET https://api.company.com/finance/invoices \
  -H "Authorization: Bearer $TOKEN_A"

# Expected Response: HTTP 403

# Verify violation log
curl -X GET "https://elasticsearch.company.com/audit-logs/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "bool": {
        "must": [
          {"match": {"event_type": "ACCESS_DENIED"}},
          {"match": {"sender.sender_id": "SENDER_A"}}
        ]
      }
    }
  }'
```

---

# 🧮 Real-World Example: 10 Senders, 1 Domain

### Access Matrix (Legend: ✅ Allowed, ❌ Blocked)

| Sender | /orders | /customers | /products | /invoices | /reports |
|--------|---------|------------|-----------|-----------|----------|
| A | ✅ R/W | ✅ R/W | ✅ R | ❌ | ❌ |
| B | ✅ R | ❌ | ✅ R | ✅ R/W | ❌ |
| F | ❌ | ❌ | ❌ | ✅ R/W | ✅ R/W |
| J | ❌ | ❌ | ✅ R | ✅ R | ✅ R/W |

---

# 🔒 Isolation Guarantees

- Sender A cannot call endpoints where `allowed_senders` excludes `SENDER_A`
- Token binding prevents cross-sender impersonation
- Cross-sender attempts are logged as security violations

---

# 📊 Security Violation Audit Example

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

---

# 🧪 Validation Logic (JavaScript Policy Reference)

```javascript
// Policy: Sender-Authorization-Check
var senderID = context.getVariable("sender.id"); 
var requestPath = context.getVariable("proxy.pathsuffix");

// Load endpoint configuration from KVM
var endpointConfigStr = context.getKeyValueMap("endpoint_config").get(requestPath);

if (!endpointConfigStr) {
    context.setVariable("response.status.code", 404);
    throw new Error("Not Found");
}

var endpointConfig = JSON.parse(endpointConfigStr);

// Check 1: Is sender in allowed list?
if (!endpointConfig.allowed_senders.includes(senderID)) {
    context.setVariable("response.status.code", 403);
    logAuditEvent("ACCESS_DENIED", senderID, requestPath);
    throw new Error("Forbidden");
}

// All checks passed
context.setVariable("target.backend_url", endpointConfig.backend_url);
```

---
## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** 10.5281/zenodo.xxxxx  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
