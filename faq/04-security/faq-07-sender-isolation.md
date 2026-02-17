```markdown
# FAQ-07 – Sender Isolation and Domain Proxies

## Q1 – If 10 senders call `/sales/*`, how do we prevent cross-sender access?

GDCR separates:

- **semantic routing** – `domain/entity/action/variant`,
- **authorization** – sender × allowed operations matrix.

For each sender:

- KVM or policy store entry:

```yaml
senderA:
  tokenHash: "<sha256>"
  allowed:
    - sales/orders/c
    - sales/orders/r

senderB:
  tokenHash: "<sha256>"
  allowed:
    - sales/customers/r
At runtime:

Fast‑fail policy resolves the sender (by token hash, mTLS DN, or header).

Computes the requested semantic operation, e.g. sales/orders/c.

Checks if it is in the sender’s allowed list.

Rejects (401/403) if not allowed, before routing. [file:1][file:3]

Q2 – Does sharing one domain proxy break isolation?
No.

All senders hit the same façade (/sales/**), but:

each sender has its own credentials / tokens,

authorization rules are per sender.

The façade is shared; the allowed operations per sender are not.

Q3 – What about auditability?
Every call includes:

x-gdcr-sender-id

x-gdcr-domain

x-gdcr-entity

x-gdcr-action

x-gdcr-interface-id

x-gdcr-correlation-id [file:3]

You can audit:

which senders call which operations,

any attempt to access forbidden operations (blocked at fast‑fail step).

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
