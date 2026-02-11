# Gateway Domain-Centric Routing (GDCR)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18582469.svg)]([[https://doi.org/10.5281/zenodo.18582469](https://doi.org/10.5281/zenodo.18582492)])
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![Paper](https://img.shields.io/badge/Paper-Zenodo-blue)]([https://zenodo.org/records/18582469](https://zenodo.org/records/18582493))

> **A vendor-agnostic, metadata-driven architecture for enterprise API governance**

---

## 📄 Published Academic Paper

**Official DOI:** 10.5281/zenodo.18582469  
**Published:** February 10, 2026  
**Repository:** Zenodo (CERN)  
**License:** CC BY 4.0 International  

📥 **[Download Full Paper (PDF)](https://zenodo.org/records/18582493)**

---

## What is GDCR?

Gateway Domain-Centric Routing (GDCR) is a **vendor-agnostic architectural pattern** that routes API traffic by **business domain** (e.g., Sales, Finance, Logistics) instead of backend endpoints.

### Key Results (Sandbox Validation on SAP BTP):
- ✅ **90% reduction** in API proxies (41 → 4)
- ✅ **90% reduction** in integration packages (39 → 4)
- ✅ **69% reduction** in technical users (39 → 12)
- ✅ **95% faster** deployment times (273 min → 14.5 min)
- ✅ **35,000+ messages** tested with 68ms average latency, 100% success rate, zero timeouts

Architecture Overview

[GDCR Architecture Overview](gdcr-architecture-overview.png)

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

## Repository Contents

```
gdcr-github/
├── README.md                          # This file
├── LICENSE                            # CC BY 4.0
├── JavaScript/
│   ├── README.md                      # This Content
│   ├── JavaScript/                    # DCRP implementation guide
│       ├── js/
|         ├── Maverick-v-14.2.png      # Representative image of this state of art code
|         |── Maverickv14.2.js         # Full code detail
│       ├── kvm-samples
|         ├── readme.md                # Samples of Key Value Mapping specific for SAP BTP Integratio Suite - APIM
│   └── faq.md                         # Frequently asked questions
├── Under Constrution/
│   ├── tdb
│   ├── tdb
│   └── tdb
```

---

## Quick Start

### 1. Understand the Architecture

Read the [Architecture Overview]tdb) to understand GDCR's core concepts.

### 2. Review the Patterns

- **Gateway Layer:** [DCRP Pattern Guide Under Construction]
- **Backend Layer:** [PDCP Pattern Guide Under Construction]

### 3. Explore the Code

See the [JavaScript Routing Engine Under Construction] for a production-ready implementation.

### 4. Implement in Your Platform

Follow the [Implementation Guide Under Construction ] for step-by-step instructions.

---

## Architecture Diagram

```
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
```

---

## Vendor-Agnostic Implementation

GDCR works with **any API Gateway** that supports:
- ✅ Request inspection (path, headers, body)
- ✅ Conditional routing logic
- ✅ Dynamic target resolution
- ✅ Metadata storage (KVM, config, external DB)

### Validated Platform:
- **SAP BTP Integration Suite** (API Management + Cloud Integration)

### Theoretical Implementations:
- Google Apigee
- Kong Gateway
- AWS API Gateway
- Azure API Management
- MuleSoft Anypoint Platform
- Tyk Gateway
- Nginx Plus

See [Implementation Guide Under Construction ](tdb) for platform-specific examples.

---

## Results Summary

### Complexity Reduction
| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| API Proxies | 41 | 4 | **90%** ↓ |
| Integration Packages | 39 | 4 | **90%** ↓ |
| Technical Users | 39 | 12 | **69%** ↓ |
| Deployment Time | 273 min | 14.5 min | **95%** ↓ |

### Performance (35,000+ messages tested)
- **Average Latency:** 68ms
- **Success Rate:** 100%
- **Timeouts:** 0
- **Error Rate:** 0%

### Estimated ROI
**€198,500** over 5 years (based on €100/hour for integration work)

---

## Academic Resources

### Citation (APA):
```
Viana, R. L. H. (2026). Gateway Domain-Centric Routing: A Vendor-Agnostic 
Metadata-Driven Architecture for Enterprise API Governance. Zenodo. 
https://doi.org/10.5281/zenodo.18582469
```

### Citation (BibTeX):
```bibtex
@article{viana2026gdcr,
  title={Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven 
         Architecture for Enterprise API Governance},
  author={Viana, Ricardo Luz Holanda},
  journal={Zenodo},
  year={2026},
  doi={10.5281/zenodo.18582469},
  url={https://zenodo.org/records/18582469}
}
```

### Related Publications:
- [Medium - GDCR Introduction]([https://medium.com/@rhviana](https://medium.com/@rhviana/gateway-domain-centric-routing-a-vendor-agnostic-api-architecture-52ad30d1d1d9))
- [SAP Community - DCRP Part I](https://community.sap.com/t5/technology-blog-posts-by-members/sap-btp-apim-domain-centric-routing-pattern-dcrp-governing-apis-via-cpi/ba-p/14312788)
- [SAP Community - PDCP Part II](https://community.sap.com/t5/technology-blog-posts-by-members/sap-btp-cpi-package-domain-centric-pattern-pdcp-solving-package-sprawl-at/ba-p/14318864)

---

## Equivalent Terminology

All these terms refer to the same architecture published under **DOI: 10.5281/zenodo.18582469**:

**Gateway Layer:**
- GDCR (Gateway Domain-Centric Router)
- DCRP (Domain-Centric Routing Pattern)
- MDAGR (Metadata-Driven API Gateway Routing)
- SRBD (Semantic Routing via Business Domains)

**Business & Semantic:**
- DOAGA (Domain-Oriented API Gateway Architecture)
- BSGR (Business-Semantic Gateway Routing)
- SAGA (Semantic API Gateway Architecture)

**Governance:**
- DGAR (Domain-Governed API Routing)
- CDRA (Centralized Domain Routing Architecture)

**Anti-Sprawl:**
- APSRA (Anti-Proxy-Sprawl Routing Architecture)
- DDGCP (Domain-Driven Gateway Consolidation Pattern)

---

## Contributing

Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) first.

### Ways to Contribute:
- Report bugs or issues
- Suggest new features or improvements
- Improve documentation
- Submit platform-specific implementations
- Share your implementation results

---

## Contact & Support

**Author:** Ricardo Luz Holanda Viana

**Connect:**
- 📧 Email: [rhviana@gmail.com]
- 💼 LinkedIn: [Viana](https://www.linkedin.com/in/ricardo-viana-br1984/)
- 🆔 ORCID: [0009-0009-9549-5862](https://orcid.org/0009-0009-9549-5862)
- 📝 Medium: [@rhviana](https://medium.com/@rhviana)

**Questions?**
- Open an [Issue](https://github.com/yourusername/gdcr/issues)
- Read the [FAQ](docs/faq.md)
- Check [Discussions](https://github.com/yourusername/gdcr/discussions)

---

## License

This work is licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](LICENSE).

You are free to:
- **Share** — copy and redistribute the material
- **Adapt** — remix, transform, and build upon the material
- **Commercial use** — use for commercial purposes

Under the following terms:
- **Attribution** — You must give appropriate credit, provide a link to the license, and indicate if changes were made

---

## Star History

If this project helped you, please **star this repository** and cite the academic paper!

---

## Project Status

- **Academic Paper:** Published (DOI: 10.5281/zenodo.18582469)
- **Sandbox Validation:** Complete (SAP BTP)
- **Community Implementations:** In Progress
- **Multi-Platform Examples:** In Progress

---

**Last Updated:** February 10, 2026  
**DOI:** 10.5281/zenodo.18582469  
**Version:** 1.0.0
