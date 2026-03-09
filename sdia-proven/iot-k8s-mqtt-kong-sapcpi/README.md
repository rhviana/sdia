# SDIA — Semantic Domain Integration Architecture
## IoT + MQTT + DDCR Engine + Kong K8s + SAP CPI

> **"The domain never lies."**
> Ricardo Luz Holanda Viana | March 2026

---

## What is this?

This repository proves that **DDCR (Domain Driven Centric Router)** is a deterministic, mathematical routing engine — completely agnostic to sender, protocol, and gateway.

It does not matter if the message comes from a REST client, a SOAP system, an IoT sensor publishing via MQTT, an LLM agent, or any other source. As long as there is a key in the database, the engine resolves. The domain routes. No ambiguity. No coupling. No failure.

**2 + 2 = 4. Eternal.**

```
SENDER                       DDCR ENGINE              DESTINATION
────────────────────────     ────────────────────      ──────────────────────────
ESP32 Temperature Sensor  →  Redis KVM lookup       →  SAP CPI iFlow (HTTP)
factory/line-a/conveyor/     /sales/orders/             /http/dcrp/orders/c/id01
  temperature                create/salesforce

REST Client               →  Redis KVM lookup       →  SAP CPI iFlow (HTTP)
/sales/orders/               /sales/orders/             /http/dcrp/orders/c/id01
  create/salesforce           create/salesforce

SOAP System               →  Redis KVM lookup       →  SAP CPI iFlow (SOAP)
/sales/orders/               /sales/orders/             /cxf/dcrp/orders/c/id05
  create/microsoft            create/microsoft

LLM Agent                 →  Redis KVM lookup       →  SAP CPI iFlow (HTTP)
/sales/orders/               /sales/orders/             /http/dcrp/orders/c/id01
  create/salesforce           create/salesforce
```

The sender never knows the destination. The destination never knows the sender. The DDCR Engine is the only truth — and the truth lives in the KVM.

### Why it never fails

DDCR is not AI. It is not probabilistic. It is not heuristic.

It is a 7-stage deterministic engine. Given the same input, it always produces the same output. There is no ambiguity in the routing decision. The key exists in Redis or it does not. The protocol is http or soap. The path is built by a formula. Mathematics does not fail.

```
IoT Sensor (MQTT)          REST Client            SOAP System
      |                        |                       |
      v                        v                       v
factory/line-a/conveyor/   /sales/orders/         /finances/
  temperature                create/salesforce       invoices/
      |                        |                       |
      +------------------------+-----------------------+
                               |
                               v
                    +-----------------------+
                    |    DDCR Engine        |
                    |    Kong K8s Plugin    |
                    |    Lua Handler v2.2   |
                    +-----------+-----------+
                                |
                    +-----------+-----------+
                    |    Redis KVM          |
                    |    Route Store        |
                    |    42 Routes          |
                    +-----------+-----------+
                                |
                    +-----------+-----------+
                    |    SAP CPI            |
                    |    42 iFlows          |
                    |    HTTP + SOAP        |
                    +-----------------------+
```

---

## Architecture — DDCR 7-Stage Engine

```
 REQUEST: POST /sales/orders/create/salesforce
 PAYLOAD: {"sensor":"temperature","value":22.5,"unit":"C"}

 +-------+--------------------------------------------------+
 | Stage | Action                                           |
 +-------+--------------------------------------------------+
 |   1   | Domain Inference                                 |
 |       | Parse /{domain}/{entity}/{action}/{target}       |
 |       | domain=sales, entity=orders,                     |
 |       | action=create, target=salesforce                 |
 +-------+--------------------------------------------------+
 |   2   | Validate                                         |
 |       | 4 segments required → 400 if incomplete          |
 +-------+--------------------------------------------------+
 |   3   | Fast Fail — Redis KVM Lookup                     |
 |       | GET /sales/orders/create/salesforce              |
 |       | → gdcrorderscSalesforceid01:http                 |
 |       | → 404 if not found                               |
 +-------+--------------------------------------------------+
 |   4   | Normalize Action                                 |
 |       | create → c                                       |
 |       | ACTION_MAP: create|post|insert → c               |
 |       |             sync|synchronize   → s               |
 |       |             notify             → n               |
 |       |             approve            → a               |
 |       |             query|search       → q               |
 +-------+--------------------------------------------------+
 |   5   | Parse Redis Value                                |
 |       | gdcrorderscSalesforceid01:http                   |
 |       | interface_id = gdcrorderscSalesforceid01         |
 |       | protocol     = http                              |
 +-------+--------------------------------------------------+
 |   6   | Extract ID Suffix                                |
 |       | id01 → used in CPI path                         |
 +-------+--------------------------------------------------+
 |   7   | Build CPI Path + Forward                         |
 |       | http → /http/dcrp/orders/c/id01                 |
 |       | soap → /cxf/dcrp/orders/c/id01                  |
 |       | Content-Type auto: json or text/xml              |
 +-------+--------------------------------------------------+
```

