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

# The 7 Core GDCR Patterns

GDCR é composto por sete padrões arquiteturais complementares:

## 1. Domain-Centric Routing Pattern (DCRP)
Roteamento semântico na camada de gateway. Consolida múltiplos proxies de vendor em poucos proxies de domínio.

## 2. Domain-Driven Centric Router (DDCR)
Router dinâmico baseado em metadata. Traduz URLs semânticas em invocações de vendor concretas.

## 3. Package Domain-Centric Pattern (PDCP)
Consolidação de pacotes por domínio no backend. Substitui "um pacote por vendor" por "um pacote por domínio de negócio".

## 4. Metadata-Driven Routing Pattern
Decisões de roteamento externalizadas em catálogos (KVM, DynamoDB, Redis), não hardcoded.

## 5. Action Normalization Pattern
Ações de negócio canônicas (C, R, U, D, S, A, N...) mapeadas a partir de 241 variantes heterogêneas.

## 6. Immutable Integration Identity Pattern (iFlow DNA)
Identidades permanentes e não-reutilizáveis para flows de integração, garantindo traceability.

## 7. Architectural Decision Record (ADR) Pattern
Documentação explícita de decisões arquiteturais, prevenindo "tribal knowledge".

---

## Interdependência

```text

DCRP (Gateway) ──► DDCR (Router) ──► (Orchestration)
│                  │                  │
└──────────────────┴──────────────────┘
Metadata-Driven Routing
---
```
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
