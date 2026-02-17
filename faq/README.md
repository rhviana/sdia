## FAQ – Core Assumptions Behind GDCR

This FAQ compares a **traditional OpenAPI/Swagger, contract‑centric model** with the **GDCR/DCRP domain‑centric, metadata‑driven model** on SAP API Management + SAP Cloud Integration. The goal is to show, visually, how routing, versioning, and governance differ.

#### 1. High-Level Comparison Diagram
-----------------------------------

```
┌──────────────────────────────────────────────┐        ┌──────────────────────────────────────────────┐
│        OPENAPI / SWAGGER MODEL               │  VS    │             GDCR / DCRP MODEL                │
│        (Contract-Centric)                    │        │      (Dynamic Routing + Stable Facade)       │
└──────────────────────────────────────────────┘        └──────────────────────────────────────────────┘
                    |                                                         |
         ___________v_____________                             _______________v________________
        | API Gateway / APIM      |                           | DCRP Layer (API Gateway)       |
        | OpenAPI / Swagger Spec  |<-- Contract-driven        | SAP BTP IS - API Mgmt          |
        |  _____________________  |                           |  ____________________________  |
        | | Explicit Endpoints  | |                           | | Stable Domain Facades      | |
        | | (per resource)      | |                           | | (4 Proxies total)          | |
        | |                     | |                           | |                            | |
        | | Sales:              | |                           | | * SALES (domain facade)    | |
        | |  /sales/orders      | |                           | |   /sales/**                | |
        | |  /sales/customers   | |                           | |    - O2C orders:           | |
        | |  /sales/payments    | |                           | |      path "/orders/**"     | |
        | |  ...                | |                           | |    - O2C customers:        | |
        | |                     | |                           | |      path "/customers/**"  | |
        | | Finance:            | |                           | |    - O2C payments:         | |
        | |  /finance/assets    | |                           | |      path "/payments/**"   | |
        | |  /finance/invoices  | |                           | |* FINANCE (domain facade)   | |
        | |  /finance/accounts  | |                           | |   /finance/**              | |
        | |  ...                | |                           | |    - R2R invoices:         | |
        | |                     | |                           | |      path "/invoices/**"   | |
        | | Logistics:          | |                           | |    - R2R payments:         | |
        | |  /logistics/ships   | |                           | |      path "/payments/**"   | |
        | |  /logistics/routes  | |                           | |    - R2R accounts:         | |
        | |  ...                | |                           | |      path "/accounts/**"   | |
        | | Procurement:        | |                           | |    - ...                   | |
        | |  /procurement/ords  | |                           | |                            | |
        | |  /procurement/paym  | |                           | |<-- Metadata-driven routing | |
        | |  ...                | |                           | |    (KVM + JS engine)       | |
        | |_____________________| |                           | |    - build semantic key    | |
        | Contract-Driven Routing |<-- URL = contract         | |      dcrp{entity}{action}… | |
        |                         |                           | |    - lookup target in KVM  | |
        | Change Impact:          |                           | |    - set target URL (CPI)  | |
        | - New process           |                           | |____________________________| |
        |   -> New endpoint       |                           |                                |
        | - Backend change        |                           | Fast-Fail + Semantic AuthZ     |
        |   -> Spec + proxy update|                           |  - sender x d/e/a matrix       |
        | - Payload evolution     |                           |  - 401/403 before routing      |
        |   -> New API version    |                           |                                |
        |                         |                           |                                |
        | Frequent Versioning     |<-- v1/v2/v3 per API       | One Package per Domain         |
        | v1 / v2 / v3 / vN       |                           | Business Process = iFlow DNA   |
        | Deploy Required         |<-- spec + proxy redeploy  | Change via KVM, not façade     |
        | (Spec + Policies)       |                           |________________________________|
        |_________________________|                                           |
                    |                                                       (semantic key)
                    |                                                         |
         ___________v_____________                             _______________v______________
        |    Integration Layer    |                           |    PDCP INTEGRATION LAYER    |
        | (SAP CPI / Services)    |                           |     (SAP CPI/Services)       |
        |                         |                           |                              |
        | Package per Vendor/App  |<-- system-centric         | One Package per Domain       |
        |                         |                           |  - nx.sales.o2c.integrations |
        | One Flow per Endpoint   |                           |  - nx.finance.r2r.integr.    |
        |                         |                           |                              |
        | iFlows: ad hoc naming   |<-- hard to search         | iFlows with DNA + indexing   |
        |  - Z_SFDC_ORDERS_01     |                           |  - id01.o2c.salesforce.order |
        |  - Z_SAP_FI_INV_99      |                           |  - id02.o2c.salesforce.order |
        | URLs: no clear pattern  |                           |  - id05.r2r.sap4hana.invoice |
        |                         |                           |                              |
        | Doc-based governance    |                           | Domain-centric governance    |
        |  - per API spec         |                           |  - KPIs by d/e/a             |
        |_________________________|                           |______________________________|
                    |                                                         |
     _____________  |  _________________                    ________________  |  ________________
     |              |                  |                    |                 |                 |
_____v_____     ____v_________     ____v_______           __v_______      ____v________     ____v______
|Salesforce|    | SAP S/4HANA |    | Custom   |          |Salesforce|    | SAP S/4HANA |    | Custom   |
|   API    |    |             |    | Backend  |          |   API    |    | SAP ECC     |    | Backend  |
|__________|    |_____________|    |__________|          |__________|    |_____________|    |__________|

```

