# DDCR Engine – Maverick Style Evolution (JavaScript PoC)

This folder contains the JavaScript policy Proof of Concept implementation of the **Domain‑Centric Routing Pattern (DCRP)** for **SAP Integration
Suite – API Management (APIM)**.

The goal of this engine is to demonstrate, in pure JavaScript, how to apply fully domain‑driven routing on top of APIM KVMs, reducing proxies, standardizing governance, and keeping gateway latency in the millisecond range.

---
```text
Latência (ms)
50 |                    v5.0 ████████████████████████████████████████
40 |                         █
30 |              v7.1 ██████████████████████████████
25 |                         █
20 |                         █
15 |    v8.0/v14.2 ████████████████          v15.0/v15.1 ████████████████
10 |              █           █                         █
 5 |              █           █                         █
 2 |    v15.2 🔒 ██          █                         █
 0 +----+----+----+----+----+----+----+----+----+----+----+----+
    v5.0     v7.1      v8.0/v14.2         v15.0/v15.1          Phantom v12
```

Latency (ms) — DDCR Phantom v12 (SAP BTP sandbox)

350 |                            p99 ███████████████████████
300 |                                █
250 |                                █
200 |                p85 ████████████
150 |        p50 ████████
100 |
 50 |
   0 +--------+--------+--------+
          p50       p85       p99

p50: 145 ms | p85: 184 ms | p99: 338 ms | 120,396 requests | 10 ms delay

Segue o README da evolução Maverick TODO em inglês, limpo, sem exagero, pronto para colar em src/javascript/README.md (substitui o conteúdo atual dessa seção).

text
# DDCR Engine – Maverick Style Evolution (JavaScript PoC)

This folder contains the JavaScript policy Proof of Concept implementation
of the **Domain‑Centric Routing Pattern (DCRP)** for **SAP Integration
Suite – API Management (APIM)**.[web:33][web:36]

The goal of this engine is to demonstrate, in pure JavaScript, how to
apply fully domain‑driven routing on top of APIM KVMs, reducing proxies,
standardizing governance, and keeping gateway latency in the
millisecond range.[web:33][web:42]

---

