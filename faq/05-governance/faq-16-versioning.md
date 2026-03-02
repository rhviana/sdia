# FAQ-16 — Versioning in GDCR

This document clarifies how versioning is managed within the **GDCR Framework**, emphasizing the decoupling of external contract stability from internal implementation cycles.

---

### Q1 – How is façade versioning handled?

In the GDCR model, versioning is treated as a rare exception rather than a routine requirement for technical updates.

* **Long-Lived URLs:** Façade URLs (e.g., `/sales/orders/create`) are designed to be domain-centric and highly stable over time.
* **Avoidance of URL Versioning:** Versioning at the URL level is avoided whenever possible to prevent consumer impact.
* **Breaking Changes:** If a fundamental, non-backward-compatible change is required, a new façade (e.g., `/v2/sales/orders/create`) can be created, but this is not the default behavior for backend updates.

---

### Q2 – Where does most versioning actually occur?

Versioning in GDCR is shifted "downstream," away from the consumer's view. It primarily occurs in:

1.  **CPI iFlows:** These represent the actual implementation artifacts.
2.  **KVM Routing Entries:** These map which specific iFlow version is currently active for a given route.

**Technical Example:**
* **Old Route:** `dcrporderscsalesforceid01:http` → points to `/http/dcrp/orders/c/id01`
* **New Route:** `dcrporderscsalesforceid02:http` → points to `/http/dcrp/orders/c/id02`
* **Result:** Clients continue calling the stable path `/sales/orders/create/salesforce` without modification.

---

### Q3 – How does this compare to traditional API versioning?

| Feature | Traditional (System-Centric) | GDCR (Domain-Centric) |
| :--- | :--- | :--- |
| **Trigger** | New backend schema = New API version | Backend evolution = Metadata update |
| **Consumer Impact** | Must migrate to new `/v2/...` paths | No impact; façade remains stable |
| **Artifacts** | New proxies and documentation required | New iFlow version + KVM update |
| **Coupling** | High (Contract tied to implementation) | Low (Contract decoupled from lifecycle) |

> **Strategic Benefit:** You decouple external contract stability from internal implementation cycles, allowing for agile backend evolution without breaking client integrations.

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------
