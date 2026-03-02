## FAQ-10 Deploy-Heavy vs Metadata-Driven Change

### Q1 — How do traditional designs handle change?

In traditional system-centric models, any technical evolution triggers a cascade of manual interventions and artifact proliferation.

* **New Process:** Requires a new endpoint or a completely new proxy.
* **Backend Change:** Requires an update to the proxy logic followed by a full redeployment.
* **Payload Change:** Often forces a new API version (v2, v3), impacting consumers.

**Result:**
* Exponential growth in deployments and managed artifacts.
* Increased version fragmentation.
* Higher risk of breaking client integrations due to URL changes.

> **Traditional Workflow:** `Change Backend` → `Change Proxy` → `Redeploy` → `Possible URL Change`.

---

### Q2 — How does GDCR handle change?

The GDCR/DCRP model introduces a layer of **Metadata Abstraction** that isolates the consumer from backend volatility.

* **Stable Façade:** The consumer path (e.g., `/sales/orders/create`) remains 100% stable.
* **Metadata-Driven:** Changes occur exclusively in the **Control Plane (KVM)**.
* **Backend Evolution:** Updating a backend or vendor only requires a KVM entry update—no façade redeployment is necessary.
* **New Regions/Variants:** Handled by adding KVM variants, allowing the client to keep the same URL.

> **GDCR Workflow:** `Change Backend` → `Update KVM` → `No Façade Change` → `No Proxy Redeploy`.

---

### Q3 — What’s the governance benefit?

By decoupling the contract from the implementation, the framework provides superior operational control:

* **Operational Efficiency:** Drastically fewer gateway deployments over time.
* **Clear Separation of Concerns:**
    * **Façade Governance:** Focused on domain, entity, and action semantics.
    * **Implementation Governance:** Focused on KVM metadata and the integration layer.
* **Reduced Risk:** Enables safer rollbacks by simply switching a metadata pointer instead of rolling back a proxy deployment.

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------
