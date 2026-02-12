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
