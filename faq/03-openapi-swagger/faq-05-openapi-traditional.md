***

### 5) `03-openapi-swagger/faq-05-openapi-traditional.md`

```markdown
# FAQ-05 – Traditional OpenAPI / Swagger Model

## Q1 – How is OpenAPI typically used in API Management?

Common pattern:

1. Teams design APIs in OpenAPI/Swagger (often derived from backend schemas).
2. APIM imports the spec and generates a proxy.
3. Routing and policies are configured per generated proxy. [web:22][web:32]

URLs tend to be system‑driven:

- `/sap/fi/invoices/v1/...`
- `/salesforce/opportunities/v1/...`

---

## Q2 – What are the implications of this model?

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

---

## Q3 – Does GDCR reject OpenAPI?

No.

- GDCR is about **routing topology and semantics**.
- OpenAPI remains valuable for:
  - documenting the façade,
  - contract testing,
  - client generation and catalogs.

The difference is: with GDCR, OpenAPI describes the **business façade**, not each backend‑specific API.

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
