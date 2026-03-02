# FAQ-15 — Sprawl Comparison: Traditional vs GDCR

This document provides a quantitative and structural analysis of how the **GDCR Framework** reverses the trend of artifact proliferation in enterprise landscapes.

---

### Q1 – What were the observed numbers in the reference landscape?

In a controlled SAP BTP sandbox validation using **GDCR/DCRP**, the following results were observed:

| Metric | Traditional Model | GDCR / DCRP Model | Reduction % |
| :--- | :--- | :--- | :--- |
| **API Proxies** | 41 | 4 | **≈90%** |
| **CPI Packages** | 39 | 4 | **≈90%** |
| **Technical Users** | 39 | 12 | **≈69%** |
| **Deployment Time** | 273 min | 14.5 min | **≈95%** |

**Performance & Reliability Note:**
More than **106,000 routed calls** were executed during the trial with a **99.92–100% success rate** and low single-digit millisecond routing overhead. These numbers reflect **structural consolidation**, not temporary optimization.

---

### Q2 – Why does system-driven design tend to sprawl?

System-centric architectures scale primarily by duplication. In this model, each new project or system typically introduces its own set of API proxies, integration packages, and technical users.

* **Fragmented Naming:** Conventions reflect systems instead of domains (e.g., `Salesforce_Orders_API` or `Z_SAP_FI_INV_01`).
* **Limited Reuse:** Components are tightly coupled to specific system identities.
* **Exponential Growth:** Artifact management becomes unmanageable as the number of systems increases.

> **The Result:** The gateway and integration layer become inventories of system-specific implementations rather than a catalog of business capabilities.

---

### Q3 – How does GDCR structurally limit sprawl?

GDCR constrains growth by enforcing a strict domain structure. Growth is not eliminated, but it is channeled into **domain-aligned boundaries** instead of uncontrolled multiplication.

* **Consolidated Façades:** High-level entry points per domain/subprocess instead of per-system proxies.
* **Unified Integration:** Fewer, more robust integration packages organized by business domain.
* **Semantic Reuse:** Multiple vendors, regions, or backend variants operate behind the same façade through metadata-driven resolution.
