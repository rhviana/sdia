## GDCR — Pattern to Layer Mapping

---

#### Pattern → Layer → Artifact Mapping Table

---

| # | Pattern Name | Category | Primary Layer | Implemented Via | Key Artifacts |
|---|--------------|----------|---------------|------------------|---------------|
| 1 | Domain-Driven Design (DDD) Alignment | Foundational | All Layers | Architectural taxonomy & naming | Domains, URLs, Packages, iFlow DNA |
| 2 | Domain-Centric Routing Pattern (DCRP) | Gateway Pattern | API Gateway | JavaScript Routing Engine | Domain Proxies, Catch-All Routes |
| 3 | Package Domain-Centric Pattern (PDCP) | Orchestration Pattern | Backend / CPI | Package Structure & Templates | Domain Packages, iFlows |
| 4 | Metadata-Driven Control Plane | Governance | Gateway + CPI | KVM / Metadata Store | Routing Keys, Target Maps |
| 5 | Anti-Fraud & Blast-Radius Containment | Security & Resilience | API Gateway | JavaScript + KVM Validation | Fail-Fast Logic, Domain Isolation |
| 6 | Immutable Integration Identity (iFlow DNA) | Identity & Traceability | Backend + Gateway | Naming Convention Standard | Immutable IDs, Traceability |
| 7 | Architectural Decision Record (ADR) Governance | Governance | Architecture | ADR Documentation | ADR-001, Trade-off Records |

---

#### How These Patterns Work Together

- DDD Alignment defines the semantic boundaries.
- DCRP enforces those boundaries at the Gateway.
- PDCP mirrors them in the Orchestration layer.
- Metadata-Driven Control Plane replaces hardcoded logic.
- Anti-Fraud logic guarantees deterministic correctness.
- iFlow DNA ensures identity and traceability over time.
- ADRs preserve architectural intent beyond individuals.

These patterns are not optional and not independent.
They form a closed architectural system.

---

#### Short Canonical Summary (Top of /patterns page)

The GDCR framework is composed of seven interdependent architectural patterns
that collectively enforce domain-centric governance across API and orchestration
layers. These patterns combine established architectural theory with original
contributions introduced by the author and are implemented, validated, and
documented in the GDCR academic publication.

---

GDCR — Architectural Patterns Reference

This document defines the official architectural patterns that compose the Gateway Domain-Centric Routing (GDCR) framework.

GDCR is not a single pattern. It is a composite architectural system built from seven interdependent patterns, some aligned with established architectural theory, and others original contributions introduced by the author.

Each pattern listed below is implemented, validated, and referenced in the GDCR academic publication and supporting materials.

Pattern Taxonomy

Foundational Patterns → theoretical alignment

Core Execution Patterns → gateway & orchestration

Governance & Resilience Patterns → control, security, continuity

Domain-Driven Design (DDD) Alignment Pattern
Category: Foundational Architecture Origin: Established (Evans, 2003)

Description

This pattern aligns the entire integration landscape with Domain-Driven Design (DDD) principles. Business domains act as bounded contexts, and the ubiquitous language is consistently reflected across all architectural artifacts.

Implementation in GDCR

Business domains define:

API base paths

API proxies

CPI packages

iFlow identities

Routing metadata

Domains such as Sales (O2C), Finance (R2R), Logistics (SCM), Procurement (S2P) are treated as first-class architectural units.

References

Evans, E. Domain-Driven Design: Tackling Complexity in the Heart of Software

GDCR Paper v4.0 — Section “Domain-Centric Architecture”

Domain-Centric Routing Pattern (DCRP)
Category: Gateway Execution Pattern Origin: GDCR Original Pattern

Description

DCRP replaces the traditional 1:1 proxy-to-backend routing model with semantic, domain-based routing at the API Gateway layer.

Routing decisions are made based on business domain and process, not on backend endpoints or vendors.

Implementation in GDCR

One API proxy per business domain

Catch-all routes with dynamic resolution

JavaScript-based routing engine

Vendor-agnostic facade URLs

References

GDCR Paper v4.0 — DCRP Section

SAP Community Blog: Domain-Centric Routing Pattern (DCRP)

GitHub: JavaScript Maverick / Phantom Engines

Package Domain-Centric Pattern (PDCP)
Category: Orchestration / Backend Pattern Origin: GDCR Original Pattern

