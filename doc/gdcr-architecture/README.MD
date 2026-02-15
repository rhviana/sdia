
# GDCR Architecture

![GDCR Architecture](../../images/architecture/gdcr-overview.png)

## 🎯 What is GDCR?

**GDCR (Global Domain-Centric Routing Pattern)** is an enterprise integration architecture pattern that:

✅ Reduces proxy count by 90% (4 proxies vs 400)  
✅ Enables metadata-driven routing (no manual configuration)  
✅ Works across SAP APIM, Apigee, AWS API Gateway, Azure APIM  
✅ Enforces domain-driven design at the API layer  

---

## 📖 Architecture Documentation

### Core Patterns
- **[DCRP - Domain-Centric Routing](./DCRP.md)** - The foundational pattern

### Design Decisions
- **[Why Domain-Centric?](./DCRP.md#why-domain-centric)** - vs traditional 1:1 routing
- **[Metadata-Driven Routing](./DCRP.md#metadata-driven-routing)** - Configuration as data
- **[Multi-Vendor Support](./DCRP.md#multi-vendor)** - Works beyond SAP

---

## 🏗️ High-Level Architecture

```
┌────────────────────────────────────────────────────────┐
│ Domain Proxies (4-20 typical)                          │
│  ┌─────────┐  ┌─────────┐  ┌─────────┐  ┌──────────┐   │
│  │ Sales   │  │ Finance │  │ HR      │  │ Logistics│   │
│  │ Domain  │  │ Domain  │  │ Domain  │  │ Domain   │   │
│  └────┬────┘  └────┬────┘  └────┬────┘  └────┬─────┘   │
├───────┼───────────┼────────────┼─────────────┼─────────┤
│       │    Metadata-Driven Routing Engine    │         │
│       │           (KVM + Config DB)          │         │
├───────┼───────────┼────────────┼─────────────┼─────────┤
│ Backend Systems (40+ typical)                          │
│  SAP CPI, REST APIs, SOAP Services, Databases          │
└────────────────────────────────────────────────────────┘
```

---

## 📊 Scaling Example

**Traditional 1:1 Approach:**
```
10 senders × 40 backends = 400 proxies to manage
```

**GDCR Approach:**
```
4 domain proxies serving 40 backends (1:10 ratio)
90% reduction in proxy count
```

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

---

## 🏗️ GDCR Architecture Layers

```
┌──────────────────────────────────────────────────────────────────┐
│ Layer 5: Presentation (Newman Tests, Dashboards)                 │
├──────────────────────────────────────────────────────────────────┤
│ Layer 4: Governance (Audit, Compliance, Credential Vault)        │
├──────────────────────────────────────────────────────────────────┤
│ Layer 3: Security (OAuth2 Fast-Fail, Scope Validation)           │ 
├──────────────────────────────────────────────────────────────────┤
│ Layer 2: Routing Engine (Metadata-Driven Decision Logic)         │
├──────────────────────────────────────────────────────────────────┤
│ Layer 1: Domain Proxies (4-20 domain-based API proxies)          │
└──────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Request Flow (End-to-End)

```
                  ┌────────────────┐
                  │ Sender A       │
                  │ Request:       │
                  │ POST /sales    │
                  │ /orders        │
                  └────────┬───────┘
                           │
                           ▼
┌────────────────────────────────────────────────────────────────┐
│ Step 1: Domain Proxy Selection                                 │
│ URL: api.company.com/sales/orders                              │
│ Matched Domain: "sales" match dynamic routing path "/orders/*" │
└──────────────────────────┬─────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│ Step 2: KVM Fast-Fail Validation                        │
│ - Extract Bearer token                                  │
│ - Hash token → KVM lookup                               │
│ - Result: Valid, sender_id = "SENDER_A"                 │
└──────────────────────────┬──────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│ Step 3: Sender Authorization                            │
│ - Required scopes: ["sales:write"]                      │
│ - Allowed senders: ["SENDER_A", "SENDER_C"]             │
│ - Result: ✅ AUTHORIZED                                 │   
└──────────────────────────┬──────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│ Step 4: Metadata-Driven Routing                         │
│ - Endpoint: /sales/orders                               │
│ - Backend URL: https://cpi.company.com/sales/orders     │
│ - Backend Auth: Fetch from Vault                        │
└──────────────────────────┬──────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│ Step 5: Backend Call                                    │
│ - HTTP POST to CPI                                      │
│ - Inject sender context: {"sender_id": "SENDER_A"}      │
│ - Response: 201 Created                                 │
└────────┬────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────┐
│ Step 6: Audit Logging                                   │
│ - Log: sender_id, endpoint, status, latency             │
│ - Store: Elasticsearch + S3 (compliance)                │
└──────────────────────────┬──────────────────────────────┘
                           │
                           ▼
                  ┌────────────────┐
                  │ Response:      │
                  │ 201 Created    │
                  └────────────────┘
```

---

## 📊 Scaling Example: 100 Senders, 500 Backends

### Traditional 1:1 Approach

```
Proxy Count: 100 × 500 = 50,000 individual proxies (impossible to manage)
```

Even with "smart grouping":
```
Proxy Count: 100 senders × 10 backend groups = 1,000 proxies
Management overhead: INSANE
```

---

### GDCR Approach

```
Domain Proxies: 20 (sales, finance, hr, logistics, etc.)
Metadata Entries: 500 (one per backend)
Credential Sets: 100 (senders) + 500 (backends) = 600

Management overhead: MINIMAL
Add new backend: Update metadata JSON (30 seconds)
Add new sender: Issue OAuth2 credentials (5 minutes)
```

**Result:**
```
┌────────────────────────────────────────────────────────────┐
│ GDCR reduces proxy count by 98% (20 vs 1,000)              │
│ while IMPROVING governance and security                    │
└────────────────────────────────────────────────────────────┘
```

---

**See also:**
- [Security Model](../security/README.md)
- [Fail-Fast Logic](../security/FAIL-FAST-LOGIC.md)
- [Implementation Guide](../implementation/sap-apim-setup.md)
