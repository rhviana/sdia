## GDCR Taxonomy & Nomenclature

The Gateway Domain-Centric Routing framework comprises multiple architectural 
patterns and naming conventions. Below is the complete taxonomy, including 
concepts from academic papers, technical blogs, and production implementations.

### Core Principle (Universal)

> **Routing decisions at the API Gateway layer are driven by business-domain 
> metadata, not by fixed vendor endpoint mappings.**

External consumers interact with a **small, stable set of domain-oriented 
gateway entry points**. These represent business domains (Sales, Finance, 
Logistics), not individual vendor services. The gateway acts as a **semantic 
router**, evaluating request metadata to dynamically resolve the execution path.

---

### 1. Gateway Layer Patterns

| Acronym | Full Name | Scope | Status |
|---------|-----------|-------|--------|
| **GDCR** | **Gateway Domain-Centric Router** | Framework umbrella | ✅ Core |
| **DCRP** | **Domain-Centric Routing Pattern** | SAP APIM implementation | ✅ Published |
| **MDAGR** | **Metadata-Driven API Gateway Routing** | Generic pattern | 📝 Blog only |
| **SRBD** | **Semantic Routing via Business Domains** | Conceptual layer | 📝 Blog only |

---

### 2. Semantic & Business-Oriented Patterns

| Acronym | Full Name | Focus |
|---------|-----------|-------|
| **DOAGA** | **Domain-Oriented API Gateway Architecture** | Business alignment |
| **BSGR** | **Business-Semantic Gateway Routing** | Semantic abstraction |
| **SAGA** | **Semantic API Gateway Architecture** | Enterprise vocabulary |

---

### 3. Governance-Oriented Patterns

| Acronym | Full Name | Purpose |
|---------|-----------|---------|
| **DGAR** | **Domain-Governed API Routing** | Compliance & control |
| **CDRA** | **Centralized Domain Routing Architecture** | Unified governance |

---

### 4. Anti-Sprawl & Scalability Patterns

| Acronym | Full Name | Problem Solved |
|---------|-----------|----------------|
| **APSRA** | **Anti-Proxy-Sprawl Routing Architecture** | Proxy consolidation |
| **DDGCP** | **Domain-Driven Gateway Consolidation Pattern** | Infrastructure reduction |

---

### 5. Control Plane & Abstraction Patterns

| Acronym | Full Name | Technical Layer |
|---------|-----------|-----------------|
| **MOGRA** | **Metadata-Oriented Gateway Routing Architecture** | Metadata engine |
| **SCPR** | **Semantic Control Plane for API Routing** | Control/data plane separation |

---

### 6. Execution Layer (NEW — v6.0)

| Acronym | Full Name | Function | Validation |
|---------|-----------|----------|------------|
| **DDCR** | **Domain-Driven Centric Router** | Runtime routing engine | ✅ **1M+ requests (Redis)** |
| | | Translates semantic URL → vendor invocation | 19ms avg, 100% success |

**DDCR Architecture:**
```text
GDCR (Gateway façade)
↓
DDCR (Router / Metadata lookup / Translation)
↓
PDCP (Orchestration execution)
```


| DDCR Component | Technology | Platform Validated |
|----------------|------------|-------------------|
| Metadata Store | KVM | SAP BTP |
| Metadata Store | **Redis** | **Kong** ✅ |
| Metadata Store | DynamoDB | AWS (em teste) |
| Runtime Engine | JavaScript | SAP APIM |
| Runtime Engine | Lua | Kong ✅ |
| Runtime Engine | Python | Custom |
| Runtime Engine | C# | Azure (planned) |

> **Note:** DDCR is documented in technical blogs and production implementations, 
> but not yet included in the formal academic white paper (v5.0). 
> Full specification coming in v6.0.
```text
GDCR (Framework)
├── Gateway Layer
│   ├── DCRP (SAP)
│   ├── MDAGR (Generic)
│   └── SRBD (Conceptual)
├── Execution Layer
│   └── DDCR ← 1M+ validated
│       ├── Redis (Kong) ✅
│       ├── KVM (SAP) ✅
│       └── DynamoDB (AWS) 🔄
└── Orchestration Layer
    └── PDCP (SAP CPI)
 ```   
---

### Architectural Definition (Formal)

> In a Gateway Domain-Centric Routing architecture, external consumers interact 
> with a small, stable set of domain-oriented gateway entry points.
>
> These entry points do **not** represent individual vendor services. They 
> represent **business domains**, such as Sales, Finance, or Logistics. 
>
> The gateway acts as a **semantic router**, evaluating request metadata to 
> dynamically resolve the execution path via the DDCR execution layer.
