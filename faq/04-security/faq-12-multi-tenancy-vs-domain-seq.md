# FAQ-12 — Multi-Tenancy & Domain Segmentation

This document explores how the **GDCR Framework** handles multi-tenancy through logical domain segmentation, avoiding the common pitfall of infrastructure sprawl.

---

### Q1 — How is multi-tenancy usually handled?

Traditional integration models typically rely on physical or technical separation to achieve multi-tenancy, which leads to linear growth in management overhead.

* **Environment-based separation:** Creating separate silos for Dev, QA, and Prod.
* **Subaccounts:** Using dedicated cloud subaccounts or tenants per customer/department.
* **Dedicated Gateways:** Deploying a separate gateway instance for each tenant.
* **URL Versioning:** Using technical segments in the URL to identify the tenant.

> **The Problem:** This approach scales infrastructure, but it does **not** scale semantics. It results in a proliferation of identical proxies that must be maintained individually.

---

### Q2 — How does GDCR approach it?

GDCR shifts the focus from technical separation to **Domain Segmentation**. Tenancy logic is handled as a dynamic attribute of the routing process rather than a static property of the gateway deployment.

#### Logical Segmentation:
The framework uses business-semantic entry points that remain consistent across tenants:
* `/sales/**`
* `/finance/**`
* `/logistics/**`

#### Enforcement Layers:
Segmentation is enforced through the deterministic routing lifecycle:
1.  **Routing Metadata:** Utilizing KVM variants to map specific tenant/domain combinations.
2.  **Domain Identifiers:** Using semantic keys to isolate traffic logic.
3.  **Policy Enforcement:** Tenant-specific logic is driven by **Headers**, **JWT Claims**, or **Routing Keys**.

---

### 🚀 Strategic Advantage

By utilizing Domain Segmentation, multi-tenancy becomes a logical configuration rather than a physical deployment challenge.

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------


* **Metadata-Driven:** Tenants are onboarded via configuration entries, not gateway duplications.
* **Cleaner Governance:** A single source of truth for domain logic across all tenants.
* **Lower Infrastructure Sprawl:** Minimizes the number of active proxies and subaccounts required to support a complex ecosystem.

---
