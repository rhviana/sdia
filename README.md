### Gateway Domain-Centric Routing (GDCR)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18619641.svg)](https://doi.org/10.5281/zenodo.18619641)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![Paper](https://img.shields.io/badge/Paper-Zenodo-blue)](https://zenodo.org/records/18619641)
![Pattern](https://img.shields.io/badge/Pattern-GDCR--v4.0-blueviolet)
![SAP](https://img.shields.io/badge/Platform-SAP%20BTP%20Integration%20Suite-008fd3)

**A vendor-agnostic, metadata-driven architecture for enterprise API & Orchestration Layers Domain-Centric Governance.**

---

### 📄 Published Academic Paper

**Official DOI:** 10.5281/zenodo.18619641  
**Published:** February 12, 2026  
**Repository:** Zenodo (CERN)  
**License:** CC BY 4.0 International  

📥 **[Download Full Paper (PDF)](https://zenodo.org/records/18619641)**

---

## Multi-Layer Governance
* **[Gateway Layer (DCRP) - SAP BTP APIM - Specific](./src/gateway-sap-apim/)**: Edge intelligence handling dynamic vectoring and perimeter security.
* **[Backend Layer (PDCP) - SAP BTP APIM - Specific)](./src/backend-sap-cpi/)**: Domain-centric consolidation using the **iFlow DNA** naming standard.
* **[Architectural Decisions (ADR)](./doc/)**: Documented rationale for engineering trade-offs (See ADR-001).
* **[Scientific Validation](./doc/academic-paper/)**: Peer-reviewed documentation archived at **Zenodo (CERN)**.

---

### What is GDCR?

Gateway Domain-Centric Routing (GDCR) is a **vendor-agnostic architectural pattern** that routes API traffic based on **business domain and business process** (e.g., Sales (o2c), Finance (r2r), Logistics (le) instead of backend endpoints applied in the Gateway layer and Orquestration Layer.

---

## Core Patterns applied in SAP BTP Integration Suite ( APIM and CPI )

#### DCRP (Domain-Centric Routing Pattern) ![SAP](https://img.shields.io/badge/Platform-SAP%20BTP%20Integration%20Suite%20API%20Management-008fd3)

SAP APIM Gateway layer that routes traffic based on business domain metadata instead of hardcoded backend endpoints.

**Benefits:**
- Eliminates proxy sprawl - 1:1
- Enables semantic routing for AI agents
- Centralized policy enforcement
- Zero vendor lock-in

#### PDCP (Package Domain-Centric Pattern) ![SAP](https://img.shields.io/badge/Platform-SAP%20BTP%20Integration%20Suite%20Cloud%20Platform%20Integration-008fd3) 

SAP CPI - Backend integration consolidation pattern that organizes integration artifacts by business domain.

**Benefits:**
- Eliminates package sprawl - 1:1 
- Reduces credential sprawl - 1:1 per package
- Consistent naming conventions
- Faster deployment cycles

### Hard Efficiency Metrics

<div align="center">
| Metric | Legacy (1:1 Model) | Maverick Engine | Velocity Gain |
| :--- | :--- | :--- | :--- |
| **Route Onboarding** | 15 Minutes / Proxy | 30 Seconds (KVM) | **30x** |
| **System Footprint** | 100+ Proxies | 4 Strategic Domains | **96% Reduction** |
| **Deployment Cycle** | 273 Minutes | 14.5 Minutes | **18.8x Faster** |
| **Reliability (Success)** | Variable | 99.92% | **Optimized** |
</div>

---

## Architecture Diagram

```text
┌──────────────────────────────────────────────────────┐
│       External Consumers / AI Agents                 │
│    40 external vendors / 4 endpoins API / many paths │
└───────────────────────┬──────────────────────────────┘
                        │
         ┌──────────────┴───────────────────┐
         │   DCRP Layer (API Gateway)       │
         │   ┌──────────────────────────┐   │
         │   │ 4 Domain Proxies:        │   │
         │   │ • Sales  10 bprocess     │   │
         │   │ • Finance 10 bprocess    │   │
         │   │ • Logistics  10 bprocess │   │
         │   │ • Customer 10 bprocess   │   │
         │   └──────────────────────────┘   │
         │   Metadata-Driven Routing        │
         └──────────────┬───────────────────┘
                        │
         ┌──────────────┴─────────────────┐
         │  PDCP Layer (Integration)      │
         │   ┌────────────────────────┐   │
         │   │ 4 Domain Packages:     │   │
         │   │ • Sales - 10 Iflows    │   │
         │   │ • Finance 10 Iflows    │   │
         │   │ • Logistics 10 Iflows  │   │
         │   │ • Customer  10 Iflows  │   │
         │   └────────────────────────┘   │
         │   Domain-Driven Design         │
         └──────────────┬─────────────────┘
                        │
    ┌───────────────────┼───────────────────┐
    │                   │                   │
┌───▼───────┐   ┌───────▼────┐   ┌─────────▼──┐
│ Salesforce│   │    SAP     │   │   Custom   │
│    API    │   │  S/4HANA   │   │  Backend   │
└───────────┘   └────────────┘   └────────────┘
```
---
  
## 📂 Repository Structure

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

## Key Results (Sandbox Validation on SAP BTP):

- ✅ **90% reduction** in API proxies (41 → 4)
- ✅ **90% reduction** in integration packages (39 → 4)
- ✅ **69% reduction** in technical users (39 → 12)
- ✅ **95% faster** deployment times (273 min → 14.5 min)
- ✅ **33,000+ messages** tested with 68ms average latency, 100% success rate

* **[The Stress Test Result)](./stress-test/)**: - 4 different tested to valided the soluttion and the results above.

---
### Final Technical Conclusion
---
- The sandbox validation proves that the **Maverick Engine™ (v14.2 baseline)** provides a **90% reduction in infrastructure complexity** while maintaining a **100% success rate** across **33,000+ messages**.
- These results are now **immortalized** under **[DOI: 10.5281/zenodo.18619641](https://zenodo.org/records/18619641)**.

---

### Quick Start

1. Understand the Architecture
Read the Architecture Overview (see diagram above) to grasp GDCR's core concepts: domain-centric routing, metadata-driven decisions, and vendor-agnostic design.

2. Review the Implementation Guides
-Step-by-step implementation guides are available in the SAP Community blog series:

-Part I (DCRP): Domain-Centric Routing Pattern
-[Complete walkthrough of the Gateway Layer with screenshots, KVM configuration, and JavaScript implementation](https://community.sap.com/t5/technology-blog-posts-by-members/sap-btp-apim-domain-centric-routing-pattern-dcrp-governing-apis-via-cpi/ba-p/14312788)

-Part II (PDCP): Package Domain-Centric Pattern
-[Backend Layer implementation with Mirror Strategy, naming conventions, and iFlow templates](https://community.sap.com/t5/technology-blog-posts-by-members/sap-btp-cpi-package-domain-centric-pattern-pdcp-solving-package-sprawl-at/ba-p/14318864)

💡 These two blog posts contain everything needed to implement a complete Proof of Concept (PoC) on SAP BTP.
    No additional step-by-step tutorials will be provided in this repository.

3. Explore the Code
See the JavaScript Routing Engine v15.1 for production-ready implementation.

4. Run the Tests (Optional)
Reproduce the validation using the Newman test collection with 35,000+ message scenarios.

---

### Projected ROI (Theoretical Estimation)

⚠️ IMPORTANT: The ROI calculation below is a theoretical projection based on sandbox validation metrics and industry standard hourly rates. This is NOT based on production deployment and should be considered an estimated potential value for cost-benefit analysis purposes only.

Estimated Savings: €198,500 over 5 years
Basis: €100/hour for integration development work

Assumptions:

Sandbox complexity reduction metrics apply to production
Linear scaling of time savings to cost savings
Standard European integration consultant hourly rate (€100/hour)

5-year TCO (Total Cost of Ownership) analysis
Calculation Breakdown:

-Deployment time savings: 258.5 min per cycle × recurring deployments
-Maintenance overhead reduction: 90% fewer artifacts to manage
-Onboarding time reduction: Simplified architecture accelerates team ramp-up

---
# Academic Citation
If you use this architecture in your research or implementation, please cite:

# APA:

Viana, R. L. H. (2026). Gateway Domain-Centric Routing: A Vendor-Agnostic 
Metadata-Driven Architecture for Enterprise API Governance. Zenodo. 
[https://doi.org/10.5281/zenodo.18619641](https://zenodo.org/records/18619641)

# BibTeX:

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
