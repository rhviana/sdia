# Gateway Domain-Centric Routing (GDCR)

A vendor-agnostic, metadata-driven architecture for enterprise API & Orchestration Layers.

> **Official DOI:** [10.5281/zenodo.18619641](https://doi.org/10.5281/zenodo.18619641)
> **Published:** February 12, 2026
> **License:** CC BY 4.0 International

---

## 📄 Overview
**Gateway Domain-Centric Routing (GDCR)** is a vendor-agnostic architectural pattern that routes API traffic by **business domain** (e.g., Sales, Finance, Logistics) instead of hardcoded backend endpoints.

### 🚀 Key Results (Sandbox Validation on SAP BTP)
| Metric | Improvement |
| :--- | :--- |
| **API Proxies** | 90% Reduction (41 → 4) |
| **Integration Packages** | 90% Reduction (39 → 4) |
| **Technical Users** | 69% Reduction (39 → 12) |
| **Deployment Time** | 95% Faster (273 min → 14.5 min) |
| **Reliability** | 100% Success Rate (35,000+ messages) |

---

## 🛠️ Core Patterns

### 1. DCRP (Domain-Centric Routing Pattern)
API Gateway layer that routes traffic based on business domain metadata instead of hardcoded backend endpoints.
* **Benefits**: Eliminates proxy sprawl, enables semantic routing for AI agents, and ensures zero vendor lock-in.

### 2. PDCP (Package Domain-Centric Pattern)
Backend integration consolidation pattern that organizes integration artifacts by business domain.
* **Benefits**: Eliminates package/credential sprawl and ensures consistent naming conventions.

---
⚠️ No Support Policy
This project is published for academic transparency and reproducibility.

I do not provide:

❌ Implementation support
❌ Consulting services
❌ Troubleshooting assistance
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

🧪 Validation Milestones (JavaScript v15.2)
The Maverick Ghost Edition (v15.1) represents the peak of performance optimization for SAP APIM:

  Path Parsing: <0.2ms using pre-compiled regex.
  Hash Computation: <0.05ms using DJB2 algorithm.
  Action Normalization: <0.05ms (O(1) lookup for 241 variants).
  Average Latency: 8-15ms routing overhead.

📖 Implementation Guides

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
