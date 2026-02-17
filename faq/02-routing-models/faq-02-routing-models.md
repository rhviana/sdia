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
```
Result:

Many proxies and packages.

Little reuse at the level of business semantics.

Q2 – How does DCRP routing differ?
DCRP introduces domain façades and semantic routing:

One façade per domain/subprocess (e.g. /sales/**, /finance/**). [file:3]

Semantic pattern: /domain/entity/action[/variant]. [file:1]

```text
Client
  |
  |  POST /sales/orders/create/salesforce
  v
+-----------------------------+
| APIM: Sales facade          |
| /sales/**                   |
+-----------------------------+
  |
  | parse:  domain  = sales
  |         entity  = orders
  |         action  = create
  |         variant = salesforce
  | → key: dcrporderscsalesforceid01:http
  v
+-----------------------------+
| CPI: /http/dcrp/orders/c/id01|
+-----------------------------+
  |
  v
[ Service backend ]

```

Key points:

The façade is stable and domain‑oriented.

Routing uses metadata (KVM), not static proxy → endpoint mapping.

New vendors/variants are onboarded via KVM entries, not new proxies.

Q3 – Is DCRP just “conditional flows on steroids”?
Not exactly.

Traditional conditional flows:

match raw paths (/v1/Order/CreateOrder, /v1/Order/ReadOrder),

embed routing decisions directly in flow conditions and policies.

DCRP:

normalizes domain/entity/action/variant,

constructs a semantic key (dcrporderscsalesforceid01:http),

uses KVM as a routing dictionary,

keeps proxy policies generic and reusable across domains. [file:3]

DCRP = pattern + semantics + metadata + engine, not só “mais if/else”.

Q4 – How does GDCR handle multiple vendors and regions?
Via the {variant} segment and KVM keys:

URLs:

text
/sales/orders/create/salesforce
/sales/orders/create/salesforceus
/sales/orders/create/salesforceemea
KVM:

text
dcrporderscsalesforceid01:http
dcrporderscsalesforceusid02:http
dcrporderscsalesforceemeaid02:http
No new proxies. No façade changes. Only metadata and iFlow additions.
