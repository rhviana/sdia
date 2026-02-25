GraphQL Client
     │
     │  query { orders_INVALID { id } }
     ▼
Apollo Resolver
     │
     │  POST https://<apim>/sales/ordersinvalid/read/salesforce/
     ▼
SAP APIM — JS Policy (DDCR engine)
     │
     │  KVM lookup: dcrpordersinvalidrsalesforce... → NOT FOUND
     │  fail-fast → HTTP 500 imediato
     │  zero backend calls
     │  zero CPI calls
     ▼
Apollo Server recebe 500
     │
     │  { errors: [{ message: "No route: ordersinvalidrsalesforce" }] }
     ▼
GraphQL Client ← erro estruturado


GraphQL Client
     │
     │  query { orders { id, status } }
     ▼
Apollo Server / Hasura
     │
     │  POST https://<apim>/sales/orders/read/salesforce/
     │  (resolver traduz query → semantic URL GDCR)
     ▼
SAP APIM — proxy cpi-dcrp-domain-sales-o2c
     │
     │  KVM lookup: dcrpordersrsalesforceid01:http
     │  constrói: https://<cpi>/http/dcrp/orders/r/id01
     ▼
SAP CPI — iFlow id01.o2c.salesforce.order.s4hana.r.in.sync
     │
     │  resposta JSON
     ▼
Apollo Server / Hasura
     │
     │  monta response GraphQL
     ▼
GraphQL Client ← { data: { orders: [...] } }
