# FAQ – Core Assumptions Behind GDCR

This FAQ compares a **traditional OpenAPI/Swagger, contract‑centric model** with the **GDCR/DCRP domain‑centric, metadata‑driven model** on SAP API Management + SAP Cloud Integration. The goal is to show, visually, how routing, versioning, and governance differ.

## 1. High-Level Comparison Diagram

```
┌──────────────────────────────────────────────┐       ┌──────────────────────────────────────────────┐
│        OPENAPI / SWAGGER MODEL               │  VS   │             GDCR / DCRP MODEL                │
│        (Contract-Centric)                    │       │      (Dynamic Routing + Stable Facade)       │
└──────────────────────────────────────────────┘       └──────────────────────────────────────────────┘
                    |                                                         |
         ___________v_____________                             _______________v________________
        | API Gateway / APIM      |                           | DCRP Layer (API Gateway)       |
        | OpenAPI / Swagger Spec  |                           | SAP BTP IS - API Mgmt          |
        |  _____________________  |                           |  ____________________________  |
        | | Explicit Endpoints  | |                           | | Stable Domain Facades      | |
        | | (examples only)     | |                           | | (4 Proxies)                | |
        | |                     | |                           | |                            | |
        | | Sales:              | |                           | | * SALES                    | |
        | |  /sales/orders      | |                           | |   /sales/** (10+ paths)    | |
        | |  /sales/customers   | |                           | |     Routing                | |
        | |  /sales/payments    | |                           | |     O2C - sales-o2c-ords   | |
        | |  ...                | |                           | |      path: "/orders/**"    | |
        | |                     | |                           | |     O2C - sales-o2c-cust   | |
        | | Finance:            | |                           | |      path: "/customers/**" | |
        | |  /finance/assets    | |                           | |     O2C - sales-o2c-paym   | |
        | |  /finance/invoices  | |                           | |      path: "/payments/**"  | |
        | |  /finance/accounts  | |                           | |     ...                    | |
        | |  ...                | |                           | |                            | |
        | | Logistics:          | |                           | | * FINANCE                  | |
        | |  /logistics/ships   | |                           | |   /finance/** (10+ paths)  | |
        | |  /logistics/routes  | |                           | |     Routing                | |
        | |  ...                | |                           | |     R2R - fin-invoices     | |
        | | Procurement:        | |                           | |      path: "/invoices/**"  | |
        | |  /procurement/ords  | |                           | |     R2R - fin-payments     | |
        | |  /procurement/paym  | |                           | |      path: "/payments/**"  | |
        | |  ...                | |                           | |     R2R - fin-accounts     | |
        | |_____________________| |                           | |      path: "/accounts/**"  | |
        | Contract-Driven Routing |                           | |     ...                    | |
        |                         |                           | |____________________________| |
        | Change Impact:          |                           | Metadata-Driven Routing        |
        | - New process           |                           | (KVM / Dictionary)             |
        |   -> New endpoint       |                           | URL Construction (JS)          |
        | - Backend change        |                           | Fast-Fail Runtime Logic        |
        |   -> Spec update        |                           |                                |
        | - Payload evolution     |                           | Integration Layer              |
        |   -> New API version    |                           | (CPI / Services)               |
        |                         |                           |                                |
        | Frequent Versioning     |                           | One Package per Domain         |
        | v1 / v2 / v3 / vN       |                           | Business Process =             |
        |                         |                           | One iFlow (DNA Indexed)        |
        | Deploy Required         |                           |                                |
        | (Spec + Policies)       |                           | Execution Governance           |
        |_________________________|                           |________________________________|
                    |                                                         |
                    |                                                         |
         ___________v_____________                             _______________v______________
        |    Integration Layer    |                           |    PDCP INTEGRATION LAYER    |
        | (SAP CPI / Services)    |                           |     (SAP CPI/Services)       |
        |                         |                           |                              |
        | Package per Vendor/App  |                           | One Package per Domain       |
        |                         |                           |                              |
        | One Flow per Endpoint   |                           | Business Process =           |
        |                         |                           | iFlows with DNA + Indexing   |
        | iFlows: No Indexing or  |                           |                              |
        | Proper Naming Convention|                           | Standardized iFlow DNA       |
        |                         |                           | Naming & Indexing            |
        | URLs: No clear          |                           |                              |
        | Definition Convention   |                           | Execution Governance         |
        |                         |                           | (Domain-Centric)             |
        | Documentation Governance|                           |                              |
        |_________________________|                           |______________________________|
                    |                                                         |
     _____________  |  _________________                    ________________  |  ________________
     |              |                  |                    |                 |                 |
_____v_____     ____v_________     ____v_______           __v_______      ____v________     ____v______
|Salesforce|    | SAP S/4HANA |    | Custom   |          |Salesforce|    | SAP S/4HANA |    | Custom   |
|   API    |    |             |    | Backend  |          |   API    |    | SAP ECC          | Backend  |
|__________|    |_____________|    |__________|          |__________|    |_____________|    |__________|



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

## 2.  How to read this diagram

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

# GDCR FAQ – Traditional vs Domain-Centric Architecture

This FAQ compares traditional, contract‑centric API designs with the GDCR (Gateway Domain‑Centric Routing) approach implemented via DCRP (gateway) and PDCP (integration) on SAP BTP Integration Suite.



## Q1 – Is SAP APIM (or any gateway) limited to 1:1 routing?

**No.** Modern gateways support 1:N routing (conditional flows, routing rules, header/path‑based routing). [web:18][web:24]

What GDCR assumes:

- In many enterprise landscapes, the **prevailing configuration pattern** is:
  - one proxy per backend system or integration,
  - one integration package per application or project,
  - naming and URLs that expose vendor/system details. [file:3][web:16][web:23]

GDCR treats this as the *starting point* (a common reality), not as a technical limitation.

---

## Q2 – What problems is GDCR explicitly trying to solve?

GDCR targets three structural problems:

1. **Proxy sprawl** – too many small, system‑centric proxies at the gateway.  
2. **Package/iFlow sprawl** – too many integration packages and iFlows grouped per system or project.  
3. **Credential sprawl** – many technical users and secrets scattered across proxies and packages. [file:1][file:3]

Side effects:

- Governance based on technical artifacts instead of business flows.
- Difficulty to reason about “how many Sales Order Create operations we really have”.
- High cost and risk when changing vendors or refactoring backends.

---

## Q3 – What does GDCR *not* claim?

GDCR does *not* claim that:

- SAP APIM or other gateways cannot do conditional routing or 1:N patterns.
- Domain‑centric designs do not exist at all in the wild.
- Using OpenAPI/Swagger is “wrong”.

Instead, GDCR says:

- The **dominant pattern** in many landscapes is system‑driven and leads to sprawl. [web:16][web:23]  
- A domain‑centric, metadata‑driven approach can significantly reduce sprawl and improve governance, as shown in the BTP sandbox/trial reference implementation. [file:3]

---

## Q4 – Is GDCR SAP-specific?

No.

- The reference implementation is on SAP BTP Integration Suite (SAP API Management + Cloud Integration). [file:3]  
- The architectural concepts (domain façades, semantic control plane, naming alignment) are portable to:
  - Apigee (JS + KVM),
  - Kong / APISIX (Lua plugins + Redis/Postgres),
  - AWS API Gateway (Lambda + DynamoDB),
  - Azure APIM (C# policies + storage),
  - MuleSoft (DataWeave + Object Store). [file:2]

GDCR is **vendor‑agnostic by design**; SAP BTP is one concrete proof of concept.

---

## Q5 – Is GDCR only about routing?

No. GDCR is a **multi‑layer pattern** that covers:

- Routing (DCRP – Domain‑Centric Routing Pattern). [file:3]  
- Package and iFlow layout (PDCP – Package Domain‑Centric Pattern). [file:3]  
- Naming and indexing conventions.  
- Security model (fast‑fail, sender × domain/entity/action matrix). [file:1]  
- Governance and observability (KPIs, semantic logs).

Routing is the visible front; the **real value** is the consistent semantic model across layers.

This FAQ compares a **traditional OpenAPI/Swagger, contract‑centric model** with the **GDCR/DCRP domain‑centric, metadata‑driven model** on SAP API Management + SAP Cloud Integration. The goal is to show, visually, how routing, versioning, and governance differ.

## 1. High-Level Comparison Diagram

```
┌──────────────────────────────────────────────┐       ┌──────────────────────────────────────────────┐
│        OPENAPI / SWAGGER MODEL               │  VS   │             GDCR / DCRP MODEL                │
│        (Contract-Centric)                    │       │      (Dynamic Routing + Stable Facade)       │
└──────────────────────────────────────────────┘       └──────────────────────────────────────────────┘
                    |                                                         |
         ___________v_____________                             _______________v________________
        | API Gateway / APIM      |                           | DCRP Layer (API Gateway)       |
        | OpenAPI / Swagger Spec  |                           | SAP BTP IS - API Mgmt          |
        |  _____________________  |                           |  ____________________________  |
        | | Explicit Endpoints  | |                           | | Stable Domain Facades      | |
        | | (examples only)     | |                           | | (4 Proxies)                | |
        | |                     | |                           | |                            | |
        | | Sales:              | |                           | | * SALES                    | |
        | |  /sales/orders      | |                           | |   /sales/** (10+ paths)    | |
        | |  /sales/customers   | |                           | |     Routing                | |
        | |  /sales/payments    | |                           | |     O2C - sales-o2c-ords   | |
        | |  ...                | |                           | |      path: "/orders/**"    | |
        | |                     | |                           | |     O2C - sales-o2c-cust   | |
        | | Finance:            | |                           | |      path: "/customers/**" | |
        | |  /finance/assets    | |                           | |     O2C - sales-o2c-paym   | |
        | |  /finance/invoices  | |                           | |      path: "/payments/**"  | |
        | |  /finance/accounts  | |                           | |     ...                    | |
        | |  ...                | |                           | |                            | |
        | | Logistics:          | |                           | | * FINANCE                  | |
        | |  /logistics/ships   | |                           | |   /finance/** (10+ paths)  | |
        | |  /logistics/routes  | |                           | |     Routing                | |
        | |  ...                | |                           | |     R2R - fin-invoices     | |
        | | Procurement:        | |                           | |      path: "/invoices/**"  | |
        | |  /procurement/ords  | |                           | |     R2R - fin-payments     | |
        | |  /procurement/paym  | |                           | |      path: "/payments/**"  | |
        | |  ...                | |                           | |     R2R - fin-accounts     | |
        | |_____________________| |                           | |      path: "/accounts/**"  | |
        | Contract-Driven Routing |                           | |     ...                    | |
        |                         |                           | |____________________________| |
        | Change Impact:          |                           | Metadata-Driven Routing        |
        | - New process           |                           | (KVM / Dictionary)             |
        |   -> New endpoint       |                           | URL Construction (JS)          |
        | - Backend change        |                           | Fast-Fail Runtime Logic        |
        |   -> Spec update        |                           |                                |
        | - Payload evolution     |                           | Integration Layer              |
        |   -> New API version    |                           | (CPI / Services)               |
        |                         |                           |                                |
        | Frequent Versioning     |                           | One Package per Domain         |
        | v1 / v2 / v3 / vN       |                           | Business Process =             |
        |                         |                           | One iFlow (DNA Indexed)        |
        | Deploy Required         |                           |                                |
        | (Spec + Policies)       |                           | Execution Governance           |
        |_________________________|                           |________________________________|
                    |                                                         |
                    |                                                         |
         ___________v_____________                             _______________v______________
        |    Integration Layer    |                           |    PDCP INTEGRATION LAYER    |
        | (SAP CPI / Services)    |                           |     (SAP CPI/Services)       |
        |                         |                           |                              |
        | Package per Vendor/App  |                           | One Package per Domain       |
        |                         |                           |                              |
        | One Flow per Endpoint   |                           | Business Process =           |
        |                         |                           | iFlows with DNA + Indexing   |
        | iFlows: No Indexing or  |                           |                              |
        | Proper Naming Convention|                           | Standardized iFlow DNA       |
        |                         |                           | Naming & Indexing            |
        | URLs: No clear          |                           |                              |
        | Definition Convention   |                           | Execution Governance         |
        |                         |                           | (Domain-Centric)             |
        | Documentation Governance|                           |                              |
        |_________________________|                           |______________________________|
                    |                                                         |
     _____________  |  _________________                    ________________  |  ________________
     |              |                  |                    |                 |                 |
_____v_____     ____v_________     ____v_______           __v_______      ____v________     ____v______
|Salesforce|    | SAP S/4HANA |    | Custom   |          |Salesforce|    | SAP S/4HANA |    | Custom   |
|   API    |    |             |    | Backend  |          |   API    |    | SAP ECC          | Backend  |
|__________|    |_____________|    |__________|          |__________|    |_____________|    |__________|

```

## How to read this diagram

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

### 3. Where to find more details

This root FAQ just gives the big picture. For deeper dives:

- **Patterns vs GDCR** – `01-patterns-vs-gdcr.md`  
- **OpenAPI / Swagger vs GDCR** – `02-openapi-vs-gdcr.md`  
- **Security and Access Control (fast‑fail, OAuth, senders)** – `03-security-and-access.md`  
- **Versioning and KVM Strategy** – `04-versioning-and-kvm.md`  
- **Governance and Sprawl Reduction** – `05-governance-and-sprawl.md`