---

## IoT Topic → DDCR → CPI Path

The sender (IoT device) knows nothing about SAP, Salesforce, Quickbooks or any backend system. It publishes to a semantic industrial topic. DDCR resolves the rest.

```
 MQTT TOPIC                              KONG PATH                        CPI PATH
 ─────────────────────────────────────── ──────────────────────────────── ────────────────────────────
 factory/line-a/conveyor/temperature  →  /sales/orders/create/salesforce  → /http/dcrp/orders/c/id01
 factory/line-c/motor/vibration       →  /sales/orders/create/microsoft   → /cxf/dcrp/orders/c/id05
 factory/line-a/welder/voltage        →  /sales/invoices/create/quickbooks → /cxf/dcrp/invoices/c/id09
 factory/line-b/pump/current          →  /sales/invoices/create/s4hana    → /cxf/dcrp/invoices/c/id10
 facility/building-a/meter/power      →  /finances/invoices/create/qbooks → /cxf/dcrp/invoices/c/id01
 facility/building-a/air/co2          →  /finances/taxes/create/avalara   → /http/dcrp/taxes/c/id10
 warehouse/zone-a/shelf/stock-level   →  /procurement/requisitions/create → /cxf/dcrp/requisitions/c/id01
 warehouse/zone-b/dock/capacity       →  /procurement/pos/create/coupa    → /http/dcrp/pos/c/id02
 fleet/truck-01/gps/location          →  /logistics/shipments/create/fedex → /http/dcrp/shipments/c/id01
 fleet/truck-02/telematics/eta        →  /logistics/trackings/update/ups  → /http/dcrp/trackings/u/id02
 fleet/customs/checkpoint/clearance   →  /logistics/manifests/create/cust → /cxf/dcrp/manifest/c/id09
```

---

## Environments Simulated

### 🏭 FACTORY — Industrial Equipment (13 sensors)
```
factory/line-a/conveyor/temperature     → conveyor belt thermal monitoring
factory/line-b/press/temperature        → hydraulic press thermal control
factory/line-c/motor/vibration          → motor vibration anomaly detection
factory/line-a/welder/voltage           → welding station voltage monitoring
factory/line-b/pump/current             → pump current draw monitoring
factory/line-a/turbine/rpm              → turbine rotational speed
factory/line-c/compressor/pressure      → compressor pressure monitoring
factory/line-b/robot/torque             → robotic arm torque sensor
factory/line-a/cnc/spindle-speed        → CNC spindle speed control
factory/line-c/oven/temperature         → industrial oven thermal control
factory/line-b/mixer/speed              → mixer speed monitoring
factory/line-a/scale/weight             → production line weight sensor
factory/line-c/valve/flow               → flow control valve monitoring
```

### 🏢 FACILITY — Building & Energy (10 sensors)
```
facility/building-a/meter/power         → power consumption meter
facility/building-b/meter/energy        → energy usage monitoring
facility/building-a/air/co2             → air quality CO2 sensor
facility/building-b/hvac/noise          → HVAC noise level monitoring
facility/building-c/ups/battery-level   → UPS battery level
facility/building-a/solar/signal        → solar inverter signal strength
facility/building-b/generator/frequency → generator frequency stability
facility/building-c/transformer/temp    → transformer thermal monitoring
facility/building-a/water/flow-rate     → water flow rate monitoring
facility/building-b/tank/level          → liquid tank level sensor
```

