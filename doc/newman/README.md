# Newman CLI Guide

Command-line test runner for Postman collections.

---

## 1. Prerequisites

Newman runs on Node.js (LTS recommended). If you do not have Node.js:

1. Go to the official Node.js website:  
   https://nodejs.org
2. Download the LTS installer for your OS and complete the setup (keep the default options).  
3. Verify in a terminal:
   ```bash
   node -v
   npm -v
   ```
If both commands print a version, Node.js and npm are installed correctly.

2. Install Newman
   
Install Newman globally with npm:

```bash
npm install -g newman
```

Verify the installation:
```bash
newman --version
```

You should see the Newman version printed in the terminal.

3. Dummy Postman Collection (Sample)
   
For quick tests, use a simple collection file. Save this as
sample-collection.json in the newman folder.
```bash
json
{
  "info": {
    "name": "GDCR Sample Collection",
    "_postman_id": "00000000-0000-0000-0000-000000000000",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
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

```bash
newman run sample-collection.json
```

This should hit your Kong GDCR route and print the mock response from the plugin.[web:92]

4. Basic Newman Usage
   
Run a collection:
```
newman run collection.json
```
Key options:

Option	Description	Example

-n <iterations>	Number of iterations	newman run collection.json -n 5
-r <reporter>	Reporter (default: cli)	-r cli
--delay-request	Delay between requests in ms	--delay-request 5
> file.txt	Redirect output to a file (shell)	... -r cli > results.txt

Example with 1,000 iterations and saved output:

```bash
newman run collection.json -n 1000 -r cli > results-1000.txt
```
5. Example Load Profiles
 
5.1 Single Pass (Smoke Test)

```bash
newman run collection.json -n 1 -r cli
```
1 iteration

Use case: quick validation / smoke test

5.2 50k Requests

Assuming 25 requests per iteration:

```bash
newman run collection.json -n 2000 -r cli > results-50k.txt
```
Total: ~50,000 requests

Use case: medium load / daily baseline

5.3 200k Requests

```bash
newman run collection.json -n 8000 -r cli > results-200k.txt
```
Total: ~200,000 requests

Use case: heavy load / weekly validation

5.4 1M Requests
bash
newman run collection.json -n 40000 -r cli > results-1M.txt
Total: ~1,000,000 requests

Use case: stress test / scalability validation

6. Lua Local Handler Test
   
Test Kong using the in‑memory Lua routing table (handler-lua-local.lua).

6.1 Setup
```bash
# Deploy Lua local handler into Kong
docker cp handler-lua-local.lua \
  kong-gateway:/usr/local/share/lua/5.1/kong/plugins/gdcr/handler.lua

docker restart kong-gateway
sleep 30
```
6.2 Run Test

Example: ~33k requests (25 routes × 1,200 iterations):

```bash
newman run collection.json -n 1200 -r cli > lua-local-33k.txt
```
Expected characteristics (reference only):

- Requests: ~33,600
- Storage: in‑memory Lua table
- Latency: around 15 ms average (depends on environment)

7. Redis Handler Test
   
Test Kong using Redis as the routing store (handler-redis.lua).

7.1 Setup

```bash
# Load routes into Redis
docker exec -it redis redis-cli
SET "/sales/orders/create/salesforce" "gdcrorderscsalesforceid01:http"
SET "/sales/customers/sync/s4hana"    "gdcrcustomersss4hanaid07:cxf"
# ... load all remaining routes
```
# Deploy Redis handler into Kong
```bash
docker cp handler-redis.lua \
  kong-gateway:/usr/local/share/lua/5.1/kong/plugins/gdcr/handler.lua
```
```bash
docker restart kong-gateway
sleep 30
```
7.2 Run Test

Example: 1M requests (25 routes × 40,000 iterations):

```bash
newman run collection.json -n 40000 -r cli > redis-1M.txt
```
Expected characteristics (reference only):

- Requests: ~1,000,000
- Storage: external Redis key-value store
- Latency: around 12–15 ms average (depends on environment)

8. Quick Reference
   
Install Node.js (LTS) from https://nodejs.org/

Install Newman globally: npm install -g newman

Run a collection: newman run collection.json

Increase -n for load tests (e.g. 2,000, 8,000, 40,000 iterations)

Redirect output to a file for long runs: > results.txt[web:87][web:94]
