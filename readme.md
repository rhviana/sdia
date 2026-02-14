### Gateway Domain-Centric Routing (GDCR)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18619641.svg)](https://doi.org/10.5281/zenodo.18619641)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![Paper](https://img.shields.io/badge/Paper-Zenodo-blue)](https://zenodo.org/records/18619641)
![Pattern](https://img.shields.io/badge/Pattern-GDCR--v4.0-blueviolet)
![SAP](https://img.shields.io/badge/Platform-SAP%20BTP%20Integration%20Suite-008fd3)

**A vendor-agnostic, metadata-driven architecture for enterprise API & Orchestration Layers Domain-Centric Governance.**

One-line Executive Summary

Validated across **106,190+ messages**, **44 vendor integrations**, **4 business domains**, with **100% success rate** and **zero routing, KVM, or timeout failures**.

GDCR for any vendor combines DDD alignment, domain-centric routing, metadata-driven control, architectural fraud prevention, immutable integration identities, and formal
decision records into a cohesive enterprise integration governance framework.

## API Sprawl vs Domain-Centric Routing (DCRP)

![API Sprawl vs GDCR Gateway Layer](./doc/diagrams/gdcr-dcrp-gateway-clean-core.png)

**Figure 1 —** Domain-Centric Routing Pattern (DCRP) consolidates uncontrolled API
proxy proliferation into a governed gateway layer aligned with Clean Core principles.


---

### 📄 Published Academic Paper

**Official DOI:** 10.5281/zenodo.18619641  
**Published:** February 12, 2026  
**Repository:** Zenodo (CERN)  
**License:** CC BY 4.0 International  

📥 **[Download Full Paper (PDF)](https://zenodo.org/records/18619641)**

---
  
#### 📂 Repository Structure
```text
gdrc-github/
├── README.md                # Documentation
├── LICENSE                  # CC BY 4.0
├── JavaScript/
│   ├── js/                  
│   │   └── Maverickv15.2.js # Phantom Edition (Hyper-Optimized)
│   └── kvm-samples/         # SAP BTP KVM Samples
├── Presentations/           # Architecture Blueprints (PDF)
└── StressTest/              # Validation Screenshots

```
---

### GDCR Architectural Scope

Gateway Domain-Centric Routing (GDCR) is not a single pattern or implementation.
It is a composite architectural framework designed to govern enterprise integration landscapes at scale.

DCRP and PDCP are its core execution patterns, but GDCR also formalizes:

- metadata as a control plane
- naming conventions as governance mechanisms
- immutable integration identities (iFlow DNA)
- documented architectural decisions (ADR)

Together, these elements operate as one cohesive system, preventing uncontrolled architectural entropy.

---

## Architecture Diagram

```text
       _________________________________________________________
      |    External Consumers / AI Agents | Applications        |
      |                 40 external vendors                     |
      |     Only - 4 endpoints DCRP-Proxies / many paths        |
      |___________________________ _____________________________|
                                  |
                   _______________v_______________
                  |   DCRP Layer (API Gateway)    |
                  |  SAP BTP IS - API Management  |
                  |  ___________________________  |
                  | | 4 Domain Proxies:         | |
                  | | * Sales      10 bprocess  | |
                  | | * Finance    10 bprocess  | |
                  | | * Logistics  10 bprocess  | |
                  | | * Customer   10 bprocess  | |
                  | |___________________________| |
                  |    Metadata-Driven Routing    |
                  |_______________ _______________|
                                  |
                   _______________v_______________
                  |      PDCP Layer (SAP CPI)     |
                  | Integration / Orchestration   |
                  |  ___________________________  |
                  | | 4 Domain Packages:        | |
                  | | - Sales      10 Iflows    | |
                  | | - Finance    10 Iflows    | |
                  | | - Logistics  10 Iflows    | |
                  | | - Customer   10 Iflows    | |
                  | |___________________________| |
                  |      Domain-Driven Design     |
                  |_______________ _______________|
                                  |
           _______________________|_______________________
          |                       |                       |
   _______v_______         _______v_______         _______v_______
  |  Salesforce   |       |      SAP      |       |    Custom     |
  |      API      |       |    S/4HANA    |       |    Backend    |
  |_______________|       |_______________|       |_______________|

```
---

#### What is GDCR?

Gateway Domain-Centric Routing (GDCR) is a vendor-agnostic architectural pattern that routes API traffic based on business domain and business process
(e.g., Sales (O2C), Finance (R2R), Logistics (LE)) instead of backend endpoints.

This routing logic is applied consistently across both the Gateway layer and the Orchestration layer.

## Core Patterns applied in SAP BTP Integration Suite ( APIM and CPI )

## Multi-Layer Governance
* **[Architectural Decisions (ADR)](./doc/)**: Documented rationale for engineering trade-offs (See ADR-001).
* **[Scientific Validation](./doc/academic-paper/)**: Peer-reviewed documentation archived at **Zenodo (CERN)**.

SAP APIM Gateway layer that routes traffic based on business domain metadata instead of hardcoded backend endpoints.

* **[Gateway Layer (DCRP) - SAP BTP APIM - Specific](./src/gateway-sap-apim/)**: Edge intelligence handling dynamic vectoring and perimeter security.

![API Sprawl vs GDCR Gateway Layer](./doc/diagrams/gdcr-dcrp-gateway-clean-core.png)

**Figure 1 —** Domain-Centric Routing (DCRP) consolidates uncontrolled API proliferation
into a governed gateway layer aligned with Clean Core principles.

**Benefits:**
- Eliminates proxy sprawl - 1:1
- Enables semantic routing for AI agents
- Centralized policy enforcement
- Zero vendor lock-in

#### PDCP (Package Domain-Centric Pattern) ![SAP](https://img.shields.io/badge/Platform-SAP%20BTP%20Integration%20Suite%20Cloud%20Platform%20Integration-008fd3) 

## Package Sprawl vs Clean Core Orchestration (PDCP)

![Package Sprawl vs Clean Core PDCP](./gdcr-pdcp-clean-core-orchestration.png)

**Figure 2 —** Package Domain-Centric Pattern (PDCP) eliminates backend
integration sprawl by consolidating orchestration per business domain.


* **[Backend Layer (PDCP) - SAP BTP APIM - Specific)](./src/backend-sap-cpi/)**: Domain-centric consolidation using the **iFlow DNA** naming standard.

SAP CPI - Backend integration consolidation pattern that organizes integration artifacts by business domain.

**Benefits:**

- Eliminates package sprawl - 1:1 
- Reduces credential sprawl - 1:1 per package
- Consistent naming conventions
- Faster deployment cycles

---

#### The 7 Core GDCR Patterns

GDCR is composed of seven complementary architectural patterns:
- Domain-Centric Routing Pattern (DCRP) — Semantic routing at the gateway layer
- Package Domain-Centric Pattern (PDCP) — Domain-based backend consolidation
- Metadata-Driven Routing Pattern — Externalized routing decisions (KVM / KV Store)
- Action Normalization Pattern — Canonical business actions (C, R, U, D, A…)
- Proxy Consolidation Pattern — One proxy per strategic domain
- Immutable Integration Identity Pattern (iFlow DNA) — Permanent, non-reusable flow identities
- Architectural Decision Record (ADR) Pattern — Explicit architectural traceability

These patterns are interdependent and must be applied together.

---

#### Naming Conventions as Governance

Naming is not cosmetic in GDCR — it is architectural control.

- Package Naming

  [org].[domain].[subprocess].integrations
  
Example:

- nx.sales.o2c.integrations
- nx.finance.p2p.integrations

Integration (iFlow DNA) Naming

   id[seq].[subdomain].[sender].[entity].[action].[direction].[sync|async]

Example:

- id01.o2c.salesforce.order.c.in.sync

Metadata Key Naming (KVM)

- dcrp{entity}{action}{vendor}id{XX}

Example:

- ndcrpordercsalesforceid01

Strict rules (mandatory):
- Lowercase only
- Canonical action codes only

Immutable IDs

These rules are required for O(log n) binary search routing.

This creates a shared semantic contract between:
       - API Gateway
       - Orchestration layer
       - Governance model

Ensuring deterministic routing, traceability, and safe refactoring.

---

#### Hard Efficiency Metrics

<div align="center">
```text
| Metric | Legacy (1:1 Model) | Maverick Engine | Velocity Gain |
| :--- | :--- | :--- | :--- |
| **Route Onboarding** | 15 Minutes / Proxy | 30 Seconds (KVM) | **30x** |
| **System Footprint** | 100+ Proxies | 4 Strategic Domains | **96% Reduction** |
| **Deployment Cycle** | 273 Minutes | 14.5 Minutes | **18.8x Faster** |
| **Reliability (Success)** | Variable | 99.92% | **Optimized** |
```
</div>

#### Key Results (Sandbox Validation on SAP BTP):

- ✅ **90% reduction** in API proxies (41 → 4)
- ✅ **90% reduction** in integration packages (39 → 4)
- ✅ **69% reduction** in technical users (39 → 12)
- ✅ **95% faster** deployment times (273 min → 14.5 min)
- ✅ **106,190+ messages** tested with 77ms average latency, 100% success rate

* **[The Stress Test Result)](./stress-test/)**: - 5 different tested to valided the soluttion and the results above.

#### Validation Milestones Overview (M1–M5)

| Milestone | Objective | JS Version | Domains | Vendors / iFlows | DCRP Proxies | Total Calls | Avg Latency | Success Rate | Environment |
|----------|-----------|------------|---------|------------------|--------------|-------------|-------------|--------------|-------------|
| M1 | Gateway Resilience (Soak Test) | v8.0 | 1 (Sales O2C) | 1 Vendor / 2 APIs | 1 | 25,000 | 66 ms | 100% | SAP BTP Sandbox |
| M2 | Multi-Vendor Smoke Test | v14.2 | 2 (Sales, Procurement) | 39 Vendors | 2 | ~50 | 101 ms | 100% | SAP BTP Sandbox |
| M3 | Multi-Domain Stress Test | v14.2 | 4 | 39 iFlows | 4 | 3,000 | 68 ms | 100% | SAP BTP Sandbox |
| M4 | Extended Off-Hours Validation | v14.2 | 4 | 39 iFlows | 4 | 5,120 | 80 ms | 100% | SAP BTP Sandbox |
| M5 | Global Production Readiness | v15.2 (Phantom) | 4 | 44 iFlows | 4 | 73,020 | 226 ms | 100% | SAP BTP Trial Tenant |
| **TOTAL** | — | — | — | — | — | **106,190+** | — | **100%** | — |

#### Milestone 5 — Phantom v15.2 (Domain-Level Breakdown)

| Business Domain | Calls Executed | Successful Calls | Errors | Avg Latency |
|-----------------|----------------|------------------|--------|-------------|
| Finance (R2R) | 16,600+ | 16,600+ | 0 | 219 ms |
| Sales (O2C) | 23,500+ | 23,500+ | 0 | 238 ms |
| Logistics (SCM) | 16,700+ | 16,700+ | 0 | 241 ms |
| Procurement (S2P) | 16,220+ | 16,220+ | 0 | 223 ms |
| **TOTAL** | **73,020** | **73,020** | **0** | **226 ms (avg)** |


---

#### Validation Status (M5):

- ✅ 44 iFlows validated
- ✅ 4 Business Domains operational
- ✅ 44 Vendor Integrations successful
- ✅ Multi-protocol (REST + SOAP)
- ✅ Approved for production deployment

---

#### Consolidated Performance Metrics (Global)

| Metric | Result |
|------|--------|
| Total Messages Validated | **106,190+** |
| Success Rate | **100.00%** |
| Routing Errors | 0 |
| KVM Failures | 0 |
| Timeouts | 0 |


#### Latency Composition (Weighted Average)

| Component | Avg Time | Percentage |
|----------|----------|------------|
| KVM Lookup | ~10 ms | 14% |
| JavaScript Routing | ~15–20 ms | 21–27% |
| DCRP Overhead (Total) | ~25–30 ms | 34–41% |
| Backend Response | ~43 ms | 59% |
| **End-to-End Average** | **~73 ms** | **100%** |


#### Note:
Metrics are weighted across Milestones M1–M4.
M5 includes additional SAP BTP Trial Tenant overhead.

---

### Final Technical Conclusion

- The sandbox validation proves that the **Maverick Engine™ (v14.2 baseline)** provides a **90% reduction in infrastructure complexity** while maintaining a **100% success rate** across **33,000+ messages**.
- These results are now **immortalized** under **[DOI: 10.5281/zenodo.18619641](https://zenodo.org/records/18619641)**.

---

License & Availability
License: CC BY 4.0
DOI: 10.5281/zenodo.18619641
Author: Ricardo Luz Holanda Viana
Repository: https://github.com/rhviana/gdcr

#### Final Statement

       GDCR is not a tool.
       It is not a product.
       It is not a shortcut.

       It is an architectural answer to enterprise-scale integration entropy.

Order from Chaos
Not a phrase.
A method.

---
### Academic Citation
If you use this architecture in your research or implementation, please cite:

#### APA:

Viana, R. L. H. (2026). Gateway Domain-Centric Routing: A Vendor-Agnostic 
Metadata-Driven Architecture for Enterprise API Governance. Zenodo. 
[https://doi.org/10.5281/zenodo.18619641](https://zenodo.org/records/18619641)

#### BibTeX:

@article{viana2026gdcr,
  title={Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven 
         Architecture for Enterprise API Governance},
  author={Viana, Ricardo Luz Holanda},
  journal={Zenodo},
  year={2026},
  doi={10.5281/zenodo.18619641},
  url={https://zenodo.org/records/18619641}
}

---

### 📞 Contact
Author: Ricardo Luz Holanda Viana

## Connect:
📧 Email: rhviana@gmail.com
💼 LinkedIn: [Ricardo Viana](https://www.linkedin.com/in/ricardo-viana-br1984/)
🆔 ORCID: 0009-0009-9549-5862
📝 Medium: @rhviana
For commercial inquiries only: rhviana@gmail.com

---

Project Status: ✅ Academic Paper Published | ✅ Sandbox Validated | 🚧 Documentation In

---