### 🏬 WAREHOUSE — Stock & Logistics (10 sensors)
```
warehouse/zone-a/shelf/stock-level      → RFID shelf stock level
warehouse/zone-b/dock/capacity          → loading dock capacity
warehouse/zone-c/cold-room/temperature  → cold room temperature (-18°C)
warehouse/zone-a/conveyor/weight        → conveyor weight threshold
warehouse/zone-b/server-room/uptime     → server room uptime monitoring
warehouse/zone-c/loading-bay/occupancy  → loading bay occupancy
warehouse/zone-a/shelf/availability     → shelf availability RFID
warehouse/zone-b/receiving/units-scanned → receiving dock barcode scanner
warehouse/zone-c/forklift/battery       → forklift battery monitoring
warehouse/zone-a/market/spot-price      → market spot price monitor
```

### 🚛 FLEET — Vehicles & Transport (9 sensors)
```
fleet/truck-01/gps/location             → GPS real-time location + speed
fleet/truck-02/telematics/eta           → ETA calculation telemetry
fleet/van-03/door/status                → delivery van door sensor
fleet/truck-04/scanner/barcode          → shipment barcode scanner
fleet/ship-01/container/seal-integrity  → container seal integrity
warehouse/zone-b/rack/occupancy         → warehouse rack occupancy
fleet/truck-05/load/weight              → freight load weight sensor
fleet/truck-06/telematics/route-deviation → route deviation monitoring
fleet/customs/checkpoint/clearance-status → customs clearance gate
```

---

## Redis KVM — Route Store

```
Key pattern:   /{domain}/{entity}/{action}/{target}
Value pattern: {interface_id}:{protocol}

Example entries:
  /sales/orders/create/salesforce      →  gdcrorderscSalesforceid01:http
  /sales/orders/create/microsoft       →  gdcrorderscMicrosoftid05:soap
  /procurement/requisitions/create/ariba → gdcrrequisitionscAribaid01:soap
  /logistics/manifests/create/customs  →  gdcrmanifestscCustomsid09:soap
  /finances/taxes/create/avalara       →  gdcrtaxescAvalaraid10:http

Protocol routing:
  http  →  Content-Type: application/json  →  /http/dcrp/{entity}/{action}/{id}
  soap  →  Content-Type: text/xml          →  /cxf/dcrp/{entity}/{action}/{id}
```

---

## Stack

```
+------------------+----------+------------------------------------------+
| Component        | Version  | Role                                     |
+------------------+----------+------------------------------------------+
| Kong             | 3.6      | API Gateway + DDCR Plugin host           |
| Redis            | 7-alpine | KVM — Semantic Route Store               |
| Mosquitto        | 2.0      | MQTT Broker                              |
| Node-RED         | 3.1      | IoT Bridge (MQTT → HTTP)                 |
| Python           | 3.14     | IoT Sensor Simulator + Load Tester       |
| Kubernetes       | -        | Container Orchestration                  |
| Istio            | -        | Service Mesh                             |
| Zero Trust       | -        | Security Layer                           |
| SAP CPI          | BTP Trial| Integration Runtime — 42 iFlows          |
| SAP APIM         | BTP Trial| API Management Layer                     |
| Newman           | 6.2.2    | REST Load Testing                        |
+------------------+----------+------------------------------------------+
```

---

## Files

```
sdia-k8s/
├── 01-redis.yaml                  # Redis deployment + service
├── 02-kong-gdcr.yaml              # Kong + GDCR plugin (handler v2.2)
├── 03-iot-mqtt.yaml               # Mosquitto + Node-RED deployment
├── kong-cpi.yaml                  # Kong declarative config → SAP CPI
├── handler-cpi-basic.lua          # GDCR Lua handler v2.2 (reference)
├── load_routes_zqhjk.bat          # Redis seed — 42 routes
├── sdia-smoke-collection.json     # Newman collection — 42 routes
├── run-sdia-newman.bat            # Newman runner (smoke + 100k)
├── sdia-iot-publisher.py          # IoT simulator — MQTT + HTTP load test
└── README.md                      # This file
```

---

## Deploy

