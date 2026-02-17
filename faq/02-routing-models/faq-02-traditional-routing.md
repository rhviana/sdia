# FAQ 02 — Traditional Routing Model

## Model

Client
|
v
API Proxy
|
v
Backend


Characteristics:
- 1 proxy per backend or integration
- OpenAPI imported per system
- Proxy lifecycle tied to backend

---

## Resulting Landscape

APIM
├── sap-orders-proxy
├── salesforce-orders-proxy
├── stripe-payments-proxy
├── shopify-orders-proxy


This creates:
- Proxy sprawl
- Policy duplication
- Credential sprawl
- Deployment friction
