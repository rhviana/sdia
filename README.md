# Gateway Domain-Centric Routing (GDCR)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18619641.svg)](https://doi.org/10.5281/zenodo.18619641)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![Paper](https://img.shields.io/badge/Paper-Zenodo-blue)](https://zenodo.org/records/18619641)

> **A vendor-agnostic, metadata-driven architecture for enterprise API & Orchestration Layers Domain-Centric Governance.**

---

## 📄 Published Academic Paper

**Official DOI:** 10.5281/zenodo.18619641  
**Published:** February 12, 2026  
**Repository:** Zenodo (CERN)  
**License:** CC BY 4.0 International  

📥 **[Download Full Paper (PDF)](https://zenodo.org/records/18619641)**

---

## What is GDCR?

Gateway Domain-Centric Routing (GDCR) is a **vendor-agnostic architectural pattern** that routes API traffic by **business domain** (e.g., Sales, Finance, Logistics) instead of backend endpoints.
---

## Core Patterns

### DCRP (Domain-Centric Routing Pattern)

API Gateway layer that routes traffic based on business domain metadata instead of hardcoded backend endpoints.

**Benefits:**
- Eliminates proxy sprawl
- Enables semantic routing for AI agents
- Centralized policy enforcement
- Zero vendor lock-in

### PDCP (Package Domain-Centric Pattern)
Backend integration consolidation pattern that organizes integration artifacts by business domain.

**Benefits:**
- Eliminates package sprawl
- Reduces credential sprawl
- Consistent naming conventions
- Faster deployment cycles

  Architecture Diagram
┌──────────────────────────────────────────────────────┐
│          External Consumers / AI Agents              │
│      (Mobile Apps, Web Apps, Third Parties)          │
└───────────────────────┬──────────────────────────────┘
                        │
         ┌──────────────┴──────────────┐
         │   DCRP Layer (API Gateway)  │
         │   ┌─────────────────────┐   │
         │   │ 4 Domain Proxies:   │   │
         │   │ • Sales             │   │
         │   │ • Finance           │   │
         │   │ • Logistics         │   │
         │   │ • Customer          │   │
         │   └─────────────────────┘   │
         │   Metadata-Driven Routing   │
         └──────────────┬──────────────┘
                        │
         ┌──────────────┴──────────────┐
         │  PDCP Layer (Integration)   │
         │   ┌─────────────────────┐   │
         │   │ 4 Domain Packages:  │   │
         │   │ • Sales             │   │
         │   │ • Finance           │   │
         │   │ • Logistics         │   │
         │   │ • Customer          │   │
         │   └─────────────────────┘   │
         │   Domain-Driven Design      │
         └──────────────┬──────────────┘
                        │
    ┌───────────────────┼───────────────────┐
    │                   │                   │
┌───▼───────┐   ┌───────▼────┐   ┌─────────▼──┐
│ Salesforce│   │    SAP     │   │   Custom   │
│    API    │   │  S/4HANA   │   │  Backend   │
└───────────┘   └────────────┘   └────────────┘

---

### Key Results (Sandbox Validation on SAP BTP):
- ✅ **90% reduction** in API proxies (41 → 4)
- ✅ **90% reduction** in integration packages (39 → 4)
- ✅ **69% reduction** in technical users (39 → 12)
- ✅ **95% faster** deployment times (273 min → 14.5 min)
- ✅ **33,000+ messages** tested with 68ms average latency, 100% success rate

## 🧪 Sandbox Validation & Testing

### Overview: Infrastructure Consolidation

| Metric | Before | After | Improvement |
| :--- | :--- | :--- | :--- |
| **API Proxies** | 41 | 4 | **90% ↓** |
| **Integration Packages** | 39 | 4 | **90% ↓** |
| **Technical Users** | 39 | 12 | **69% ↓** |
| **Deployment Time** | 273 min | 14.5 min | **95% Faster** |

**Technical Metrics Summary:**
* **Messages Tested**: 33,000+
* **Success Rate**: 100% (Zero timeouts)
* **Average Latency**: 68ms (v14.2 baseline)

---

### Test Environment Setup

* **Platform**: SAP BTP Integration Suite (Trial)
* **Region**: Europe (Frankfurt) - cf-eu10
* **Runtime**: Cloud Foundry
* **Test Period**: February 2026
* **JavaScript Engine**: v8.0 and v14.2 (Nashorn)

---

### Milestone 1: Gateway Resilience — The 25k "Soak Test"

---

**Objective:** Validate long-running stability of the SAP APIM Gateway and KVM lookup consistency.

* **Total Requests**: ~25,000 over ~1 hour
* **Success Rate**: 100%
* **Key Finding**: JavaScript heap remained stable with zero memory leaks under sustained load.

![Milestone 1 - Part A](StressTest/1.png)
![Milestone 1 - Part B](StressTest/2.png)

---

### Milestone 2: JavaScript v14.2 — Smoke Test (Multi-Vendor)

**Objective:** Validate domain consolidation across Sales (O2C) and Procurement (S2P/P2P).

* **Proxy Reduction**: 95% (39 → 2 in test scope)
* **Deployment Time**: ~5 minutes (template-based)
* **Average Latency**: 68ms

![Milestone 2](StressTest/3.png)

---

### Milestone 3: Multi-Domain Stress Test — JavaScript v14.2

---

**Objective:** Confirm that 4 proxies can replace 40 without performance degradation.

* **Total Requests**: 3,000
* **Success Rate**: 100%
* **P99 Latency**: 112ms
* **Cache Efficiency**: 98.1%
* 
![Milestone 3](StressTest/4.png)
![Milestone 3](StressTest/5.png)

---

### Milestone 4: Extended Off-Hours Validation — JavaScript v14.2

**Objective:** Validate system stability during minimal cloud infrastructure contention (04:00 AM).

* **Total Requests**: 5,000
* **Average Latency**: 65ms (improved due to lower network contention)
* **Key Finding**: System remained stable with optimal cache TTL performance.

![Milestone 4](StressTest/5.png)

---

⚠️ **No Support Policy**
This project is published for academic transparency and reproducibility. No implementation support, consulting, or troubleshooting assistance is provided.

I do not provide:

  ❌Implementation support
  ❌Consulting services
  ❌Troubleshooting assistance
  ❌ Custom development

The SAP Community blog posts (Part I & II) contain complete step-by-step implementation guides sufficient for building a full PoC. No additional tutorials will be provided.

For commercial inquiries only: rhviana@gmail.com

---

Quick Start
    1. Understand the Architecture
        Read the Architecture Overview (see diagram above) to understand GDCR's core concepts.
    2. Review the Patterns
        📖 Step-by-step implementation guides are available in the SAP Community blog series:
    Part I (DCRP): Domain-Centric Routing Pattern
        Complete walkthrough of the Gateway Layer with screenshots, KVM configuration, and JavaScript implementation
    Part II (PDCP): Package Domain-Centric Pattern
        Backend Layer implementation with Mirror Strategy, naming conventions, and iFlow templates

💡 These two blog posts contain everything needed to implement a complete Proof of Concept (PoC) on SAP BTP.
No additional step-by-step guides will be provided in this repository.

---

Projected ROI (Theoretical Estimation)

⚠️ IMPORTANT: The ROI calculation below is a theoretical projection based on sandbox validation metrics and industry standard hourly rates. This is NOT based on production deployment and should be considered an estimated potential value for cost-benefit analysis purposes only.

Estimated Savings: €198,500 over 5 years
Basis: €100/hour for integration development work
Assumptions:

Sandbox complexity reduction metrics apply to production
Linear scaling of time savings to cost savings
Standard European integration consultant hourly rate
5-year TCO (Total Cost of Ownership) analysis
Calculation breakdown:

Deployment time savings: 258.5 min per cycle
Maintenance overhead reduction: 90% fewer artifacts to manage
Onboarding time reduction: Simplified architecture
---

📊 Validation Status: All metrics validated in SAP BTP Trial sandbox environment only. Production results may vary based on:

---
Actual integration complexity
Organizational structure
Existing technical debt
Team skill levels
Specific platform configuration

---

## 📂 Repository Structure
```text
GDCR-github/
├── README.md                # Documentation
├── LICENSE                  # CC BY 4.0
├── JavaScript/
│   ├── js/                  
│   │   └── Maverickv15.2.js # Phantom Edition (Hyper-Optimized)
│   └── kvm-samples/         # SAP BTP KVM Samples
├── Presentations/           # Architecture Blueprints (PDF)
└── StressTest/              # Validation Screenshots

The Maverick Ghost Edition (v15.1) represents the peak of performance optimization for SAP APIM:
Expected Improvements over v14.2:

  ⚡ Pre-compiled regex: 30% reduction in path parsing time
  ⚡ DJB2 hash: 50% faster than FNV-1a (v14.2)
  ⚡ O(1) action lookup: Eliminates O(n) loop (241 action variants)
  ⚡ Target latency: 8-15 ms routing overhead (vs 12-22 ms in v14.2)
  ⚡ Path Parsing: <0.2ms using pre-compiled regex.
  ⚡ Hash Computation: <0.05ms using DJB2 algorithm.
  ⚡ Action Normalization: <0.05ms (O(1) lookup for 241 variants).
  ⚡ Average Latency: 8-15ms routing overhead.
---

🏛️ Academic Citation

If you use this architecture, please cite the original work:

Fragment kodu
@article{viana2026gdcr,
  title={Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven Architecture for Enterprise API Governance},
  author={Viana, Ricardo Luz Holanda},
  journal={Zenodo},
  year={2026},
  doi={10.5281/zenodo.18619641},
  url={https://zenodo.org/records/18619641}
}
---

Commercial Inquiries: Contact rhviana@gmail.com.

Author: Ricardo Luz Holanda Viana

Project Status: ✅ Academic Paper Published | ✅ Sandbox Validated | 🚧 Documentation In
