Gateway Domain-Centric Routing (GDCR)
DOI License: CC BY 4.0 Paper

A vendor-agnostic, metadata-driven architecture for enterprise API & Orchestration Layers Domain-Centric Governance

📄 Published Academic Paper
  Official DOI: 10.5281/zenodo.18619641
  Published: February 12, 2026
  Repository: Zenodo (CERN)
  License: CC BY 4.0 International

📥 Download Full Paper (PDF)

What is GDCR?
  Gateway Domain-Centric Routing (GDCR) is a vendor-agnostic architectural pattern that routes API traffic by business domain (e.g., Sales, Finance, Logistics) instead of backend endpoints.

Key Results (Sandbox Validation on SAP BTP):
  ✅ 90% reduction in API proxies (41 → 4)
  ✅ 90% reduction in integration packages (39 → 4)
  ✅ 69% reduction in technical users (39 → 12)
  ✅ 95% faster deployment times (273 min → 14.5 min)
  ✅ 35,000+ messages tested with 68ms average latency, 100% success rate, zero timeouts

Architecture Overview
GDCR Architecture Overview

Core Patterns
  DCRP (Domain-Centric Routing Pattern)
API Gateway layer that routes traffic based on business domain metadata instead of hardcoded backend endpoints.

Benefits:

Eliminates proxy sprawl
Enables semantic routing for AI agents
Centralized policy enforcement
Zero vendor lock-in
PDCP (Package Domain-Centric Pattern)
Backend integration consolidation pattern that organizes integration artifacts by business domain.

Benefits:

Eliminates package sprawl
Reduces credential sprawl
Consistent naming conventions
Faster deployment cycles

🚧 Repository Contents (Under Construction)
GDCR-github/
├── README.md                                    # This file
├── LICENSE                                      # CC BY 4.0
├── JavaScript/
│   ├── README.md                                # Implementation guide
│   ├── js/  
│   │   ├── Maverick-v-15.1.png                  # State-of-the-art code visualization
│   │   └── Maverickv15.1.js                     # Full production code (v15.1)
│   └── kvm-samples/
│       └── README.md                            # Key-Value Mapping samples (SAP BTP)
├── Presentations/
│   ├── DCRP-Domain-Centric-Routing-Pattern.pdf  # Gateway Layer: 96% proxy reduction blueprint
│   ├── PDCP-Package-Domain-Centric-Pattern.pdf  # Backend Layer: Mirror Strategy deep-dive
│   └── [TBD]
└── [Under Construction]/
    ├── [TBD]
    ├── [TBD]
    └── [TBD]

Quick Start
1. Understand the Architecture

  Read the Architecture Overview (see diagram above) to understand GDCR's core concepts.

2. Review the Patterns
 
  Gateway Layer: [DCRP Pattern Guide – Under Construction]
  Backend Layer: [PDCP Pattern Guide – Under Construction]

3. Explore the Code

See the JavaScript Routing Engine v15.1 for a production-ready implementation.

4. Implement in Your Platform

Follow the Implementation Guide (coming soon) for step-by-step instructions.

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

Vendor-Agnostic Implementation:

GDCR works with any API Gateway that supports:

  ✅ Request inspection (path, headers, body)
  ✅ Conditional routing logic
  ✅ Dynamic target resolution
  ✅ Metadata storage (KVM, config, external DB)
  
Validated Platform:

SAP BTP Integration Suite (API Management + Cloud Platform Integration)
Theoretical Implementations:
  
  Google Apigee
  Kong Gateway
  AWS API Gateway
  Azure API Management
  MuleSoft Anypoint Platform
  Tyk Gateway
  Nginx Plus
  
See Implementation Guide (coming soon) for platform-specific examples.

Results Summary

  Complexity Reduction (Sandbox Environment)
  Metric	Before	After	Improvement
  API Proxies	41	4	90% ↓
  Integration Packages	39	4	90% ↓
  Technical Users	39	12	69% ↓
  Deployment Time	273 min	14.5 min	95% ↓
  Performance (35,000+ messages tested in sandbox)
  Average Latency: 68ms
  Success Rate: 100%
  Timeouts: 0
  Error Rate: 0%
  
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
📊 Validation Status: All metrics validated in SAP BTP Trial sandbox environment only. Production results may vary based on:

Actual integration complexity
Organizational structure
Existing technical debt
Team skill levels
Specific platform configuration
Academic Resources
Citation (APA):
Viana, R. L. H. (2026). Gateway Domain-Centric Routing: A Vendor-Agnostic 
Metadata-Driven Architecture for Enterprise API Governance. Zenodo. 
https://doi.org/10.5281/zenodo.18619641
Citation (BibTeX):
@article{viana2026gdcr,
  title={Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven 
         Architecture for Enterprise API Governance},
  author={Viana, Ricardo Luz Holanda},
  journal={Zenodo},
  year={2026},
  doi={10.5281/zenodo.18619641},
  url={https://zenodo.org/records/18619641}
}
Related Publications:
Medium - GDCR Introduction
SAP Community - DCRP Part I
SAP Community - PDCP Part II
Equivalent Terminology
All these terms refer to the same architecture published under DOI: 10.5281/zenodo.18619641:

Gateway Layer:

GDCR (Gateway Domain-Centric Router)
DCRP (Domain-Centric Routing Pattern)
MDAGR (Metadata-Driven API Gateway Routing)
SRBD (Semantic Routing via Business Domains)
Business & Semantic:

DOAGA (Domain-Oriented API Gateway Architecture)
BSGR (Business-Semantic Gateway Routing)
SAGA (Semantic API Gateway Architecture)
Governance:

DGAR (Domain-Governed API Routing)
CDRA (Centralized Domain Routing Architecture)
Anti-Sprawl:

APSRA (Anti-Proxy-Sprawl Routing Architecture)
DDGCP (Domain-Driven Gateway Consolidation Pattern)
Contributing
Contributions are welcome! Please read our Contributing Guidelines (coming soon) first.

Ways to Contribute:
Report bugs or issues
Suggest new features or improvements
Improve documentation
Submit platform-specific implementations
Share your implementation results
Contact & Support
Author: Ricardo Luz Holanda Viana

Connect:

📧 Email: rhviana@gmail.com
💼 LinkedIn: Ricardo Viana
🆔 ORCID: 0009-0009-9549-5862
📝 Medium: @rhviana
Questions?

Open an Issue
Check Discussions
⚠️ No Support Policy
This project is published for academic transparency and reproducibility.

I do not provide:

❌ Implementation support
❌ Consulting services
❌ Troubleshooting assistance
❌ Custom development
The code and paper are sufficient for technical professionals to understand and implement the pattern independently.

For commercial inquiries only: rhviana@gmail.com

License
This work is licensed under Creative Commons Attribution 4.0 International (CC BY 4.0).

You are free to:

Share — copy and redistribute the material
Adapt — remix, transform, and build upon the material
Commercial use — use for commercial purposes
Under the following terms:

Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made
Star History
If this project helped you, please ⭐ star this repository and cite the academic paper!

Project Status
✅ Academic Paper: Published (DOI: 10.5281/zenodo.18619641)
✅ Sandbox Validation: Complete (SAP BTP Trial Environment)
⚠️ Production Validation: Not yet tested
🚧 Documentation: In Progress
🚧 Community Implementations: In Progress
🚧 Multi-Platform Examples: In Progress
Last Updated: February 12, 2026
DOI: 10.5281/zenodo.18619641
Version: 1.0.0
