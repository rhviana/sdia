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

### Key Results (Sandbox Validation on SAP BTP):
- ✅ **90% reduction** in API proxies (41 → 4)
- ✅ **90% reduction** in integration packages (39 → 4)
- ✅ **69% reduction** in technical users (39 → 12)
- ✅ **95% faster** deployment times (273 min → 14.5 min)
- ✅ **35,000+ messages** tested with 68ms average latency, 100% success rate

---

## 🧪 Performance & Sandbox Validation

### Milestone 1: Gateway Resilience (25k Soak Test)
![Milestone 1](StressTest/1.png)

### Milestone 2: Multi-Vendor Smoke Test
![Milestone 2](StressTest/2.png)

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

---

## Repository Structure

```text
GDCR-github/
├── README.md                                    # This file
├── LICENSE                                      # CC BY 4.0
├── JavaScript/
│   ├── js/  
│   │   ├── Maverick-v-15.2.png                  # Phantom Edition Visualization
│   │   └── Maverickv15.2.js                     # Hyper-Optimized Code (8-15ms)
│   └── kvm-samples/
│       └── readme.md                            # SAP BTP KVM Samples
├── Presentations/
│   ├── DCRP-Routing-Pattern.pdf                 # 96% Proxy Sprawl Reduction Blueprint
│   └── PDCP-Package-Pattern.pdf                 # Mirror Strategy Deep-Dive
└── StressTest/
    ├── 1.png                                    # Milestone 1 Results
    └── 2.png                                    # Milestone 2 Results

⚠️ No Support Policy

This project is published for academic transparency and reproducibility.

I do not provide:

  ❌Implementation support
  ❌Consulting services
  ❌Troubleshooting assistance
  ❌ Custom development

The SAP Community blog posts (Part I & II) contain complete step-by-step implementation guides sufficient for building a full PoC. No additional tutorials will be provided.

For commercial inquiries only: rhviana@gmail.com

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

Implementation Guides

Step-by-step guides are available via the SAP Community blog series:

  Medium - GDCR Introduction
  SAP Community - DCRP Part I
  SAP Community - PDCP Part II
  Part III (The Final Step): Conclusion and results.

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

⚠️ Policy & Support
No Support: This project is for academic transparency. No implementation or troubleshooting support is provided.

Commercial Inquiries: Contact rhviana@gmail.com.

Author: Ricardo Luz Holanda Viana

Project Status: ✅ Academic Paper Published | ✅ Sandbox Validated | 🚧 Documentation In
