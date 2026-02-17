# FAQ 02 — Traditional Routing Model

## Model

Client
|
v
API Proxy
|
v
Backend


Characteristics:
- 1 proxy per backend or integration
- OpenAPI imported per system
- Proxy lifecycle tied to backend

---

## Resulting Landscape

APIM
├── sap-orders-proxy
├── salesforce-orders-proxy
├── stripe-payments-proxy
├── shopify-orders-proxy


This creates:
- Proxy sprawl
- Policy duplication
- Credential sprawl
- Deployment friction

------------------------------------

**Author:** Ricardo Luz Holanda Viana  
**Role:** Enterprise Integration Architect · SAP BTP Integration Suite  
**Creator of:** GDCR · DCRP · PDCP  

**Architectural scope:** Business‑semantic, domain‑centric routing architectures for API Gateways and Integration Orchestration (vendor‑agnostic), with SAP‑specific implementations via DCRP (SAP BTP API Management) and PDCP (SAP BTP Cloud Integration).  

**License:** Creative Commons Attribution 4.0 International (CC BY 4.0)  
**DOI:** [zenodo.18661136](https://doi.org/10.5281/zenodo.18582492)  
**DOI:** [figshare.31331683](https://doi.org/10.6084/m9.figshare.31331683)

This document is part of the **Gateway Domain‑Centric Routing (GDCR)** framework and represents original architectural work authored by Ricardo Luz Holanda Viana. Reuse, adaptation, and distribution are permitted only with proper attribution. Any derivative or equivalent architectural implementation must reference the original work and associated DOI.

-----------------------------------
