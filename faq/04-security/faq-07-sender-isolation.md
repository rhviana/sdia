# FAQ-07 — Sender Isolation & Fast-Fail Security Model

This document explains how the **GDCR Framework** maintains strict security boundaries within a shared Domain Façade, preventing unauthorized cross-sender access.

---

### Q1 – If multiple senders call /sales/*, how is cross-sender access prevented?

GDCR achieves isolation by strictly separating the routing intent from the authorization logic. While the entry point (the façade) is shared, the permissions are granularly enforced per sender.

* **Semantic Routing:** Defines *what* the business operation is (e.g., creating an order).
* **Authorization Matrix:** Defines *who* is allowed to execute that specific operation.

#### Conceptual Separation
1. **Routing Layer:** Processes the path `/sales/orders/create`.
2. **Security Layer:** Validates the sender identity against the requested action:
   * **Sender A:** Identified and mapped to the action → **Allowed**.
   * **Sender B:** Not mapped to the specific domain/action pair → **Denied**.

> [!IMPORTANT]
> **Isolation Invariant:** Security is not achieved by multiplying proxies. It is enforced through **deterministic sender-domain-action validation** at the gateway boundary.

---

### Isolation Comparison

```text
  [ TRADITIONAL MODEL ]                  [ GDCR / DCRP MODEL ]
   (Isolation by Proxy)                (Isolation by Metadata)

 Sender A -> [Proxy_Sales_Orders]      Sender A --+    /sales/orders/c
                                                  |--> [ SALES FACADE ]
 Sender B -> [Proxy_Sales_Customers]   Sender B --+    /sales/cust/r
                                                       
 PROS: Simple isolation.               PROS: 1 Proxy. Centralized Log.
 CONS: 100 Senders = 100 Proxies.      CONS: Requires strict metadata governance and disciplined sender-action matrix maintenance.
       High Maintenance.                     Scale is handled by KVM.
```

### Q2 – How is Fast-Fail validation performed?

Fast-Fail execution occurs **before** metadata lookup and backend resolution as part of the deterministic routing lifecycle.

#### Runtime Flow:
1.  **Resolve Sender Identity:** Validates the OAuth token, mTLS certificate, or signed header.
2.  **Extract Semantic Operation:** Identifies the Domain, Entity, and Canonical Action.
3.  **Check Authorization Matrix:** Performs an exact-match lookup for the combination: `sender:domain:entity:action`.
4.  **Decision:**
    * **Match:** Continue the lifecycle.
    * **No Match:** Immediate **HTTP 403**.

> [!IMPORTANT]
> When a match fails, **no CPI call is made** and **no backend resolution occurs**. The request is terminated at Layer 7.

---

### Q3 – Does sharing one façade break isolation?

**No.** The façade is a shared entry point, not a shared permission set.

**The Building Analogy:**
Think of a secured building with one entrance. Everyone enters through the same door (the Façade), but access to individual rooms is governed strictly by keycards (the Authorization Matrix).

**In GDCR:**
* The façade is shared.
* Execution permissions are **sender-specific**.
* Access is enforced via an **exact-match whitelist**.
* Isolation is **logical and deterministic**, not structural via artifact duplication.

---

### Q4 – How is auditability improved?

Because GDCR resolves semantic context early, logs are enriched with business metadata rather than technical identifiers. Each request produces structured audit headers:
* `x-gdcr-sender-id`
* `x-gdcr-domain`
* `x-gdcr-entity`
* `x-gdcr-action`

**Traditional Audit:** You see `iFlow_v2_final`.
**GDCR Audit:** You see `sales/orders/create` by `mobile-app`.

**Logs are indexed by semantic business keys rather than technical artifact names.**

---

### 🛡️ Security Model Positioning

The GDCR security layer is **Layer 7 semantic-aware**, **whitelist-based** (deny by default), and **control-plane governed**. Isolation is strictly enforced before metadata routing and backend invocation, metadata routing, or orchestration invocation to minimize the blast radius and reduce backend exposure.

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------

-----------------------------------Reuse, adaptation, and distribution are permitted only with proper attribution. Any derivative or equivalent architectural implementation must reference the original work and associated DOI.
