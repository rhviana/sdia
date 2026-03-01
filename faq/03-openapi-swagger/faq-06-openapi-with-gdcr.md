# FAQ-06 — Using OpenAPI / Swagger with GDCR

This document defines the structural role of OpenAPI within the **Gateway Domain-Centric Routing (GDCR)** framework and how it differs from traditional system-centric implementations.

---

### Q1 – How should OpenAPI be used in a GDCR architecture?

In the GDCR model, the OpenAPI specification documents the **Domain Façade**, not individual backend systems. The OpenAPI contract defines business-domain paths, valid request/response structures, security requirements, and semantic operations. Routing decisions are executed separately by the **DDCR engine** through metadata resolution.

#### Example – Domain-Centric OpenAPI Structure

Example YAML Structure:
```js
YAML
paths:
  /sales/orders/create/{variant}:
    post:
      summary: Create a sales order via specific vendor/region
      parameters:
        - name: variant
          in: path
          required: false
          schema:
            type: string
            enum: [salesforce, s4hana, sf-us, sf-emea]
            description: "Target variant resolved by DCRP metadata"
      responses:
        '201':
          description: "Order accepted by domain façade"
```          
In this model:

 - OpenAPI defines the contract.
 - DDCR resolves the execution target.
 - The Façade remains stable even if backend systems change.

The

#### Q2 – How does OpenAPI versioning interact with GDCR?
---
Traditionally, a backend change forces a URL change (e.g., /v1/ to /v2/). In GDCR, we decouple Schema Versioning from Endpoint Routing.

Versioning Comparison (ASCII):

```text

[ TRADITIONAL VERSIONING ]             [ GDCR SEMANTIC STABILITY ]
     (Rigid & Explosive)                   (Fluid & Metadata-Driven)

      Client v1  Client v2                  Client v1  Client v2
          |          |                          |          |
          v          v                          +----+-----+
      [Proxy v1] [Proxy v2]                          v
          |          |                    [ SINGLE DOMAIN FACADE ]
          v          v                          | (JS Logic)
      [S/4 v1]   [S/4 v2]                       +----------+
                                                |          |
 RESULT: URL must change.               RESULT: URL is STABLE.
 Consumers MUST migrate.                Routing updated via KVM.

```
RESULT:

URL Stability: The URL remains stable.

Absorption: Backend changes are absorbed via metadata.

Migration: Consumers are not forced to migrate unless contract semantics change.

#### Q3 – Comparison: Documentation vs. Implementation
---
The main benefit of combining OpenAPI with GDCR is the separation of concerns.
```text

| Aspect        | OpenAPI / Swagger Role              | GDCR / DCRP Role                             |
|---------------|-------------------------------------|-------------------------------------------   |
| Visibility    | Public – the **menu** consumers see | Private – the **kitchen** where routing runs |
| Logic         | Defines valid inputs and outputs    | Executes routing and fast-fail validation    |
| Stability     | High, business-aligned              | Dynamic, system- and metadata-aligned        |
| Change Impact | Changes affect API consumers        | Changes affect only KVM / CPI internals      |

```
OpenAPI defines what the business capability does; GDCR determines how the request is fulfilled.

#### The "Contract vs. Route" Diagram (ASCII):
---

```text

[ OPENAPI SPEC ]                 [ GDCR ENGINE ]
    "What the user sees"            "How the data flows"
             |                               |
    GET /hr/emp/read/{id}  ----(Match)--->  Key: hr_emp_r
             |                               |
             |                      +--------v----------+
             |                      |   KVM LOOKUP      |
             |                      | rwd -> Workday    |
             |                      | rs4 -> S/4HANA    |
             |                      +--------+----------+
             |                               |
             +-----------(Execute)-----------+------> [ TARGET ]

```
### Q4 – How does routing actually occur behind the OpenAPI façade?
---
The OpenAPI contract exposes a semantic path, while the **DDCR engine** executes the deterministic routing lifecycle:

1. **Context Extraction**
2. **Route Guard Validation**
3. **Canonical Action Normalization**
4. **Deterministic Key Construction**
5. **Metadata Lookup (Control Plane)**
6. **Dynamic Target Binding**

```text
[ OPENAPI SPEC ] -> POST /sales/orders/create/{variant}
       |
       v
[ DDCR ENGINE ] -> Canonical normalization & Deterministic key build
       |
       v
[ METADATA CONTROL PLANE ] -> sales:orders:c:sf  =>  http://cpi/orders/global
       |
       v
[ EXECUTION TARGET ]
```
### Security & Routing Invariants

The **GDCR Framework** enforces a strict security boundary by decoupling client-side requests from backend-side execution.

> [!IMPORTANT]
> **Security Invariant:** No backend URL is ever derived from client input. All routing is resolved exclusively via **exact-match metadata lookup** within the Control Plane.

### Q5 – What are the benefits of using OpenAPI with GDCR?
---
Combining OpenAPI with the **GDCR framework** provides several strategic advantages for enterprise architecture, primarily by decoupling the consumer contract from the technical implementation:

* **Stable Domain-Centric Contracts:** Interfaces remain consistent and reliable for consumers, regardless of internal backend changes or migrations.
* **Reduced Version Fragmentation:** Prevents the "explosion" of API versions (v1, v2, v3...) that are typically triggered by minor technical shifts or backend upgrades.
* **Vendor Interchangeability:** Enables the business to switch vendors (e.g., moving from one CRM to another) or regions without impacting the API consumer's code.
* **Clear Separation of Documentation and Execution:** Effectively decouples the **"What"** (the Functional Contract) from the **"How"** (the Routing Logic).
* **Governance Aligned to Business Semantics:** Organizes the API catalog by business value and domains rather than technical system silos.
* **Scalable Routing without Proxy Proliferation:** Eliminates the "Proxy Sprawl" by removing the requirement to create a new proxy artifact for every new backend system added to the landscape.

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------
