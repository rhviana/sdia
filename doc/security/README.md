# GDCR Security & Architecture Documentation

![GDCR Architecture](https://www.genspark.ai/api/files/s/YJ193kgD)

## 📚 Documentation Structure

This documentation addresses enterprise-grade security, compliance, and architectural concerns raised by the community.

### 🔒 Security Documentation
- **[SECURITY.md](./SECURITY.md)** - Complete security model overview
- **[OAUTH2-FLOW.md](./OAUTH2-FLOW.md)** - Fast-fail OAuth2 validation logic
- **[ACCESS-CONTROL.md](./ACCESS-CONTROL.md)** - Per-sender isolation mechanisms

### 🏗️ Architecture Documentation
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - Domain-centric routing pattern (DCRP)
- **[CREDENTIAL-MANAGEMENT.md](./CREDENTIAL-MANAGEMENT.md)** - Credential vault architecture
- **[AUDIT-COMPLIANCE.md](./AUDIT-COMPLIANCE.md)** - Audit trail & compliance

---

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
   
---

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





## ⚡ Quick Answers to Common Questions

### Q1: How does GDCR prevent Sender A from calling Sender B's endpoints?
**A:** OAuth2 scope-based validation at the routing engine level. See [ACCESS-CONTROL.md](./ACCESS-CONTROL.md).

### Q2: Is this just native APIM conditional routing?
**A:** No. GDCR is metadata-driven, multi-vendor, and governance-first. See [ARCHITECTURE.md](./ARCHITECTURE.md#vs-native-conditional-routing).

### Q3: How many credentials exist for 4 proxies serving 40 backends?
**A:** Per-sender credentials (N senders) + backend service accounts (M backends). See [CREDENTIAL-MANAGEMENT.md](./CREDENTIAL-MANAGEMENT.md#credential-count).

### Q4: How is audit trail maintained for compliance?
**A:** Every request logs: sender ID, endpoint, timestamp, action, result. See [AUDIT-COMPLIANCE.md](./AUDIT-COMPLIANCE.md).

---

## 🎯 Design Philosophy

**GDCR is NOT about tool-level configuration.**

It's an **enterprise integration architecture pattern** that:
- ✅ Works across SAP APIM, Apigee, AWS API Gateway, Azure APIM
- ✅ Enforces domain-driven design at the API layer
- ✅ Scales governance through metadata, not manual proxy duplication
- ✅ Separates sender identity from backend routing

---
Traditional Approach (1:1): ┌─────────────────────────────────────────────────────────────┐ │ Integration Count = N senders × M backends │ │ │ │ Example: 10 senders × 40 backends = 400 individual proxies │ │ │ │ Problems: │ │ ❌ Proxy sprawl (400+ API proxies to manage) │ │ ❌ Duplicate policies across proxies │ │ ❌ No centralized governance │ │ ❌ Manual configuration for every new integration │ │ ❌ Impossible to audit at scale │ └─────────────────────────────────────────────────────────────┘

---

## 🔍 GDCR vs Native APIM Conditional Routing

### ❓ Question from Community

> *"SAP APIM already supports conditional routing (1:N). A single proxy can route to 10+ backends based on path prefix. How is GDCR different?"*

### ✅ Answer: GDCR is **Architecture-First**, Not Tool-First

| Aspect | Native Conditional Routing | GDCR Framework |
|--------|---------------------------|----------------|
| **Scope** | Single proxy configuration | Enterprise governance pattern |
| **Routing Logic** | Hardcoded in proxy XML/policies | Metadata-driven (external config) |
| **Multi-Vendor** | SAP APIM only | Works across SAP, Apigee, AWS, Azure |
| **Governance** | Manual per-proxy | Centralized domain-level policies |
| **Scalability** | Requires manual proxy edits | Add endpoints via metadata updates |
| **Security Model** | Per-proxy OAuth setup | Domain-wide sender isolation |
| **Audit Trail** | Per-proxy logs | Domain-level consolidated audit |
| **Change Management** | Redeploy proxy for new routes | Update metadata (no redeployment) |

**TL;DR:**
> Native conditional routing is a **feature**. GDCR is an **architectural pattern** that uses conditional routing as one component, alongside metadata-driven governance, sender isolation, and multi-vendor abstraction.


🧪 Audit Testing
Test 1: Verify Per-Sender Isolation in Logs
Copy# Step 1: Make request as SENDER_A
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
    },
    "size": 1,
    "sort": [{"timestamp": "desc"}]
  }'

# Step 3: Verify log entry exists with correct sender_id
# Expected: sender.sender_id = "SENDER_A"
Test 2: Verify Security Violation Logging
Copy# Step 1: Attempt unauthorized access
curl -X GET https://api.company.com/finance/invoices \
  -H "Authorization: Bearer $TOKEN_A"  # SENDER_A not allowed

# Expected Response: HTTP 403

# Step 2: Verify security violation log
curl -X GET "https://elasticsearch.company.com/audit-logs/_search" \
  -H "Content-Type: application/json" \
  -d '{
    "query": {
      "bool": {
        "must": [
          {"match": {"event_type": "ACCESS_DENIED"}},
          {"match": {"sender.sender_id": "SENDER_A"}},
          {"match": {"request.endpoint": "/finance/invoices"}}
        ]
      }
    },
    "size": 1,
    "sort": [{"timestamp": "desc"}]
  }'

