# FAQ-10 — Semantic URL Fakery

This document defines the concept of **Semantic URL Fakery** within the GDCR framework—a deliberate architectural strategy to decouple consumer interfaces from underlying infrastructure.

---

### Q1 — What does “Semantic URL Fakery” mean in GDCR?

In **Gateway Domain-Centric Routing (GDCR)**, Semantic URL Fakery is the deliberate architectural strategy of exposing stable, business-semantic paths to API consumers while fully masking internal technical complexity.

The consumer interacts only with logical domain routes, while the actual technical destination remains entirely hidden.

* **Public Path (The "Fake" Semantic URL):** `/sales/orders/create`
* **Hidden Technical Reality (Example):** `https://cpi-tenant-qa.region.aws.ondemand.com/http/v1/s4/fi/order_creation_v2`

> [!TIP]
> The public path is intentionally “fake” from an infrastructure perspective—but **true** from a business domain perspective. This is the core principle of the framework.

---

### Q2 — What information is hidden from the consumer?

Semantic URL Fakery abstracts and hides four critical layers of technical debt:

1. **Hostnames:** No exposure of internal tenants, regions, or subaccounts (e.g., SAP, Salesforce, AWS, Workday).
2. **System Codes:** No leakage of internal identifiers such as `ECC`, `S4H`, `SFDC`, or `WDAY`.
3. **Environment Tags:** The public URL does not change or expose tags like `dev`, `qa`, `prod`, or specific regional deployment codes.
4. **Orchestration & Runtime Details:** Technical paths of CPI iFlows, package names, version identifiers, and internal authentication strategies are completely masked.

---

## Q3 – How is this resolved internally? (Architecture flow)

The gateway acts as a translator: it takes the clean URL, looks up the technical target in a metadata store (KVM) and uses a JavaScript engine to build the final route.

```text
[ EXTERNAL / PUBLIC SIDE ]             [ INTERNAL / PRIVATE SIDE ]
      Clean & Semantic                       Technical & Complex

      CONSUMER REQUEST
             |
             v
    /sales/orders/create   <--- "Fake Path" (Stable)
             |
    +--------|---------------------------------------------------+
    |        |        SAP APIM - DOMAIN FACADE                   |
    |        v                                                   |
    |  [ 1. KVM Lookup ] -----------------> [ KVM STORE ]        |
    |        |                              | Key: s_o_c         |
    |        | <--------------------------- | Value: "id01|auth" |
    |        v                                                   |
    |  [ 2. JS Engine ]                                          |
    |    - Validates "id01|auth"                                 |
    |    - Builds: http://internal-cpi/salesforce/v2/orders      |
    |    - Sets: target.url                                      |
    +--------|---------------------------------------------------+
             |
             v
    [ SAP CPI / BACKEND ]   <--- "Real Path" (Hidden)
```

### Q4 — What are the benefits of this “fakery”?

The implementation of **Semantic URL Fakery** within the GDCR framework provides four strategic pillars of value:

#### Security
* **Reduced attack surface:** Minimizes the exposure of internal routing logic.
* **No backend fingerprinting:** Prevents attackers from identifying specific server types or versions.
* **No environment inference:** Hides whether a request is hitting dev, qa, or production.
* **No vendor exposure:** Keeps internal vendor choices (SAP, AWS, etc.) private.
* **Zero-Trust alignment:** This enforces Zero-Trust principles directly at the URL layer.

#### Governance
* **Domain-centric monitoring:** Logs and analytics follow business paths like `/sales`, `/orders`, or `/payments`.
* **Business alignment:** Monitoring reflects business capabilities rather than cryptic infrastructure topology.

#### Agility
* **Seamless Migrations:** When moving from SAP ECC to S/4HANA or changing integration engines, only the **metadata entry** changes.
* **Contract Stability:** The consumer URL remains 100% unchanged during backend overhauls.
* **Architectural Freedom:** Allows internal teams to evolve infrastructure without impacting external partners.

#### Professional API Surface
* **Product-like Interfaces:** APIs are treated as clean products, not technical exports.
* **Hidden Complexity:** Legacy debt, orchestration layers, and vendor dependencies remain private and never leak into the public contract.

---

### Architectural Positioning

**Semantic URL Fakery** is not merely "URL rewriting." It is a foundational principle within **GDCR v6.0** defined as:

* **Domain-first abstraction**
* **Infrastructure masking**
* **Metadata-driven routing**
* **Vendor-agnostic façade design**

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------
