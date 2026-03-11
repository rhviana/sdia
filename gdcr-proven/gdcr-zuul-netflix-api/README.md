# GDCR — Gateway Domain-Centric Routing
## DDCR — Domain-Driven Centric Router (Phantom v12)

> **"The domain never lies."**

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC%20BY%204.0-blue.svg)](https://creativecommons.org/licenses/by/4.0/)
[![DOI](https://img.shields.io/badge/DOI-10.5281%2Fzenodo.18582492-blue)](https://doi.org/10.5281/zenodo.18582492)
[![Prior Art](https://img.shields.io/badge/Prior%20Art-IP.com%20IPCOM000277654D-green)](https://ip.com)
[![USPTO](https://img.shields.io/badge/USPTO-99680660%20%7C%2099691792-orange)](https://uspto.gov)

---

## Author

**Ricardo Luz Holanda Viana**
Enterprise Integration Architect | SAP Press Author | Independent Researcher
Warsaw, Poland — March 2026
ORCID: [0009-0009-9549-5862](https://orcid.org/0009-0009-9549-5862)
LinkedIn: [linkedin.com/in/ricardo-viana-br1984](https://linkedin.com/in/ricardo-viana-br1984)
Medium: [medium.com/@rhviana](https://medium.com/@rhviana)

---

## What is this?

SDIA (Semantic Domain Integration Architecture) is a vendor-agnostic enterprise integration architecture in which **business domain semantics govern every layer of the integration stack simultaneously** — gateway routing, runtime resolution, and orchestration.

It is not a framework. Not a product. Not a vendor pattern.

It is an **architectural invariant** — a governing law that emerges from the nature of enterprise integration itself. Universal like 2 + 2 = 4. Valid in any datacenter, any cloud, any technological era yet to come.

Built alone. No company. No investor. No team. No budget. No peer review.
**32 days. 1 laptop. 1 obsession: eliminate SPRAWL forever.**

---

## The 4 Core Components

| Component | Role | Layer |
|-----------|------|-------|
| **SDIA** | Semantic Domain Integration Architecture — governing umbrella | Architecture |
| **GDCR** | Gateway Domain-Centric Router — 1 proxy per domain, not per system | Gateway |
| **DDCR** | Domain-Driven Centric Router — 7-stage deterministic engine | Runtime |
| **ODCP** | Orchestration Domain-Centric Pattern — Package/iFlow/Credential DNA | Orchestration |

---

## The Problem: SPRAWL

Every enterprise integration landscape suffers from the same disease:

```
Before SDIA:
  41 API proxies    (1 per backend)
  39 packages       (1 per vendor)
  39 credentials    (1 per system)
  Vendor onboarding: hours to days
  Deployment time:  273 minutes
```

This is accepted as normal. SAP, IBM, MuleSoft, Microsoft sell tools to **manage** SPRAWL.
Nobody questioned the root cause. Until now.

---

## The Solution: Domain as the Invariant

```
After SDIA:
  4 API proxies     (1 per domain)    ↓ 90%
  4 packages        (domain-named)    ↓ 90%
  12 credentials    (domain-scoped)   ↓ 69%
  Vendor onboarding: 30 seconds       ↓ 99%
  Deployment time:  14.5 minutes      ↓ 95%
```

One semantic address. Forever.

```
POST /sales/orders/create/salesforce
  → GDCR (semantic facade)
  → DDCR (7-stage resolution, <4ms)
  → SAP S/4HANA

# Vendor changes? 1 metadata entry.
# Consumer URL? Never changes.
# ∀ B₁→B₂: consumer_url(request) = constant
```

---

## DDCR — The 7-Stage Engine

The DDCR engine (reference implementation: **Phantom v12**) executes a deterministic 7-stage pipeline:

| Stage | Name | Function |
|-------|------|----------|
| 1 | Domain Inference | Parse semantic URL — extract entity, action, vendor |
| 2 | Policy Execution | AuthZ, Zero Trust boundary enforcement |
| 3 | Route Guard | **Fast Fail** — invalid intent rejected at ~0.1ms, before backend |
| 4 | Normalize | 241 action variants → 15 canonical codes (O(1) hash lookup) |
| 5 | Build KVM Key | `[prefix][entity][actionCode][vendor][flowId]:[adapter]` |
| 6 | Resolve | KVM lookup — f(key)→value, <4ms, any metadata substrate |
| 7 | Dispatch | Backend execution — consumer URL immutable |

### Action Normalization — 241 → 15

```javascript
// Any of these → "c" (CREATE)
"create", "created", "post", "insert", "add", "new",
"submit", "register", "provision", "onboard", "publish",
"generate", "build", "open", "setup", "initialize", "draft"...

// Any of these → "r" (READ)
"read", "get", "fetch", "retrieve", "view", "list",
"show", "search", "find", "query", "lookup", "check"...

// 15 canonical codes: c, r, u, d, s, a, n, t, e, b, v, w, x, z, f
```

### The Mathematical Invariant

```
f("/<domain>/<entity>/<action>/<target>") → "<endpoint>"
```

Any system that implements this function — regardless of name, vendor, language, or technology — is a derivative application of the DDCR invariant.

---

## Empirical Validation

Validated independently across **8 platforms**, **5 languages**, **~2,067,873 requests**.

| Platform | Language | Requests | Failures |
|----------|----------|----------|----------|
| SAP BTP APIM | JavaScript | ~500,000+ | 0 |
| Kong Gateway | Lua | ~1,133,602 | 0 |
| Kong on Kubernetes | Lua | included above | 0 |
| Azure API Management | C# | ~200,008 | 0 |
| AWS API Gateway | Python | ~138,600 | 0 |
| Netflix Zuul | Java | ~100,035 | 0 |
| Industrial IoT (MQTT) | Python | 42 sensors | 0 |
| Istio / Service Mesh | JavaScript | validated | 0 |

**100% routing accuracy. Zero failures. Sub-4ms latency. 99.99% uptime.**

### Netflix Zuul — Newman Validation

```
iterations:    2,565
requests:      100,035      failed: 0
test-scripts:  100,035      failed: 0
assertions:    600,210      failed: 0
duration:      9h 35m 32.8s
avg response:  138ms [min: 109ms, max: 2s]
```
<img width="756" height="758" alt="image" src="https://github.com/user-attachments/assets/949fbc1f-8496-461d-8565-4f245d9d7404" />
<img width="1108" height="1025" alt="image" src="https://github.com/user-attachments/assets/30b1fbbf-c7a4-4df7-92f6-1e635eb2eab2" />

---

---

## License

**Creative Commons Attribution 4.0 International (CC BY 4.0)**

Free for educational, research, commercial, and any other use **with attribution**.

Required attribution:
> *"This work implements the SDIA/DDCR semantic routing invariant as originally defined by Ricardo Luz Holanda Viana (DOI: 10.5281/zenodo.18582492 | IPCOM000277654D | USPTO: 99680660)."*

The architecture is open. The authorship is permanent and non-transferable.

---

## The Invariant

> *"Business domain semantics are the permanent governing layer across all integration patterns, protocols, platforms, and implementations. Technology is transient. The domain never lies."*

> *"Technology changes by the quarter. Business processes last for decades. The domain never lies."*

**— Ricardo Luz Holanda Viana · Warsaw, Poland · March 2026 🇧🇷**
