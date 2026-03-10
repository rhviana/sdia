# SDIA — GDCR - Gateway Domain Centric Router
## Kong K8s + SAP CPI | End-to-End Integration

> **"The domain never lies."**
> Ricardo Luz Holanda Viana | March 2026

---

## Overview

This repository contains the full implementation of **SDIA (Semantic Domain Integration Architecture)** running on Kubernetes with Kong Gateway routing 100,000 requests to SAP Cloud Integration (CPI) across 42 iFlows — real end-to-end, no mocks.

The DDCR Engine (Domain Driven Centric Router) resolves semantic URLs using Redis as a KVM (Key-Value Metadata store), determines the correct protocol (HTTP/SOAP), builds the CPI target path, and forwards the request — all in sub-4ms at the Kong plugin layer.

---

## Architecture

```
Client
  │
  ▼
Kong Gateway (K8s NodePort :30800)
  │
  ├── GDCR Plugin (Lua handler v2.2)
  │     ├── Stage 1: Domain Inference       → parse /{domain}/{entity}/{action}/{target}
  │     ├── Stage 2: Validate               → 400 if incomplete
  │     ├── Stage 3: Fast Fail              → Redis KVM lookup → 404 if not found
  │     ├── Stage 4: Normalize Action       → ACTION_MAP (create→c, sync→s, notify→n...)
  │     ├── Stage 5: Parse Redis Value      → interface_id:protocol
  │     ├── Stage 6: Extract ID Suffix      → id{nn}
  │     └── Stage 7: Build CPI Path         → /http/dcrp/ or /cxf/dcrp/
  │
  ├── Redis KVM (redis-service:6379)
  │     └── Key: /{domain}/{entity}/{action}/{target}
  │         Value: {interface_id}:{protocol}
  │         Example: /sales/orders/create/salesforce → gdcrorderscSalesforceid01:http
  │
  └── SAP CPI (HTTPS :443)
        ├── HTTP iFlows  → /http/dcrp/{resource}/{action_norm}/{id}
        └── SOAP iFlows  → /cxf/dcrp/{resource}/{action_norm}/{id}
```

---

## URL Pattern

```
/{domain}/{entity}/{action}/{target}
```

| Segment | Example | Description |
|---------|---------|-------------|
| domain | `sales` | Business domain |
| entity | `orders` | Resource entity |
| action | `create` | Semantic action |
| target | `salesforce` | Backend system |

**Action normalization:**

| Semantic | Code |
|----------|------|
| create, post, insert | `c` |
| read, get, retrieve | `r` |
| update, put, modify | `u` |
| delete, remove | `d` |
| sync, synchronize | `s` |
| transfer, send | `t` |
| notify, notification | `n` |
| approve, authorize | `a` |
| query, search | `q` |

---

## Redis KVM — Key Pattern

```
Key:   /{domain}/{entity}/{action}/{target}
Value: {interface_id}:{protocol}
```

**Protocol mapping:**
- `http` → CPI path `/http/dcrp/{resource}/{action_norm}/{id}`
- `soap` → CPI path `/cxf/dcrp/{resource}/{action_norm}/{id}`

**Content-Type auto-detection:**
- `http` → `application/json`
- `soap` → `text/xml; charset=utf-8`

---

## Stack

| Component | Version | Role |
|-----------|---------|------|
| Kong | 3.6 | API Gateway |
| Redis | 7-alpine | KVM / Route Store |
| Kubernetes | - | Orchestration |
| Istio | - | Service Mesh |
| Zero Trust | - | Security Layer |
| SAP CPI | BTP Trial | Integration Runtime |
| Newman | 6.2.2 | Load Testing |

---

## Files

| File | Description |
|------|-------------|
| `01-redis.yaml` | Redis deployment + service (namespace: sdia) |
| `02-kong-gdcr.yaml` | Kong deployment + GDCR plugin ConfigMap (handler v2.2) |
| `kong-cpi.yaml` | Kong declarative config pointing to SAP CPI |
| `handler-cpi-basic.lua` | GDCR Lua handler v2.2 (standalone reference) |
| `load_routes_zqhjk.bat` | Redis seed script — loads all 42 routes |
| `sdia-smoke-collection.json` | Newman Postman collection — 42 routes with correct bodies |
| `run-sdia-newman.bat` | Newman runner — smoke + 100k load test |

---

## Deploy

### 1. Namespace + Redis

```bash
kubectl apply -f 01-redis.yaml
```

### 2. Kong + GDCR Plugin

```bash
kubectl apply -f 02-kong-gdcr.yaml
kubectl rollout status deployment/kong -n sdia
```

### 3. Load Routes into Redis KVM

```bash
load_routes_zqhjk.bat
```

Verify:
```bash
kubectl exec -n sdia <redis-pod> -- redis-cli DBSIZE
# Expected: 42
```

### 4. Smoke Test — 42 Routes

