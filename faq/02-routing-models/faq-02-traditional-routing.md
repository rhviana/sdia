# FAQ 02 — Traditional Routing Model

This document analyzes the standard industry approach to API Management—**System-Oriented Routing**—and identifies its structural scaling challenges.

---

## Model: System-Oriented (Traditional) Routing

In this model, the architecture establishes a direct, rigid link between a specific gateway artifact and a specific backend system.

```text

  [ CLIENT ]
      |
      v
  [ API PROXY ]  <-- (System-Specific Mapping)
      |
      v
  [ BACKEND ]    <-- (Hardcoded Target)

```

## Core Characteristics

In the traditional model, the Gateway layer mirrors the backend infrastructure. Each integration follows a strict 1:1 mapping:

* **One Proxy per Backend:** A new integration typically results in a new proxy artifact.
* **Spec-Per-System:** OpenAPI specifications are imported and mapped directly to specific backend systems.
* **Tied Lifecycles:** The proxy lifecycle (versioning, deployment) is strictly bound to the backend system's release schedule.
* **Static Binding:** Target endpoints are hardcoded in the target configuration of the proxy.

---

## Typical Resulting Landscape

As the enterprise grows, the API Management (APIM) layer becomes a reflection of backend silos rather than business domains.

```text
APIM (Gateway Layer)
├── sap-orders-proxy
├── salesforce-orders-proxy
├── stripe-payments-proxy
├── shopify-orders-proxy
└── [ ... hundreds more ... ]
```

## Structural Scaling Effect (Linear Growth)
In traditional integration models, the administrative overhead and technical debt grow proportionally with the number of systems. This creates a linear trajectory where scaling equals increased complexity.

Each new backend introduces:
A new proxy artifact (New code and configuration files).

New policy configurations (Redundant Security, Quota, and Spike Arrest logic).

New credentials (Fragmented Auth headers, OAuth clients, and Certificates).

Separate lifecycle management (Individual CI/CD pipelines, testing, and deployment).

## The "Three Sprawls" & Impact
The traditional pattern leads to three critical operational bottlenecks:

###The "Three Sprawls" & Impact Matrix

| PROBLEM | IMPACT | GDCR CONTEXT |
| :--- | :--- | :--- |
| **Proxy Sprawl** | Too many artifacts to govern effectively. | **Solved** via Domain Facades |
| **Policy Duplication** | Security logic is repeated across hundreds of proxies. | **Solved** via Global Policy Sets |
| **Credential Sprawl** | Managing secrets becomes an operational bottleneck. | **Solved** via Consolidated Auth |

-----------------------------------

### ⚖️ Attribution & Framework Identity

> **GDCR Framework** · 2026 · ✍️ [Ricardo Luz Holanda Viana](https://orcid.org/0009-0009-9549-5862) · 🔗 [DOI: 10.5281/zenodo.xxxxx](https://doi.org/10.5281/zenodo.xxxxx) · ⚖️ [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/)

This framework is an original architectural work. For academic, technical, or professional citations, please use the metadata provided above. Reuse, adaptation, and distribution are permitted provided that proper attribution to the original author and DOI is maintained.

-----------------------------------
