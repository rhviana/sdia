```markdown
# FAQ – OpenAPI / Swagger vs GDCR/DCRP

---

## Q1 – How does an OpenAPI-first approach typically work?

Common steps:

1. Model APIs in OpenAPI / Swagger (often mirroring backend schemas).
2. Import specs into APIM to generate proxies.
3. Configure routing and policies per generated proxy. [web:22][web:32]

URLs tend to be:

- `/sap/fi/invoices/v1/...`
- `/salesforce/opportunities/v1/...`

Contracts and routing end up **system‑driven**.

---

## Q2 – How is GDCR/DCRP different?

GDCR/DCRP:

- Starts from **business domain semantics**, not from backend object models.
- URL is the semantic contract:

```
/sales/orders/create
/sales/orders/create/{variant}
/finance/invoices/approve/{variant}

Routing is resolved at runtime by the DCRP engine:

parse domain/entity/action/variant,

build KVM key (dcrporderscsalesforceid01:http),

look up CPI endpoint (/http/dcrp/orders/c/id01).

OpenAPI becomes optional documentation of the façade, not the source of routing.

Q3 – How does versioning differ?

OpenAPI‑driven, system‑centric:

Backend change → OpenAPI change → new API version (/v2, /v3) → new proxy + consumer migration.

GDCR/DCRP:
Façade (/sales/orders/create) is stable.

Backend changes:
new iFlow → new idXX in name,

KVM entry updated from id01 to id02.

Consumers:

keep using the same URL,

may not notice backend changes if payload contract remains backward‑compatible.

OpenAPI specs can still be versioned for schema evolution, but routing is decoupled from version numbers.
