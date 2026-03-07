# SDIA for Kubernetes
### Semantic Domain Integration Architecture — K8s Validation

> **"Technology changes by the quarter. Business processes last for decades. The domain never lies."**
> — Ricardo Luz Holanda Viana

---

## What is this?

This repository contains the **first validated implementation of SDIA (Semantic Domain Integration Architecture) running on Kubernetes** — using Kong as the GDCR gateway and Redis as the KVM metadata store.

**One command. One semantic address. Zero backend knowledge.**

```
POST /sales/orders/create/salesforce
```

That is all the consumer ever sees. Domain governs everything else.

---

## Results

| Test | Result |
|------|--------|
| `POST /sales/orders/create/salesforce` | ✅ Routed — `id01` — `action_norm: c` |
| `POST /finance/payments/transfer/stripe` | ✅ Routed — `id11` — `action_norm: t` |
| `POST /hr/employees/sync/successfactors` | ✅ Routed — `id31` — `action_norm: s` |
| `POST /unknown/entity/action/target` | ✅ Fast Fail — `route not found` |
| KVM source | `redis-k8s` |
| Platform | Kubernetes v1.34.1 (Docker Desktop) |

---

## Architecture

```
Consumer
    │
    │  POST /sales/orders/create/salesforce
    ▼
┌─────────────────────────────────────────┐
│  Kong Gateway (NodePort 30800)          │
│  Namespace: sdia                        │
│                                         │
│  ┌──────────────────────────────────┐   │
│  │  GDCR Plugin (handler.lua)       │   │
│  │                                  │   │
│  │  Stage 1 — Domain Inference      │   │
│  │  Stage 2 — Validate Segments     │   │
│  │  Stage 3 — Route Guard (FastFail)│   │
│  │  Stage 4 — Normalize Action      │   │
│  │  Stage 5 — Parse Interface ID    │   │
│  │  Stage 6 — Extract ID Suffix     │   │
│  │  Stage 7 — Build URL + Dispatch  │   │
│  └──────────────┬───────────────────┘   │
└─────────────────┼───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  Redis KVM (redis-service:6379)         │
│  Namespace: sdia                        │
│                                         │
│  KEY: /sales/orders/create/salesforce   │
│  VAL: gdcrorderscsalesforceid01:http    │
└─────────────────────────────────────────┘
                  │
                  ▼
        Backend (resolved by metadata)
        Never hardcoded. Never exposed.
```

---

## Stack

| Component | Technology | Role |
|-----------|-----------|------|
| Gateway | Kong 3.6 | GDCR semantic facade |
| Resolution Engine | GDCR Plugin (Lua) | 7-stage deterministic router |
| KVM Store | Redis 7 | Metadata — passive routing table |
| Orchestrator | Kubernetes v1.34.1 | Container platform |
| Local Cluster | Docker Desktop | Development environment |

---

## Quick Start

### Prerequisites
- Docker Desktop with Kubernetes enabled
- `kubectl` installed

### 1. Create namespace + Redis

```cmd
kubectl apply -f 01-redis.yaml
```

### 2. Deploy Kong + GDCR Plugin

```cmd
kubectl apply -f 02-kong-gdcr.yaml
```

### 3. Verify pods are running

```cmd
kubectl get pods -n sdia
```

Expected:
```
NAME                     READY   STATUS    RESTARTS   AGE
kong-67cc5f8547-zzj2r    1/1     Running   0          88s
redis-794bb58794-f7bmk   1/1     Running   0          11m
```

### 4. Load semantic routes into Redis KVM

```cmd
kubectl exec -n sdia <redis-pod-name> -- redis-cli SET "/sales/orders/create/salesforce"   "gdcrorderscsalesforceid01:http"
kubectl exec -n sdia <redis-pod-name> -- redis-cli SET "/sales/customers/sync/s4hana"      "gdcrcustomersss4hanaid07:cxf"
kubectl exec -n sdia <redis-pod-name> -- redis-cli SET "/finance/payments/transfer/stripe" "gdcrpaymentstStripeid11:http"
kubectl exec -n sdia <redis-pod-name> -- redis-cli SET "/procurement/orders/create/ariba"  "gdcrorderscAribaid21:http"
kubectl exec -n sdia <redis-pod-name> -- redis-cli SET "/hr/employees/sync/successfactors" "gdcremployeessSFid31:http"
```

