# FAQ-13 — Audit, Tracing and Observability

This document defines how the **GDCR Framework** transforms technical logs into business-aware observability through structured semantic enrichment.

---

### Q1 – How does GDCR enable better tracing?

Every request passing through a GDCR façade is automatically enriched with structured semantic headers that serve as a universal metadata layer. These tags propagate across **API Management logs**, **CPI iFlow logs**, and downstream monitoring systems.

#### Structured Semantic Headers:
* **x-gdcr-sender-id**: Identifies the specific consumer or system.
* **x-gdcr-domain**: The business domain (e.g., Sales, Finance).
* **x-gdcr-entity**: The business object (e.g., Orders, Invoices).
* **x-gdcr-action**: The normalized operation performed (c, r, u, d, a).
* **x-gdcr-interface-id**: Unique identifier for the technical interface.
* **x-gdcr-correlation-id**: Global ID to link the entire transaction across distributed systems.

**The Result:** Tracing becomes **domain-aware** rather than artifact-aware. You can query your entire landscape by Domain, Entity, or Sender instead of searching through cryptic technical iFlow names.

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
```

### Q3 – How is this better than traditional setups?

In traditional system-centric architectures, logs are typically keyed by technical identifiers such as **proxy names**, **iFlow names**, or **technical interface IDs**. Answering simple business questions often requires "tribal knowledge" to map those technical names back to a business process.

#### The Traditional Difficulty:
* **Question:** “Which finance invoice operations failed yesterday?”
* **Problem:** Requires an engineer who knows exactly which specific proxy or iFlow handles invoices.

#### The GDCR Advantage:
GDCR aligns logs directly with **business semantics**, making the data accessible to both technical and business stakeholders.

* **Semantic Query Examples:**
    * “Show all `sales/orders/c` (create) calls yesterday.”
    * “Show all failed `finance/invoices/a` (approve) operations.”

**This alignment significantly improves:**
* **Governance:** Clear visibility into domain health.
* **Compliance Reporting:** Structured data for regulatory audits.
* **Auditability:** Forensic traceability by Sender, Domain, and Action.
* **AI/Analytics Readiness:** Clean, structured data ready for machine learning and automated insights.

---

### Q4 – Do I need new tools?

**No.**

GDCR does not require a new observability or monitoring stack. Instead, it leverages your existing infrastructure more effectively:

* **API Management Logging:** Enriched with semantic headers.
* **CPI Runtime Logs:** Carrying the global correlation ID.
* **Existing SIEM/Observability Stacks:** Tools like Splunk, ELK, or SAP CloudALM simply receive better-structured data.

> [!TIP]
> **The shift is structural, not technological.** GDCR changes **how** logs are tagged and structured at the source, ensuring your current tools provide significantly higher value.

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------


This document is part of the **Gateway Domain‑Centric Routing (GDCR)** framework and represents original architectural work authored by Ricardo Luz Holanda Viana. Reuse, adaptation, and distribution are permitted only with proper attribution. Any derivative or equivalent architectural implementation must reference the original work and associated DOI.

-----------------------------------
