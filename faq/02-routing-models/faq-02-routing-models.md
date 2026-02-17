# FAQ – Routing Models: Traditional vs GDCR/DCRP

## Q1 – What is the common routing model in many landscapes?

The traditional pattern is **system-oriented**. It creates a rigid relationship between the API Proxy and the technical backend.

### Typical Characteristics:
* **One Proxy per Backend:** Every unique interface requires a new proxy.
* **System-Encoded URLs:** Paths explicitly mention the system (e.g., `/sap/fi/invoices`).
* **Static Routing:** The mapping is hardcoded in the Target Endpoint.

#### Traditional Architecture (ASCII):

```text
Client
  |
  +--> [Proxy: Salesforce_Orders]  --> CPI iFlow A --> Salesforce
  |
  +--> [Proxy: SAP_FI_Invoices]    --> CPI iFlow B --> SAP S/4HANA
  |
  +--> [Proxy: Workday_Employees]  --> CPI iFlow C --> Workday
Client
  |
  +--> [Proxy: Salesforce_Orders]  -> CPI iFlow A -> Salesforce
  |
  +--> [Proxy: SAP_FI_Invoices]   -> CPI iFlow B -> SAP S/4HANA
  |
  +--> [Proxy: Workday_Employees] -> CPI iFlow C -> Workday
```
Result:

Many proxies and packages.

Little reuse at the level of business semantics.

Q2 – How does DCRP routing differ?
DCRP introduces Domain Façades and Semantic Routing. It abstracts the backend complexity using a stable pattern: /{domain}/{entity}/{action}/{variant}.

DCRP Architecture (ASCII):
```text
Client 
  |  
  |   POST /sales/orders/create/salesforce
  v
+------------------------------------+
|       SAP APIM: Sales Facade       |
|       Path: /sales/** |
+------------------------------------+
  |
  |  Logic:
  |  1. Parse: d/e/a/variant
  |  2. Build Key: dcrp:orders:c:sf
  |  3. KVM Lookup: Get Target URL
  |  4. JS Engine: Build Final URL
  v
+------------------------------------+
|    SAP CPI: /http/dcrp/orders/c    |
+------------------------------------+
  |
  v
[ Service Backend ]
```

Key points:

The façade is stable and domain‑oriented.

Routing uses metadata (KVM), not static proxy → endpoint mapping.

New vendors/variants are onboarded via KVM entries, not new proxies.

Q3 – Comparison: Traditional vs. DCRP
This table highlights the shift from technical silos to business domains.
```text

| Feature        | Traditional Model           | DCRP / GDCR Model                 |
|---------------|----------------------------- |-----------------------------------|
| Focus         | System-oriented              | Domain-oriented                   |
| Routing       | Static (hardcoded)           | Dynamic (metadata / KVM-based)    |
| Onboarding    | New proxy deployment         | New KVM entry + shared JS engine  |
| Scalability   | Low (proxy sprawl)           | High (metadata-driven)            |
| URL Stability | Changes with backend systems | Stable, business-centric interface|
```

## Q4 – How does GDCR handle multiple vendors and regions?

GDCR uses the `{variant}` segment to support multiple vendors, regions, or deployment variants without changing API proxy code.

### 1. Semantic URL Mapping

Consumers call logical, business‑centric URLs that include the variant:

```text
/sales/orders/create/salesforce      <-- Global instance
/sales/orders/create/salesforceus    <-- USA region
/sales/orders/create/salesforceemea  <-- Europe region
```
2. KVM Key Resolution (“Truth Table”)

The routing engine normalizes the request into a KVM key that maps business intent to a concrete backend endpoint.

| Business Intent (URL)                      | Generated KVM Key        | Target Value (CPI / Backend)    |
|-------------------------------------------|--------------------------|--------------------------------- |
| `/sales/orders/create/salesforce`         | `sales:orders:c:sf`      | `http://cpi/orders/global`       |
| `/sales/orders/create/salesforceus`       | `sales:orders:c:sfus`    | `http://cpi/orders/usa`          |
| `/sales/orders/create/salesforceemea`     | `sales:orders:c:sfemea`  | `http://cpi/orders/emea`         |

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
