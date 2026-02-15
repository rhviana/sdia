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

## 🚀 Repository Structure
