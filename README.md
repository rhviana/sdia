# SDIA — Semantic Domain Integration Architecture

> **"Technology changes by the quarter. Business processes last for decades. The domain never lies."**
> — Ricardo Luz Holanda Viana

---

## 📜 NOTICE — IP Rights, DOIs & Licenses

Please review before proceeding.

| Document | Record | IP.com Prior Art |
|----------|--------|-----------------|
| SDIA v1.0 | [zenodo.org/records/18877636](https://zenodo.org/records/18877636) | IPCOM000277630D |
| GDCR™ v6.0 | [doi.org/10.5281/zenodo.18582492](https://doi.org/10.5281/zenodo.18582492) | IPCOM000277632D |
| DDCR™ v1.0 | [zenodo.org/records/18864833](https://zenodo.org/records/18864833) | IPCOM000277633D |
| ODCP™ v1.0 | [zenodo.org/records/18876594](https://zenodo.org/records/18876594) | IPCOM000277631D |

**License:** CC BY 4.0 — Free for educational, research, and non-commercial use with attribution.
**Trademarks:** SDIA™ · GDCR™ · DDCR™ · ODCP™ — USPTO applications filed and pending.
**ORCID:** [0009-0009-9549-5862](https://orcid.org/0009-0009-9549-5862)
**First Public Disclosure:** February 7, 2026

---

## What is SDIA?

**Semantic Domain Integration Architecture (SDIA)** is a vendor-agnostic enterprise integration architecture in which business domain semantics govern every layer of the integration stack simultaneously — gateway routing, runtime resolution, and orchestration topology.

SDIA is not a product. It is not a pattern. It is a new class of integration architecture defined by a single invariant:

> *Business domain semantics are the permanent governing layer across all integration patterns, protocols, platforms, and implementations. Technology is transient. The domain never lies.*

**One semantic address. Any platform. Any language. Any backend.**

```
POST /sales/orders/create/salesforce
```

That is all the consumer ever sees. Domain governs everything else.

---

## Architecture

```
                    SDIA
     Semantic Domain Integration Architecture
                      |
        +-------------+-------------+
        |             |             |
      GDCR           DDCR          ODCP
   Gateway        Resolution    Orchestration
    Layer           Engine         Layer
      |               |             |
  1 proxy          7-stage       Domain
  per domain      deterministic  semantic
  immutable       router <4ms    topology
```

### The Three Pillars

| Pillar | Component | Role |
|--------|-----------|------|
| Gateway | GDCR™ | Semantic facade — 1 proxy per domain |
| Resolution | DDCR™ | 7-stage deterministic routing engine |
| Orchestration | ODCP™ | Domain-centric artifact topology |

---

## GDCR — Gateway Domain-Centric Routing

**One proxy per business domain. Immutable. Vendor-agnostic.**

The gateway never changes. The metadata does.

```
POST /sales/orders/create/salesforce   → GDCR → DDCR → SAP S/4HANA
POST /finance/payments/transfer/stripe → GDCR → DDCR → Stripe API
POST /hr/employees/sync/successfactors → GDCR → DDCR → SuccessFactors
```

### Governance Impact

| Metric | Before | After | Reduction |
|--------|--------|-------|-----------|
| API Proxies | 41 | 4 | 90% |
| Orchestration Packages | 39 | 4 | 90% |
| Technical Credentials | 39 | 12 | 69% |
| Deployment Time | 273 min | 14.5 min | 95% |
| Vendor Onboarding | Hours | 30 seconds | 99% |

---

## DDCR — Domain-Driven Centric Router

**Deterministic. 7 stages. Any language. Any platform. Forever.**

```
Stage 1 — Domain Inference     Parse semantic URL
Stage 2 — Policy Execution     AuthZ · Zero Trust
Stage 3 — Route Guard          Fast Fail — ~0.1ms rejection
Stage 4 — Normalize            Canonical action code
Stage 5 — Build KVM Key        Metadata key construction
Stage 6 — Resolve              KVM lookup — <4ms
Stage 7 — Dispatch             Backend execution
```

**Fast Fail Contract:** Invalid intent never reaches the engine. Zero backend impact. Zero blast radius.

---

## ODCP — Orchestration Domain-Centric Pattern

**Domain-semantic naming topology for all integration artifacts.**

```
Package DNA:  nx.sales.o2c.integrations
iFlow DNA:    id01.o2c.salesforce.order.s4hana.c.in.sync
```

Applicable to any platform — SAP CPI, MuleSoft, Boomi, Azure Logic Apps, or any middleware.

---

## Validation Summary

| Metric | Result |
|--------|--------|
| Total Requests | 1,499,869 |
| Routing Success Rate | 100% |
| Routing Failures | 0 |
| Platforms | SAP BTP · Kong · Azure APIM · AWS API Gateway · Kubernetes |
| Languages | JavaScript · Lua · C# · Python |
| DDCR Phantom v12 p50/p85/p99 | 145ms / 184ms / 338ms |
| KVM Lookup | <4ms |
| Fast Fail rejection | ~0.1ms |

---

## Platform Validation Matrix

| Platform | Implementation | Requests | Success | Status |
|----------|---------------|----------|---------|--------|
| Kong (Docker) | Redis KVM + Lua | 1,000,000 | 100% | ✅ PROVEN |
| Kong (Docker) | Lua KVM | 33,600 | 100% | ✅ PROVEN |
| SAP APIM + CPI | JS Policy + KVM | 106,190 | 99.92% | ✅ PROVEN |
| SAP APIM + CPI (Phantom v12) | DDCR JS v15.1 | 121,471 | 99.9967% | ✅ PROVEN |
| AWS API Gateway | Lambda + DynamoDB | 38,600 | 100% | ✅ PROVEN |
| Azure APIM | C# Policy + Redis | 200,008 | 99.98% | ✅ PROVEN |
| Kubernetes v1.34 | Kong + Redis K8s | 44 endpoints | 100% | ✅ PROVEN |

---

## Semantic URL Pattern

```
/{domain}/{entity}/{action}/{target}
    |         |        |        |
    |         |        |        +-- Backend system
    |         |        +----------- Business action
    |         +-------------------- Business entity
    +------------------------------ Business domain
```

### Action Normalization — 241 verbs → 15 canonical codes

| Input verbs | Code | Meaning |
|-------------|------|---------|
| create, post, insert | c | Create |
| read, get, retrieve | r | Read |
| update, put, modify | u | Update |
| delete, remove | d | Delete |
| sync, synchronize | s | Synchronize |
| transfer, send | t | Transfer |
| notify, notification | n | Notify |
| approve, authorize | a | Approve |
| query, search | q | Query |

---

## Repository Structure

```
sdia/
├── README.md                    # This file — SDIA entry point
├── NOTICE.md                    # IP rights, DOIs, licenses
├── LICENSING.md                 # CC BY 4.0 full text
│
├── gdcr/                        # Gateway Domain-Centric Routing
│   ├── doc/                     # Architecture documentation
│   ├── gdcr-proven/             # Validation evidence per platform
│   ├── src/javascript/          # DDCR Phantom v12 engine (JS)
│   └── src/kvm/                 # KVM routing config templates
│
├── ddcr/                        # Domain-Driven Centric Router
│   ├── phantom-v12/             # Phantom v12 specification
│   └── implementations/        # JS · Lua · C# · Python
│
├── odcp/                        # Orchestration Domain-Centric Pattern
│   ├── package-dna/             # Package naming convention
│   ├── iflow-dna/               # iFlow naming convention
│   └── credential-dna/         # Credential governance model
│
├── sdia-k8s/                    # Kubernetes validation
│   ├── 01-redis.yaml
│   ├── 02-kong-gdcr.yaml
│   └── SDIA_K8s_44_Newman.json  # 44 endpoint Newman collection
│
└── prior-art/                   # Prior art documentation
    └── SDIA_Complete_PriorArt_v2.md
```

---

## Academic Citation

**APA**
```
Viana, R. L. H. (2026). Semantic Domain Integration Architecture (SDIA):
A Vendor-Agnostic Semantic Governance Framework for Enterprise Integration.
Zenodo. https://zenodo.org/records/18877636
```

**BibTeX**
```bibtex
@article{viana2026sdia,
  title   = {Semantic Domain Integration Architecture (SDIA):
             A Vendor-Agnostic Semantic Governance Framework for Enterprise Integration},
  author  = {Viana, Ricardo Luz Holanda},
  year    = {2026},
  doi     = {10.5281/zenodo.18877636},
  url     = {https://zenodo.org/records/18877636}
}
```

---

## No-Support Policy

This repository is published to ensure academic transparency and reproducibility under CC BY 4.0.

Successful adoption requires prior experience with API Management platforms, understanding of distributed systems, and familiarity with metadata-driven routing models.

GitHub issues are not used for implementation troubleshooting.

For academic collaboration, architectural discussion, or commercial engagement, contact the author directly.

---

## Contact

**Ricardo Luz Holanda Viana**
Enterprise Integration Architect | SAP Press Author | Independent Researcher

📧 rhviana@gmail.com
💼 [LinkedIn](https://linkedin.com/in/rhviana)
📝 [Medium](https://medium.com/@rhviana)

*For commercial inquiries only: rhviana@gmail.com*

---

## Attribution & Intellectual Property

SDIA™, GDCR™, DDCR™, and ODCP™ are original architectural frameworks authored by Ricardo Luz Holanda Viana.

- **First Public Disclosure:** February 7, 2026
- **ORCID:** 0009-0009-9549-5862
- **License:** CC BY 4.0
- **Prior Art:** IP.com records IPCOM000277630D · IPCOM000277632D · IPCOM000277633D · IPCOM000277631D
- **Trademarks:** USPTO applications filed and pending

*Built alone. Published with evidence. The domain never lies.*