#### 2.  How to read this diagram

### Left: OpenAPI / Swagger, contract‑centric model

**Gateway surface** is driven by OpenAPI/Swagger contracts:  
- One endpoint per resource/process (`/sales/orders`, `/finance/invoices`, etc.).

**Routing** is contract‑driven:  
- Each endpoint is tied to a specific backend integration.

**Change impact:**  
- New process → new endpoint + new OpenAPI spec section.  
- Backend change → spec update + proxy change.  
- Payload evolution → new API version (`v1`, `v2`, `v3`).

**Integration layer:**  
- Packages per vendor/app (Salesforce, SAP, etc.).  
- One iFlow per endpoint.  
- Naming and indexing often ad hoc.

**Result:**  
- More endpoints and proxies over time.  
- Frequent versioning and redeployments.  
- Governance focused on **contracts and docs**, not on routing semantics.

---

### Right: GDCR / DCRP / PDCP domain‑centric model

**Gateway surface:**  
- 4 stable domain façades (Sales, Finance, Logistics, Procurement).  
- Paths like `/sales/**`, `/finance/**` grouped by business process (O2C, R2R, etc.).

**Routing:**  
- `domain/entity/action` are parsed from the URL (e.g. `/sales/orders/create/salesforce`).  
- The engine builds a semantic key (e.g. `dcrporderscsalesforceid01:http`).  
- The KVM dictionary resolves to a CPI endpoint (`/http/dcrp/orders/c/id01`).

**Fast‑fail:**  
- Sender/token validated in KVM before routing.  
- Unauthorized calls are rejected without reaching CPI. [file:1][file:3]

**Integration layer (PDCP):**  
- One package per domain/subprocess (e.g. `nx.sales.o2c.integrations`).  
- iFlows use standardized “DNA” naming (id + subprocess + sender + entity + action…).  
- Domain‑centric execution governance and observability. [file:3]

**Result:**  
- Small, stable set of façades.  
- No façade versioning for backend changes; routing moves via KVM updates.  
- Governance focused on **domain/entity/action**, not on technical endpoints.

---

#### 3. Where to find more details

- Core assumptions – 01-core-assumptions/faq-01-core-assumptions.md
- Routing models – 02-routing-models/faq-02-routing-models.md
- OpenAPI / Swagger vs GDCR – 03-openapi-swagger/faq-05-openapi-traditional.md and 03-openapi-swagger/faq-06-openapi-with-gdcr.md
- Security and access control – files in 04-security/
- Governance and sprawl – files in 05-governance/
- Observability and tracing – 06-observability/faq-13-audit-and-tracing.md

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



