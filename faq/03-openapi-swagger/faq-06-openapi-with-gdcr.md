# FAQ-06 – Using OpenAPI / Swagger with GDCR

## Q1 – How can I document GDCR façades with OpenAPI?

Example:

```yaml
paths:
  /sales/orders/create:
    post:
      summary: Create a sales order (vendor-agnostic)
      parameters:
        - name: variant
          in: query
          schema:
            type: string
            description: Optional vendor/region
      responses:
        '201':
          description: Order created
  /sales/orders/create/{variant}:
    post:
      summary: Create a sales order via specific vendor
      parameters:
        - name: variant
          in: path
          schema:
            enum: [salesforce, sap4hana, salesforceus, salesforceemea]
The spec describes the semantic surface; DCRP decides which backend/iFlow to call via KVM. [file:1][file:3]

Q2 – How does OpenAPI versioning interact with GDCR?
Façade (/sales/orders/create) remains stable.

If the payload schema changes:

you can bump an OpenAPI version (e.g. v2 in the spec),

but routing logic stays metadata‑driven.

You avoid:

changing URLs for backend‑only refactorings,

proliferating proxies just to point to new endpoints.

Q3 – What is the main benefit of combining OpenAPI with GDCR?
You get:

Clear semantic façade:

strongly structured URLs,

documented in OpenAPI.

Flexible implementation:

routing dictated by metadata in KVM,

backend changes implemented by KVM + CPI changes, not by façade changes.

This combination allows catalogs and governance tools to reason in terms of domain/entity/action rather than systems only. [web:32][web:38]
