# GDCR Kong Plugins

This directory contains the Kong plugins used to validate the GDCR routing
model and URL generation in a controlled (mock) environment.

The plugins are designed for:
- Decoupling business routing from backend implementation
- Stress‑testing Kong with different storage backends (Lua table vs Redis)
- Verifying the GDCR interface ID pattern and URL construction

---

## Plugin Overview

The GDCR plugin runs in the access phase and performs the following steps:

1. Reads the incoming request path (for example `/sales/orders/create/salesforce`).  
2. Looks up the path in the GDCR routing table (Lua or Redis).  
3. Parses the `interfaceId:protocol` string (for example `gdcrorderscsalesforceid01:http`).  
4. Decomposes the path into `domain/resource/action/backend`.  
5. Normalizes the action (`create → c`, `update → u`, `sync → s`, etc.).  
6. Extracts the interface ID suffix (`id01`, `id02`, …).  
7. Builds a target URL in the format:  

   ```text
   https://cpi-host/{protocol}/gdcr/{resource}/{actionNorm}/{backend}/{idSuffix}
    ```
Returns a mock JSON response with all resolved fields and the generated URL.

- No real backend calls are executed in this mode.

Subdirectories
Typical layout:

lua-handler/
- Lua plugin using an in‑memory routing table.
- Optimized for small, static route sets and simple validation tests.

redis-handler/
- Lua plugin using Redis as the routing table backend.
- Optimized for large route sets and high‑volume stress tests.

routing-table/
- CSV files or documentation describing the canonical set of GDCR routes
- that both handlers consume.

Each subdirectory contains its own README file with more details and full
handler examples.

## Lua Handler (In‑Memory)

The Lua handler variant stores the routing table inside the plugin code
as a static Lua table.

Key points:

- Storage: in‑memory Lua table
- Use case: 33k message validation test
- Latency: ~12 ms (reference value from local tests)
- Scalability: approximately 100 routes per instance

Deployment example:
```text
bash
docker cp lua-handler/handler-lua-local.lua \
  kong-gateway:/usr/local/share/lua/5.1/kong/plugins/gdcr/handler.lua

docker restart kong-gateway
```

## Redis Handler (External Store)

The Redis handler variant reads the routing table from an external Redis
key‑value store.

Key points:

- Storage: Redis key‑value store (routePath → interfaceId:protocol)
- Use case: 1M message stress test
- Latency: ~12 ms (reference value with warm connection)
- Scalability: 10k+ routes, depending on Redis sizing

Deployment example:
```text
bash
# Load routes into Redis
docker exec -it redis redis-cli
SET "/sales/orders/create/salesforce" "gdcrorderscsalesforceid01:http"
SET "/sales/customers/sync/s4hana"    "gdcrcustomersss4hanaid07:cxf"
# ... load remaining routes

# Deploy handler
docker cp redis-handler/handler-redis.lua \
  kong-gateway:/usr/local/share/lua/5.1/kong/plugins/gdcr/handler.lua

docker restart kong-gateway
```

Mock Mode and Production Notes

- Both plugin variants currently operate in mock mode:
- Validate routing table entries
- Validate GDCR interface IDs and action normalization

Add error handling, timeouts, retries and logging as required by the
target landscape
