
GDCR Architectural Scope
-----------------------------------

Gateway Domain-Centric Routing (GDCR) is not a single pattern or implementation.
It is a composite architectural framework designed to govern enterprise integration landscapes at scale.

DCRP and PDCP are its core execution patterns, but GDCR also formalizes:

- metadata as a control plane
- naming conventions as governance mechanisms
- immutable integration identities (iFlow DNA)
- documented architectural decisions (ADR)

Together, these elements operate as one cohesive system, preventing uncontrolled architectural entropy.


SAP-Specific Architecture Diagram (DCRP + PDCP)
The diagrams above describe the vendor-agnostic GDCR + DDCR framework.
The following architecture diagram shows one concrete realization on
SAP BTP Integration Suite, where:

- DCRP implements the GDCR gateway layer (SAP API Management).
- DDCR is implemented via JavaScript routing logic + KVM (Maverick Engine).
- PDCP implements the orchestration layer on SAP Cloud Integration (CPI).
-----------------------------------

```text
                         _________________________________________________________
                        |    External Consumers / AI Agents | Applications        |
                        |                 40 external vendors                     |
                        |     Only - 4 endpoints DCRP-Proxies / many paths        |
                        |___________________________ _____________________________|
                                                    |
                                      ______________v_______________
                                     |   DCRP Layer (API Gateway)    |
                                     |  SAP BTP IS - API Management  |
                                     |  ___________________________  |
                                     | | 4 Domain Proxies:         | |
                                     | | * Sales      10+ bprocess | |
                                     | | * Finance    10+ bprocess | |
                                     | | * Logistics  10 bprocess  | |
                                     | | * Customer   10 bprocess  | |
                                     | |___________________________| |
                                     |    Metadata-Driven Routing    |
                                     |_______________ _______________|
                                                     |
                                      _______________v_______________
                                     |      PDCP Layer (SAP CPI)     |
                                     | Integration / Orchestration   |
                                     |  ___________________________  |
                                     | | 4 Domain Packages:        | |
                                     | | - Sales      10 Iflows    | |
                                     | | - Finance    10 Iflows    | |
                                     | | - Logistics  10 Iflows    | |
                                     | | - Customer   10 Iflows    | |
                                     | |___________________________| |
                                     |      Domain-Driven Design     |
                                     |_______________ _______________|
                                                     |
                              _______________________|_______________________
                             |                       |                       |
                      _______v_______         _______v_______         _______v_______
                     |  Salesforce   |       |      SAP      |       |    Custom     |
                     |      API      |       |    S/4HANA    |       |    Backend    |
                     |_______________|       |_______________|       |_______________|

```

The 7 Core GDCR Patterns
-----------------------------------

GDCR is composed of seven complementary architectural patterns:
- Domain-Centric Routing Pattern (DCRP) — Semantic routing at the gateway layer
- Package Domain-Centric Pattern (PDCP) — Domain-based backend consolidation
- Metadata-Driven Routing Pattern — Externalized routing decisions (KVM / KV Store)
- Action Normalization Pattern — Canonical business actions (C, R, U, D, A…)
- Proxy Consolidation Pattern — One proxy per strategic domain
- Immutable Integration Identity Pattern (iFlow DNA) — Permanent, non-reusable flow identities
- Architectural Decision Record (ADR) Pattern — Explicit architectural traceability

These patterns are interdependent but also can work isolated of each other - DCRP and PDCP and the ideal scenario be applied together for full domain-centric layer from the gateway, orquestraction connected with CORE BUSINESS ERP.



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
