# Newman CLI Guide

Command-line test runner for Postman collections.

## 1. Prerequisites

Newman runs on **Node.js** (LTS recommended). If you do not have Node.js:
1. Go to the official Node.js website: [https://nodejs.org](https://nodejs.org)
2. Download the LTS installer for your OS and complete the setup.
3. Verify in a terminal:
   ```bash
   node -v
   npm -v
 ``
## Install Newman
**Install Newman globally with npm:**

```text
npm install -g newman
```

Verify the installation:

```text
newman --version
```
## 2. Dummy Postman Collection (Sample)
For quick tests, save this as sample-collection.json in your project folder.

```json
{
  "info": {
    "name": "GDCR Sample Collection",
    "_postman_id": "00000000-0000-0000-0000-000000000000",
    "schema": "[https://schema.getpostman.com/json/collection/v2.1.0/collection.json](https://schema.getpostman.com/json/collection/v2.1.0/collection.json)"
  },
  "item": [
    {
      "name": "Healthcheck",
      "request": {
        "method": "GET",
        "url": {
          "raw": "http://localhost:8000/sales/orders/create/salesforce",
          "protocol": "http",
          "host": ["localhost"],
          "port": "8000",
          "path": ["sales", "orders", "create", "salesforce"]
        }
      }
    }
  ]
}
```

Run it once:

```text
newman run sample-collection.json
```

## 3. Basic Newman Usage

Run a collection:

```text
newman run collection.json
```



## 4. Example Load Profiles
## 4.1 Single Pass (Smoke Test)
Bash
```text
newman run collection.json -n 1 -r cli
```
## 4.2 50k Requests
Assuming 25 requests per iteration:
```text
newman run collection.json -n 2000 -r cli > results-50k.txt
```

## 4.3 200k Requests

```text
newman run collection.json -n 8000 -r cli > results-200k.txt
```

## 4.4 1M Requests (Stress Test)
```text
newman run collection.json -n 40000 -r cli > results-1M.txt
```

## 5. Lua Local Handler Test

Test Kong using the in-memory Lua routing table.

## 5.1 Setup
```text
# Deploy Lua local handler into Kong
docker cp handler-lua-local.lua \
  kong-gateway:/usr/local/share/lua/5.1/kong/plugins/gdcr/handler.lua

docker restart kong-gateway
sleep 30
```

## 5.2 Run Test
```text
newman run collection.json -n 1200 -r cli > lua-local-33k.txt
```

## 6. Redis Handler Test
Test Kong using Redis as the routing store.

## 6.1 Setup
```text
# Load routes into Redis
docker exec -it redis redis-cli
SET "/sales/orders/create/salesforce" "gdcrorderscsalesforceid01:http"
SET "/sales/customers/sync/s4hana"    "gdcrcustomersss4hanaid07:cxf"
```

# Deploy Redis handler into Kong
```text
docker cp handler-redis.lua \
  kong-gateway:/usr/local/share/lua/5.1/kong/plugins/gdcr/handler.lua

docker restart kong-gateway
sleep 30
```
## 6.2 Run Test
```text
newman run collection.json -n 40000 -r cli > redis-1M.txt
```

## 7. Quick Reference Summary
Node.js: https://nodejs.org/

Install: npm install -g newman

Run: newman run collection.json

Scale: Increase -n for load tests (2k, 8k, 40k).

Save: Redirect output to a file for long runs: > results.txt
---
## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** 10.5281/zenodo.xxxxx  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
