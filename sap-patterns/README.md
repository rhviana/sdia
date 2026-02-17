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
