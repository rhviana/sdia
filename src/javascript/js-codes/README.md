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

### 2️⃣ DCRP v15.1 — Maverick Reference Engine (Robust POC)

**File:**  
src/javascript/js-codes/dcrp-js-maverick-v15.1.js


**Purpose:**  
A significantly more **robust reference implementation**, demonstrating
how the DCRP model behaves under **realistic load and complexity**.

**Characteristics:**
- Pre-initialized global action map (semantic normalization)
- Metadata-driven deterministic routing
- Optimized string handling (no regex in hot path)
- Cache with TTL and hash-based invalidation
- Built-in observability (latency, cache hit, versioning headers)
- Strict fail-fast semantics

**Scope & Usage:**
- Still a **POC / reference implementation**
- Handles **500+ concurrent calls** across multiple HTTP facades
- Stable as long as consumers respect the **metadata-driven contract**
- Suitable for architectural benchmarking and validation

This version demonstrates **engineering maturity**, but still does not expose
the full production-grade logic.

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

The **real security model** of GDCR/DCRP is **not defensive filtering**.

It is based on:
- deterministic semantic routing,
- explicit metadata contracts,
- strict domain and process boundaries,
- and fail-fast governance **by design**.

These JavaScript files are published to:
- document architectural evolution,
- support academic validation,
- and enable controlled POC experimentation.

They do **not** represent the full production implementation.
