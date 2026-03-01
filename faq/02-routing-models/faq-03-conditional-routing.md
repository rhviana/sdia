# FAQ: Conditional Routing vs. GDCR Framework

This document explores the technical differences between standard **Conditional Routing** and the **Gateway Domain-Centric Routing (GDCR)** architectural pattern.

---

## Q1 – What is conditional routing in SAP APIM?

**Conditional routing** allows a single API proxy to inspect the request path, HTTP method, headers, or query parameters and route to different backend targets based on configured conditions.

### Example Configuration
* **Proxy Base Path:** `/v1/Order`
* **Condition A:** `/v1/Order/CreateOrder` → **Target:** CPI iFlow A
* **Condition B:** `/v1/Order/ReadOrder` → **Target:** CPI iFlow B

Within the proxy, conditional flows determine the target endpoints and the execution of specific policies (quotas, transformations, or security rules). This reduces the need for a strictly 1:1 proxy-to-method mapping.

---

## Q2 – How does this improve over strict 1:1 routing?

Compared to pure 1:1 mapping, conditional routing offers several operational advantages:
* **Consolidation:** Allows multiple operations within a single proxy artifact.
* **Policy Reuse:** Enables limited reuse of security and traffic management policies.
* **Efficiency:** Reduces the total proxy count at a small scale.

### The Remaining Structural Challenges:
* ❌ **Hardcoded Logic:** Routing decisions remain hardcoded inside proxy XML/policy flows.
* ❌ **Static Mapping:** Backend resolution is still statically configured in the TargetEndpoint.
* ❌ **Technical URLs:** Paths often encode technical operation names rather than business domains.
* ❌ **Coupled Lifecycle:** Backend changes still require proxy modification and redeployment.

> [!NOTE]
> Conditional routing optimizes artifact count but does not eliminate **backend coupling**.

---

## Q3 – How is this different from GDCR / DCRP?

Conditional routing is a **configuration technique**; GDCR/DCRP is an **architectural pattern** with deterministic execution semantics.

### Comparison Matrix

| Feature | Traditional Conditional Routing | GDCR / DCRP Model |
| :--- | :--- | :--- |
| **Logic Placement** | Hardcoded inside proxy policies | Immutable & generic proxy logic |
| **Path Structure** | Operation-based (e.g., `/CreateOrder`) | Semantic (e.g., `/{domain}/{entity}/{action}`) |
| **Lifecycle** | Tied to backend changes | Tied to Domain/Business evolution |
| **Resolution** | Static/Hardcoded Target | Dynamic Metadata (KVM/Control-Plane) |
| **Normalization** | None (Raw paths/verbs) | Canonical Action Normalization (241 → 15) |

### The GDCR Formalization
Conditional routing is a building block. **GDCR** formalizes that block into:
1.  A **deterministic 7-stage routing lifecycle**.
2.  A **domain-centric semantic façade**.
3.  A **control-plane-driven** execution model.

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------

> [!TIP]
> The difference is not technical capability—it is **formalization, scalability, and governance scope**.
