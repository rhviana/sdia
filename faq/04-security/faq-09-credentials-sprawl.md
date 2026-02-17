```markdown
# FAQ-09 – Credential Sprawl and GDCR

## Q1 – How does GDCR reduce credential sprawl?

By consolidating proxies and packages:

- you no longer need one technical user per tiny proxy per endpoint,
- you can manage credentials at the level of:
  - backend system,
  - trust boundary,
  - or domain package. [file:3]

Sandbox/trial results:

- technical users reduced from 39 to 12 (≈69%). [file:3]

---

## Q2 – Is it safe to reuse credentials across multiple operations?

Yes, when:

- they target the same backend system and trust boundary,
- operations are part of the same integration contract,
- you maintain proper least‑privilege scopes/roles on the backend.

GDCR doesn’t force “one user for everything”; it removes **unnecessary duplication** created by system‑driven, per‑proxy credentialing.

---

## Q3 – How are credentials stored and used?

Typical pattern:

- Credentials stored securely in:
  - APIM secure stores or KVM with encryption,
  - CPI credential stores. [file:3]
- Each KVM routing entry references:
  - the target CPI endpoint,
  - and optionally the credential alias or profile to use.

This keeps credentials and routing configuration **decoupled from façade URLs**.

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
