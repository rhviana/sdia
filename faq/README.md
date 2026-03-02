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

#### 2. How to Read This Diagram

### Left: OpenAPI / Swagger — Contract-Centric Model

**Gateway Surface**  
Driven by OpenAPI/Swagger contracts:
- One endpoint per resource or process (`/sales/orders`, `/finance/invoices`, etc.).

**Routing**  
Contract-driven:
- Each endpoint is explicitly tied to a specific backend integration artifact.

**Change Impact**
- New process → new endpoint + new OpenAPI specification section.  
- Backend change → specification update + proxy modification.  
- Payload evolution → new API version (`v1`, `v2`, `v3`).

**Integration Layer**
- Packages organized per vendor or application (Salesforce, SAP, etc.).  
- Typically one iFlow per endpoint.  
- Naming and indexing often ad hoc or system-centric.

**Result**
- Growing number of endpoints and proxies over time.  
- Frequent versioning and redeployments.  
- Governance focused on **contracts and documentation**, not routing semantics.

---

### Right: GDCR / DCRP / PDCP — Domain-Centric Model

**Gateway Surface**
- Four stable domain façades (Sales, Finance, Logistics, Procurement).  
- Paths such as `/sales/**`, `/finance/**` grouped by business process (O2C, R2R, etc.).

**Routing**
- `domain/entity/action` parsed from the URL (e.g., `/sales/orders/create/salesforce`).  
- The engine builds a semantic routing key (e.g., `dcrporderscsalesforceid01:http`).  
- The KVM dictionary resolves to a CPI endpoint (e.g., `/http/dcrp/orders/c/id01`).

**Fast-Fail Security**
- Sender/token validated via KVM before routing.  
- Unauthorized combinations are rejected at the gateway layer without reaching CPI.

**Integration Layer (PDCP)**
- One package per domain or subprocess (e.g., `nx.sales.o2c.integrations`).  
- iFlows follow standardized “DNA” naming (id + subprocess + sender + entity + action).  
- Domain-centric execution governance and observability model.

**Result**
- Small, stable set of façades.  
- No façade versioning for backend changes; routing evolves via KVM updates.  
- Governance centered on **domain/entity/action semantics**, not technical endpoints.

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------