### 1. Namespace + Redis
```bash
kubectl apply -f 01-redis.yaml
```

### 2. Kong + DDCR Plugin
```bash
kubectl apply -f 02-kong-gdcr.yaml
kubectl rollout status deployment/kong -n sdia
```

### 3. IoT Stack — Mosquitto + Node-RED
```bash
kubectl apply -f 03-iot-mqtt.yaml
kubectl rollout status deployment/mosquitto -n sdia
kubectl rollout status deployment/nodered -n sdia
```

### 4. Load Routes into Redis KVM
```bash
load_routes_zqhjk.bat
kubectl exec -n sdia <redis-pod> -- redis-cli DBSIZE
# Expected: 42
```

### 5. REST Smoke Test — 42 Routes
```bash
newman run sdia-smoke-collection.json \
  --env-var "base_url=http://localhost:30800" \
  --reporters cli
```

### 6. REST Load Test — 100k Requests
```bash
newman run sdia-smoke-collection.json \
  --env-var "base_url=http://localhost:30800" \
  -n 2381 \
  --reporters cli
# 2381 iterations x 42 routes = 100,002 requests
```

### 7. IoT Smoke Test — 42 Sensors
```bash
pip install paho-mqtt requests
python sdia-iot-publisher.py load 1
```

### 8. IoT Load Test — 100k Messages
```bash
python sdia-iot-publisher.py load 2381
# 2381 iterations x 42 sensors = 100,002 messages
```

---

## Ports

```
Kong Proxy    →  localhost:30800
Kong Admin    →  localhost:30801
Mosquitto     →  localhost:31883
Node-RED UI   →  localhost:31880
Redis         →  internal: redis-service.sdia.svc.cluster.local:6379
```

---

## Validation Results

```
+------------------+------------------+------------------+
| Test             | Requests         | Failed           |
+------------------+------------------+------------------+
| REST Smoke       |               42 |                0 |
| REST Load 100k   |          100,002 |                0 |
| IoT Smoke        |               42 |                0 |
| IoT Load 100k    |          100,002 |                0 |
+------------------+------------------+------------------+
| TOTAL            |          200,088 |                0 |
+------------------+------------------+------------------+
| SAP BTP 24h      |          200,833 |                0 |
+------------------+------------------+------------------+

Average response time: 144ms
Min: 123ms | Max: 5s | Std dev: 41ms
Runtime: SAP BTP Trial
Protocols: HTTP + SOAP
Domains: Sales, Finances, Procurement, Logistics
```
<img width="1012" height="1018" alt="image" src="https://github.com/user-attachments/assets/77233430-8594-44b6-8d19-69d231ca4963" />
---

## SDIA Research — Published

| Pillar | Description | DOI |
|--------|-------------|-----|
| GDCR | Gateway Domain-Centric Routing | 10.5281/zenodo.18836272 |
| DDCR | Domain Driven Centric Router | 10.5281/zenodo.18864833 |
| ODCP | Orchestration Domain-Centric Pattern | 10.5281/zenodo.18876594 |
| SDIA | Semantic Domain Integration Architecture | Zenodo |

USPTO Trademark Application: **99680660** (GDCR™, DDCR™, ODCP™)

---

## SAP BTP Trial

This entire implementation runs on **SAP BTP Trial** — free tier.

```
CPI Host:  {your-trial}.it-cpitrial05-rt.cfapps.us10-001.hana.ondemand.com
APIM Host: {your-trial}-trial.integrationsuitetrial-apim.us10.hana.ondemand.com
Auth:      Basic Auth (clientid:clientsecret from BTP service key)
iFlows:    /http/dcrp/{resource}/{action}/{id}
           /cxf/dcrp/{resource}/{action}/{id}
```

Want to test? Create a free SAP BTP Trial account at [https://www.sap.com/products/technology-platform/trial.html](https://www.sap.com/products/technology-platform/trial.html)

---

## Author

**Ricardo Luz Holanda Viana** — *The Commander*
Enterprise Integration Architect | SAP BTP Integration Suite Expert | SAP Press e-Bite Author
Warsaw, Poland

Questions? Reach out. Happy to help. 🤝

---

*The domain never lies.* 🎯



