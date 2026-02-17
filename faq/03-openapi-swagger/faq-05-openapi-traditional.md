
# FAQ-05 – Traditional OpenAPI / Swagger Model

## Q1 – How is OpenAPI typically used in API Management?

In the standard model, the API lifecycle is System-Driven. The process usually follows these steps:

Schema Derivation: Teams export schemas directly from backends (e.g., OData from S/4HANA or REST from Salesforce).

Proxy Generation: APIM imports the Swagger/OpenAPI spec and generates a unique proxy.

Hardcoded Routing: Policies and targets are locked to the specific backend version defined in the spec.

URLs are technical and system-coded:

/sap/fi/invoices/v2/...

/salesforce/api/v42/opportunities/...

---

Q2 – Architectural Comparison: Traditional vs. GDCR
The traditional model creates a "Direct-Link" dependency, whereas GDCR creates an "Abstraction Layer."

Characteristics:

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

No.

- GDCR is about **routing topology and semantics**.
- OpenAPI remains valuable for:
  - documenting the façade,
  - contract testing,
  - client generation and catalogs.
 
Version Fragmentation: Every backend schema update forces a new API version (v1,v2), requiring expensive consumer migrations.Proxy Sprawl: The landscape grows horizontally. Managing security and monitoring across 500 system-specific proxies becomes a governance nightmare.Contract Rigidity: The contract is a mirror of the backend technical debt. If the backend is messy, the API is messy.

The difference is: with GDCR, OpenAPI describes the **business façade**, not each backend‑specific API.

## Q4 – Does GDCR reject OpenAPI?

Absolutely not. GDCR redefines the purpose of the OpenAPI specification.

- In the Traditional Model: OpenAPI describes the Implementation (How the backend works).
- In the GDCR Model: OpenAPI describes the Business Intent (What the business process does).

OpenAPI remains the primary tool for documentation, contract testing, and client SDK generation. The difference is that in GDCR, the OpenAPI spec points to a Domain Façade, and the routing logic (JS/KVM) manages the complexity of which backend version or system actually fulfills the request.

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
