# FAQ-12 – Versioning in GDCR

## Q1 – How is façade versioning handled?

In GDCR:

- Facade URLs (e.g. `/sales/orders/create`) are designed to be **long‑lived** and domain‑centric. [file:1][file:3]
- Versioning is avoided at the URL level whenever possible.

If fundamental breaking changes are needed:

- you can still create `/v2/sales/orders/create` as a new façade,
- but this is an exception, not the default.

---

## Q2 – Where does most versioning actually occur?

Versioning primarily happens in:

- CPI iFlows (implementation artifacts),
- KVM routing entries (mapping which iFlow is “current”).

Example:

- Old: `dcrporderscsalesforceid01:http` → `/http/dcrp/orders/c/id01`
- New: `dcrporderscsalesforceid02:http` → `/http/dcrp/orders/c/id02`

Clients continue calling `/sales/orders/create/salesforce`.

---

## Q3 – How does this compare to traditional API versioning?

Traditional (OpenAPI‑driven, system‑centric):

- new backend / schema → new API version path (`/v2/...`),
- new proxy and consumer migration.

GDCR:

- keeps façade stable,
- evolves routing and implementations via metadata + iFlow versions.

You **decouple** external contract stability from internal implementation cycles.
