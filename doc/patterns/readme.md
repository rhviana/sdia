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

