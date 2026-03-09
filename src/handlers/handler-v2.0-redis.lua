local redis = require "resty.redis"

local GdcrHandler = {
  PRIORITY = 9999,
  VERSION = "2.0.0-redis",
}

local redis_host = "redis-kvm"
local redis_port = 6379
local redis_timeout = 100  -- 100ms
local cpi_base = "http://your-cpi-host.com"

function GdcrHandler:access(conf)
  local path = ngx.var.uri
  local cache_key = "gdcr:" .. path
  
  -- Conecta Redis
  local red = redis:new()
  red:set_timeout(redis_timeout)
  
  local ok, err = red:connect(redis_host, redis_port)
  if not ok then
    kong.log.err("Failed to connect to Redis: ", err)
    return kong.response.exit(503, {
      status = "error",
      message = "KVM service unavailable"
    })
  end
  
  -- Lookup KVM
  local kvm_value, err = red:get(cache_key)
  
  if not kvm_value or kvm_value == ngx.null then
    red:set_keepalive(10000, 100)
    return kong.response.exit(404, {
      status = "error",
      message = "Route not found in GDCR KVM",
      path = path
    })
  end
  
  -- Parse KVM value
  local interface_id, protocol = kvm_value:match("([^:]+):([^:]+)")
  
  if not interface_id or not protocol then
    red:set_keepalive(10000, 100)
    return kong.response.exit(500, {
      status = "error",
      message = "Invalid KVM format"
    })
  end
  
  -- Parse path
  local domain, resource, action, backend = path:match("/([^/]+)/([^/]+)/([^/]+)/([^/]+)")
  
  if not domain or not resource or not action or not backend then
    red:set_keepalive(10000, 100)
    return kong.response.exit(400, {
      status = "error",
      message = "Invalid path format"
    })
  end
  
  -- Build target URL
  local id_suffix = interface_id:match("(id%d+)$") or "id00"
  local action_initial = action:sub(1, 1)
  local target_url = string.format("%s/%s/gdcr/%s/%s/%s/%s", 
    cpi_base, protocol, resource, action_initial, backend, id_suffix)
  
  -- Set headers
  kong.service.request.set_header("X-GDCR-Interface-ID", interface_id)
  kong.service.request.set_header("X-GDCR-Domain", domain)
  kong.service.request.set_header("X-GDCR-Resource", resource)
  kong.service.request.set_header("X-GDCR-Action", action)
  kong.service.request.set_header("X-GDCR-Backend", backend)
  kong.service.request.set_header("X-GDCR-Protocol", protocol)
  kong.service.request.set_header("X-GDCR-Target", target_url)
  kong.service.request.set_header("X-GDCR-Cache", "REDIS")
  
  -- Keepalive Redis connection
  red:set_keepalive(10000, 100)
  
  -- Return success
  return kong.response.exit(200, {
    status = "success",
    interface_id = interface_id,
    domain = domain,
    resource = resource,
    action = action,
    backend = backend,
    protocol = protocol,
    target_url = target_url,
    kvm_source = "redis",
    timestamp = ngx.now()
  })
end

return GdcrHandler
