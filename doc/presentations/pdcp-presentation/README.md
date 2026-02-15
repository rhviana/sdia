# 🚀 SAP BTP: Package Domain-Centric Pattern (PDCP)

> Enterprise-grade governance for SAP Integration Suite (CPI) based on the GDCR framework. Designed to eliminate "Package Sprawl," optimize credential management, and scale integration landscapes.

![Status](https://img.shields.io/badge/Status-Production--Ready-green)
![Methodology](https://img.shields.io/badge/Methodology-PDCP--v15.1-blue)
![Architecture](https://img.shields.io/badge/Architecture-Clean--Core-orange)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

---

## 📌 Overview

This repository provides the implementation blueprints, KVM configurations, and naming standards for the **PDCP** methodology. The goal is to shift from "Technical Silos" (naming by app/vendor) to **Intelligent Business Domains** (naming by process).

### 📊 Measurable Impact (ROI)
Based on real-world implementations, the PDCP framework achieves:

| Metric | Traditional (Before) | PDCP (After) | Improvement |
| :--- | :--- | :--- | :--- |
| **CPI Packages** | 39 | 4 | **↓ 90%** |
| **Technical Users** | 39 | 12 | **↓ 69%** |
| **Deployment Time** | 273 min | 14.5 min | **18.8x Faster** |
| **ALM Search Time** | 10 min | 5 sec | **120x Faster** |

---

## 🏗 Architectural Synergy

The PDCP framework works in tandem with the **DCRP (Domain-Centric Routing Pattern)** to create a "Perfect Mirror" between the Gateway and Backend:

1.  **Consumer Layer:** External clients call agnostic facade URLs (e.g., `/sales/orders/id01`).
2.  **Gateway Layer (DCRP):** SAP APIM uses a JavaScript v8.0 engine and KVMs to resolve dynamic routing.
3.  **Backend Layer (PDCP):** Consolidated CPI packages execute granular iFlows identified by the "iFlow DNA."

---

## 🏷 Naming Convention (iFlow DNA)

To maintain order within consolidated packages, every asset must follow the **7-segment iFlow DNA**:

`id[seq].[subdomain].[sender].[entity].[action].[direction].[processing]`

**Example:**
`id01.o2c.salesforce.order.s4hana.c.in.sync`

* **id01:** Sequential index (Reset per subdomain).
* **o2c:** Subdomain (e.g., Order-to-Cash, Record-to-Report).
* **salesforce:** Source system/vendor.
* **order:** Business entity.
* **c:** Action code (c=Create, u=Update, s=Sync, n=Notify).
* **in/out:** Direction of data flow.
* **sync/async:** Processing mode.

---

## 🛠 Repository Contents

### 📂 `/kvm-templates`
Contains JSON structures for SAP API Management Key-Value Maps.
* `cpipackage-sales-o2c.json`: Metadata for the Sales domain.
* `cpipackage-finance-r2r.json`: Metadata for the Finance domain.

### 📂 `/src/js`
The **Routing Engine Brain (v8.0)**. 
* Automatic adapter detection (HTTP vs SOAP/CXF).
* Multi-vendor disambiguation logic.
* Vendor-aware exact-match routing.

### 📂 `/iflow-templates`
Blueprint XMLs for "Agnostic Endpoints" within SAP CPI.

---

## 🛡 Security & Governance

* **Tiered Credentials:** Segregation by criticality (Transactional Core, Master Data, Vendor-Specific) to prevent "Total Blackouts."
* **Blast Radius Control:** Failures in secondary flows (e.g., Price Sync) are isolated from mission-critical flows (e.g., Order Creation).
* **Traceability:** URL endpoints reflect the iFlow DNA for surgical monitoring in SAP Cloud ALM.

---

## 📚 Credits & References

This implementation follows the architectural patterns introduced by **Ricardo Luz Holanda Viana (2026)**.

* **Original Publication:** SAP Community - [PDCP Part II](https://community.sap.com/)
* **Official DOI:** [10.5281/zenodo.18582469](https://doi.org/10.5281/zenodo.18582469)
* **Framework:** GDCR (Gateway Domain-Centric Routing)

---

## 🤝 Contribution

1.  **Fork** the project.
2.  **Create a Branch** for your domain (`git checkout -b domain/NewProcess`).
3.  **Commit** changes following the iFlow DNA standard.
4.  **Open a Pull Request**.

---
*"In the middle of package sprawl, order is your greatest tactical advantage."*

