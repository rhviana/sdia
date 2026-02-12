# 📂 Backend Layer: PDCP Consolidation

This sector manages the **Package Domain-Centric Pattern**, organizing SAP Cloud Integration into governed Business Domains.

---

## 🏷️ iFlow DNA Standard

To prevent "black-box" packages, all flows must follow the 7-segment naming convention:

`id[seq].[subdomain].[sender].[entity].[action].[direction].[processing]`

---

| Component | Meaning | Example |
| :--- | :--- | :--- |
| **id[seq]** | Sequential Index | `id01` |
| **subdomain** | Business Process | `o2c` |
| **sender** | Source System | `salesforce` |
| **action** | Operation | `c` (Create) |

---

## 🛡️ Tiered Security Strategy

We isolate technical users by business criticality to control the "blast radius":
* **Transactional Core**: Mission-critical credentials (e.g., Order Creation).
* **Master Data**: Secondary credentials (e.g., Customer Sync).
* **Result**: 69% reduction in technical users with 100% operational isolation.

---
