## FAQ01 – Core Assumptions Behind GDCR
<div height="1px" style="background-color: #e1e4e8; border: none; height: 1px;"></div>

This FAQ clarifies the fundamental philosophy of GDCR, addressing common misconceptions about product limitations and the structural problems the pattern solves.

#### Q1 – Is SAP APIM (or any gateway) limited to 1:1 routing?
---

**No.** Modern gateways are extremely capable of 1:N routing. The issue is not the **tool**, but the **prevailing implementation pattern**.

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

The "Sprawl" Impact Matrix (ASCII):
```text
PROBLEM              | CAUSE                          | GDCR SOLUTION
---------------------|--------------------------------|-------------------------
Governance Blindness | Everything is a "Proxy ID"     | Semantic Domains
Maintenance Tax      | Change = Proxy Redeploy        | Metadata Update (KVM)
Security Risk        | Credential Duplication         | Consolidated Auth
High Latency         | Multiple IdP Round-trips       | Fast-Fail Validation
```
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
**Author:** Ricardo Luz Holanda Viana  
**Role:** Enterprise Integration Architect · SAP BTP Integration Suite  
**Creator of:** GDCR · DCRP · PDCP  

**Architectural scope:** Business‑semantic, domain‑centric routing architectures for API Gateways and Integration Orchestration (vendor‑agnostic), with SAP‑specific implementations via DCRP (SAP BTP API Management) and PDCP (SAP BTP Cloud Integration).  

**License:** Creative Commons Attribution 4.0 International (CC BY 4.0)  
**DOI:** [zenodo.18661136](https://doi.org/10.5281/zenodo.18582492)  
**DOI:** [figshare.31331683](https://doi.org/10.6084/m9.figshare.31331683)

This document is part of the **Gateway Domain‑Centric Routing (GDCR)** framework and represents original architectural work authored by Ricardo Luz Holanda Viana. Reuse, adaptation, and distribution are permitted only with proper attribution. Any derivative or equivalent architectural implementation must reference the original work and associated DOI.

-----------------------------------
