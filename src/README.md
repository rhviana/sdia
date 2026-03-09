# src — Core Runtime Components

> *"The domain never lies."*
> Ricardo Luz Holanda Viana | March 2026

This folder contains the **core runtime components** of the SDIA architecture.
Everything inside `src` is responsible for **executing the metadata-driven routing logic**, enabling:

- Domain-centric routing — zero hardcoded endpoints
- Deterministic fast-fail — key exists or it does not
- Protocol-agnostic execution — REST, SOAP, MQTT, LLM
- Gateway-agnostic deployment — Kong, SAP APIM, Netflix Zuul, Apigee

This is the **heart of the architecture**. The DDCR Engine lives here.

---

## Why it never fails

DDCR is not AI. It is not probabilistic. It is not heuristic.

Given the same input, it always produces the same output. The key exists in the KVM or it does not. The protocol is `http` or `soap`. The path is built by a formula.

**2 + 2 = 4. Eternal.**

---

## Structure

```
src/
├── handlers/                   ← Lua — Kong K8s (DDCR Engine)
│   ├── handler-v1.0-hardcoded.lua
│   ├── handler-v1.1-mock.lua
│   ├── handler-v2.0-redis.lua
│   └── handler-v2.2-production.lua   ← 100,002 requests | 0 failures ✅
│
├── javascript/                 ← JavaScript — SAP APIM / Apigee (Phantom v12)
│   └── phantom-v12.js              ← 1,820,000 requests | 0 failures ✅
│
├── java-zuul/                  ← Java — Netflix Zuul (Phantom v12 port)
│   ├── DdcrPhantomFilter.java
│   ├── DdcrZuulApplication.java
│   └── pom.xml
│
└── README.md
```

---

## handlers/ — Lua (Kong K8s)

The DDCR Engine implemented as a **Kong plugin in Lua**.
Runs inside Kong on Kubernetes. Uses Redis as the KVM store.

| File | Version | Description |
|------|---------|-------------|
| `handler-v1.0-hardcoded.lua` | v1.0.0 | KVM hardcoded in Lua. First working proof of concept. |
| `handler-v1.1-mock.lua` | v1.0.1 | Mock mode. Returns 200 JSON with generated URL. No backend call. |
| `handler-v2.0-redis.lua` | v2.0.0 | Redis integration. Dynamic KVM lookup via `resty.redis`. |
| `handler-v2.2-production.lua` | v2.2.0 | **Production. 100,002 requests. Zero failures.** Full Action Map + SOAP auto-detection. |

```
POST /sales/orders/create/salesforce
        ↓
  Kong + handler-v2.2
        ↓
  Redis GET /sales/orders/create/salesforce
        ↓
  gdcrorderscSalesforceid01:http
        ↓
  /http/dcrp/orders/c/id01
        ↓
  SAP CPI iFlow
```

---

## javascript/ — Phantom v12 (SAP APIM / Apigee)

The DDCR Engine implemented as a **JavaScript policy** for SAP BTP APIM and Apigee.
This is the production engine. Zero regex. Zero split. O(1) lookup after warm cache.

```
Cold start (first request):   ~3-4ms
Warm requests (cache hit):    ~1.5-2.5ms
KVM entries supported:        up to ~200 without degradation
Regex operations:             ZERO
Array split operations:       ZERO
Hardcoded patterns:           ZERO
```

Validated at **1,820,000 requests** on SAP BTP APIM with zero failures.

241 action variants → 15 canonical single-character codes:

| Code | Canonical | Example variants |
|------|-----------|-----------------|
| `c` | CREATE | create, post, insert, add, publish, generate... |
| `r` | READ | read, get, fetch, retrieve, list, query, find... |
| `u` | UPDATE | update, put, patch, modify, edit, amend... |
| `d` | DELETE | delete, remove, cancel, terminate, purge... |
| `s` | SYNC | sync, synchronize, replicate, mirror, align... |
| `a` | APPROVE | approve, authorize, validate, confirm, signoff... |
| `n` | NOTIFY | notify, alert, inform, broadcast, emit, trigger... |
| `t` | TRANSFER | transfer, send, move, migrate, forward, relay... |
| `e` | ENABLE | enable, activate, start, resume... |
| `b` | DISABLE | disable, deactivate, stop, pause... |
| `v` | ARCHIVE | archive, store, backup, retain... |
| `w` | RESTORE | restore, recover, rollback, revert... |
| `x` | AUDIT | audit, log, trace, track... |
| `z` | EXECUTE | execute, run, process, compute... |
| `f` | FLOW | flow, route, dispatch, pipeline... |

---

## java-zuul/ — Phantom v12 Java Port (Netflix Zuul)

The DDCR Engine implemented as a **Netflix Zuul Filter in Java** for Spring Boot.
Direct port of Phantom v12. Same deterministic logic, same KVM contract, same zero-failure guarantee.

