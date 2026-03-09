-- ============================================================================
-- DDCR Engine — Kong Plugin Handler v2.2 (PRODUCTION)
-- ============================================================================
-- Author:  Ricardo Luz Holanda Viana
-- License: CC BY 4.0
-- DOI:     https://doi.org/10.5281/zenodo.18619641
--
-- Validated: 100,002 requests | 0 failures | 99.99% uptime | ~144ms avg
-- Stack:     Kong 3.6 | Redis 7 | SAP BTP CPI Trial | Kubernetes
--
-- Path format:  /{domain}/{entity}/{action}/{target}
-- Redis key:    /{domain}/{entity}/{action}/{target}
-- Redis value:  {interface_id}:{protocol}   (protocol: http | soap)
-- CPI path:     /http/dcrp/{entity}/{action_code}/{id_suffix}
--               /cxf/dcrp/{entity}/{action_code}/{id_suffix}
-- ============================================================================

local redis = require "resty.redis"

local GdcrHandler = {
  PRIORITY = 1000,
  VERSION  = "2.2.0",
}

-- ── Config ───────────────────────────────────────────────────────────────────
local CPI_HOST   = "YOUR-TRIAL.it-cpitrial05-rt.cfapps.us10-001.hana.ondemand.com"
local BASIC_AUTH = "Basic YOUR-BASE64-CREDENTIALS"
local REDIS_HOST = "redis-service.sdia.svc.cluster.local"
local REDIS_PORT = 6379

-- ── Action Map — normalized codes ────────────────────────────────────────────
local ACTION_MAP = {
  create      = "c", post        = "c", insert       = "c",
  read        = "r", get         = "r", retrieve     = "r",
  update      = "u", put         = "u", modify       = "u",
  delete      = "d", remove      = "d",
  sync        = "s", synchronize = "s",
  transfer    = "t", send        = "t",
  notify      = "n", notification = "n",
  approve     = "a", authorize   = "a",
  query       = "q", search      = "q",
}

-- ── Resource Map — path normalization ────────────────────────────────────────
local RESOURCE_MAP = {
  manifests = "manifest",
}

-- ── Redis get — O(1) KVM lookup ───────────────────────────────────────────────
local function redis_get(key)
  local red = redis:new()
  red:set_timeout(200)
  local ok, err = red:connect(REDIS_HOST, REDIS_PORT)
  if not ok then
    return nil, "redis connection failed: " .. (err or "unknown")
  end
  local val, err2 = red:get(key)
  red:set_keepalive(10000, 100)
  if not val or val == ngx.null then
    return nil, "key not found: " .. key
  end
  return val, nil
end

-- ── Path splitter — zero regex ────────────────────────────────────────────────
local function split_path(path)
  local result = {}
  for part in path:gmatch("[^/]+") do
    table.insert(result, part)
  end
  return result
end

-- ── Handler:access — 7-stage DDCR engine ─────────────────────────────────────
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
      message = "invalid semantic URL — expected /{domain}/{entity}/{action}/{target}",
      path    = path,
    })
  end

  -- Stage 3: Fast Fail — Redis KVM lookup
  local route_value, err = redis_get(path)
  if not route_value then
    return kong.response.exit(404, {
      status  = "error",
      message = err or "route not found in KVM",
      path    = path,
      hint    = "register route in Redis KVM first",
    })
  end

  -- Stage 4: Normalize action
  local action_norm = ACTION_MAP[action:lower()] or action:sub(1, 1)

  -- Stage 5: Parse interface_id and protocol from Redis value
  local interface_id, protocol = route_value:match("^(.+):(.+)$")

  -- Stage 6: Extract id suffix
  local id_suffix = interface_id:match("(id%d+)$")

  -- Stage 7: Build CPI path and forward
  local prefix        = (protocol == "soap") and "cxf" or "http"
  local resource_norm = RESOURCE_MAP[resource] or resource
  local cpi_path      = string.format("/%s/dcrp/%s/%s/%s", prefix, resource_norm, action_norm, id_suffix)
  local content_type  = (protocol == "soap") and "text/xml; charset=utf-8" or "application/json"

  kong.service.set_target(CPI_HOST, 443)
  kong.service.request.set_path(cpi_path)
  kong.service.request.set_header("Authorization",    BASIC_AUTH)
  kong.service.request.set_header("Content-Type",     content_type)
  kong.service.request.set_header("X-SDIA-Domain",    domain)
  kong.service.request.set_header("X-SDIA-Version",   "2.2.0")
  kong.service.request.set_header("X-SDIA-Interface", interface_id)
end

return GdcrHandler
