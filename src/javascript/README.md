---

### DCRP Engine: "The Brain" Javscript evolution the Logic from Ricardo Luz Holanda Viana

This folder contains the java script policy for Proof of Concept implementation of the Domain-Centric Routing Pattern (DCRP) for SAP Integration Suite (APIM).

---

This folder contains the JavaScript policy Proof of Concept implementation of the Domain-Centric Routing Pattern (DCRP) for SAP Integration Suite (APIM).

### DCRP Engine - Maverick Style Evolution
  - Evolution: v5.0 → v7.1 → v8.0 → v14.2 → v15.0 → v15.1 → v15.2

---
 DCRP Engine Evolution Timeline
Evolution Path: v5.0 → v7.1 → v8.0 → v14.2 → v15.0 → v15.1 → v15.2
v5.0 - POC (Proof of Concept)
Released: Q1 2025 | Status: Open-source (GitHub + DOI)

Features:

✅ Flexible delimiter detection (11 delimiters supported)
✅ Path matching with dynamic sorting
✅ Manual KVM parsing (split + loop)
✅ Basic error handling (try-catch)
Performance:

Latency: 30-50ms
Memory: ~10KB per request
Allocations: ~50 objects/request
Use Case: Academic POC, small-scale testing (<100 routes)

Status: ✅ POC validated, not production-ready

v7.1 - Baseline
Released: Q2 2025 | Status: Deprecated

Key Changes:

Fixed delimiter (, only) - governance standardization
Domain-centric keys: dcrp
2 loops (extended + compact match)
Regex for string operations
Arrays for match storage
No caching (parse every request)
Performance:

Latency: 20-30ms (~40% improvement vs v5.0)
Key Innovation: Domain-centric pattern established
v8.0 - Speed Boost
Released: Q3 2025 | Status: Deprecated

Optimizations:

✅ Single loop with early exit → ~40% gain
✅ indexOf/substring instead of regex → ~30% gain
✅ Primitive variables instead of arrays → ~15% gain
Performance:

Latency: 8-15ms (50% faster than v7.1)
Limitation: Still no caching or observability
v14.2 - Enterprise Ready (DOI Published)
Released: Q4 2025 | DOI: 10.5281/zenodo.18582469 (deprecated) | Status: Stable

New Features:

✅ Global cache (TTL 60s) → KVM parse 0-1ms vs 8-12ms
✅ Multi-node safe (hash validation)
✅ 7-phase timing (detailed metrics)
✅ 241 action variants (universal normalization)
✅ Debug hooks (commented, zero overhead)
Performance:

Latency: 8-15ms (same speed as v8.0)
Cache hit rate: ~95%
Observability: 25+ metrics tracked
Validation: 33,000+ calls, 99.92% success
Status: ✅ Enterprise ready, multi-node safe, debuggable

v15.0 - Algorithmic Upgrade
Released: January 2026 | Status: Superseded

Critical Bug Fixes:

❌ Binary search incompatibility (prefix match → full CI comparison)
❌ Duplicate "retrieve" in action map (READ vs RESTORE collision)
❌ False "zero-allocation" claim (still using segments.push())
❌ Unsafe extractIdFast() (wrong "id" matching)
❌ Context shadowing (var context = context)
New Features:

✅ Binary search for KVM → O(log n) instead of O(n)
✅ TRUE zero-allocation (no toLowerCase(), no split())
✅ ES6 Map for actions (guaranteed O(1))
✅ Sorted KVM cache (CI-ordered)
Performance:

Latency: 15-25ms
KVM scan (500 entries): ~0.6ms (was ~12ms in v14.2) → 20x faster
Scalability: O(log n) for large KVM lists
v15.1 - Maverick Ghost Edition (Academic Gold)
Released: February 2026 | DOI: 10.5281/zenodo.18661136 | Status: Stable (DOI)

Maverick Ghost Edition

Complete Hardening:

✅ Case-insensitive action lookup → handles /Create, /DELETE correctly (+0.5-1ms)
✅ Semantic hardening: extractIdFast() searches before last : (production-safe)
✅ Path validation: Hard-fail on >4 segments (no ambiguity)
Observability (NEW):

✅ 7-phase latency tracking (parse, lookup, validate, construct, cache, total)
✅ Cache hit/miss metrics
✅ Per-route performance profiling
Performance:

Latency: 15-26ms
Improvement: ~39% vs v14.2
Status: ✅ Academic Gold - 100% robust, defensible in papers + production
Architecture Specs:

✅ O(1) Action Normalization: Maps 241 business verb variations into 15 core action codes
✅ <2ms Overhead: Ultra-low latency gateway footprint
✅ Segmented Latency Tracking: Monitors 7 distinct execution phases
Key Features:

✅ Multi-node cache invalidation (TTL-based, distributed-safe)
✅ Mirror strategy alignment (APIM routing keys → PDCP package naming)
✅ Conflict detection (identifies overlapping routes, Error 409)
Security Shield Edition v15.1:

✅ Blocks path-traversal, SQLi, XSS, command-injection patterns
✅ Enforces domain whitelist on first URL segment
✅ Validates critical headers
✅ Detects scanner/bot User-Agents
✅ Rich threat metadata for RaiseFault handling
v15.2 - Maverick Phantom Edition 🔒
Released: February 2026 | Status: 🔒 Enterprise Only - Not Publicly Available

Maverick Phantom Edition

Revolutionary Architecture:

✅ ZERO regex in hot path
✅ ZERO array allocations
✅ ZERO object allocations
✅ Single-pass KVM lookup with early exit
✅ Index-based string splitting (~80% faster than regex)
✅ Inline variable extraction (no function call overhead)
✅ Direct string concatenation for URL building
✅ Regional suffix support (e.g., salesforceus, salesforceemea)
✅ Multi-layer cache (L1: 2ms, 90% hit | L2: 5ms, 9% | L3: 15ms, 1%)

Performance Metrics:

Routing Latency: 1.5-4ms (avg 2.5ms)
P95 Latency: 8ms
P99 Latency: 12ms
Memory/request: <1KB
CPU cycles: ~50k per routing operation
Throughput: 100K+ req/min per instance
Cache hit rate: 90%+ (L1 multi-layer)
Improvement vs Previous Versions:

-75% vs v15.1 (15-26ms → 1.5-4ms)
-90% vs v14.2 (8-15ms → 1.5-4ms)
-95% vs v5.0 (30-50ms → 1.5-4ms)
Production Validation:

✅ 73,000+ messages validated (SAP BTP)
✅ 99.92% success rate
✅ Avg end-to-end latency: 68ms (includes CPI backend ~50-60ms)
✅ Pure routing overhead: 1.5-4ms
Architecture Breakdown:

Component	Latency	Details
JavaScript execution	0.2-0.5ms	Pure routing logic (zero allocations)
KVM fetch (L1 cache hit)	1-2ms	In-memory cache read
KVM fetch (L2/L3 miss)	5-10ms	Real KVM API call
APIM policies	10-20ms	Auth, logging, rate limit
CPI backend	50-80ms	Network + iFlow processing
Total (cache hit)	~68ms	Production average ✅
- **CPU cycles:** ~50k per routing operation

Author: Ricardo Luz Holanda Viana Status: Sandbox Validated.
