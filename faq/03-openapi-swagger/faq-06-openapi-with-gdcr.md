## FAQ-06 – Using OpenAPI / Swagger with GDCR

#### Q1 – How can I document GDCR façades with OpenAPI?
---
In the GDCR model, the OpenAPI spec describes the Domain Logic, not the backend implementation. You define paths that represent business actions.

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
The spec defines the Contract; DCRP fulfills the Routing via KVM lookup.

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
#### Q4 – Summary of Benefits
---
Clear Semantic Façade: Catalogs and governance tools see business domains (Sales, Finance), not a list of systems.

Developer Experience (DX): Consumers use predictable, human-readable URLs.

Governance at Scale: You can apply global policies (Security, Logging) once at the Façade level, rather than repeating them across 100 system-specific proxies.

-----------------------------------

**Author:** Ricardo Luz Holanda Viana  
**Role:** Enterprise Integration Architect · SAP BTP Integration Suite  
**Creator of:** GDCR · DCRP · PDCP  

**Architectural scope:** Business‑semantic, domain‑centric routing architectures for API Gateways and Integration Orchestration (vendor‑agnostic), with SAP‑specific implementations via DCRP (SAP BTP API Management) and PDCP (SAP BTP Cloud Integration).  

**License:** Creative Commons Attribution 4.0 International (CC BY 4.0)  
**DOI:** [zenodo.18661136](https://doi.org/10.5281/zenodo.18582492)  
**DOI:** [figshare.31331683](https://doi.org/10.6084/m9.figshare.31331683)

This document is part of the **Gateway Domain‑Centric Routing (GDCR)** framework and represents original architectural work authored by Ricardo Luz Holanda Viana. Reuse, adaptation, and distribution are permitted only with proper attribution. Any derivative or equivalent architectural implementation must reference the original work and associated DOI.

-----------------------------------
