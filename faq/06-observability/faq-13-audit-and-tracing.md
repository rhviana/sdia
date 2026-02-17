# FAQ-13 – Audit, Tracing and Observability

## Q1 – How does GDCR enable better tracing?

Every call through a GDCR façade is tagged with:

- `x-gdcr-sender-id`
- `x-gdcr-domain`
- `x-gdcr-entity`
- `x-gdcr-action`
- `x-gdcr-interface-id`
- `x-gdcr-correlation-id` [file:3]

These tags appear in:

- APIM logs,
- CPI iFlow logs,
- downstream logging/monitoring systems.

You can query by:

- domain/entity/action,
- correlation ID,
- sender ID.

---

## Q2 – Example end-to-end trace

```text
Client
  |
  |  POST /sales/orders/create/salesforce
  |  x-gdcr-sender-id: systemA
  |  x-gdcr-correlation-id: 12345
  v
+-----------------------------+
| APIM: Sales facade          |
| logs:                       |
|  - domain:  sales           |
|  - entity:  orders          |
|  - action:  c               |
|  - sender:  systemA         |
|  - corrId: 12345            |
+-----------------------------+
  |
  v
+-----------------------------+
| CPI: /http/dcrp/orders/c/id01|
| logs:                        |
|  - interface-id: id01...     |
|  - correlation-id: 12345     |
|  - backend status: 201       |
+-----------------------------+
  |
  v
[ Backend logs ]
Q3 – How is this better than traditional setups?
Traditional:

logs keyed by proxy name, iFlow name, technical IDs,

difficult to answer business questions without tribal knowledge.

GDCR:

logs aligned with business semantics:

“Show all sales/orders/c calls yesterday,”

“Show all failed finance/invoices/a operations.” [file:1][file:3]

This is a better fit for governance, compliance, and AI/analytics use cases.

Q4 – Do I need new tools?
No.

GDCR uses:

existing APIM logging/tracing,

CPI logs,

whatever SIEM/observability stack you already use.

The change is how you structure and tag the logs, not the tooling itself.
