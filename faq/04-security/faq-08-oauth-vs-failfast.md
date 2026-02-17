
### FAQ-08 – OAuth2 vs. KVM Fast-Fail

####  Q1 – Where does OAuth2 fit in GDCR ?

- OAuth2/OIDC remains the industry standard for identity delegation. Within a GDCR landscape, it is treated as an External Security Wrapper.

Best For: Public-facing APIs, user-centric apps, and scenarios requiring delegated consent.

- The GDCR Role: OAuth validates who the user is, while the DCRP core handles where the request goes based on the semantic path (domain/entity/action).

####  Q2 – What is KVM Fast-Fail and why use it?

KVM Fast-Fail is a high-performance validation pattern where the Gateway checks sender permissions against local metadata (KVM) before any heavy processing or routing occurs.

How it works: The Gateway extracts the sender ID and validates the requested operation (domain/entity/action) directly against a pre-loaded KVM table.

The "Fast-Fail": If the sender isn't authorized for that specific action, the request is rejected (401/403) in milliseconds, without ever touching a backend or an Identity Provider (IdP).

Benefits for M2M (Machine-to-Machine):
Zero Latency Round-trips: No need to call an external IdP for every single request.

High Resilience: The Gateway can still validate and route traffic even if the central IdP is experiencing downtime.

Efficiency: Rejects "garbage" traffic at the edge, protecting downstream CPI and Backend resources.

####  Q3 – Comparison: Side-by-Side Architectural Flow

```text
      [ OAUTH2 FLOW ]                           [ KVM FAST-FAIL ]
   (Standard Delegation)                      (GDCR Edge Validation)

1. Client -> Request + Token            1. Client -> Request + ID/Token
         |                                         |
2. APIM -> Call External IdP            2. APIM -> Local KVM Check (Edge)
         |      (Latency!)                         |      (Ultra-Fast!)
         v                                         v
3. IdP -> Validates & Scopes            3. KVM -> Matches Key: [Sender_Action]
         |                                         |
4. APIM -> Routes to Backend            4. APIM -> Routes to Backend
         |                                         |
   (Depends on IdP Uptime)                 (Independent / High Performance)

```

####  Q4 – Can OAuth2 Scopes be mapped to Domain/Entity/Action?

- Absolutely. This is the "Best of Both Worlds" approach. You can map OAuth2 scopes directly to the GDCR semantic operations:
- Scope: sales.orders.create
- Gateway Logic: Checks if the Token is valid AND if the KVM permits that specific Sender to perform that specific Domain Action.


Author Information
Author: Ricardo Luz Holanda Viana

Role: Enterprise Integration Architect · SAP BTP Integration Suite

Creator of: GDCR · DCRP · PDCP

Architectural scope: Business‑semantic, domain‑centric routing architectures for API Gateways and Integration Orchestration (vendor‑agnostic), with SAP‑specific implementations via DCRP (SAP BTP API Management) and PDCP (SAP BTP Cloud Integration).

License: Creative Commons Attribution 4.0 International (CC BY 4.0)

DOI: zenodo.18661136

DOI: figshare.31331683

This document is part of the Gateway Domain‑Centric Routing (GDCR) framework and represents original architectural work authored by Ricardo Luz Holanda Viana. Reuse, adaptation, and distribution are permitted only with proper attribution. Any derivative or equivalent architectural implementation must reference the original work and associated DOI.
