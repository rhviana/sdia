
This repository contains original architectural work, named patterns, and advanced SAP BTP Integration Suite technical material.

Before exploring, reusing, or referencing any content, you are strongly encouraged to read

👤 [ABOUT-ME](./01-ABOUT-ME.md) – To understand the 17-year journey from SAP XI/PI – GRC NF-e (Brazilian electronic invoicing solution) to BTP Expert, and the context of the "The Commander – Viana" methodology.

📜 [NOTICE](./02-NOTICE.md) – Regarding IP rights, DOIs, and usage licenses.

Please review these files before proceeding to the main technical documentation.

Gateway Domain-Centric Routing (GDCR™)
-----------------------------------

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18582492.svg)](https://zenodo.org/records/18582492)
[![DOI](https://img.shields.io/badge/DOI-10.6084%2Fm9.figshare.31444984-brightgreen)](https://doi.org/10.6084/m9.figshare.31444984)
[![Paper](https://img.shields.io/badge/Paper-Zenodo-blue)](https://zenodo.org/records/18836272)
[![Paper](https://img.shields.io/badge/Paper-Figshare-brightgreen)](https://doi.org/10.6084/m9.figshare.31444984)
[![ORCID](https://img.shields.io/badge/ORCID-0009--0009--9549--5862-brightgreen)](https://orcid.org/0009-0009-9549-5862)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
![Pattern](https://img.shields.io/badge/Pattern-GDCR--v6.0%20The%20Foundation-blueviolet)
![SAP](https://img.shields.io/badge/Platform-SAP%20BTP%20Integration%20Suite-008fd3)
![Kong](https://img.shields.io/badge/Platform-Kong%20Gateway-003459)
![Azure](https://img.shields.io/badge/Platform-Microsoft%20Azure%20APIM-0078D4)
![AWS](https://img.shields.io/badge/Platform-AWS%20API%20Gateway-FF9900)
[![Medium](https://img.shields.io/badge/Medium-@rhviana-black)](https://medium.com/@rhviana)
[![Academia](https://img.shields.io/badge/Academia.edu-Ricardo%20Viana-lightgrey)]([https://independent.academia.edu/Ricardo%20Viana](https://www.academia.edu/164919623/Gateway_Domain_Centric_Routing_GDCR_A_Vendor_Agnostic_Metadata_Driven_Architecture_for_Enterprise_API_Governance_The_Foundation_v6_0))

DOI License: CC BY 4.0 — Academic Paper Pattern

A vendor-agnostic, metadata-driven architecture for enterprise API & orchestration governance, enabling Domain-Centric Routing across heterogeneous backend landscapes.


Online Executive Summary
-----------------------------------

GDCR is vendor-agnostic by design and unifies Domain-Driven Design (DDD) alignment, domain-centric routing, metadata-driven control planes, metadata-driven control planes, semantic URL abstraction (reducing information leakage), immutable integration identities, immutable integration identities, and formal architectural decision records into a single, cohesive enterprise integration governance framework.

The objective of this validation was not to benchmark raw throughput, but to prove architectural correctness, deterministic behavior, and measurable governance impact under controlled conditions.

What is (GDCR™) ?
-----------------------------------

Gateway Domain-Centric Routing (GDCR™) is a vendor-agnostic architectural pattern that routes API traffic based on business domain and business process
(e.g., Sales (O2C), Finance (R2R), Logistics (LE)) instead of backend endpoints.

This routing logic is applied consistently across both the Gateway layer and the Orchestration layer.

<p align="center">
<img width="1232" height="841" alt="image" src="https://github.com/user-attachments/assets/0be438e5-a2f4-4d73-beaf-adf61441df50" />

</p>

---

## Validation Summary — v6.0
<div align="center">
  
| Metric | Result |
| :--- | :--- |
| Total Requests | **1,499,869** |
| Routing Success Rate | **100%** (0 routing failures) |
| End-to-End Success Rate | **99.9916%** |
| Routing Failures | **0** |
| Network failures (ECONNRESET/ETIMEDOUT) | 158 (infrastructure only) |
| Platforms Validated | Kong · SAP BTP · AWS · Azure |
| SAP BTP Total (2 engine generations) | 227,661 requests |
| DDCR Phantom v12 · p50 / p85 / p99 | 145ms / 184ms / 338ms |
| API Proxy Reduction | **90%** (41 → 4) |
| Orchestration Package Reduction | **90%** (39 → 4) |
| Deployment Time Reduction | **95%** (273 min → 14.5 min) |
| Vendor Onboarding | **< 30 seconds** (metadata only) |
> All validations executed on free trial and sandbox environments (SAP BTP Trial, AWS Free Tier, Azure Trial, Kong Docker localhost). Results demonstrate architectural correctness and cross-platform portability — not production throughput or SLA guarantees.
</div>

---

## Core Patterns
<div align="center">
  
| Pattern | Layer | Scope |
| :--- | :--- | :--- |
| **DCRP** — Domain-Centric Routing Pattern | API Gateway | Single proxy per domain, metadata-driven routing |
| **PDCP** — Package-Domain-Centric Pattern | Orchestration (SAP CPI) | Packages organized by business domain, not vendor |
| **DDCR** — Domain-Driven Centric Router | Execution Engine | 241 verbs → 15 codes, runtime URL generation |
| **ODCP** — Orchestration Domain-Centric Pattern | Theoretical | Universal extension: MuleSoft, Boomi, Azure Logic Apps |

**DDCR Engine lifecycle:** `Parse → Normalize → Lookup → Route`

</div>
---

## Platform Validation Matrix

<div align="center">
  
| Platform | Implementation | Requests | Success Rate | Avg Latency | Status |
| :--- | :--- | ---: | :--- | :--- | :--- |
| Kong (Docker) | Redis KVM + Lua | 1,000,000 | 100% | 19ms | ✅ PROVEN |
| Kong (Docker) | Lua KVM | 33,600 | 100% | 15ms | ✅ PROVEN |
| SAP APIM + CPI | JS Policy v15.1 + KVM | 106,190 | 99.92% | 68ms | ✅ PROVEN |
| SAP APIM + CPI (Phantom v12) | DDCR JS v15.1 + KVM | 121,471 | 99.9967% | 168ms | ✅ PROVEN |
| AWS API Gateway + CPI | Lambda + DynamoDB | 38,600 | 100% | 764ms | ✅ PROVEN |
| Microsoft Azure APIM + CPI | C# Policy + Redis | 200,008 | 99.98% | 175ms | ✅ PROVEN |

Full evidence: Newman test reports, per-platform logs, error classification → [`/gdcr-proven`](./gdcr-proven)

</div>

Repository Structure
-----------------------------------

```text
gdcr/
├── 01-ABOUT-ME.md              # Author background — read first
├── 02-NOTICE.md                # IP rights, DOIs, licenses — read second
├── 03-README.md                # This file
├── 04-LICENSING.md             # CC BY 4.0 full text
│
├── doc/                        # Architecture documentation
│   ├── 0-ddcr/                 # DDCR engine specification
│   ├── 01-pdcp-sap-cpi/        # PDCP pattern — SAP CPI
│   ├── 02-dcrp-sap-apim/       # DCRP pattern — SAP API Management
│   ├── academic-paper/         # White paper v6.0 (PDF)
│   ├── compliance/             # Audit trail & governance
│   ├── ddcr-phantom-js-v12/    # Phantom v12 specification
│   ├── gdcr-architecture/      # Architecture overview & diagrams
│   ├── implementation/         # Implementation guides
│   ├── newman/                 # Newman test reports & validation evidence
│   ├── patterns/               # Pattern catalog (DCRP, PDCP, DDCR, ODCP)
│   ├── presentations/          # Slide decks
│   ├── repository/             # Repository assets
│   └── security/               # Security model, Fail-Fast, URL Fakery
│
├── faq/                        # Frequently asked questions
│   ├── 01-core-assumptions/
│   ├── 02-routing-models/
│   ├── 03-openapi-swagger/
│   ├── 04-security/
│   ├── 05-governance/
│   └── 06-observability/
│
├── gdcr-proven/                # Validation evidence per platform
│   ├── gdcr-aws-api/           # AWS API Gateway + CPI results
│   ├── gdcr-dcrp-sap-api/      # SAP APIM + CPI results
│   ├── gdcr-kong-api/          # Kong results
│   └── gdcr-microsoft-azure-api/ # Azure APIM + CPI results
│
├── gdcr-sap-patterns/          # SAP-specific pattern implementations
│
├── sap-btp-blogs/              # SAP Community Network blog posts
│
├── src/                        # Source code
│   ├── javascript/
│   │   └── js-codes/
│   │       ├── js-phantomv12/  # DDCR Phantom v12 engine (JS)
│   │       ├── dcrp-js-v5.0.js
│   │       └── dcrp-security-shield.js
│   └── kvm/
│       └── dcrp-routing-config-template.xml
│
├── taxonomy-nomenclature/      # iFlow DNA naming convention
│
└── workflows/                  # Deployment metadata workflows
```

Key Highlights:
-----------------------------------
### Academic Citation

If you use this architecture in your research or implementation, please cite:

APA
-----------------------------------

Viana, R. L. H. (2026). *Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven Architecture for Enterprise API Governance - Version 5.0*. Zenodo. https://doi.org/10.5281/zenodo.18582492

Viana, R. L. H. (2026). *Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven Architecture for Enterprise API Governance - Version 5.0*. Figshare. https://doi.org/10.6084/m9.figshare.31331683

BibTeX
-----------------------------------
```text
@article{viana2026gdcr,
  title   = {Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven Architecture
             for Enterprise API Governance — v6.0 Edition},
  author  = {Viana, Ricardo Luz Holanda},
  year    = {2026},
  doi     = {10.5281/zenodo.18582492},
  url     = {https://doi.org/10.5281/zenodo.18582492}
}

@misc{viana2026gdcr_assets,
  title        = {Gateway Domain-Centric Routing (GDCR): Companion Repository — v6.0},
  author       = {Viana, Ricardo Luz Holanda},
  year         = {2026},
  howpublished = {GitHub},
  url          = {https://github.com/rhviana/gdcr}
}
```
-----------------------------------

## No-Support Policy

This repository is published to ensure academic transparency and reproducibility under the Creative Commons Attribution 4.0 (CC BY 4.0) License.

It documents the GDCR architectural framework at a conceptual, governance, and implementation-pattern level.

It is not intended to function as a step-by-step tutorial or implementation guide.

Successful adoption requires:

Prior experience with API Management platforms

Understanding of distributed systems

Familiarity with metadata-driven routing models

GitHub issues are not used for implementation troubleshooting or configuration support.

For academic collaboration, architectural discussion, or commercial engagement, the author may be contacted directly.

----------------------------------

### 📞 Contact
Author: Ricardo Luz Holanda Viana

## Connect:
📧 Email: rhviana@gmail.com
💼 LinkedIn: [Ricardo Viana](https://www.linkedin.com/in/ricardo-viana-br1984/)
📝 Medium: @rhviana
For commercial inquiries only: rhviana@gmail.com

-----------------------------------

## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR™) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** [10.5281/zenodo.18582492](https://zenodo.org/records/18836272)  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
