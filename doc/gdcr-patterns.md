GDCR — Architectural Patterns Reference

This document defines the official architectural patterns that compose the Gateway Domain-Centric Routing (GDCR) framework.

GDCR is not a single pattern.
It is a composite architectural system built from seven interdependent patterns, some aligned with established architectural theory, and others original contributions introduced by the author.

Each pattern listed below is implemented, validated, and referenced in the GDCR academic publication and supporting materials.

Pattern Taxonomy

Foundational Patterns → theoretical alignment

Core Execution Patterns → gateway & orchestration

Governance & Resilience Patterns → control, security, continuity

1. Domain-Driven Design (DDD) Alignment Pattern

Category: Foundational Architecture
Origin: Established (Evans, 2003)

Description

This pattern aligns the entire integration landscape with Domain-Driven Design (DDD) principles.
Business domains act as bounded contexts, and the ubiquitous language is consistently reflected across all architectural artifacts.

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

2. Domain-Centric Routing Pattern (DCRP)

Category: Gateway Execution Pattern
Origin: GDCR Original Pattern

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

3. Package Domain-Centric Pattern (PDCP)

Category: Orchestration / Backend Pattern
Origin: GDCR Original Pattern

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

4. Metadata-Driven Control Plane Pattern

Category: Governance & Control
Origin: Derived / Extended Pattern (Authorial Composition)

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

5. Anti-Fraud & Blast-Radius Containment Pattern

Category: Security & Resilience
Origin: GDCR Original Pattern

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

6. Immutable Integration Identity Pattern (iFlow DNA)

Category: Identity & Traceability
Origin: GDCR Original Pattern

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

7. Architectural Decision Record (ADR) Governance Pattern

Category: Architectural Governance
Origin: Established Pattern (Documented, Extended)

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

Pattern Origin Summary
Pattern	Origin
DDD Alignment	Established
DCRP	GDCR Original
PDCP	GDCR Original
Metadata-Driven Control Plane	Derived / Composed
Anti-Fraud & Blast-Radius Containment	GDCR Original
Immutable Integration Identity (iFlow DNA)	GDCR Original
ADR Governance	Established / Extended
Final Note

GDCR patterns are not optional best practices.
They are designed to operate together as a single architectural system.

Removing one weakens the whole.

Order from Chaos
Not a phrase.
A method.
