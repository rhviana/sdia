# DDCR Phantom v12 — High‑Performance JavaScript Routing Engine (PoC)

This folder contains the high‑performance JavaScript proof‑of‑concept
implementation of the **Domain‑Driven Centric Router (DDCR) — Phantom v12**
for SAP Integration Suite – API Management (APIM).

Phantom v12 extends the Maverick family of DDCR engines by pushing the
limits of performance and allocation behavior in the gateway layer, while
preserving the same semantic model described in the GDCR v6.0 white paper.

> Scope: Phantom v12 is an **internal performance PoC**.  
> The official, DOI‑backed results in the v6.0 paper are based on the
> **Maverick v15.1 + Phantom v12** combination as executed in SAP BTP
> sandbox environments.[file:32]

---

## 1. Purpose and Scope

Phantom v12 was designed to answer a single question:

> “How far can we reduce routing overhead in a JavaScript policy while
> keeping the semantic model stable?”

It keeps the same domain‑centric routing semantics, KVM metadata model,
and action normalization used in earlier Maverick versions, but focuses
on:

- Removing unnecessary allocations from the hot path.
- Eliminating regular expressions.
- Reducing string operations to a minimal, index‑based set.
- Keeping routing latency in the low single‑digit millisecond range in
  SAP APIM sandbox environments.

Phantom v12 is **not** a separate product. It is a **technical evolution**
in the Maverick line and should be read in the context of the overall
engine evolution documented under `src/javascript/README.md`.[web:33][web:42]

---

## 2. Architecture Overview

At a high level, Phantom v12 implements the following routing sequence:

1. **Context extraction**  
   Reads domain, entity, action, and vendor from the incoming URL
   (for example: `/sales/orders/create/salesforce`).[web:42]

2. **Action normalization**  
   Maps 241 verb variations (create, post, submit, approve, sync, etc.)
   into a compact code set (e.g., `c`, `r`, `u`, `d`, `q`, `s`, `t`, `a`,
   `n`, `v`, `e`, `x`).[file:32]

3. **Metadata lookup (KVM)**  
   Resolves a pre‑computed DDCR metadata string from the KVM, such as:

   `dcrporderscsalesforceid01:http`

   This metadata string encodes domain, entity, action code, vendor,
   route identifier, and adapter/protocol.[file:32]

4. **Target construction**  
   Builds the final Cloud Integration (CPI) iFlow endpoint URL based on
   the metadata, without exposing any backend details at the public
   gateway surface.

5. **Context update**  
   Writes the resolved target URL and auxiliary fields back into the
   APIM context for the subsequent policies and target flow.

The key architectural principles are:

- **Semantic façade** — public URLs remain strictly business‑semantic
  (`/domain/entity/action/vendor`); backends stay invisible.[file:32]
- **Metadata control plane** — all routing decisions are driven by KVM
  metadata, not by hard‑coded URLs or system names.[file:32]
- **Single‑pass resolution** — the engine walks the KVM only once per
  request, with an early‑exit pattern.

---

## 3. Implementation Highlights

Phantom v12 implements several low‑level optimizations, while keeping
the logic of Maverick v15.1 intact:

- **No regex in the hot path**  
  Uses `indexOf`, `substring`, and `charCodeAt` for parsing, avoiding
  regular expressions in performance‑critical sections.[web:33]

- **No array/object allocations on the hot path**  
  Operates on primitive variables instead of constructing arrays or
  intermediate objects during parsing.[web:33]

- **Single‑pass KVM lookup**  
  Sequential scan with early exit once the matching metadata key is
  found; the KVM itself remains the same semantic map used by earlier
  versions.[web:33]

- **Inline extraction and concatenation**  
  URL segments are extracted via index arithmetic, and the target URL is
  built via direct string concatenation, avoiding utility functions in
  the hot path.[web:33]

- **Regional suffix support** (optional)  
  Vendors can carry regional suffixes (for example, `salesforceus`,
  `salesforceemea`, `sapbrazil`), which are split into base vendor +
  region and resolved via corresponding metadata keys when present.[web:33]

These optimizations are **implementation details**, not new concepts.
They refine how the GDCR/DDCR semantic model is executed inside the
gateway.

---

## 4. Performance Characteristics (Sandbox Observations)

The GDCR v6.0 white paper reports end‑to‑end metrics for SAP BTP
implementations, including Phantom v12, such as:[file:32]

- 121,471 requests across 4 domains, 88 vendors, 4 proxies, and 44 iFlows.
- 99.9967% end‑to‑end success rate.
- p50 145 ms, p85 184 ms, p99 338 ms (Poland → USA).[file:32]

These numbers represent **full path latency** (gateway + CPI +
network) in sandbox environments.

Within that context, Phantom v12 aims to keep **routing overhead** in
the low single‑digit millisecond range when running in SAP APIM
JavaScript policies, under similar conditions to Maverick v15.1.

Important clarifications:

- Phantom v12 does **not** change the overall end‑to‑end metrics
  reported in the white paper; it refines how the routing work is
  performed inside the gateway.[file:32]
- All observations are from free‑trial and sandbox environments and
  should be interpreted as evidence of **architectural correctness and
  efficiency**, not as production SLA guarantees.[file:32]

---

## 5. Relationship to the Maverick Engine Evolution

Phantom v12 belongs to the same evolution line described in
`src/javascript/README.md`:[web:33][web:42]

- v5.0 — initial POC with flexible delimiters and regex‑based parsing.  
- v7.1 — domain‑centric key normalization and fixed delimiters.  
- v8.0 — single‑loop parsing and reduced allocations.  
- v14.2 — enterprise‑ready “Panzer” edition with global cache and full
  observability.  
- v15.0 / v15.1 — “Maverick” editions with algorithmic hardening,
  case‑insensitive action lookup, and Security Shield features.  
- **v15.2 / Phantom v12** — high‑performance PoC focusing on zero
  allocation and simplified string handling.

In short:

- **Maverick v15.1** is the **documented, DOI‑backed** engine used as
  primary reference in the white paper.[file:32]  
- **Phantom v12** is a **research branch** that explores how far the
  same semantics can be pushed in terms of low‑level performance.

---

## 6. Usage Notes

Phantom v12 is intended for **experimentation** and **performance
research**:

- Target environment: SAP BTP Integration Suite – API Management
  (JavaScript policy + KVM + CPI endpoints).[web:33][web:36]
- Recommended audience: integration architects and engineers already
  familiar with the DCRP/PDCP patterns, as described in the GDCR v6.0
  paper.[file:32]

Before using Phantom v12 in any production‑like environment, you should:

- Review and adapt the code to your own non‑functional requirements.  
- Measure routing overhead in your specific landscape.  
- Validate behavior against your own metadata model and governance
  constraints.

---

## 7. References

- **White paper:**  
  *Gateway Domain‑Centric Routing (GDCR): A Vendor‑Agnostic
  Metadata‑Driven Architecture for Enterprise API Governance – v6.0
  Edition*.[file:32]

- **Engine evolution:**  
  `src/javascript/README.md` — *DDCR Engine – Maverick Style Evolution
  (JavaScript PoC).*[web:33][web:42]
