# FAQ-09 — Credential Sprawl & GDCR

This document explains how the **GDCR Framework** resolves the "Credential Sprawl" problem by moving from a per-proxy credentialing model to a governed, domain-based security funnel.

---

### Q1 – How does GDCR reduce credential sprawl?

Traditional integration models often suffer from a 1:1 ratio between technical users and interfaces, leading to an unmanageable number of secrets.

* **Consolidation:** By consolidating proxies and packages into **domain-based façades**, GDCR eliminates the need for redundant technical users.
* **Boundary Management:** Credentials are managed at the level of the backend system, trust boundary, or domain package, rather than the "tiny proxy" level.
* **Proven Efficiency:** In sandbox trials, the number of technical users dropped from **39 to 12** (a **~69% reduction**), while maintaining clear ownership boundaries.

---

### Q2 – How is “credential sprawl” visualized?

Traditional models generate a "spaghetti" of credentials, whereas GDCR creates a **security funnel** that simplifies lifecycle management.

```text
[ TRADITIONAL MODEL ]                  [ GDCR / DCRP MODEL ]
   (Credential Sprawl)                    (Security Funnel)

 Proxy A --> User_A1 --> DB_1          Domain Façade --+
 Proxy B --> User_B2 --> DB_1                          |
 Proxy C --> User_C3 --> DB_1           [ KVM / JS ] --+--> Global_User_01
 Proxy D --> User_D4 --> DB_2                          |        (Target DB)
 Proxy E --> User_E5 --> DB_2           [ KVM / JS ] --+--> Global_User_02
                                                                (Target CRM)
```

### Q3 – Is it safe to reuse credentials across multiple operations?

**Yes, provided the reuse is governed.** GDCR replaces arbitrary duplication with explicit, governed sharing under the following conditions:

* **Target Consistency:** All operations target the same backend system and remain within the same trust boundary.
* **Contractual Alignment:** The operations belong to the same integration contract or domain package.
* **Least Privilege:** The backend technical user is restricted to specific roles/scopes required for that domain.

> [!NOTE]
> GDCR does not enforce “one user for everything”; it removes unnecessary duplication created by system-driven, per-proxy credentialing and replaces it with explicit, governed sharing.

---

### Q4 – How are credentials stored and used in this model?
---

GDCR decouples credentials from the URL structure and individual proxy artifacts through metadata-driven injection.

| Component | Responsibility |
| :--- | :--- |
| **Secure Storage** | Credentials are held in APIM secure stores, encrypted KVMs, or CPI credential stores. |
| **Metadata Reference** | Each KVM routing entry references the target endpoint and a specific credential alias. |
| **Runtime Injection** | The engine resolves the alias and injects the required authentication (Headers/OAuth) dynamically. |

```text
 RESULT: 1 Proxy = 1 User               RESULT: Multiple routes share 
 Complexity grows exponentially.        secure, governed credentials.
```

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------
