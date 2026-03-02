
# PDCP — Package Domain-Centric Pattern (Orchestration Layer)

## 1. Purpose
The **Package Domain-Centric Pattern (PDCP)** reorganizes orchestration artifacts (e.g., SAP Cloud Integration iFlows, mappings, value mappings, scripts) into strictly domain-aligned packages governed by deterministic naming.

PDCP ensures structural alignment between:
* **Gateway semantic façade** (DCRP)
* **Metadata control plane** (KVM / DDCR)
* **Orchestration layer** (CPI packages and iFlows)

> [!TIP]
> All layers speak the same business-domain language. This eliminates vendor-centric fragmentation and enforces semantic consistency across the integration landscape.

---

## 2. Architectural Principle

### Traditional Model (Anti-pattern)
* `Package_Salesforce_Orders`
* `Package_Salesforce_Customers`
* `Package_QuickBooks_Invoices`
* *Observation: This structure organizes by vendor/system.*

### PDCP Model
PDCP replaces vendor-centric organization with **domain-centric governance**. 
* Integration artifacts are grouped by **business capability**, not system origin.
* Business semantics become the primary organizational index.

---

## 3. Domain Package Naming Model

### Formal Pattern
`[prefix].[domain].[subprocess].integrations`

### Component Definition

| Component | Description | Example | Constraint |
| :--- | :--- | :--- | :--- |
| **prefix** | Organizational namespace | `nx`, `sap`, `corp` | lowercase |
| **domain** | Business domain | `sales`, `finance`, `logistics` | lowercase |
| **subprocess** | Business subprocess | `o2c`, `r2r`, `p2p`, `crm` | lowercase |
| **integrations** | Fixed suffix | `integrations` | constant |

---

## 4. Examples

* `nx.sales.o2c.integrations`
* `nx.sales.crm.integrations`
* `nx.finance.r2r.integrations`
* `nx.finance.p2p.integrations`
* `nx.logistics.wms.integrations`

**These packages contain:**
1.  All iFlows for the subprocess
2.  Mappings & Scripts
3.  Value mappings
4.  Supporting artifacts

> [!IMPORTANT]
> **No package is created per vendor.**

---

## 5. Cross-Layer Semantic Alignment
PDCP mirrors the semantic structure of the gateway façade and metadata control plane.

| Layer | Semantic Expression |
| :--- | :--- |
| **Gateway** | `/sales/orders/create` |
| **Metadata** | `dcrp:orders:c:salesforce:id01:http` |
| **Orchestration** | `nx.sales.o2c.integrations` → `id01.o2c.salesforce.order.c.in.sync` |

---

## 6. Structural Impact

| Feature | Before PDCP | After PDCP |
| :--- | :--- | :--- |
| **Scalability** | Packages scale linearly per vendor | One package per subprocess |
| **Logic** | Duplicate logic across systems | Centralized domain logic |
| **Ownership** | Weak domain ownership | Clear Domain-level ownership |
| **Credentials** | Proliferation per system | Tiered by domain criticality |
| **Topology** | Fragile/System-dependent | Stable architectural topology |

---

## 7. Governance Properties
PDCP enables:
* **Domain-based ownership** (e.g., “Sales Integration Owner”).
* **Tiered credential management** by domain criticality.
* **Deterministic artifact discovery** (no searching for "where is Salesforce?").
* **Controlled scaling** (horizontal vendor addition, vertical process expansion).
* **Structural symmetry** with GDCR routing model.

---

## 8. Architectural Invariant

* **Vendors are variable.**
* **Business domains are stable.**

PDCP encodes stability at the package layer. Vendor changes (e.g., swapping Salesforce for Dynamics) do **not** require:
1.  New packages
2.  Structural reorganization
3.  Consumer-facing impact

**Only metadata evolves.**

---

## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** 10.5281/zenodo.xxxxx  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
