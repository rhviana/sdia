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
