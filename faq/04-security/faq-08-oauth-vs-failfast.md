
```markdown
# FAQ-08 – OAuth2 vs KVM Fast-Fail

## Q1 – Where does OAuth2 fit in GDCR?

OAuth2/OIDC is recommended for:

- public or user‑centric APIs,
- scenarios with delegated consent and short‑lived tokens.

In GDCR:

- OAuth is a **layer around** DCRP, not part of the core routing formula.
- The core routing only needs `domain/entity/action/variant`.

---

## Q2 – What is KVM fast-fail and why use it?

KVM fast‑fail:

- stores sender metadata and allowed operations in KVM,
- validates sender/token locally at the gateway,
- rejects unauthorized calls (401/403) before routing. [file:1][file:3]

Benefits for M2M:

- no external IdP round‑trip on every call,
- lower latency,
- fewer runtime dependencies.

---

## Q3 – Can OAuth2 scopes be mapped to domain/entity/action?

Yes.

- Scopes can be defined in terms of semantic operations:

```text
scope: sales.orders.c
scope: finance.invoices.a
Gateway checks:

token validity,

scope → allowed domain/entity/action.

Fast‑fail with KVM and OAuth2 scopes can coexist, depending on security requirements.

-----------------------------------

**Author:** Ricardo Luz Holanda Viana  
**Role:** Enterprise Integration Architect · SAP BTP Integration Suite  
**Creator of:** GDCR · DCRP · PDCP  

**Architectural scope:** Business‑semantic, domain‑centric routing architectures for API Gateways and Integration Orchestration (vendor‑agnostic), with SAP‑specific implementations via DCRP (SAP BTP API Management) and PDCP (SAP BTP Cloud Integration).  

**License:** Creative Commons Attribution 4.0 International (CC BY 4.0)  
**DOI:** [zenodo.18661136](https://doi.org/10.5281/zenodo.18582492)  
**DOI:** [figshare.31331683](https://doi.org/10.6084/m9.figshare.31331683)

This document is part of the **Gateway Domain‑Centric Routing (GDCR)** framework and represents original architectural work authored by Ricardo Luz Holanda Viana. Reuse, adaptation, and distribution are permitted only with proper attribution. Any derivative or equivalent architectural implementation must reference the original work and associated DOI.

-----------------------------------
