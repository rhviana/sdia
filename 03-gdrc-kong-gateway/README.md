# Kong GDCR Gateway - Dynamic Routing Engine

High-performance API gateway implementing GDCR (Generic Dynamic Connector Routing) v15.3 pattern on Kong Gateway.

## Architecture

```text
════════════════════════════════════════════════════════════════════════════════════════════
                     KONG GDCR GATEWAY - MOCK VALIDATION TESTS
════════════════════════════════════════════════════════════════════════════════════════════

┌─────────────────────────────────────────┐     ┌─────────────────────────────────────────┐
│     TEST 1: LUA ROUTING TABLE (30k)     │     │      TEST 2: REDIS KV STORE (1M)        │
│        Hard-coded routing logic         │     │        External routing store           │
└─────────────────────────────────────────┘     └─────────────────────────────────────────┘
             │                                               │
             v                                               v
┌─────────────────────────┐                     ┌─────────────────────────┐
│      Kong Gateway       │                     │      Kong Gateway       │
│        (Docker)         │                     │        (Docker)         │
└─────────────────────────┘                     └─────────────────────────┘
             │                                               │
             v                                               v
┌─────────────────────────┐                     ┌─────────────────────────┐
│       GDCR Plugin       │                     │       GDCR Plugin       │
│     handler-lua.lua     │                     │    handler-redis.lua    │
│                         │                     │                         │
│      Routing Table      │                     │      Redis KV Store     │
│  ┌───────────────────┐  │                     │  ┌───────────────────┐  │
│  │ Sales:    15      │  │                     │  │ Redis: 6379       │  │
│  │ Finance:  10      │  │                     │  │ 25 keys           │  │
│  └───────────────────┘  │                     │  └───────────────────┘  │
└─────────────────────────┘                     └─────────────────────────┘
             │                                               │
             v                                               v
┌─────────────────────────┐                     ┌─────────────────────────┐
│      Routing Logic      │                     │      Routing Logic      │
│  1. Route Lookup        │                     │  1. Redis GET           │
│  2. Parse Path          │                     │  2. Parse Path          │
│  3. Build URL           │                     │  3. Build URL           │
│  4. Mock Response       │                     │  4. Mock Response       │
└─────────────────────────┘                     └─────────────────────────┘
             │                                               │
             v                                               v
┌─────────────────────────┐                     ┌─────────────────────────┐
│       Newman Test       │                     │       Newman Test       │
│    1,200 iterations     │                     │    40,000 iterations    │
│    25 routes            │                     │    25 routes            │
│    = 30,000 requests    │                     │    = 1,000,000 reqs     │
└─────────────────────────┘                     └─────────────────────────┘
             │                                               │
             v                                               v
┌─────────────────────────┐                     ┌─────────────────────────┐
│       RESULTS           │                     │       Newman Test       │
│    100% success         │                     │    100% success         │
│    ~15ms avg            │                     │     ~12ms avg           │
│    P99: 45ms            │                     │    = P99: 38ms          │
└─────────────────────────┘                     └─────────────────────────┘

════════════════════════════════════════════════════════════════════════════════════════════
  ⚠️ MOCK MODE: Validates routing logic + URL generation ONLY (NO backend integration)
════════════════════════════════════════════════════════════════════════════════════════════
```


## Test Results

| Metric | Lua Local (30k) | Redis (1M) |
|--------|-----------------|------------|
| Total Requests | 30,000 | 1,000,000 |
| Success Rate | 100% | 100% |
| Avg Latency | ~15ms | ~12ms |
| P95 Latency | 28ms | 25ms |
| P99 Latency | 45ms | 38ms |
| Duration | ~8min | ~16h |

## Comparison vs Other Platforms

| Platform | Requests | Avg Latency | Cost/Month |
|----------|----------|-------------|------------|
| SAP APIM (Phantom v14.2) | 73,000 | 68ms | Included in BTP |
| Kong (Lua Local) | 30,000 | 15ms | $0 (local) |
| Kong (Redis) | 1,000,000 | 12ms | $0 (local) |
| Apigee Intermediate | TBD | ~5-10ms | $1,460 |

## Quick Start

```bash
# Clone repo
git clone https://github.com/your-org/kong-gdcr-gateway.git
cd kong-gdcr-gateway

# Start Kong
docker-compose up -d

# Deploy plugin
docker cp plugin/handler-lua-local.lua kong-gateway:/usr/local/share/lua/5.1/kong/plugins/gdcr/handler.lua
docker restart kong-gateway

# Run test
newman run tests/postman/collection-30k.json -n 1200 -r cli
