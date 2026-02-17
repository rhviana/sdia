# FAQ – Routing Models: Traditional vs GDCR/DCRP

---

## Q1 – What is the common routing model in many landscapes?

Typical patterns:

- One proxy per backend/application/interface.
- URLs often encode system names (`/sap/fi/invoices`, `/salesforce/opportunities`, …).
- Routing rules are mostly static:
  - proxy → fixed backend,
  - occasional conditional flows inside the proxy, still system‑centric. [web:16][web:24]

```text
Client
  |
  +--> [Proxy: Salesforce_Orders]  -> CPI iFlow A -> Salesforce
  |
  +--> [Proxy: SAP_FI_Invoices]   -> CPI iFlow B -> SAP S/4HANA
  |
  +--> [Proxy: Workday_Employees] -> CPI iFlow C -> Workday

Result:

Many proxies and packages.

Little reuse at the level of business semantics.
