FAQ-07 – Sender Isolation and Domain Proxies

Q1 – If 10 senders call /sales/*, how do we prevent cross-sender access?
GDCR decouples the Public Interface from the Authorization Matrix. While the path is shared, the permission to execute an action is unique to each sender.

Semantic Routing: Defines the "What" (sales/orders/create).

Authorization Matrix: Defines "Who" can do "What".

Isolation Comparison (ASCII):

```text
  [ TRADITIONAL MODEL ]                  [ GDCR / DCRP MODEL ]
   (Isolation by Proxy)                (Isolation by Metadata)

 Sender A -> [Proxy_Sales_Orders]      Sender A --+    /sales/orders/c
                                                  |--> [ SALES FACADE ]
 Sender B -> [Proxy_Sales_Customers]   Sender B --+    /sales/cust/r
                                                       
 PROS: Simple isolation.               PROS: 1 Proxy. Centralized Log.
 CONS: 100 Senders = 100 Proxies.      CONS: None (Isolation is logic-based).
       High Maintenance.                     Scale is handled by KVM.
```

Q2 – How is the "Fast-Fail" validation performed?
When a request hits the façade, the Fast-Fail policy acts as a gatekeeper. It resolves the sender's identity (via token hash, mTLS, or Header) and checks the requested operation against a whitelist.

Runtime Process:

Resolve Sender: Identify SND_001.

Compute Operation: Extract sales/orders/c.

Cross-Check: Does the whitelist for SND_001 contain sales/orders/c?

Execute: If yes, route. If no, Fail Fast with a 403 Forbidden.

Q3 – Does sharing one domain proxy break isolation?
No. Sharing the façade is simply sharing the entry point.

Think of it like a bank vault with many safe-deposit boxes. Everyone enters through the same front door (the façade), but each person only has a key to their specific box (the authorization matrix).

The façade is shared.

The allowed operations are NOT.

Q4 – What about auditability?
Because the DCRP engine "understands" the domain semantics, every log entry is enriched with high-value business metadata. You aren't just auditing URLs; you are auditing business actions.

Every call generates headers for the audit log:

x-gdcr-sender-id: Who called?

x-gdcr-domain/entity/action: What business operation was attempted?

x-gdcr-correlation-id: End-to-end trace ID.

Author Information
Author: Ricardo Luz Holanda Viana

Role: Enterprise Integration Architect · SAP BTP Integration Suite

Creator of: GDCR · DCRP · PDCP

Architectural scope: Business‑semantic, domain‑centric routing architectures for API Gateways and Integration Orchestration (vendor‑agnostic), with SAP‑specific implementations via DCRP (SAP BTP API Management) and PDCP (SAP BTP Cloud Integration).

License: Creative Commons Attribution 4.0 International (CC BY 4.0)

DOI: zenodo.18661136

DOI: figshare.31331683

This document is part of the Gateway Domain‑Centric Routing (GDCR) framework and represents original architectural work authored by Ricardo Luz Holanda Viana. Reuse, adaptation, and distribution are permitted only with proper attribution. Any derivative or equivalent architectural implementation must reference the original work and associated DOI.
