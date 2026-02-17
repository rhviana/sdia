iFlow Naming Convention (iFlow DNA)
PDCP uses a structured “DNA” for iFlow names:

id[seq].[subdomain].[sender].[entity].[action].[direction].[sync/async]

Where:

id[seq] – local sequence within the subprocess (e.g. id01, id02, …)

subdomain – business subprocess (e.g. o2c, r2r, s2p)

sender – source system (e.g. salesforce, sap4hana, shopify)

entity – business object (e.g. order, invoice, customer)

action – normalized action code (c, r, u, d, s, etc.)

direction – in, out, sync, etc.

sync/async – processing mode

Examples:

text
id01.o2c.salesforce.order.c.in.sync
id02.o2c.salesforce.order.c.in.sync
id03.o2c.shopify.order.s.in.sync
id05.r2r.sap4hana.invoice.c.out.sync
id01 is always “first” within its subprocess; IDs are local per subprocess, not global.

The same semantic pattern can have regional variants (e.g. id02us, id02emea) without breaking the URL or KVM model. [file:3]

Mapping to DCRP KVM Keys
Each iFlow is referenced by a compact KVM key used by the DCRP engine:

text
dcrp{entity}{action}{vendor}id{XX}:{adapter}
Examples:

text
# From DCRP façade: /sales/orders/create/salesforce
# → entity = order, action = c, vendor = salesforce

dcrporderscsalesforceid01:http  # maps to id01.o2c.salesforce.order.c.in.sync

dcrporderscsalesforceusid02:http   # US variant
dcrporderscsalesforceemeaid02:http # EMEA variant

dcrpinvoicescsap4hanaid05:cxf   # maps to id05.r2r.sap4hana.invoice.c.out.sync
This mapping ensures:

one semantic URL → one KVM key → one iFlow name,

quick lookup in CPI monitors (you can find the right iFlow in seconds by ID and semantics),

clear ownership: e.g. “Sales O2C” team owns nx.sales.o2c.integrations and all its idXX.o2c.* iFlows. [file:3]

Why PDCP Matters
Governance: all integrations for a given business domain/subprocess live together and follow the same naming rules. [file:3]

Observability: logs and traces are tagged with the same domain/entity/action semantics as the gateway layer.

Change management: swapping implementations or vendors is a metadata/iFlow mapping change, not a breaking URL change.

Alignment with GDCR/DCRP: PDCP completes the semantic thread:

text
Client URL  →  DCRP façade  →  KVM key  →  PDCP iFlow  →  Backend
/sales/...     /sales/*         dcrp...      idXX...       SAP/SFDC/...
For full details on the GDCR/PDCP naming playbook and examples, refer to the GDCR paper (v5.0) and the documentation in ../docs/.
