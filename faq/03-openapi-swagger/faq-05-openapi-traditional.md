
# FAQ-05 – Traditional OpenAPI / Swagger Model

# FAQ: OpenAPI Usage & Architectural Patterns

This document analyzes the traditional **System-Driven OpenAPI Model** and its long-term effects on enterprise integration landscapes.

---

## Q1 – How is OpenAPI typically used in API Management?

In most enterprise landscapes, OpenAPI follows a **system-driven lifecycle** where the gateway is treated as a pass-through layer for backend-originated contracts.

### The System-Driven Lifecycle:
1.  **Schema Derivation:** API contracts are exported directly from backend systems (e.g., OData from S/4HANA, REST from Salesforce).
2.  **Proxy Generation:** The OpenAPI specification is imported into API Management, generating a dedicated, system-specific proxy.
3.  **Hardcoded Target Binding:** The proxy is configured with static target endpoints tied to that specific backend version.

#### Typical URL Examples:
* `/sap/fi/invoices/v2/...`
* `/salesforce/api/v42/opportunities/...`

This creates a direct structural coupling between the **Contract**, the **Proxy**, and the **Backend System**.

---

## Q2 – What architectural effects does this model create?

The traditional OpenAPI model establishes a rigid, linear relationship that impacts scalability.

### Traditional OpenAPI Model Overview
* **Mapping:** 1 Spec → 1 Proxy → 1 Backend
* **Logic:** Routing decisions are embedded in the proxy configuration.
* **Maintenance:** Backend version changes often trigger a chain reaction requiring:
    * New API versions (v1, v2, v3)
    * New proxy artifacts
    * Mandatory consumer migrations

### Structural Consequences

| EFFECT | DESCRIPTION |
| :--- | :--- |
| **Proxy Proliferation** | The gateway becomes cluttered with hundreds of system-specific proxies. |
| **Version Fragmentation** | Managing multiple backend versions leads to overlapping and confusing API lifecycles. |
| **Governance Blindness** | APIs are indexed and governed by technical system names rather than business value. |
| **Mirroring Debt** | The APIM layer simply mirrors the backend's technical debt instead of abstracting it. |

- **Contract‑centric**:
  - Routing is tied to the endpoints defined in the OpenAPI spec.
- **System‑centric**:
  - Each system or service often has its own set of APIs and proxies.
- **Version‑heavy**:
  - Backend/schema changes frequently produce API versions (`v1`, `v2`, `v3`),
  - Each version may have its own proxy and deployment.

Impacts:

- More proxies and endpoints over time.
- Consumer migration required between versions.
- Governance centered on API documents, not on domain semantics.

Comparison Diagram (ASCII):

```text
[ TRADITIONAL OPENAPI MODEL ]            [ GDCR / DCRP MODEL ]
     (System-Centric Specs)                (Domain-Centric Spec)

   SPEC A      SPEC B      SPEC C                SINGLE SPEC
 [SAP S/4]   [SFDC v1]   [SFDC v2]             [Sales Domain]
     |           |           |                       |
     v           v           v                       v
 +-------+   +-------+   +-------+          +------------------+
 |Proxy A|   |Proxy B|   |Proxy C|          |  DOMAIN FACADE   |
 +-------+   +-------+   +-------+          +------------------+
     |           |           |              /       |          \
     |           |           |             /        |           \
 [SAP S4]    [SFDC v1]   [SFDC v2]      [S/4HANA] [SFDC v1] [SFDC v2]

 RESULT: 1 Spec = 1 Proxy.             RESULT: 1 Spec = N Systems.
 Governance: Document-centered.         Governance: Domain-centered.

```
---

## Q3 – Does GDCR reject OpenAPI?

**No.** GDCR does not reject OpenAPI; it **repositions its purpose**.

### Traditional Model vs. GDCR Model
* **In the Traditional Model:** OpenAPI describes **how the backend works** (technical mapping).
* **In the GDCR Model:** OpenAPI describes **what the business capability does** (semantic façade).

### In the GDCR framework:
* The OpenAPI specification defines the **Domain Façade**.
* Backend selection is resolved dynamically by the **DDCR engine**.
* Routing is governed by **metadata**, not by the OpenAPI target section.

### OpenAPI remains essential for:
* **Documentation:** Providing a clear interface for developers.
* **Client SDK Generation:** Ensuring easy consumption across languages.
* **Contract Testing:** Validating that the façade remains stable.
* **API Catalogs:** Enabling discovery within the enterprise.

**The difference is structural:** The contract becomes stable and domain-centric, while backend volatility is absorbed by the control plane.

---

## Q4 – What does this change enable?

By decoupling the OpenAPI specification from backend endpoint identity, GDCR enables:

* **Stable Façade Contracts:** The interface remains unchanged even if the backend is replaced.
* **Reduced Version Explosion:** Eliminates the need for new API versions just because a technical endpoint changed.
* **Vendor Interchangeability:** Switch vendors or regions without impacting the API consumer.
* **Semantic Governance:** Aligns the API strategy with business domains rather than IT silos.

> [!TIP]
> OpenAPI remains first-class. It is simply no longer the structural anchor of routing—it is the **functional definition of the domain**.

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------