# Expected: 
# - event_type = "ACCESS_DENIED"
# - violation.reason = "Sender not in allowed_senders list"



🧮 Real-World Example: 10 Senders, 1 Domain
Scenario
Domain: api.company.com/sales/*
Endpoints: 5 (orders, customers, products, invoices, reports)
Senders: 10 (A through J)
Access Matrix
Sender	/orders	/customers	/products	/invoices	/reports
A	✅ R/W	✅ R/W	✅ R	❌	❌
B	✅ R	❌	✅ R	✅ R/W	❌
C	✅ R	❌	✅ R	❌	✅ R
D	❌	❌	✅ R	✅ R	❌
E	✅ R/W	✅ R	✅ R/W	❌	❌
F	❌	❌	❌	✅ R/W	✅ R/W
G	✅ R	✅ R	❌	❌	❌
H	❌	❌	✅ R	❌	✅ R
I	✅ R/W	❌	❌	❌	❌
J	❌	❌	✅ R	✅ R	✅ R/W
Legend: ✅ = Allowed, ❌ = Blocked, R = Read scope, W = Write scope

🔒 Isolation Guarantees
✅ What IS Enforced
Sender A cannot call endpoints where allowed_senders excludes "SENDER_A"
Even with a valid OAuth2 token, scope check blocks unauthorized paths
Cross-sender access attempts are logged as security violations
Each sender operates in complete isolation at the routing layer
❌ What Does NOT Happen
❌ Sender A cannot "steal" Sender B's token (KVM binds token to sender_id)
❌ Sender A cannot bypass scope checks (JavaScript policy enforces before routing)
❌ Sender A cannot access another sender's data (backend receives sender context)
🧪 Testing Cross-Sender Isolation
Copy# Scenario: SENDER_A tries to access SENDER_B's endpoint

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
📊 Audit Trail for Cross-Sender Attempts
Every blocked attempt generates an audit entry:

Copy{
  "timestamp": "2026-02-15T13:42:17Z",
  "event_type": "ACCESS_DENIED",
  "sender_id": "SENDER_A",
  "endpoint": "/finance/invoices",
  "reason": "Sender not in allowed_senders list",
  "source_ip": "203.0.113.45",
  "token_hash": "sha256:7f3e9c...",
  "severity": "WARNING"
}
See AUDIT-COMPLIANCE.md for full audit structure.

🚀 Performance Impact
Operation	Latency	Scaling
Load endpoint config	2-3ms	O(1) KVM lookup
Check allowed_senders	<1ms	Array includes()
Scope validation	1-2ms	Set intersection
Total overhead	3-6ms	Linear with # scopes
For 10 senders hitting 1 endpoint:

No additional latency (each sender validated independently)
No contention (read-only KVM access)
🔄 Dynamic Access Control Updates
Question: Can I add/remove senders from allowed_senders without redeploying proxies?

Answer: YES.

Update the KVM entry:

Copy# Add SENDER_K to /sales/orders
curl -X PUT https://apim.company.com/kvm/endpoint_config/sales/orders \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -d '{
    "allowed_senders": ["SENDER_A", "SENDER_C", "SENDER_E", "SENDER_K"]
  }'

# Takes effect immediately (no proxy restart)
✅ Best Practices
Principle of least privilege: Only add senders that genuinely need access
Regular audits: Review allowed_senders lists quarterly
Explicit over implicit: Never use wildcard "*" for allowed_senders
Log everything: Security violations should trigger alerts


🧪 Validation Logic (JavaScript Policy)
Copy// Policy: Sender-Authorization-Check
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

## 🚀 Repository Structure
