# AQ01 – Core Assumptions Behind GDCR

This document clarifies the foundational architectural assumptions behind **Gateway Domain-Centric Routing (GDCR)** and addresses common misconceptions about API gateway capabilities and integration design patterns.

---

## Q1 – Is SAP APIM (or any API Gateway) limited to 1:1 routing?

**No.** Modern API gateways are technically capable of sophisticated $1:N$ routing. 

The structural problem GDCR addresses is not tool limitation—it is **implementation convention**. Many enterprise landscapes adopt a **system-centric mapping pattern**, where each backend system results in a new proxy artifact. This is a governance choice, not a platform constraint.

### System-Centric Pattern vs. Domain-Centric Pattern

```text
[ TRADITIONAL PATTERN ]                  [ GDCR PATTERN ]
(System-Centric Mapping)                 (Domain-Centric Routing)

  Proxy A -> Backend X                   Domain Facade --+
  Proxy B -> Backend Y                                   |
  Proxy C -> Backend Z                    [ Metadata ] --+--> Backend X
                                                         |--> Backend Y
                                                         |--> Backend Z

PATTERN: 1:1 Artifact Mapping         PATTERN: 1:N Semantic Routing
GOVERNANCE: By Proxy ID               GOVERNANCE: By Business Domain
```

GDCR formalizes a domain-centric routing model where the façade remains stable and execution targets are resolved dynamically via metadata.

## Q2 – What problems is GDCR explicitly trying to solve?

GDCR addresses recurring structural scaling problems in enterprise integration landscapes, commonly referred to as the “Three Sprawls”:

1 - Proxy Sprawl

2 - Package Sprawl

3 - Technical Credential Sprawl

These are governance and structural scalability problems, not performance issues.

Sprawl Impact Matrix

#### The "System-Centric" Trap vs. GDCR Reality (ASCII):

```text
[ TRADITIONAL PATTERN ]                  [ GDCR PATTERN ]
(Product misuse/Sprawl)                (Optimized Architecture)

  Proxy A -> Backend X                   Domain Facade --+
  Proxy B -> Backend Y                                   |
  Proxy C -> Backend Z                    [ KVM / JS ] --+--> Backend X
                                                         |--> Backend Y
                                                         |--> Backend Z

PATTERN: 1:1 (Manual)                  PATTERN: 1:N (Dynamic)
GOVERNANCE: By Artifact                GOVERNANCE: By Business Domain
```
#### Q2 – What problems is GDCR explicitly trying to solve?

GDCR targets the "Three Sprawls" that paralyze large-scale enterprise integration landscapes:

Proxy Sprawl: Hundreds of technical proxies that are impossible to catalog.

Package/iFlow Sprawl: Integration logic scattered across project-based silos.

Credential Sprawl: A security nightmare of technical users and secrets duplicated everywhere.

### Sprawl Impact Matrix

| PROBLEM | ROOT CAUSE | GDCR APPROACH |
| :--- | :--- | :--- |
| **Governance Blindness** | System-based artifact naming | Domain-based façades |
| **Maintenance Tax** | Change requires redeployment | Metadata-only updates |
| **Security Risk** | Credential duplication | Consolidated auth model |
| **Operational Noise** | Technical identifiers in logs | Semantic observability |

---

#### Q3 – What does GDCR not claim?

GDCR is a framework for Usage Patterns, not a critique of software features.

We do NOT say gateways lack routing features. We say they are often implemented poorly.

We do NOT say OpenAPI is wrong. We say it should document the Business Intent (Façade), not the technical debt (Backend).

We do NOT say we invented domain-centricity. We say we codified it into a repeatable engine (DCRP + PDCP) for the SAP ecosystem.

#### Q4 – Is GDCR SAP‑specific?

No. While the reference implementation uses SAP BTP, the logic is Vendor-Agnostic.

Cross-Platform Implementation Map (ASCII):
```text
LAYER          | SAP BTP (DCRP) | APIGEE         | KONG / APISIX  | AZURE APIM
---------------|----------------|----------------|----------------|-------------
Logic Engine   | JavaScript     | JavaScript     | Lua Plugins    | C# Policies
Metadata Store | KVM            | KVM            | Redis / DB     | Storage/Table
Fast-Fail      | Policy / JS    | Flow Callouts  | Auth Plugins   | Custom Policy
```

#### Q5 – Is GDCR only about routing?

No. GDCR is a full-stack architectural alignment. Routing is just the entry point.

```text
The GDCR Multi-Layer Alignment (ASCII):

[ LAYER 1: GATEWAY ] --> DCRP (Domain-Centric Routing Pattern)
                         Focus: Semantic URLs & Metadata Routing
           |
           v
[ LAYER 2: ORCHESTRATOR ] --> PDCP (Package Domain-Centric Pattern)
                               Focus: Logic isolation by Domain in CPI
           |
           v
[ LAYER 3: SECURITY ] --> FAST-FAIL
                          Focus: Sender/Domain access matrix (mTLS/OAuth)
           |
           v
[ LAYER 4: OPS/LOGS ] --> SEMANTIC OBSERVABILITY
                          Focus: Monitoring "Sales Orders", not "iFlow_v2_final"
```

Routing is only the visible tip; the value is the **consistent semantic model across all layers**.

--------------------------
# ⚖️ Attribution & Framework Identity

**Gateway Domain-Centric Routing (GDCR)**

> [!IMPORTANT]
> **Original architectural framework authored by Ricardo Luz Holanda Viana · 2026**

* **First Public Disclosure:** February 7, 2026
* **DOI:** [10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx)
* **ORCID:** [0009-0009-9549-5862](https://orcid.org/0009-0009-9549-5862)
* **License:** [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/)

---
This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------
