# FAQ-08 — OAuth2 vs. KVM Fast-Fail in GDCR

This section clarifies how identity delegation (OAuth2) and semantic authorization (Fast-Fail via KVM) coexist inside the GDCR security model to create a layered defense-in-depth architecture.

---

### Q1 – Where does OAuth2 fit in GDCR?

**OAuth2 / OIDC** remains the industry standard for identity delegation and token validation. Within GDCR, OAuth is treated as the **External Identity Validation Layer**.

* **OAuth2 answers:** Who is calling? Is the token valid? What scopes are attached?
* **GDCR answers:** Is this specific sender allowed to execute this specific semantic operation? Where should the request be routed?

#### Responsibility Separation

| Layer | Responsibility |
| :--- | :--- |
| **OAuth2 / OIDC** | Identity validation & token integrity |
| **GDCR Fast-Fail** | Semantic authorization (domain/entity/action) |
| **DDCR Engine** | Deterministic routing & metadata resolution |

> **Summary:** OAuth validates **Identity**; GDCR validates **Semantic Permission**.

---

### Q2 – What is KVM Fast-Fail?

**KVM Fast-Fail** is a deterministic sender-operation authorization pattern executed directly at the gateway edge. It performs an exact-match lookup before metadata routing, orchestration invocation, or backend execution.

#### Fast-Fail Logic:
1.  **Resolve identity:** Extract `client_id`, mTLS DN, or signed header.
2.  **Extract components:** Identify **Domain**, **Entity**, and **Canonical Action**.
3.  **Construct key:** Create the string `sender:domain:entity:action`.
4.  **Perform lookup:** Execute an exact-match metadata lookup.
5.  **Decision:** If no match exists, return an **immediate HTTP 403**.

**Result:** No CPI call, no backend call, and no extra IdP round-trip for authorization.

---

### Q3 – OAuth2 Flow vs. KVM Fast-Fail Flow

```text
[ OAUTH2 FLOW ]                         [ KVM FAST-FAIL ]
(Standard Delegation)                   (GDCR Edge Authorization)

1. Client -> Request + Token             1. Client -> Request + Token/ID
2. APIM -> Validate Token (IdP)          2. APIM -> Extract Semantic Context
3. IdP -> Validate & Return Claims       3. APIM -> Local KVM Lookup
4. APIM -> Route                         4. APIM -> Route (if authorized)

Dependency: IdP uptime                   Dependency: Local metadata cache
Latency: External call possible          Latency: In-memory lookup
```

## 🔒 Security & Fast-Fail Model

GDCR enforces a strict security boundary by decoupling client-side requests from backend-side execution.

> [!IMPORTANT]
> **Security Invariant:** No backend URL is ever derived from client input. All routing is resolved exclusively via **exact-match metadata lookup** within the Control Plane.

### Q4 – KVM Key Structure for Authorization
Permissions are stored as deterministic keys that serve as the hard authorization boundary:

```text

| KVM Key                     | Value                                      | Description                                   |
|----------------------------|--------------------------------------------|-----------------------------------------------|
| `SND_001:sales:orders:c`   | `http://cpi/orders/create|auth_alias`     | Sender 001 is allowed to **create** orders.   |
| `SND_001:sales:orders:r`   | `http://cpi/orders/query|auth_alias`      | Sender 001 is allowed to **read/query** orders. |
| `SND_002:fin:inv:a`        | `http://cpi/finance/approve|fin_alias`    | Sender 002 is allowed to **approve** invoices. |
```

The exact adapter URL and alias format are implementation details; the key idea is that `sender:domain:entity:action` is the primary security surface. 

## Q5 – Pseudocode Illustration (Conceptual Only)
---
The snippet below is **illustrative pseudocode**, not production code.  
It shows the Fast-Fail idea: validate the sender/semantic operation combination before any routing or backend call. [file:80][file:81]

```js
// 1. Capture semantic URL variables and Sender ID
var senderId = context.getVariable("client_id");      // e.g. from token or header
var domain   = context.getVariable("dcrp.domain");
var entity   = context.getVariable("dcrp.entity");
var action   = context.getVariable("dcrp.action");

// 2. Build the Fast-Fail lookup key: SND_xxx:domain:entity:action
var lookupKey = senderId + ":" + domain + ":" + entity + ":" + action;

// 3. Read the pre-resolved KVM value for this sender/operation
// (In a real policy, a KVM lookup step would populate this variable.)

var routingMetadata = context.getVariable("dcrp.ff.metadata." + lookupKey);

if (!routingMetadata) {
  // FAST-FAIL: no mapping for this Sender/Semantic action → reject at the edge
  context.setVariable("flow.error.code", "403");
  context.setVariable(
    "flow.error.message",
    "Unauthorized: sender not allowed to perform this semantic action."
  );
} else {
  // Proceed: split metadata into endpoint and credential alias
  var parts = routingMetadata.split("|");
  context.setVariable("target.url", parts);
  context.setVariable("dcrp.auth.alias", parts);
}
```

### Q6 – Why is this secure and efficient?
---
The GDCR security model provides three core advantages that solve traditional gateway bottlenecks:

* **Strict Isolation:** A credential leak for `SND_001` does not grant access to other domains, entities, or actions. The lookup key enforces exact semantic boundaries.
* **Edge Performance:** Authorization occurs in-memory via the gateway cache. Unauthorized traffic is rejected immediately without incurring CPI or backend load.
* **Operational Transparency:** Logs are indexed by **Sender**, **Domain**, **Entity**, and **Action**, which drastically improves forensic traceability and incident response.

---

### Q7 – Can OAuth2 Scopes map to Domain/Entity/Action?
---
**Yes.** This integration creates a robust, layered **defense-in-depth** strategy:

1.  **Identity:** The token is cryptographically valid (Standard OAuth).
2.  **Scope:** The token explicitly allows "Sales" operations (OAuth Scope validation).
3.  **Exact Semantic Authorization:** A check is performed to ensure this specific sender is authorized to "Create Orders" (GDCR Fast-Fail via KVM).
4.  **Deterministic Routing:** The final execution route is resolved via metadata (DDCR).

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------
