⚠️ IMPORTANT: Repository Access Protocol
This repository contains original architectural work, proprietary frameworks, and advanced SAP BTP Integration Suite technical blogs.

Before exploring, reusing, or referencing any content, you are strongly required to read the following documents to understand the authorship, the engineering background, and the Intellectual Property (IP) protections governing this work:

👤 [ABOUT-ME](./01-ABOUT-ME.md) – To understand the 17-year journey from SAP XI/PI - GRC NF-e ( Brazilian eletronic invoices solution ) to BTP Expert and the context of the " The Commander - Viana" methodology.

📜 [NOTICE](./02-NOTICE.md) – Regarding IP rights, DOIs, and usage licenses.


Please ensure you have reviewed these files before proceeding to the main technical documentation.

Gateway Domain-Centric Routing (GDCR)
-----------------------------------


[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18582492.svg)](https://zenodo.org/records/18661136)
[![DOI](https://img.shields.io/badge/DOI-10.6084%2Fm9.figshare.31331683-brightgreen)](https://doi.org/10.6084/m9.figshare.31331683)
[![Paper](https://img.shields.io/badge/Paper-Zenodo-blue)](https://zenodo.org/records/18661136)
[![Paper](https://img.shields.io/badge/Paper-Figshare-brightgreen)](https://doi.org/10.6084/m9.figshare.31331683)
[![ORCID](https://img.shields.io/badge/ORCID-0009--0009--9549--5862-brightgreen)](https://orcid.org/0009-0009-9549-5862)
[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
![Pattern](https://img.shields.io/badge/Pattern-GDCR--v5.0-blueviolet)
![SAP](https://img.shields.io/badge/Platform-SAP%20BTP%20Integration%20Suite-008fd3)
![SAP](https://img.shields.io/badge/Platform-SAP%20BTP%20Cloud%20Platform%20Integration-008fd3)
![SAP](https://img.shields.io/badge/Platform-SAP%20BTP%20API%20Management-008fd3)

**DOI License:** CC BY 4.0 — Academic Paper Pattern (SAP)

A **vendor-agnostic, metadata-driven architecture** for enterprise **API & orchestration layers**, enabling **Domain-Centric Governance**.

**Contents**

- [Online Executive Summary](#online-executive-summary)
- [What is GDCR ?](#what-is-gdcr-)
- [Domain-Driven Centric Router (DDCR)](#domain-driven-centric-router-ddcr)
- [SAP-Specific Architecture (DCRP + PDCP)](#sap-specific-architecture-diagram-dcrp--pdcp)
- [The 7 Core GDCR Patterns](#the-7-core-gdcr-patterns)
- [Repository Structure](#-repository-structure)
- [Documentation](#-documentation)
- [Stress Tests & Results](#key-highlights)
- [Academic Citation](#academic-citation)
- [Contact](#-contact)

Online Executive Summary
-----------------------------------

Validated across 106,190+ messages, 44 vendor integrations http facades, 4 business domains proxies, 4 domain-aligned integration packages, and 44 domain-governed iFlows endpoints, GDCR achieved a 100% success rate with zero routing errors, zero KVM failures, and zero timeouts, executed through four distinct JavaScript policy implementations.

GDCR is vendor-agnostic by design and unifies Domain-Driven Design (DDD) alignment, domain-centric routing, metadata-driven control planes, architectural fraud prevention (semantic URL abstraction), immutable integration identities, and formal architectural decision records into a single, cohesive enterprise integration governance framework.

The objective of this validation was not to benchmark raw throughput, but to prove architectural correctness, deterministic behavior, and measurable governance impact under controlled conditions.

What is GDCR ?
-----------------------------------

Gateway Domain-Centric Routing (GDCR) is a vendor-agnostic architectural pattern that routes API traffic based on business domain and business process
(e.g., Sales (O2C), Finance (R2R), Logistics (LE)) instead of backend endpoints.

This routing logic is applied consistently across both the Gateway layer and the Orchestration layer.

<p align="center">
  <img src="./repository/figures/gdrc.png"
       alt="Domain-Centric Routing (GDCR) - API and Orquestration"
       width="85%" />
</p>


Domain-Driven Centric Router (DDCR)
-----------------------------------

While GDCR defines the **gateway-level architecture**, the **Domain-Driven Centric Router (DDCR)** defines how routing decisions are executed at runtime behind the gateway.

DDCR operates over the **semantic URL façade** exposed by GDCR:

```text
/{domain}/{resource}/{action}/{vendor-id}
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                    GDCR FRAMEWORK v6.0 – THREE LAYERS                       │
│                                                                             │
│   ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐        │
│   │      GDCR       │───►│      DDCR       │───►│      GDCR       │        │
│   │   (Gateway)     │    │   (Router)      │    │ (Orchestration) │        │
│   │                 │    │                 │    │                 │        │
│   │ • SAP APIM      │    │ • Runtime       │    │ • SAP CPI       │        │
│   │ • Kong          │    │ • Metadata      │    │ • iFlow DNA     │        │
│   │ • AWS / Azure   │    │ • Translation   │    │ • Packages      │        │
│   │                 │    │                 │    │                 │        │
│   │ “Facade”        │    │ “Routing”       │    │ “Execution”     │        │
│   │ /sales/...      │───►│ sf-us → id01    │───►│ id01.o2c.sf...  │        │
│   └─────────────────┘    └─────────────────┘    └─────────────────┘        │
│                                                                             │
│   GDCR exposes       DDCR translates          PDCP executes                 │
│   business language  intent into              the technical flow            │
│   at the gateway     a concrete backend       in the orchestration layer    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘


Instead of binding gateway routes directly to vendors, DDCR treats this path as a business-semantic string, performs a metadata lookup (DynamoDB, KVM, Redis, etc.), and translates it into the concrete vendor invocation (iPaaS, microservice, queue, function, etc.) in real time.

Route shape and vendor identity

In GDCR/DDCR, only the first segment is strictly fixed:

- Domain is the core invariant of the semantic contract and always appears first. It anchors the request in a business context (e.g., sales, finance, logistics, masterdata) and is never reordered.
- The following segments (resource, action, and any additional qualifiers) are structurally flexible, as long as the DDCR knows how to compose the routing key from them (for example: {resource}/{action}/{vendor-id} or {resource}/{subresource}/{action}/{vendor-id} or any sequence).
- The last segment is not a generic "vendor", but a vendor identifier (vendor-id) that uniquely represents a concrete integration endpoint or tenant, including region/instance when needed. Examples:

| vendor-id         | Significado                |
| ----------------- | -------------------------- |
| `salesforce-us`   | Salesforce instância US    |
| `salesforce-emea` | Salesforce instância EMEA  |
| `salesforce-apac` | Salesforce instância APAC  |
| `s4hana-br`       | SAP S/4HANA Brasil         |
| `s4hana-eu`       | SAP S/4HANA Europa         |
| `cpi-tenant1`     | SAP CPI tenant específico  |
| `cpi-tenant2`     | SAP CPI tenant alternativo |


This uniqueness at the vendor-id level prevents routing collisions and allows the catalog (e.g., gdcr-kvm) to map multiple regions, tenants or instances for the same domain/resource/action combination without ambiguity.

Key characteristics:

| Característica        | Descrição                                                                                                                               |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Gateway compatibility | Works behind any GDCR‑aligned gateway (SAP APIM, AWS API Gateway, Apigee, Kong, etc.)                                                   |
| Metadata catalog      | Uses `gdcr-kvm` or equivalent to resolve: domain, resource, action, vendor-id, interface\_id, protocol, target\_vendor, env, version, … |
| Runtime flexibility   | Implemented in any modern stack (JavaScript, Python, Node.js, C#, …)                                                                    |
| Fast-fail semantics   | If a route is not defined or authorization fails, the request is rejected deterministically, without exposing vendor topology           |
| Security by design    | Makes endpoint discovery by attackers impractical, since the gateway only exposes business‑semantic façades, not raw vendor URLs        |

DDCR is the execution layer of GDCR:
The gateway speaks in business language; the DDCR translates that into backend reality in a fully metadata‑driven, vendor‑agnostic way.

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                         CLIENT / API CONSUMER                              │
│                                                                             │
│    ┌─────────────────────────────────────────────────────────────────┐      │
│    │  REQUEST: POST /sales/orders/create/salesforce-us              │      │
│    │  Headers: { "X-Correlation-Id": "abc-123", ... }               │      │
│    └─────────────────────────────────────────────────────────────────┘      │
│                              │                                              │
│                              ▼                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────────────────┐
│                    DDCR – DOMAIN-DRIVEN CENTRIC ROUTER                     │
│                    ═══════════════════════════════════                     │
│                                                                             │
│  ┌──────────────── SEMANTIC API GATEWAY ──────────────────────────────┐    │
│  │                                                                     │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐  ┌───────────┐ │    │
│  │  │   DOMAIN    │  │  RESOURCE   │  │    ACTION    │  │ VENDOR-ID │ │    │
│  │  │   /sales    │  │   /orders   │  │   /create    │  │ /sf-us    │ │    │
│  │  └─────────────┘  └─────────────┘  └──────────────┘  └───────────┘ │    │
│  │                                                                     │    │
│  │  Business intent encoded as path                                    │    │
│  │  (no IPs, no regions, no tech stack in the URL)                     │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                              │                                              │
│                              ▼                                              │
│  ┌──────────────── LIGHTWEIGHT RUNTIME ENGINE ─────────────────────────┐    │
│  │                                                                     │    │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │    │
│  │  │   JS    │ │ Python  │ │ Node.js │ │   C#    │ │  Lua    │ ...   │    │
│  │  │ (SAP)   │ │ (Custom)│ │ (Edge)  │ │ (Azure) │ │ (Kong)  │       │    │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘       │    │
│  │                              │                                      │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │  EXECUTION FLOW:                                            │    │    │
│  │  │                                                             │    │    │
│  │  │  1. PARSE      → Treat path as STRING                       │    │    │
│  │  │  2. LOOKUP     → Query METADATA CATALOG                     │    │    │
│  │  │                  ┌─────────┐ ┌─────────┐ ┌─────────┐         │    │    │
│  │  │                  │DynamoDB │ │   KVM   │ │  Redis  │ ...     │    │    │
│  │  │                  └─────────┘ └─────────┘ └─────────┘         │    │    │
│  │  │  3. RESOLVE    → Match semantic route → concrete backend    │    │    │
│  │  │  4. TRANSLATE  → Build target URL / invocation              │    │    │
│  │  │  5. FORWARD    → Route to destination                       │    │    │
│  │  │                                                             │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                              │                                              │
│                    ┌─────────┴─────────┐                                    │
│                    ▼                   ▼                                    │
│              ┌─────────┐         ┌─────────┐                                │
│              │ SUCCESS │         │  FAIL   │                                │
│              │ Route   │         │  FAST   │                                │
│              │ Found   │         │ (4xx/5xx)                                │
│              └────┬────┘         └────┬────┘                                │
│                   │                   │                                     │
│                   ▼                   ▼                                     │
│         ┌─────────────────┐   ┌─────────────────┐                           │
│         │  Forward Call   │   │  Return 4xx/5xx │                           │
│         │  to Backend     │   │  No endpoint    │                           │
│         │                 │   │  exposure       │                           │
│         │  • Orchestration│   │  No guessing    │                           │
│         │    Layers       │   │  No probing     │                           │
│         │  • Core ERP     │   │                 │                           │
│         │  • 3rd-Party    │   │  Attack surface │                           │
│         │    Systems      │   │  = ZERO         │                           │
│         └─────────────────┘   └─────────────────┘                           │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │  SECURITY & OBSERVABILITY PROPERTIES:                               │    │
│  │                                                                     │    │
│  │  ✓ Endpoint discovery impossible (no tech details in URL)           │    │
│  │  ✓ No infrastructure probing (semantic façade blocks reconnaissance)│    │
│  │  ✓ Observable (semantic tags: domain/resource/action/vendor-id)     │    │
│  │  ✓ Governable (centralized metadata catalog)                        │    │
│  │  ✓ Vendor-agnostic (same pattern, any runtime, any backend)         │    │
│  │                                                                     │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         BACKEND TARGETS                                    │
│                                                                             │
│   ┌────────────────┐   ┌────────────────┐   ┌────────────────┐             │
│   │ Orchestration  │   │   Core ERP     │   │   3rd-Party    │             │
│   │  Layers        │   │  Systems       │   │   Systems      │             │
│   │                │   │                │   │                │             │
│   │ • SAP CPI      │   │ • SAP S/4HANA  │   │ • Salesforce   │             │
│   │ • Other iPaaS  │   │ • Oracle ERP   │   │ • ServiceNow   │             │
│   │ • ESB / BPM    │   │ • Dynamics 365 │   │ • Custom APIs  │             │
│   └────────────────┘   └────────────────┘   └────────────────┘             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```
## Core Patterns applied in SAP BTP Integration Suite ( APIM and CPI )

**[Scientific Validation](./doc/academic-paper-zenodo/)**

- Peer-reviewed documentation archived at **Zenodo (CERN)**
- Peer-reviewed documentation archived at **Figshare(CERN)**

### SAP-specific benefits (DCRP + PDCP)

- **DCRP (SAP API Management):** consolidates many system-centric proxies into a few domain façades, with metadata-driven routing (KVM + JS) and fast-fail security (sender × domain/entity/action) directly at the gateway.

- **[Gateway Layer (DCRP) - SAP BTP APIM - Specific](./src/gateway-sap-apim/)**

- **PDCP (SAP Cloud Integration):** replaces “package per vendor/app” with “one package per domain”, using iFlow DNA naming so each KVM key in DCRP points to a clearly indexed CPI flow, cutting package/iFlow sprawl while keeping domain ownership clear.

- **[Backend Layer (PDCP) - SAP BTP APIM - Specific](./src/backend-sap-cpi/)**

📂 Repository Structure
-----------------------------------

This repository is organized to clearly separate **architecture concepts,
academic material, runtime components, visual assets, automation workflows,
and validation evidence**.

The structure reflects the evolution of the **GDCR framework** from
conceptual definition to validated runtime execution.

```text
├── .github/                          # GitHub-specific configuration
│
├── JavaScript/                       # Standalone JavaScript artifacts
│   ├── js/                           # JavaScript execution logic
│   └── README.md                     # JavaScript scope and usage
│
├── dgrc-gateway-domain-centric/      # Conceptual and historical GDCR material
│   └── README.md
│
├── doc/                              # Primary documentation hub
│   ├── academic-paper/               # Academic material (DOI / Zenodo)
│   ├── complience/                   # Compliance and audit documentation
│   ├── gdcr-architecture/            # High-level architecture descriptions
│   ├── implementation/               # Implementation guidelines
│   ├── patterns/                     # GDCR core patterns (DCRP, PDCP, etc.)
│   ├── presentations/                # Slides and explanatory material
│   ├── security/                     # Security model and fast-fail logic
│   └── README.md                     # Documentation index
│
├── repository/                       # Visual assets repository
│   ├── figures/                      # Architecture diagrams and illustrations
│   └── README.md                     # Visual assets scope
│
├── src/                              # Core runtime components
│   ├── gateway-sap-apim/              # SAP API Management (Gateway layer)
│   ├── javascript/                   # Runtime JavaScript execution engine
│   ├── kvm/                          # Key-Value Mapping metadata definitions
│   └── README.md                     # Runtime architecture overview
│
├── stress-test/                      # Validation and stress testing
│   ├── stress-imagens/                # Test result screenshots
│   └── README.md                     # Test methodology and results
│
├── workflows/                        # Automation and deployment workflows
│   ├── deploy-metadata.yml            # Metadata deployment pipeline
│   └── README.md                     # Workflow documentation
│
├── LICENSING.md                      # Licensing details (CC BY 4.0)
├── NOTICE.md                         # Attribution, prior art, and usage notice
└── README.md                         # Main project documentation
```


GDCR Architectural Scope
-----------------------------------

Gateway Domain-Centric Routing (GDCR) is not a single pattern or implementation.
It is a composite architectural framework designed to govern enterprise integration landscapes at scale.

DCRP and PDCP are its core execution patterns, but GDCR also formalizes:

- metadata as a control plane
- naming conventions as governance mechanisms
- immutable integration identities (iFlow DNA)
- documented architectural decisions (ADR)

Together, these elements operate as one cohesive system, preventing uncontrolled architectural entropy.


SAP-Specific Architecture Diagram (DCRP + PDCP)
The diagrams above describe the vendor-agnostic GDCR + DDCR framework.
The following architecture diagram shows one concrete realization on
SAP BTP Integration Suite, where:

- DCRP implements the GDCR gateway layer (SAP API Management).
- DDCR is implemented via JavaScript routing logic + KVM (Maverick Engine).
- PDCP implements the orchestration layer on SAP Cloud Integration (CPI).
-----------------------------------

```text
                         _________________________________________________________
                        |    External Consumers / AI Agents | Applications        |
                        |                 40 external vendors                     |
                        |     Only - 4 endpoints DCRP-Proxies / many paths        |
                        |___________________________ _____________________________|
                                                    |
                                      ______________v_______________
                                     |   DCRP Layer (API Gateway)    |
                                     |  SAP BTP IS - API Management  |
                                     |  ___________________________  |
                                     | | 4 Domain Proxies:         | |
                                     | | * Sales      10+ bprocess | |
                                     | | * Finance    10+ bprocess | |
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

The 7 Core GDCR Patterns
-----------------------------------

GDCR is composed of seven complementary architectural patterns:
- Domain-Centric Routing Pattern (DCRP) — Semantic routing at the gateway layer
- Package Domain-Centric Pattern (PDCP) — Domain-based backend consolidation
- Metadata-Driven Routing Pattern — Externalized routing decisions (KVM / KV Store)
- Action Normalization Pattern — Canonical business actions (C, R, U, D, A…)
- Proxy Consolidation Pattern — One proxy per strategic domain
- Immutable Integration Identity Pattern (iFlow DNA) — Permanent, non-reusable flow identities
- Architectural Decision Record (ADR) Pattern — Explicit architectural traceability

These patterns are interdependent but also can work isolated of each other - DCRP and PDCP and the ideal scenario be applied together for full domain-centric layer from the gateway, orquestraction connected with CORE BUSINESS ERP.

📖 Documentation
-----------------------------------

Complete documentation available in [`/doc`](./doc):

👉 **[Security: Fail-Fast Logic](./doc/security/FAIL-FAST-LOGIC.md)** - Why no OAuth2 (66x faster)
👉 **[Architecture Overview](./doc/architecture/README.md)** - GDCR pattern explained
👉 **[Access Control](./doc/security/ACCESS-CONTROL.md)** - Per-sender isolation
👉 **[Compliance](./doc/compliance/AUDIT-COMPLIANCE.md)** - Audit trail & GDPR

Key Highlights:
-----------------------------------

- ⚡ 2-5ms validation (vs 150-300ms OAuth2)
- 🔒 Zero external dependencies (KVM fast-fail)
- 📊 90% proxy reduction (4 proxies vs 400)
- 🌐 Multi-vendor (SAP APIM, Apigee, AWS, Azure, Any)


Note:
-----------------------------------

Metrics are weighted across Milestones M1–M4.
M5 includes additional SAP BTP Trial Tenant overhead.

**[The Stress Test Result)](./stress-test/)**: - 5 different tested to valided the soluttion and the results above.

Final Technical Conclusion

-----------------------------------

- The sandbox validation proves that the **Maverick Engine™ (v14.2 baseline)** provides a **90% reduction in infrastructure complexity** while maintaining a **100% success rate** across **33,000+ messages**.
- These results are now **immortalized** under **[DOI: 10.5281/zenodo.18619641](https://zenodo.org/records/18619641)**.

-----------------------------------

## No-Support Policy

This project is published for academic transparency and reproducibility. No implementation support, consulting, or troubleshooting assistance is provided.

I do not provide free consulting:

❌Implementation support

❌Consulting services

❌Troubleshooting assistance

❌ Custom development

For commercial inquiries contact me.

---
### Academic Citation

If you use this architecture in your research or implementation, please cite:

APA
-----------------------------------

Viana, R. L. H. (2026). *Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven Architecture for Enterprise API Governance - Version 5.0*. Zenodo. https://doi.org/10.5281/zenodo.18582492

Viana, R. L. H. (2026). *Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven Architecture for Enterprise API Governance - Version 5.0*. Figshare. https://doi.org/10.6084/m9.figshare.31331683

BibTeX
-----------------------------------

@article{viana2026gdcr,
  title   = {Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven Architecture for Enterprise API Governance - Version 5.0},
  author  = {Viana, Ricardo Luz Holanda},
  journal = {Zenodo},
  year    = {2026},
  doi     = {10.5281/zenodo.18619641},
  url     = {https://doi.org/10.5281/zenodo.18619641}
}

@misc{viana2026gdcr_assets,
  title        = {Gateway Domain-Centric Routing (GDCR): A Vendor-Agnostic Metadata-Driven Architecture for Enterprise API Governance},
  author       = {Viana, Ricardo Luz Holanda},
  year         = {2026},
  howpublished = {Figshare},
  doi          = {10.6084/m9.figshare.31331683},
  url          = {https://doi.org/10.6084/m9.figshare.31331683}
}

-----------------------------------
### 📞 Contact
Author: Ricardo Luz Holanda Viana

## Connect:
📧 Email: rhviana@gmail.com
💼 LinkedIn: [Ricardo Viana](https://www.linkedin.com/in/ricardo-viana-br1984/)
📝 Medium: @rhviana
For commercial inquiries only: rhviana@gmail.com

-----------------------------------

Maverick Phantom Edition v15.2 - Now Available

-----------------------------------

**GDCR Maverick Phantom Edition v15.2** is available for early access.

### ✅ Proven at Scale
- **73,000 messages** validated successfully
- **2-5ms average latency** (P95 ≤8ms)
- **Zero operational errors** or routing failures
- **100% success rate** across all scenarios

### 🔬 Status
- Production-ready with 90% code completion
- Under last adjustaments and performance check
- Optimization phase targeting 1-2ms performance
- Early access available for enterprise pilots and collaboration

Contact me privately.

-----------------------------------

**Author:** Ricardo Luz Holanda Viana  
**Role:** Enterprise Integration Architect · SAP BTP Integration Suite  
**Creator of:** GDCR · DCRP · PDCP  

**Architectural scope:** Business‑semantic, domain‑centric routing architectures for API Gateways and Integration Orchestration (vendor‑agnostic), with SAP‑specific implementations via DCRP (SAP BTP API Management) and PDCP (SAP BTP Cloud Integration).  

**License:** Creative Commons Attribution 4.0 International (CC BY 4.0)  
**DOI:** [zenodo.18661136](https://doi.org/10.5281/zenodo.18582492)  
**DOI:**  [figshare.31331683](https://doi.org/10.6084/m9.figshare.31331683)

This document is part of the **Gateway Domain‑Centric Routing (GDCR)** framework and represents original architectural work authored by Ricardo Luz Holanda Viana. Reuse, adaptation, and distribution are permitted only with proper attribution. Any derivative or equivalent architectural implementation must reference the original work and associated DOI.

---
