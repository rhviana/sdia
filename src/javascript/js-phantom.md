# DDCR Phantom v12 — High-Performance JavaScript Routing Engine (PoC)

This folder contains the high-performance JavaScript proof-of-concept implementation of the **Domain-Driven Centric Router (DDCR) — Phantom v12** for SAP Integration Suite – API Management (APIM).

Phantom v12 extends the Maverick engine line by pushing performance boundaries at the gateway layer while preserving the semantic model described in the GDCR v6.0 white paper.

> Scope: Phantom v12 is an internal performance PoC.  
> The official validation results are based on the Maverick v15.1 + Phantom v12 execution model in SAP BTP sandbox environments.

---

## 1. Purpose

Phantom v12 was built to answer a single question:

> How far can routing overhead be reduced in a JavaScript policy while keeping the semantic model stable?

It keeps the same:

- Domain-centric routing semantics
- Canonical action normalization
- Metadata-driven resolution (KVM model)
- Deterministic URL construction logic

But focuses on:

- Eliminating regex in the hot path
- Minimizing string operations
- Avoiding unnecessary allocations
- Keeping routing latency in low single-digit milliseconds (sandbox)

Phantom v12 is not a separate product.  
It is a performance-focused branch of the Maverick engine line.

---

## 2. Routing Flow Overview

Phantom v12 executes a deterministic routing sequence.

### 2.1 Context Extraction

Parses semantic URL:


/domain/entity/action/vendor


Example:


/sales/orders/create/salesforce


---

### 2.2 Action Normalization

Maps heterogeneous verbs (create, post, submit, provision, approve, sync, etc.)  
into canonical single-character codes.

| Code | Meaning |
|------|---------|
| c | Create |
| r | Read |
| u | Update |
| d | Delete |
| s | Sync |
| n | Notify |
| t | Transfer |
| a | Approve |
| q | Query |

Routing keys are built from canonical codes — never from raw verbs.

---

### 2.3 Metadata Lookup (KVM)

Example KVM entry:


dcrporderscsalesforceid01:http


Structure:


dcrp<entity><actionCode><vendor>idNN:<adapter>


The metadata encodes:

- Entity
- Canonical action code
- Vendor
- Route identifier (idNN)
- Adapter / protocol

All routing decisions are metadata-driven.

No backend URLs are hardcoded.

---

### 2.4 Target Construction

Final CPI endpoint is constructed deterministically:


<host>/<adapter>/dcrp/<process>/<entity>/<actionCode>/idNN


Optional segments:

- Resource ID
- Extra path
- Query string (preserved)

Nothing is inferred from arbitrary client input.

All segments are validated before assembly.

---

## 3. Implementation Characteristics

Phantom v12 optimizes execution without altering the semantic model.

### No regex in the hot path

Parsing is performed using:

- `indexOf`
- `substring`
- `charCodeAt`

### Minimal allocations

No arrays or objects are created during critical routing execution.

### Single-pass metadata resolution

Sequential scan with early exit once match is found.

### Deterministic validation

- Exact suffix match for action+vendor
- Explicit entity verification
- Fail-fast behavior on mismatch

---

## 4. Performance Context

Phantom v12 operates within the broader GDCR validation framework.

Observed sandbox characteristics (end-to-end path including gateway + CPI + network):

- 120K+ validated requests
- 4 domains
- 40+ vendors
- >99.99% success rate (sandbox)

These metrics represent full integration flow latency.

Phantom v12 focuses specifically on minimizing routing overhead inside the gateway policy layer.

No production SLA claims are made.

---

## 5. Engine Evolution Context

DDCR JavaScript evolution line:

- v5.x — early regex-based parsing
- v7.x — domain-centric normalization
- v8.x — reduced allocations
- v14.x — enterprise-ready hardened model
- v15.1 (Maverick) — documented reference engine
- Phantom v12 — performance-focused PoC branch

Maverick v15.1 remains the primary documented engine.

Phantom v12 explores performance boundaries of the same semantic model.

---

## 6. Usage Notes

Target environment:

- SAP BTP Integration Suite – API Management
- JavaScript policy
- KVM metadata
- CPI backend endpoints

Before production usage:

- Validate behavior in your own environment
- Measure routing overhead
- Align with governance and security policies

---

## 7. References

- GDCR v6.0 White Paper (Zenodo DOI)
- Engine evolution documentation under `src/javascript/`

---

> Stable outside. Infinite variability inside.  
> Business intent enters. Metadata decides.

  -----------------------------------

## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** [10.5281/zenodo.18582492](https://zenodo.org/records/18836272)  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
