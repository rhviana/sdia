# Redis Handler

Kong GDCR plugin using an external Redis key-value store for the routing table.

## Purpose

- 1M message stress test  
- Dynamic routing table loaded from Redis  
- Target size: 10k+ routes

## Redis Data Model

Routing entries are stored as:

```text

Key:   route path
Value: interfaceId:protocol

Example:

bash
SET "/sales/orders/create/salesforce" "gdcrorderscsalesforceid01:http"
SET "/sales/customers/sync/s4hana"    "gdcrcustomersss4hanaid07:cxf"
-- ... load all 25 routes
Core Logic
The handler uses the same GDCR parsing logic, but reads from Redis instead of
a local Lua table.

lua
local redis = require "resty.redis"

local ACTION_MAP = {
  create = "c", post = "c", insert = "c",
  read   = "r", get  = "r", retrieve = "r",
  update = "u", put  = "u", modify   = "u",
  delete = "d", remove = "d",
  sync   = "s", synchronize = "s",
  transfer = "t", send = "t",
  notify = "n", notification = "n",
}

local function split_path(path)
  local result = {}
  for segment in string.gmatch(path, "[^/]+") do
    table.insert(result, segment)
  end
  return result
end

local function redis_get(path)
  local red = redis:new()
  red:set_timeout(1000)

  local ok, err = red:connect("redis-host", 6379)
  if not ok then
    return nil, "failed to connect to redis: " .. (err or "")
  end

  local val, err = red:get(path)
  if not val or val == ngx.null then
    return nil, "route not found"
  end

  return val
end

local GdcrHandler = {
  PRIORITY = 1000,
  VERSION  = "1.0.0",
}

function GdcrHandler:access(conf)
  local path = ngx.var.uri

  -- 1. Lookup route in Redis
  local route_value, err = redis_get(path)
  if not route_value then
    return kong.response.exit(404, {
      status  = "error",
      message = err or "route not found",
      path    = path,
    })
  end

  -- 2. interfaceId:protocol
  local interface_id, protocol = route_value:match("^(.+):(.+)$")

  -- 3. /domain/resource/action/backend
  local parts    = split_path(path)
  local domain   = parts[1]
  local resource = parts[2]
  local action   = parts[3]
  local backend  = parts[4]

  -- 4. Normalize action
  local action_norm = ACTION_MAP[action:lower()] or action:sub(1, 1)

  -- 5. Extract id suffix
  local id_suffix = interface_id:match("(id%d+)$")

  -- 6. Build URL
  local target_url = string.format(
    "https://cpi-host/%s/gdcr/%s/%s/%s/%s",
    protocol, resource, action_norm, backend, id_suffix
  )

  -- 7. Mock response
  kong.response.exit(200, {
    status        = "success",
    test_mode     = "mock_url_generation",
    domain        = domain,
    resource      = resource,
    action        = action,
    action_norm   = action_norm,
    backend       = backend,
    interface_id  = interface_id,
    protocol      = protocol,
    generated_url = target_url,
  })
end

return GdcrHandler
```
## Deployment

# 1. Load routes into Redis
```luna
docker exec -it redis redis-cli
SET "/sales/orders/create/salesforce" "gdcrorderscsalesforceid01:http"
SET "/sales/customers/sync/s4hana"    "gdcrcustomersss4hanaid07:cxf"
-- load remaining routes
```
# 2. Deploy plugin
```luna
docker cp redis-handler/handler-redis.lua \
  kong-gateway:/usr/local/share/lua/5.1/kong/plugins/gdcr/handler.lua

docker restart kong-gateway
```
<img width="1442" height="620" alt="image" src="https://github.com/user-attachments/assets/44481af8-5b4e-49d9-9de0-15e4526347e8" />

