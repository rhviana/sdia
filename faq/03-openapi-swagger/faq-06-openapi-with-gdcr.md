# FAQ-06 – Using OpenAPI / Swagger with GDCR

## Q1 – How can I document GDCR façades with OpenAPI?

Example:

```yaml
paths:
  /sales/orders/create:
    post:
      summary: Create a sales order (vendor-agnostic)
      parameters:
        - name: variant
          in: query
          schema:
            type: string
            description: Optional vendor/region
      responses:
        '201':
          description: Order created
  /sales/orders/create/{variant}:
    post:
      summary: Create a sales order via specific vendor
      parameters:
        - name: variant
          in: path
          schema:
            enum: [salesforce, sap4hana, salesforceus, salesforceemea]
The spec describes the semantic surface; DCRP decides which backend/iFlow to call via KVM. [file:1][file:3]

Q2 – How does OpenAPI versioning interact with GDCR?
Façade (/sales/orders/create) remains stable.

If the payload schema changes:

you can bump an OpenAPI version (e.g. v2 in the spec),

but routing logic stays metadata‑driven.

You avoid:

changing URLs for backend‑only refactorings,

proliferating proxies just to point to new endpoints.

Q3 – What is the main benefit of combining OpenAPI with GDCR?
You get:

Clear semantic façade:

strongly structured URLs,

documented in OpenAPI.

Flexible implementation:

routing dictated by metadata in KVM,

backend changes implemented by KVM + CPI changes, not by façade changes.

This combination allows catalogs and governance tools to reason in terms of domain/entity/action rather than systems only. [web:32][web:38]

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