Description

PDCP governs the backend orchestration layer by consolidating integration artifacts per business domain, not per vendor or project.

This eliminates package sprawl and aligns backend execution with the same domain model used at the gateway.

Implementation in GDCR

One CPI package per business domain

Subprocess-based organization (O2C, R2R, SCM, S2P)

Backend mirrors gateway domain boundaries

Enables deterministic ownership and lifecycle control

References

GDCR Paper v4.0 — PDCP Section

SAP Community Blog: Package Domain-Centric Pattern (PDCP)

Metadata-Driven Control Plane Pattern
Category: Governance & Control Origin: Derived / Extended Pattern (Authorial Composition)

Description

All routing and orchestration decisions are externalized into metadata, transforming integration onboarding from a deployment activity into a configuration-driven operation.

Implementation in GDCR

Key-Value Maps (KVM) as the control plane

Runtime lookup for routing resolution

Zero proxy redeployment for new integrations

Lazy parsing and deterministic resolution

References

GDCR Paper v4.0 — Metadata-Driven Routing

Control Plane concepts (general architectural literature)

Anti-Fraud & Blast-Radius Containment Pattern
Category: Security & Resilience Origin: GDCR Original Pattern

Description

Security is enforced architecturally, not by stacking additional security layers.

If routing logic does not resolve correctly and deterministically against metadata, the request is terminated immediately at the gateway.

This prevents:

Domain spoofing

Vendor impersonation

Unauthorized routing paths

Accidental blast-radius expansion

Implementation in GDCR

JavaScript validates routing key ↔ KVM consistency

No metadata match → fail-fast termination

Backend is never reached on invalid logic

Security emerges from architectural correctness

References

GDCR Paper v4.0 — Security & Resilience

Maverick / Phantom JavaScript Engines

Immutable Integration Identity Pattern (iFlow DNA)
Category: Identity & Traceability Origin: GDCR Original Pattern

Description

Each integration flow is assigned a permanent, immutable identity that is independent of implementation details, versions, or refactoring.

Identity is decoupled from code.

Implementation in GDCR

Immutable IDs (id01, id02, …)

Seven-segment naming standard

Routing binds to identity, not endpoint

Enables auditability, rollback, and analytics

References

GDCR Paper v4.0 — iFlow DNA Section

Naming Conventions Specification

Architectural Decision Record (ADR) Governance Pattern
Category: Architectural Governance Origin: Established Pattern (Documented, Extended)

Description

All significant architectural decisions are captured as Architectural Decision Records (ADR) to preserve rationale, constraints, and trade-offs over time.

This prevents architectural drift and loss of institutional knowledge.

Implementation in GDCR

ADR documents stored alongside architecture

Explicit trade-off documentation (complexity vs scale)

Supports long-term sustainability of the framework

References

ADR methodology (Michael Nygard)

GDCR ADR-001

Pattern Origin Summary Pattern Origin DDD Alignment Established DCRP GDCR Original PDCP GDCR Original Metadata-Driven Control Plane Derived / Composed Anti-Fraud & Blast-Radius Containment GDCR Original Immutable Integration Identity (iFlow DNA) GDCR Original ADR Governance Established / Extended Final Note

GDCR patterns are not optional best practices. They are designed to operate together as a single architectural system.

Removing one weakens the whole.

Order from Chaos Not a phrase. A method.

---

**Author:** Ricardo Luz Holanda Viana  
**Role:** Enterprise Integration Architect | SAP BTP Integration Suite  
**Creator of:** GDCR · DCRP · PDCP  
**Architectural Scope:** Business-semantic, domain-centric routing architectures
for API Gateways and Integration Orchestration (vendor-agnostic),
with SAP-specific implementations via DCRP (SAP BTP API Management)
and PDCP (SAP BTP Cloud Integration).  
**License:** Creative Commons Attribution 4.0 International (CC BY 4.0)  
**DOI:** https://doi.org/10.5281/zenodo.18619641  

This document is part of the **Gateway Domain-Centric Routing (GDCR)** framework  
and represents original architectural work authored by Ricardo Luz Holanda Viana.

Reuse, adaptation, and distribution are permitted **only with proper attribution**.  
Any derivative or equivalent architectural implementation must reference the
original work and associated DOI.

---
