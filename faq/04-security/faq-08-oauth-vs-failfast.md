
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
Segue a versão “limpa” para GitHub, tratando o código só como pseudocódigo ilustrativo:

## KVM Key Structure for Fast-Fail

For Fast-Fail to work effectively, each KVM entry combines **Sender ID** and **Semantic Operation** into a unique key.  
This keeps permissions granular and checked at the gateway edge, before any routing happens. 

```text

| KVM Key                     | Value                                      | Description                                   |
|----------------------------|--------------------------------------------|-----------------------------------------------|
| `SND_001:sales:orders:c`   | `http://cpi/orders/create|auth_alias`     | Sender 001 is allowed to **create** orders.   |
| `SND_001:sales:orders:r`   | `http://cpi/orders/query|auth_alias`      | Sender 001 is allowed to **read/query** orders. |
| `SND_002:fin:inv:a`        | `http://cpi/finance/approve|fin_alias`    | Sender 002 is allowed to **approve** invoices. |

```

The exact adapter URL and alias format are implementation details; the key idea is that `sender:domain:entity:action` is the primary security surface. 

## JavaScript Pseudocode (Fast-Fail Idea Only)

The snippet below is **illustrative pseudocode**, not production code.  
It shows the Fast-Fail idea: validate the sender/semantic operation combination before any routing or backend call. [file:80][file:81]

```js
// 1. Capture semantic URL variables and Sender ID
var senderId = context.getVariable("client_id");      // e.g. from token or header
var domain   = context.getVariable("dcrp.domain");
var entity   = context.getVariable("dcrp.entity");
var action   = context.getVariable("dcrp.action");

// 2. Build the Fast-Fail lookup key: SND_xxx:domain:entity:action
var lookupKey = senderId + ":" + domain + ":" + entity + ":" + action;

// 3. Read the pre-resolved KVM value for this sender/operation
// (In a real policy, a KVM lookup step would populate this variable.)

var routingMetadata = context.getVariable("dcrp.ff.metadata." + lookupKey);

if (!routingMetadata) {
  // FAST-FAIL: no mapping for this Sender/Semantic action → reject at the edge
  context.setVariable("flow.error.code", "403");
  context.setVariable(
    "flow.error.message",
    "Unauthorized: sender not allowed to perform this semantic action."
  );
} else {
  // Proceed: split metadata into endpoint and credential alias
  var parts = routingMetadata.split("|");
  context.setVariable("target.url", parts);
  context.setVariable("dcrp.auth.alias", parts);
}
```

#### Why is this secure and efficient?

Strict isolation: A credential leak for SND_001 does not grant access to Finance routes; the sender:domain:entity:action key is a hard gate at API Management level, blocking lateral movement.

Edge performance: Validation is in‑memory via KVM cache, so unauthorized requests are rejected without calling backends or external IdPs. 

Operational transparency: Logged keys make it easy to see which business domains and actions are being accessed, without digging into backend‑specific logs. 

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