### 5. Test semantic routing

```cmd
curl -X POST http://localhost:30800/sales/orders/create/salesforce
curl -X POST http://localhost:30800/finance/payments/transfer/stripe
curl -X POST http://localhost:30800/unknown/entity/action/target
```

---

## Semantic URL Pattern

```
/{domain}/{entity}/{action}/{target}
   │         │        │        │
   │         │        │        └── Backend system (Salesforce, SAP, Stripe...)
   │         │        └─────────── Business action (create, read, sync, transfer...)
   │         └──────────────────── Business entity (orders, payments, employees...)
   └────────────────────────────── Business domain (sales, finance, hr, procurement...)
```

**The consumer address never changes. The backend can change at any time — zero redeployment.**

---

## Action Normalization

| Input | Normalized | Meaning |
|-------|-----------|---------|
| `create`, `post`, `insert` | `c` | Create |
| `read`, `get`, `retrieve` | `r` | Read |
| `update`, `put`, `modify` | `u` | Update |
| `delete`, `remove` | `d` | Delete |
| `sync`, `synchronize` | `s` | Synchronize |
| `transfer`, `send` | `t` | Transfer |
| `notify`, `notification` | `n` | Notify |

---

## Fast Fail Contract

Invalid intent never reaches the backend.

```json
{
  "status": "error",
  "message": "route not found in KVM",
  "path": "/unknown/entity/action/target",
  "hint": "register route in Redis KVM first"
}
```

- HTTP 400 — invalid semantic URL structure
- HTTP 404 — route not registered in KVM
- Rejection at Stage 3 — ~0.1ms
- Zero backend impact. Zero blast radius.

---

## Sample Response

```json
{
  "status": "success",
  "sdia_version": "1.0.0",
  "domain": "sales",
  "resource": "orders",
  "action": "create",
  "action_norm": "c",
  "backend": "salesforce",
  "interface_id": "gdcrorderscsalesforceid01",
  "protocol": "http",
  "generated_url": "https://cpi-host/http/gdcr/orders/c/salesforce/id01",
  "kvm_source": "redis-k8s"
}
```

---

## SDIA Invariant

> *Business domain semantics are the permanent governing layer across all integration patterns, protocols, platforms, and implementations. Technology is transient. The domain never lies.*

This K8s implementation proves the invariant holds across:

- ✅ SAP BTP Integration Suite — original validation — 1,499,869 requests — 0 failures
- ✅ Kong + Redis (local Docker) — 1M requests stress test
- ✅ Kubernetes v1.34.1 (this repository)
- ✅ Azure APIM (C# implementation)
- ✅ AWS API Gateway (Python implementation)

**Same semantic address. Same 7-stage engine. Same result. Any platform.**

---

## Prior Art & Publications

| Document | DOI / Record | IP.com |
|----------|-------------|--------|
| SDIA v1.0 | [zenodo.org/records/18877636](https://zenodo.org/records/18877636) | IPCOM000277630D |
| GDCR v6.0 | [doi.org/10.5281/zenodo.18582492](https://doi.org/10.5281/zenodo.18582492) | IPCOM000277632D |
| DDCR v1.0 | [zenodo.org/records/18864833](https://zenodo.org/records/18864833) | IPCOM000277633D |
| ODCP v1.0 | [zenodo.org/records/18876594](https://zenodo.org/records/18876594) | IPCOM000277631D |

---

## Author

**Ricardo Luz Holanda Viana**
Enterprise Integration Architect | SAP Press Author | Independent Researcher
ORCID: 0009-0009-9549-5862 | Warsaw, Poland

*Built alone. Published with evidence.*

---

## License

Creative Commons Attribution 4.0 International (CC BY 4.0)

Free for educational, research, and non-commercial use with attribution.
Commercial implementations permitted with attribution to original author.

---

*The domain never lies.*

<img width="1158" height="457" alt="image" src="https://github.com/user-attachments/assets/8871d781-5ad4-441d-8bc3-89998320df3c" />

C:\sdia-k8s>load_44_routes.bat
Loading 44 SDIA routes into Redis KVM...
Redis pod: redis-794bb58794-f7bmk

OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK
OK

Done! Verifying total keys:
46



sdia-k8s

Primeiro commando:

docker info | findstr /i kubernetes

<img width="1288" height="762" alt="image" src="https://github.com/user-attachments/assets/d66785a8-2dfe-4ce3-9904-452d4f315497" />

mkdir C:\sdia-k8s
cd C:\sdia-k8s

<img width="986" height="325" alt="image" src="https://github.com/user-attachments/assets/f5602d52-13f7-4b59-bd3d-84026cfb7110" />


kubectl apply -f C:\sdia-k8s\01-redis.yaml
kubectl apply -f C:\sdia-k8s\02-kong-gdcr.yaml

<img width="703" height="548" alt="image" src="https://github.com/user-attachments/assets/baec5870-7ca4-4bf9-8936-3f0417eaa7d1" />

kubectl apply -f C:\sdia-k8s\02-kong-gdcr.yaml

C:\sdia-k8s>kubectl get pods -n sdia
NAME                     READY   STATUS    RESTARTS   AGE
kong-67cc5f8547-zzj2r    1/1     Running   0          88s
redis-794bb58794-f7bmk   1/1     Running   0          11m

for /f %i in ('kubectl get pod -n sdia -l app=redis -o jsonpath="{.items[0].metadata.name}"') do set REDIS_POD=%i

kubectl exec -n sdia %REDIS_POD% -- redis-cli SET "/sales/orders/create/salesforce" "gdcrorderscsalesforceid01:http"
kubectl exec -n sdia %REDIS_POD% -- redis-cli SET "/sales/customers/sync/s4hana" "gdcrcustomersss4hanaid07:cxf"
kubectl exec -n sdia %REDIS_POD% -- redis-cli SET "/finance/payments/transfer/stripe" "gdcrpaymentstStripeid11:http"
kubectl exec -n sdia %REDIS_POD% -- redis-cli SET "/procurement/orders/create/ariba" "gdcrorderscAribaid21:http"
kubectl exec -n sdia %REDIS_POD% -- redis-cli SET "/hr/employees/sync/successfactors" "gdcremployeessSFid31:http"

C:\sdia-k8s>kubectl get pods -n sdia -l app=redis
NAME                     READY   STATUS    RESTARTS   AGE
redis-794bb58794-f7bmk   1/1     Running   0          14m


C:\sdia-k8s>kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/sales/orders/create/salesforce" "gdcrorderscsalesforceid01:http"
OK

C:\sdia-k8s>kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/sales/customers/sync/s4hana" "gdcrcustomersss4hanaid07:cxf"
OK

C:\sdia-k8s>kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/finance/payments/transfer/stripe" "gdcrpaymentstStripeid11:http"
OK

C:\sdia-k8s>kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/procurement/orders/create/ariba" "gdcrorderscAribaid21:http"
OK

C:\sdia-k8s>kubectl exec -n sdia redis-794bb58794-f7bmk -- redis-cli SET "/hr/employees/sync/successfactors" "gdcremployeessSFid31:http"
OK



C:\sdia-k8s>curl -X POST http://localhost:30800/unknown/entity/action/target
{"path":"/unknown/entity/action/target","message":"route not found","hint":"register route in Redis KVM first","status":"error"}
C:\sdia-k8s>curl -X POST http://localhost:30800/finance/payments/transfer/stripe
{"interface_id":"gdcrpaymentstStripeid11","domain":"finance","protocol":"http","sdia_version":"1.0.0","action":"transfer","backend":"stripe","resource":"payments","kvm_source":"redis-k8s","status":"success","generated_url":"https://cpi-host/http/gdcr/payments/t/stripe/id11","action_norm":"t"}
C:\sdia-k8s>curl -X POST http://localhost:30800/sales/orders/create/salesforce
{"interface_id":"gdcrorderscsalesforceid01","domain":"sales","protocol":"http","sdia_version":"1.0.0","action":"create","backend":"salesforce","resource":"orders","kvm_source":"redis-k8s","status":"success","generated_url":"https://cpi-host/http/gdcr/orders/c/salesforce/id01","action_norm":"c"}
C:\sdia-k8s>

## Newman result 44k messages:
<img width="692" height="1043" alt="image" src="https://github.com/user-attachments/assets/5a3315f3-a38a-4bcf-a420-2e41efa9917c" />