```bash
newman run sdia-smoke-collection.json \
  --env-var "base_url=http://localhost:30800" \
  --reporters cli,json \
  --reporter-json-export sdia-smoke-results.json
```

### 5. Load Test — 100k Requests

```bash
newman run sdia-smoke-collection.json \
  --env-var "base_url=http://localhost:30800" \
  -n 2381 \
  --reporters cli,json \
  --reporter-json-export sdia-newman-100k-results.json
```

> 2381 iterations × 42 routes = **100,002 requests**

---

## 42 Routes — Domain Map

### SALES (13)
| Route | Protocol |
|-------|----------|
| /sales/orders/create/salesforce | http |
| /sales/orders/update/salesforceemea | http |
| /sales/orders/create/microsoft | soap |
| /sales/invoices/create/quickbooks | soap |
| /sales/invoices/create/s4hana | soap |
| /sales/payments/notify/stripe | http |
| /sales/payments/notify/s4hana | soap |
| /sales/customers/sync/shopify | http |
| /sales/customers/sync/s4hana | soap |
| /sales/deliveries/transfer/fedex | http |
| /sales/deliveries/transfer/s4hana | soap |
| /sales/returns/create/shopify | http |
| /sales/returns/create/s4hana | soap |

### FINANCES (10)
| Route | Protocol |
|-------|----------|
| /finances/invoices/create/quickbooks | soap |
| /finances/invoices/create/s4hana | soap |
| /finances/taxes/create/avalara | http |
| /finances/budgets/sync/workday | soap |
| /finances/expenses/create/coupa | http |
| /finances/payments/notify/stripe | http |
| /finances/payments/notify/s4hana | http |
| /finances/journals/create/sap | soap |
| /finances/accounts/sync/xero | http |
| /finances/receipts/update/concur | http |

### PROCUREMENT (10)
| Route | Protocol |
|-------|----------|
| /procurement/requisitions/create/ariba | soap |
| /procurement/pos/create/coupa | http |
| /procurement/rfqs/create/ariba | soap |
| /procurement/invoices/approve/basware | soap |
| /procurement/contracts/sync/jaggaer | http |
| /procurement/suppliers/sync/ivalua | http |
| /procurement/catalogs/update/tradeshift | http |
| /procurement/grns/create/wms | soap |
| /procurement/buyers/sync/oracle | http |
| /procurement/sourcings/query/ariba | soap |

### LOGISTICS (9)
| Route | Protocol |
|-------|----------|
| /logistics/shipments/create/fedex | http |
| /logistics/trackings/update/ups | http |
| /logistics/deliveries/create/dhl | soap |
| /logistics/shipments/query/fedex | http |
| /logistics/containers/sync/maersk | http |
| /logistics/warehouses/update/sf | soap |
| /logistics/freights/create/coyote | http |
| /logistics/routes/sync/project44 | http |
| /logistics/manifests/create/customs | soap |

---

## SAP BTP Trial

This entire implementation was built and validated using **SAP BTP Trial**.

- CPI Host: `{your-trial}.it-cpitrial05-rt.cfapps.us10-001.hana.ondemand.com`
- Authentication: Basic Auth (clientid:clientsecret from BTP service key)
- iFlow endpoint pattern: `/http/dcrp/{resource}/{action}/{id}` or `/cxf/dcrp/{resource}/{action}/{id}`

---

## Validation Results

| Metric | Result |
|--------|--------|
| Total Routes | 42 |
| Smoke Test | 42/42 ✅ |
| Load Test | 100,002 requests |
| Protocols | HTTP + SOAP |
| Domains | Sales, Finances, Procurement, Logistics |
| Runtime | SAP BTP Trial |

<img width="1757" height="715" alt="image" src="https://github.com/user-attachments/assets/65315bc9-8535-4fc3-8bb0-ec499eaed325" />

<img width="1005" height="732" alt="image" src="https://github.com/user-attachments/assets/53f304e1-471f-4869-b384-cab642bc6f7b" />

---

## SDIA Research

This implementation is part of the **SDIA (Semantic Domain Integration Architecture)** framework:

| Pillar | DOI |
|--------|-----|
| GDCR — Gateway Domain-Centric Routing | 10.5281/zenodo.18836272 |
| DDCR — Domain Driven Centric Router | 10.5281/zenodo.18864833 |
| ODCP — Orchestration Domain-Centric Pattern | 10.5281/zenodo.18876594 |
| SDIA — Semantic Domain Integration Architecture | Zenodo |

USPTO Trademark Application: **99680660** (GDCR™, DDCR™, ODCP™)

---

## Author

**Ricardo Luz Holanda Viana** — *The Commander*
Enterprise Integration Architect | SAP BTP Integration Suite Expert | SAP Press e-Bite Author
Warsaw, Poland

> Questions? Reach out. Happy to help. 🤝

---

*The domain never lies.* 🎯

