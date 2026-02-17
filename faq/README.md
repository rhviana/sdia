# FAQ – Traditional API Design vs GDCR/DCRP

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




```
