## JavaScript Reference Implementations (POC Scope)

This repository exposes a limited set of **JavaScript reference implementations**
intended strictly for **Proof of Concept (POC)** validation and architectural
understanding of the **GDCR / DCRP** model.

These scripts are **not production artifacts**. They exist to demonstrate
**how the architecture behaves**, not to represent its hardened,
production-grade execution.

All JavaScript files are located under:

src/javascript/js-codes/


---

### 1️⃣ DCRP v5.0 — Basic POC Implementation

**File:**  
src/javascript/js-codes/dcrp-js-v5.0.js


**Purpose:**  
A **fully functional but intentionally simple** implementation of the
Domain-Centric Routing Pattern (DCRP).

**Characteristics:**
- Metadata-driven routing via KVM
- Dynamic iFlow resolution
- Path and query string preservation
- Basic governance header propagation
- Fail-fast behavior on invalid configuration

**Scope & Usage:**
- Designed for **basic POC scenarios**
- Can be implemented in **~30 minutes**
- Ideal for understanding the **core routing concept**
- Not optimized for high throughput or extreme edge cases

This version proves **conceptual correctness**, not runtime excellence.

---

### 3️⃣ DCRP Security Shield — Experimental (Do NOT Use)

**File:**  
src/javascript/js-codes/dcrp-security-shield.js


**Purpose:**  
An **experimental security script** created during early tests involving
a **single catch-all DCRP proxy** routing hundreds of business processes.

**Important Context:**
This script was built **only** to protect an unsafe architectural experiment
involving wildcard routes (e.g. `/sales/*`).

It exists solely as a **historical artifact** and learning milestone.

**Characteristics:**
- Path traversal detection
- SQL injection and XSS pattern blocking
- Domain whitelist enforcement
- Bot and scanner detection
- Header validation and fail-fast blocking

**⚠️ Important Clarification**

This script exists **only for an extreme experimental scenario**.

It was created intentionally to **stress-test the absolute limits of a
standard API-Proxy model**, using a single catch-all route and aggressive
defensive filtering, purely for exploratory purposes.

This experiment was conducted to understand:
- where governance breaks down,
- how security complexity escalates,
- and why wildcard-based routing does not scale safely.

It is **not intended** to be used as a real security solution and is
**explicitly discouraged** for production environments.

The findings from this experiment directly influenced the decision to abandon
wildcard routing approaches and adopt a **strict, metadata-driven,
domain-centric routing model** instead.

---

## Architectural Clarification

The real security model of **GDCR/DCRP** is **not based on defensive filtering**.

It is based on:

- deterministic semantic routing,
- explicit metadata contracts,
- strict domain and business-process boundaries,
- and **fail-fast governance by design**.

These JavaScript files are published to:
- document architectural evolution,
- support academic validation,
- and enable controlled POC experimentation.

They do **not** represent the full production implementation.

---

### Security Model Clarification

From a routing and governance perspective, **basic security concerns do not need
to be addressed at this layer**.

Traditional mechanisms such as **basic authentication, OAuth2, or token-based
models** operate at a different concern level and can coexist independently.

At the **GDCR/DCRP routing layer**, the security logic is intentionally simple
and deterministic:

- If the incoming request **does not match the expected semantic string**
  defined by metadata and JavaScript routing logic,
- the request **fails immediately** (*fail-fast*),
- an **HTTP 500** is returned,
- and the **backend URL is never generated**.

As a result:
- no unintended backend exposure occurs,
- no fallback routing is possible,
- and invalid or malformed requests **cannot propagate further**.

This guarantees that **only semantically valid, metadata-aligned requests**
are ever routed beyond the gateway.

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
