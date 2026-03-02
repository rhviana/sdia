# FAQ-14 — Impact of Change & Governance

This document compares how traditional models and the **GDCR Framework** handle technical evolution and the resulting governance benefits.

---

### Q1 — How do traditional designs handle change?

In traditional system-centric models, technical evolution triggers cascading artifact changes and redeployments.

* **New Process:** Requires a new endpoint or a new proxy.
* **Backend Change:** Requires updating proxy logic and performing a full redeployment.
* **Payload Change:** Often forces a new API version (v2, v3), impacting consumers.

**The Result:**
* Exponential growth of deployments and managed artifacts.
* Significant version fragmentation.
* Increased risk of breaking client integrations due to URL changes.

> **Traditional Workflow:** `Change Backend` → `Change Proxy` → `Redeploy` → `Possible URL Change`.

---

### Q2 — How does GDCR handle change?

**GDCR/DCRP** introduces **Metadata Abstraction**, effectively isolating consumers from backend volatility.

* **Stable Façade:** The consumer path (e.g., `/sales/orders/create`) remains fully stable regardless of backend shifts.
* **Metadata-Driven Control:** All change occurs in the **Control Plane (KVM)**.
* **Backend Evolution:** Updating a backend or vendor requires only a KVM entry update—no façade redeployments are necessary.
* **New Regions or Variants:** Handled simply by adding metadata variants. The client URL remains unchanged.

> **GDCR Workflow:** `Change Backend` → `Update KVM` → `No Façade Change` → `No Proxy Redeploy`.

---

### Q3 — What’s the governance benefit?

By decoupling the contract from the implementation, GDCR provides structural operational control.

* **Operational Efficiency:** Significantly fewer gateway deployments required over time.
* **Clear Separation of Concerns:**

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------
    * **Façade Governance:** Focused on domain, entity, and action semantics.
    * **Implementation Governance:** Focused on metadata (KVM) and the integration layer.
* **Reduced Risk:** Rollback becomes a simple metadata switch—not a high-risk proxy rollback.
