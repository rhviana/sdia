## Terminology and Naming  
### Intentional Scope Definition & Prior Art Protection

To avoid semantic ambiguity, dilution, or subsequent rebranding without proper
attribution, the same architectural principle is intentionally referenced under
multiple equivalent names and acronyms.

This is a **deliberate and documented strategy** designed to:
- preserve semantic integrity,
- prevent post-hoc reinterpretation or redefinition,
- and protect the original architectural intent as **documented prior art**.

All terminology defined below refers to the **same architectural core concept**
originally authored and published by **Ricardo Luz Holanda Viana**, with
prior-art evidence publicly established on **February 7, 2026**, and formally
archived via DOI on **Zenodo (CERN)**.

---

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
    └── ODPC (Orquestration Framework)
         └── PDCP (SAP CPI)
 ```   

## Equivalent Architectural Names and Acronyms

The following terms are explicitly defined as **synonymous** and
**architecturally equivalent** to the **Gateway Domain-Centric Routing (GDCR)**
framework.

Any reuse of these terms to describe substantially similar architectural
approaches **must reference this repository and the associated DOI publication**.

---

### 1. Gateway Layer Patterns

| Acronym | Full Name | Scope | Status |
|---------|-----------|-------|--------|
| **GDCR** | **Gateway Domain-Centric Router** | Framework umbrella | ✅ Core |
| **DCRP** | **Domain-Centric Routing Pattern** | SAP APIM implementation | ✅ Published |
| **MDAGR** | **Metadata-Driven API Gateway Routing** | Generic pattern | - |
| **SRBD** | **Semantic Routing via Business Domains** | Conceptual layer | -y |

---

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

---
| DDCR Component | Technology | Platform Validated |
|----------------|------------|-------------------|
| Metadata Store | KVM | SAP BTP |
| Metadata Store | **Redis** | **Kong** ✅ |
| Metadata Store | DynamoDB | AWS (em teste) |
| Runtime Engine | JavaScript | SAP APIM |
| Runtime Engine | Lua | Kong ✅ |
| Runtime Engine | Python | Custom |
| Runtime Engine | C# | Azure (planned) |

## Core Architectural Principle (Applies to All Names)

Across all terminology variants listed above, the **core architectural principle
remains invariant**:

> Routing decisions at the API Gateway layer are driven by **business-domain
metadata**, not by fixed or static backend endpoint mappings.

Any architecture that materially implements this principle, regardless of
terminology or branding, is considered a **derivative or equivalent expression**
of the GDCR framework.

---

## Prior Art Statement

The architectural concepts, terminology, naming strategy, and semantic scope
defined in this section constitute **documented prior art** as of
**February 7, 2026**, with formal academic archiving under:

* First Publication: February 7, 2026 — Medium: https://medium.com/@rhviana/gateway-domain-centric-routing-a-vendor-agnostic-api-architecture-52ad30d1d1d9
* Formal Archive: February 10, 2026 — Zenodo (CERN)
  - **DOI:** 10.5281/zenodo.18582492
  - **DOI:** 10.6084/m9.figshare.31331683
  - **Repository:** Zenodo (CERN)  

Subsequent publications, implementations, frameworks, or architectural models
introducing equivalent concepts under alternative naming **must explicitly
acknowledge this prior art**.

Failure to do so may constitute **academic misconduct**, **professional
misrepresentation**, or **intellectual misattribution**, depending on context.

-----------------------------------

Author: Ricardo Luz Holanda Viana Role: Enterprise Integration Architect · SAP BTP Integration Suite Expert Creator of: GDCR · DCRP · PDCP · DDCR · DDCR Phantom v12 Engine
Validation: 1,499,869 requests · 100% routing success · 99.9916% end-to-end · Kong · SAP BTP · AWS · Azure

**Validation:** 1,174,782+ requests · 100% success · 19ms avg (Redis/Kong/SAP)

License: CC BY 4.0 | DOI: 10.5281/zenodo.18582492 · 10.6084/m9.figshare.31331683
**DOI:** [zenodo.18661136](https://doi.org/10.5281/zenodo.18661136) · [figshare.31331683](https://doi.org/10.6084/m9.figshare.31331683)

*This document is part of the **Gateway Domain-Centric Routing (GDCR)** framework. 
Reuse permitted only with proper attribution to original work and associated DOI.*

-----------------------------------

