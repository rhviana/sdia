-- SDIA GDCR Handler v2.1 — SAP CPI Real Integration
-- Basic Auth — clientid:clientsecret
-- Ricardo Luz Holanda Viana | March 2026

local redis = require "resty.redis"

local CPI_HOST = "282cc9datrial.it-cpitrial05-rt.cfapps.us10-001.hana.ondemand.com"
local BASIC_AUTH = "Basic c2ItNWY1ZjRlZGQtM2FmZi00NGNkLWIyMTItODljNjgwNTI3M2Y2IWI2MDE0NzB8aXQtcnQtMjgyY2M5ZGF0cmlhbCFiMjY2NTU6N2JmNDY2MGUtNzgyZS00NjNkLTllZjktMWJiYTRhMzEzYWE2JHdzUGtzektOQnJSU1ItSjB0NWhodE03cGZXZXp0d3FSV2tidG90U29MZFE9"

local ACTION_MAP = {
  create = "c", post = "c", insert = "c",
  read   = "r", get  = "r", retrieve = "r",
  update = "u", put  = "u", modify   = "u",
  delete = "d", remove = "d",
  sync   = "s", synchronize = "s",
  transfer = "t", send = "t",
  notify = "n", notification = "n",
  approve = "a", authorize = "a",
  query  = "q", search = "q",
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
  local ok, err = red:connect("redis-service.sdia.svc.cluster.local", 6379)
  if not ok then
    return nil, "redis connect failed: " .. (err or "")
  end
  local val = red:get(path)
  if not val or val == ngx.null then
    return nil, "route not found in KVM"
  end
  return val
end

local GdcrHandler = {
  PRIORITY = 1000,
  VERSION  = "2.1.0",
}

function GdcrHandler:access(conf)
  local path = ngx.var.uri

  -- Stage 1: Domain Inference
  local parts    = split_path(path)
  local domain   = parts[1]
  local resource = parts[2]
  local action   = parts[3]
  local backend  = parts[4]

  -- Stage 2: Validate
  if not domain or not resource or not action or not backend then
    return kong.response.exit(400, {
      status  = "error",
      message = "invalid semantic URL",
      path    = path,
    })
  end

  -- Stage 3: Fast Fail
  local route_value, err = redis_get(path)
  if not route_value then
    return kong.response.exit(404, {
      status  = "error",
      message = err or "route not found in KVM",
      path    = path,
    })
  end

  -- Stage 4: Normalize
  local action_norm = ACTION_MAP[action:lower()] or action:sub(1, 1)

  -- Stage 5: Parse
  local interface_id, protocol = route_value:match("^(.+):(.+)$")

  -- Stage 6: Extract id
  local id_suffix = interface_id:match("(id%d+)$")

-- Stage 7: Set CPI target
ngx.log(ngx.ERR, "SDIA DEBUG cpi_path=", cpi_path, " protocol=", protocol, " interface_id=", interface_id, " id_suffix=", id_suffix)
local prefix = (protocol == "soap") and "cxf" or "http"
local cpi_path = string.format("/%s/dcrp/%s/%s/%s",
    prefix, resource, action_norm, id_suffix)

kong.service.set_target(CPI_HOST, 443)
kong.service.request.set_path(cpi_path)
kong.service.request.set_header("Authorization", BASIC_AUTH)
kong.service.request.set_header("X-SDIA-Domain", domain)
kong.service.request.set_header("X-SDIA-Version", "2.1.0")
kong.service.request.set_header("X-SDIA-Interface", interface_id)
kong.service.request.set_header("Content-Type", "application/json")
end

return GdcrHandler
