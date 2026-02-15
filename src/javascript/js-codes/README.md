## Version 5.0 — Proof of Concept (Baseline)

**Status:** Functional POC  
**Purpose:** Validate the Domain-Centric Routing Pattern (DCRP) concept  
**Scope:** Basic functionality, clarity over performance

### Characteristics
- Metadata-driven routing using KVM values
- Dynamic iFlow resolution based on path suffix
- Flexible delimiter detection in KVM entries
- Path parameter preservation
- Query string forwarding
- Basic governance header propagation
- Fail-fast behavior on missing or invalid metadata

### Technical Profile
- String-based parsing (split / trim / sort)
- Route matching via prefix comparison
- Runtime interpretation of KVM values
- Moderate object allocation
- Suitable for demonstrations and architectural validation

### Intended Usage
- Proof of Concept (POC)
- Architectural understanding
- Initial validation of GDCR/DCRP principles

---

## Version 15.1 — Reference Implementation (Optimized Engine)

**Status:** Reference Implementation  
**Purpose:** Demonstrate production-grade engineering principles  
**Scope:** Performance, determinism, and observability

### Characteristics
- Pre-initialized global action map (241 normalized verbs)
- Metadata-driven routing with deterministic resolution
- Binary search (O(log n)) over sorted KVM entries
- Case-insensitive comparison using charCode operations
- Cache with TTL and hash-based invalidation
- Dynamic endpoint generation across vendors
- Inline variable extraction and header enrichment
- Built-in observability (latency, cache-hit, version headers)
- Strict fail-fast semantics

### Technical Profile
- Zero regex usage
- Minimal object allocation
- Optimized string handling
- Reduced GC pressure
- Stable P95 and P99 latency under load

### Performance
- Average routing overhead: ~5–8 ms
- Significant improvement over v5.0
- Suitable as an academic and technical reference

### Intended Usage
- Reference implementation
- Academic publication support
- Architectural benchmarking
- Non-production baseline for GDCR

---

## Notes on Evolution

Version 5.0 establishes **conceptual correctness**.  
Version 15.1 establishes **engineering maturity**.

Later versions (e.g. v15.2+) introduce additional hardening,
runtime optimizations, and edge-case handling not published here.
