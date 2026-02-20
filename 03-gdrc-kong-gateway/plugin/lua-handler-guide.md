Vamos separar em DOIS arquivos README diferentes, um para cada handler, bem simples:

1. lua-handler/README.md (para o handler que usa tabela Lua)
text
# Lua Handler

Kong GDCR plugin using an in-memory Lua routing table.

## Purpose

- 30k message validation test  
- Static routing table embedded in Lua code  
- Target size: up to ~100 routes

## Routing Table

The routing table is a Lua table:

```lua
local ROUTES = {
  ["/sales/orders/create/salesforce"] = "gdcrorderscsalesforceid01:http",
  ["/sales/customers/sync/s4hana"]    = "gdcrcustomersss4hanaid07:cxf",
  -- ... 25 routes total
}
```
## Core Logic
The handler reads the route, parses the GDCR interface ID, normalizes the
action and builds a mock target URL.

```lua
lua
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

local GdcrHandler = {
  PRIORITY = 1000,
  VERSION  = "1.0.0",
}

function GdcrHandler:access(conf)
  local path = ngx.var.uri

  -- 1. Lookup route in Lua table
  local route_value = ROUTES[path]
  if not route_value then
    return kong.response.exit(404, {
      status  = "error",
      message = "route not found",
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

```text
bash
docker cp lua-handler/handler-lua-local.lua \
  kong-gateway:/usr/local/share/lua/5.1/kong/plugins/gdcr/handler.lua

docker restart kong-gateway
```



