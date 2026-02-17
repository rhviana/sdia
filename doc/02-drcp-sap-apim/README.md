# DCRP – Domain-Centric Routing Pattern (Gateway Layer)

The **Domain-Centric Routing Pattern (DCRP)** consolidates many system-centered API proxies into a small set of **domain façades**. Instead of exposing one proxy per backend system (Salesforce, SAP, Workday…), DCRP exposes one semantic façade per domain/subprocess and performs metadata-driven routing behind the scenes. [file:3]

Example façade:

```text
http://<apim>/sales/*
This single façade can cover:

Entities: orders, invoices, contracts, deliverables, customers, …

Actions: create, read, update, delete, sync, …

Vendors/variants: salesforce, sap4hana, shopify, …
[file:3]

Semantic URL Structure
DCRP enforces a stable URL pattern:

text
/sales/orders/create/salesforce
/sales/invoices/read/sap4hana
/sales/orders/create/salesforceus
/sales/orders/create/salesforceemea
From this path, the engine extracts:

domain → sales

entity → orders

action → create (normalized to c)

variant → salesforce, salesforceus, salesforceemea
[file:1][file:3]

Metadata-Driven Routing (KVM)
Routing is fully metadata-driven. For each semantic combination, a compact key is stored in a Key-Value Map:

text
dcrporderscsalesforceid01:http
dcrporderscsalesforceusid02:http
dcrporderscsalesforceemeaid02:http
dcrpinvoicescsap4hanaid05:cxf
At runtime, the JavaScript engine:

Parses the path (/sales/orders/create/salesforce).

Normalizes the action (create → c).

Builds the routing key (dcrporderscsalesforceid01:http).

Looks up the corresponding target in KVM.

Sets the target URL, e.g.:

text
http://<cpi>/http/dcrp/orders/c/id01
No proxy redeployment is required to:

onboard a new vendor or region,

change the target iFlow,

or switch adapters (e.g. http ↔ cxf).
[file:3]

Fast-Fail Security and Observability
The DCRP engine also:

Implements fast-fail logic (e.g. token hash lookup in KVM, rejecting requests before any backend call when a sender is not authorized). [file:1]

Injects standard headers for traceability:

x-gdcr-sender-id

x-gdcr-correlation-id

x-gdcr-interface-id

x-gdcr-domain, x-gdcr-entity, x-gdcr-action

This enables end-to-end, domain-aware observability across gateway and CPI. [file:3]

Example End-to-End Flow
Request
text
POST /sales/orders/create/salesforce HTTP/1.1
Host: api.example.com
Authorization: Bearer <token>
DCRP Steps (simplified)
Parse: domain = sales, entity = orders, action = create, variant = salesforce.

Normalize action = c.

Build key: dcrporderscsalesforceid01:http.

Lookup KVM → http://<cpi>/http/dcrp/orders/c/id01.

Enrich headers (sender, correlation, interface).

Forward to CPI.

CPI Endpoint
text
/http/dcrp/orders/c/id01
This endpoint is implemented by a PDCP iFlow (see ../pdcp/README.md).
[file:3]

Benefits
Collapse dozens of system-specific proxies into one façade per domain/subprocess.

No need to version / redeploy proxies when backends change: update KVM entries instead.

Domain/entity/action becomes the single lens for routing, security, and analytics.

Vendor technologies remain interchangeable implementation details.

For detailed performance results and engine internals (binary search, zero-allocation strings, etc.), see the GDCR paper and the engine source code in this folder. [file:3]

text