```
POST /sales/orders/create/salesforce
        ↓
  Netflix Zuul + DdcrPhantomFilter
        ↓
  Redis lookup (Jedis) /sales/orders/create/salesforce
        ↓
  gdcrorderscSalesforceid01:http
        ↓
  /http/dcrp/orders/c/id01
        ↓
  SAP CPI iFlow
```

Run locally:
```bash
mvn clean package -DskipTests
docker build -t ddcr-zuul:v12 .
docker run -p 8080:8080 ddcr-zuul:v12
```

---

## How It Works

```
SENDER (any protocol)
  MQTT sensor:   factory/line-a/conveyor/temperature
  REST client:   POST /sales/orders/create/salesforce
  SOAP system:   POST /sales/orders/create/microsoft
  LLM agent:     POST /sales/orders/create/salesforce
        ↓
DDCR ENGINE (7 stages)
  Stage 1 — Domain Inference:    parse /{domain}/{entity}/{action}/{target}
  Stage 2 — Validate:            4 segments required
  Stage 3 — KVM Lookup:          Redis GET → interface_id:protocol
  Stage 4 — Normalize Action:    create → c | sync → s | notify → n
  Stage 5 — Parse Redis Value:   interface_id + protocol
  Stage 6 — Extract ID Suffix:   id01, id02...
  Stage 7 — Build + Forward:     /http/dcrp/{entity}/{action}/{id}
                                  /cxf/dcrp/{entity}/{action}/{id}
        ↓
SAP CPI (or any backend)
  HTTP iFlow:  /http/dcrp/orders/c/id01
  SOAP iFlow:  /cxf/dcrp/orders/c/id01
```

The sender never knows the destination.
The destination never knows the sender.
The DDCR Engine is the only truth — and the truth lives in the KVM.

---

## Gateway Compatibility

| Gateway | Language | Engine | Status |
|---------|----------|--------|--------|
| SAP BTP APIM | JavaScript | Phantom v12 | ✅ 1.82M requests |
| Kong K8s | Lua | handler v2.2 | ✅ 100k requests |
| Netflix Zuul | Java | Phantom v12 port | 🔜 Validation in progress |
| Apigee | JavaScript | Phantom v12 | 🔜 Planned |

---

## KVM Contract

```
Key format:    /{domain}/{entity}/{action}/{target}
Value format:  {interface_id}:{protocol}

Example:
  Key:    /sales/orders/create/salesforce
  Value:  gdcrorderscSalesforceid01:http

  Key:    /sales/orders/create/microsoft
  Value:  gdcrorderscMicrosoftid05:soap
```

Protocol routing:
- `http` → Content-Type: `application/json` → `/http/dcrp/...`
- `soap` → Content-Type: `text/xml; charset=utf-8` → `/cxf/dcrp/...`

---

## Architecture Principles

- **Metadata-driven** — all routing decisions live in the KVM, not in code
- **Domain-centric** — the domain is the address, not the URL
- **Deterministic** — same input always produces same output
- **Fast-fail** — missing key = immediate 404, no fallback, no ambiguity
- **Protocol-agnostic** — REST, SOAP, MQTT, LLM — the engine does not care
- **Gateway-agnostic** — Lua, JavaScript, Java — the contract is always the same
- **Zero endpoint exposure** — no CPI URL ever reaches the sender

---

## Security Model

- No direct endpoint exposure to the sender
- No static routing rules in code
- No environment-specific logic
- All destinations resolved dynamically via KVM metadata
- Fail-fast if metadata is invalid or missing
- Basic Auth injected by engine — sender never holds CPI credentials

---

## Validation Results

| Test | Gateway | Requests | Failed | Avg Latency |
|------|---------|----------|--------|-------------|
| REST Load | SAP APIM | 1,820,000 | 0 | ~2ms |
| REST Load | Kong K8s | 100,002 | 0 | 144ms |
| IoT Load | Kong K8s | 100,002 | 0 | 144ms |
| **TOTAL** | | **2,020,004** | **0** | |

---

## Attribution & Intellectual Property

DDCR (Domain Driven Centric Router) and GDCR (Gateway Domain-Centric Routing) are original architectural frameworks authored by **Ricardo Luz Holanda Viana**.

| Pillar | DOI |
|--------|-----|
| GDCR | [10.5281/zenodo.18836272](https://doi.org/10.5281/zenodo.18836272) |
| DDCR | [10.5281/zenodo.18864833](https://doi.org/10.5281/zenodo.18864833) |
| ODCP | [10.5281/zenodo.18876594](https://doi.org/10.5281/zenodo.18876594) |

**USPTO Trademark Application:** 99680660 (GDCR™, DDCR™, ODCP™)
**ORCID:** 0009-0009-9549-5862
**License:** CC BY 4.0
**First Public Disclosure:** February 7, 2026