```text
Latency (relative units)
50 |                    v5.0 ████████████████████████████████████████
40 |                         █
30 |              v7.1 ██████████████████████████████
25 |                         █
20 |                         █
15 |    v8.0/v14.2 ████████████████          v15.0/v15.1 ████████████████
10 |              █           █                         █
 5 |              █           █                         █
 2 |                    Phantom v12 ██
 0 +----+----+----+----+----+----+----+----+----+----+----+----+
        v5.0     v7.1      v8.0/v14.2         v15.0/v15.1   Phantom v12
text
Latency (ms) — DDCR Phantom v12 (SAP BTP sandbox)

350 |                            p99 ███████████████████████
300 |                                █
250 |                                █
200 |                p85 ████████████
150 |        p50 ████████
100 |
 50 |
   0 +--------+--------+--------+
          p50       p85       p99

p50: 145 ms | p85: 184 ms | p99: 338 ms | 120,396 requests | 10 ms delay
Phantom v12 is a high‑performance DDCR engine PoC that follows the same
semantic model as the Maverick line (v5.0–v15.1) while exploring further
reductions in routing overhead in SAP APIM sandbox runs.[file:32] It is
treated as a research branch, not as a DOI‑backed reference version. The
Phantom v12 run reported in the GDCR v6.0 white paper achieved:[file:32]

120,396 requests (Full Load run)

p50: 145 ms · p85: 184 ms · p99: 338 ms (end‑to‑end, Poland → USA)

99.9967% success rate, 4 network‑layer errors (ECONNRESET), 0 routing failures

Evolution Timeline
Evolution path:
v5.0 → v8.0 → v14.2 → v15.0 → v15.1 → Phantom v12

v5.0 – POC (Proof of Concept)
Released: Q1 2025

Status: Open‑source (GitHub + DOI)

Features:

Flexible delimiter detection (11 supported delimiters)

Dynamic path matching with ordering

Manual KVM parsing (split + loop)

Basic error handling (try/catch)

Approximate performance:

Latency: 30–50 ms

Memory: ~10 KB per request

Allocations: ~50 objects per request

Recommended use: academic POC, small scenarios (< 100 routes)

Status: validated POC, not recommended for production.[web:42]


v8.0 – Speed Boost

Status: Deprecated

Optimizations:

Single loop with early exit (~40% gain)

indexOf + substring instead of regex (~30% gain)

Arrays replaced by primitive variables (~15% gain)

Performance:

Latency: 8–15 ms (≈ 50% faster than v7.1)

Limitations: still no caching or advanced observability.[web:33]

v14.2 – Enterprise Ready 

DOI: 10.5281/zenodo.18582469

Status: Stable (later superseded by newer versions)

New features:

Global cache (TTL 60s) → KVM parse drops from 8–12 ms to 0–1 ms

Multi‑node‑safe cache (validation hash)

7 time‑measurement phases (detailed observability)

241 verb variations (universal action normalization)

Commented debug hooks (zero overhead in production)

Performance:

Latency: 8–15 ms (similar to v8.0, but with full observability)

Cache hit rate: ~95%

33,000+ calls validated with ~99.9% success

Status: enterprise‑ready, multi‑node, highly observable.[web:33][web:42]

v15.0 – Algorithmic Upgrade
Released: January 2026

Status: Superseded

Critical fixes:

Binary search adjustment (prefix match → full case‑insensitive match)

Removal of duplicate "retrieve" entry in the action map

Correction of the “zero allocation” claim (removed segments.push())

Hardening of extractIdFast() (correct "id" detection)

Removal of context shadowing (var context = context)

New features:

Binary search for KVM → O(log n) instead of O(n)

Real zero‑allocation hot path (no toLowerCase(), no split() in hot path)

ES6 Map for actions, guaranteeing O(1) normalization

Sorted, normalized KVM cache (case‑insensitive)

Performance:

Latency: 15–25 ms

500‑entry KVM scan: ~0.6 ms (vs ~12 ms in v14.2, ~20× faster)

Focus: scalability for large KVMs with stricter search semantics.[web:33]

v15.1 – Maverick Ghost Edition (Academic Gold)

DOI: 10.5281/zenodo.18661136

Status: Stable (Academic / DOI)

Hardening:

Case‑insensitive action lookup (/Create, /DELETE, etc.)

Semantic extractIdFast() (searches before the last : → safe for production)

Path validation: hard‑fail when more than 4 segments are present

Observability:

Tracks 7 latency phases (parse, lookup, validate, construct, cache, total)

Cache hit/miss metrics

Per‑route performance profile

Performance:

Latency: 15–26 ms

~39% improvement vs v14.2

Architecture:

O(0) action normalization for 241 variations into 15 core codes

Gateway overhead < 2 ms on the hot path

Multi‑node cache with TTL invalidation

Alignment with PDCP (domain‑based package naming)

Conflict detection for overlapping routes (HTTP 409)

Security Shield (v15.1):

Blocking of path traversal, SQLi, XSS, command‑injection patterns

Domain whitelist on the first URL segment

Validation of critical headers

Threat metadata enrichment for use with RaiseFault.[web:33][web:36]

Phantom v12 – High‑Performance DDCR PoC
Phantom v12 is a high‑performance DDCR engine Proof of Concept that
follows the same semantic model as the Maverick line (v5.0–v15.1) while
exploring additional reductions in routing overhead in SAP APIM sandbox
runs.[file:32] It is treated as a research branch, not as a
DOI‑backed reference version.

The GDCR v6.0 white paper includes a dedicated Phantom v12 run on
SAP API Management + SAP Cloud Integration:[file:32]

Requests: 120,396 (Full Load run, 10 ms delay between calls)

Success rate: 99.9967% (4 errors = ECONNRESET, network‑layer only)

Routing failures: 0

End‑to‑end latency (Poland → USA):

p50: 145 ms

p85: 184 ms

p99: 338 ms

These values represent full path latency (gateway + CPI + network) in
sandbox tenants and are reported as evidence of architectural correctness
and cross‑platform portability, not as production SLA guarantees

- **Autor:** Ricardo Luz Holanda Viana  
- **Ambiente alvo:** SAP BTP – Integration Suite (API Management + Cloud Integration)  
- **Status:** Sandbox validado, com evidências publicadas em blogs técnicos, GitHub e registros DOI.[web:33][web:36][web:42]
