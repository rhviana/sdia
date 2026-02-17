API Sprawl vs Domain-Centric Routing (DCRP - SAP)
-----------------------------------

<p align="center">
  <img src="./repository/figures/apisprawl.png"
       alt="API Sprawl vs Domain-Centric Routing (GDCR)"
       width="85%" />
</p>

<p align="center">
  <strong>Figure 1 — Domain-Centric Routing Pattern (DCRP - Apllied for SAP BTP) consolidates uncontrolled API
  proxy proliferation into a governed gateway layer aligned with Clean Core principles.</strong> 
</p>


PDCP (Package Domain-Centric Pattern)
-----------------------------------

## Package Sprawl vs Clean Core Orchestration (PDCP)

<p align="center">
  <img src="./repository/figures/orquestrationsprawl.png"
       alt="API Sprawl vs Domain-Centric Routing (GDCR)"
       width="85%" />
</p>

<p align="center">
  <strong>Figure 2 — Package Domain-Centric Pattern (PDCP), applied on SAP BTP Integration
Suite (Cloud Integration), eliminates package sprawl by consolidating integration
artifacts per business domain, fully aligned with Clean Core principles.</strong> 
</p>

**[Backend Layer (PDCP) - SAP BTP APIM - Specific](./src/backend-sap-cpi/)**: Domain-centric consolidation using the **iFlow DNA** naming standard.

SAP CPI - Backend integration consolidation pattern that organizes integration artifacts by business domain.

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
