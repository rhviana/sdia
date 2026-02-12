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
├── StressTest/
│   ├── milestone-1-soak-test.png                # 25k messages, gateway resilience
│   ├── milestone-2-smoke-test.png               # 2 domains, 39 vendors
│   ├── milestone-3-multi-domain.png             # 4 domains, 3k iterations
│   └── milestone-4-extended.png                 # 5k iterations, off-hours
└── [Under Construction]/
    ├── [TBD]
    ├── [TBD]
    └── [TBD]
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

3. Explore the Code
See the JavaScript Routing Engine v15.1 for production-ready implementation.

4. Advanced Resources
Academic Paper: Deep-dive into theoretical foundations (Zenodo)
Presentations: Architecture blueprints in /Presentations/
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
Vendor-Agnostic Implementation
GDCR works with any API Gateway that supports:

✅ Request inspection (path, headers, body)
✅ Conditional routing logic
✅ Dynamic target resolution
✅ Metadata storage (KVM, config, external DB)
Validated Platform:
SAP BTP Integration Suite (API Management + Cloud Integration)
Theoretical Implementations:
Google Apigee
Kong Gateway
AWS API Gateway
Azure API Management
MuleSoft Anypoint Platform
Tyk Gateway
Nginx Plus
See Implementation Guide (coming soon) for platform-specific examples.

🧪 Sandbox Validation & Testing
Overview: Infrastructure Consolidation
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Infrastructure Consolidation:

API proxies: 41 → 4 (90% reduction)
Integration packages: 39 → 4 (90% reduction)
Technical users: 39 → 12 (69% reduction)
Deployment time: 273 min → 14.5 min (95% faster)
Technical Metrics:

35,000+ messages tested
100% success rate, zero timeouts
68ms average latency (v14.2 baseline)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Test Environment Setup
Infrastructure:

Platform: SAP BTP Integration Suite (Trial)
Region: Europe (Frankfurt) - cf-eu10
Runtime: Cloud Foundry
Test Period: February 2026
JavaScript Engine: v8.0 (Nashorn)
Milestone 1: Gateway Resilience — The 25k "Soak Test"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Objective:
Validate long-running stability of the SAP APIM Gateway, focusing on JavaScript heap behavior and KVM lookup consistency.

Test Scope:

Vendors: 1
Business Domain: Sales
Business Process: O2C (Order to Cash)
Endpoints: 2 (Sales Order Create/Update)
DCRP Proxies: 1
JavaScript Engine: v8.0
Environment: SAP BTP Sandbox
Load & Results:

Total Requests: ~25,000 over ~1 hour
Success Rate: 100%
Average Latency: 66 ms
Requests >500 ms: 77 (0.28%) — caused by transient cloud network jitter
Timeouts: 0
Errors: 0
Key Findings:

✅ JavaScript heap stable under sustained load
✅ KVM cache hit rate: 99.2%
✅ No memory leaks detected
✅ Gateway remained responsive throughout test duration
Milestone 1 - Soak Test Results

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Milestone 2: JavaScript v14.2 — Smoke Test (Multi-Vendor)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Objective:
Validate domain consolidation with multiple vendors across two business domains.

Test Scope (Domain-Centric):

Vendors: 39 total (~10 vendors per business process, sampled)
Business Domains: 2
Sales — O2C (Order to Cash)
Procurement — S2P / P2P (Source/Procure to Pay)
DCRP Proxies: 2 (one proxy per business domain)
Routing Engine: JavaScript v14.2
Environment: SAP BTP Sandbox
What Was Validated:

All vendors related to Sales (O2C) and Procurement (S2P/P2P) were exposed through only two DCRP proxies (one per domain).

This replaces the traditional model of:

❌ 20–40 individual API proxies (1:1 vendor mapping)
With:

✅ 2 domain-based DCRP proxies
✅ Deployment time: ~5 minutes (template-based)
Results:

Success Rate: 100%
Average Latency: 68 ms
Proxy Reduction: 95% (39 → 2 in test scope)
First performance check of JavaScript v14.2: ✅ Pass
Milestone 2 - Smoke Test Results

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Milestone 3: Multi-Domain Stress Test — JavaScript v14.2
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Objective:
Validate domain consolidation efficiency—can 4 proxies truly replace 40 without performance degradation?

Setup:

Business Domains: 4
Finance (R2R — Record to Report)
Sales (O2C — Order to Cash)
Logistics (SCM — Supply Chain Management)
Procurement (S2P — Source to Pay)
iFlows: 39
DCRP Proxies: 4 (1 per domain)
Test Load: 75 iterations × ~40 calls = 3,000 total requests
Routing Engine: JavaScript Maverick v14.2
Results:

Total Requests: 3,000
Success Rate: 100%
Average Latency: 67 ms
P95 Latency: 89 ms
P99 Latency: 112 ms
Timeouts: 0
Errors: 0
Key Findings:

✅ 4 proxies successfully replaced 40 with zero degradation
✅ Latency remained consistent across all domains
✅ No hotspots or bottlenecks detected
✅ Cache efficiency: 98.1%
Milestone 3 - Multi-Domain Stress Test

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Milestone 4: Extended Off-Hours Validation — JavaScript v14.2
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Objective:
Validate system stability during extended operation with minimal cloud infrastructure contention.

Setup:

Test Execution: 04:00 AM — February 10, 2026 (outside business hours)
Iterations: 5,000
Business Domains: 4 (Finance, Sales, Logistics, Procurement)
DCRP Proxies: 4
Routing Engine: JavaScript Maverick v14.2 (Domain Consolidation)
Results:

Total Requests: 5,000
Success Rate: 100%
Average Latency: 65 ms (improved due to reduced cloud contention)
P95 Latency: 87 ms
P99 Latency: 108 ms
Timeouts: 0
Errors: 0
Key Findings:

✅ Off-hours performance slightly better (lower network contention)
✅ System remained stable throughout extended test
✅ No memory leaks or resource exhaustion
✅ Cache TTL (60s) performed optimally
Milestone 4 - Extended Off-Hours Validation

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Final Analysis: JavaScript Maverick Ghost Edition v15.1
🚀 Under final analysis — Results for the latest Maverick Ghost Edition (v15.1) are being compiled.

Expected Improvements over v14.2:

⚡ Pre-compiled regex: 30% reduction in path parsing time
⚡ DJB2 hash: 50% faster than FNV-1a (v14.2)
⚡ O(1) action lookup: Eliminates O(n) loop (241 action variants)
⚡ Target latency: 8-15 ms routing overhead (vs 12-22 ms in v14.2)
Preliminary Results (ongoing validation):

Messages Tested: 35,000+
Success Rate: 100%
Average Latency: 68 ms (includes backend processing)
GDCR Routing Overhead: ~1-2 ms (v15.1 optimizations)
📊 Full v15.1 validation report coming soon.

Test Reproducibility
All test artifacts available in this repository:

Newman Collection: /tests/postman/GDCR-Test-Collection.json
Environment Config: /tests/postman/SAP-BTP-Trial-Environment.json
Sample Payloads: /tests/sample-payloads/*.json
KVM Configuration: /JavaScript/kvm-samples/
Test Results: /StressTest/ (screenshots)
Run tests:

Copynewman run tests/postman/GDCR-Test-Collection.json \
  --environment tests/postman/SAP-BTP-Trial-Environment.json \
  --reporters cli,json,html \
  --reporter-html-export test-report.html \
  --delay-request 100 \
  --iteration-count 5000
Known Limitations (Sandbox Environment)
⚠️ The following were NOT tested and may behave differently in production:

High Concurrent Load: Trial limited to ~10 req/s (production may handle 100-1,000+ req/s)
Large Payloads: Tested up to 2MB (production may require tuning for 10MB+)
Multi-Tenant Scenarios: Single tenant only (production may need cache isolation)
Cross-Region Routing: EU network only (global production not tested)
Disaster Recovery: No HA/failover testing conducted
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
The SAP Community blog posts (Part I & II) contain complete step-by-step implementation guides sufficient for building a full PoC. No additional tutorials will be provided.

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
✅ Sandbox Validation: Complete (35,000+ messages, 4 milestones)
⚠️ Production Validation: Not yet tested
✅ Implementation Guides: Available (SAP Community Blog I & II)
🚧 Documentation: In Progress
🚧 Community Implementations: In Progress
🚧 Multi-Platform Examples: In Progress
Last Updated: February 12, 2026
DOI: 10.5281/zenodo.18619641
Version: 1.0.0
