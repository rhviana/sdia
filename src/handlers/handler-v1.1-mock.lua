-- Kong GDCR Plugin - Mock URL Generation (FIXED IDs)
-- Version: 1.0.1-mock-fixed

local GdcrHandler = {
  PRIORITY = 9999,
  VERSION = "1.0.1-mock-fixed"
}

-- KVM CORRIGIDO com IDs de 01 a 25
local KVM = {
  -- Sales O2C (15 rotas) - IDs 01-15
  ["/sales/orders/create/salesforce"] = "gdcrorderscsalesforceid01:http",
  ["/sales/orders/update/salesforceus"] = "gdcrordersusalesforceusid02:http",
  ["/sales/orders/update/salesforceemea"] = "gdcrordersusalesforceemeaid03:http",
  ["/sales/payments/notify/stripe"] = "gdcrpaymentsnstripeid04:http",
  ["/sales/orders/create/Microsoft"] = "gdcrorderscmicrosoftid05:cxf",
  ["/sales/deliveries/transfer/fedex"] = "gdcrdeliveriestfedexid06:http",
  ["/sales/customers/sync/s4hana"] = "gdcrcustomersss4hanaid07:cxf",
  ["/sales/payments/notify/s4hana"] = "gdcrpaymentsns4hanaid08:cxf",
  ["/sales/invoices/create/quickbooks"] = "gdcrinvoicescquickbooksid09:cxf",
  ["/sales/invoices/create/s4hana"] = "gdcrinvoicescs4hanaid10:cxf",
  ["/sales/deliveries/transfer/s4hana"] = "gdcrdeliveriests4hanaid11:cxf",
  ["/sales/returns/create/shopify"] = "gdcrreturnscshopifyid12:http",
  ["/sales/returns/create/s4hana"] = "gdcrreturnscs4hanaid13:http",
  ["/sales/customers/sync/shopify"] = "gdcrcustomerssshopifyid14:http",
  ["/sales/customers/sync/salesforceemea"] = "gdcrcustomersssalesforceemeaid15:http",
  
  -- Finance R2R (10 rotas) - IDs 16-25
  ["/finances/taxes/create/avalara"] = "gdcrtaxescavalaraid16:http",
  ["/finances/budgets/sync/workday"] = "gdcrbudgetssworkdayid17:http",
  ["/finances/journals/create/sap"] = "gdcrjournalscsapid18:cxf",
  ["/finances/accounts/sync/xero"] = "gdcraccountssxeroid19:http",
  ["/finances/payments/notify/s4hana"] = "gdcrpaymentsns4hanaid20:cxf",
  ["/finances/payments/notify/stripe"] = "gdcrpaymentsnstripeid21:http",
  ["/finances/invoices/create/s4hana"] = "gdcrinvoicescs4hanaid22:cxf",
  ["/finances/invoices/create/quickbooks"] = "gdcrinvoicescquickbooksid23:cxf",
  ["/finances/expenses/create/coupa"] = "gdcrexpensesccoupaid24:http",
  ["/finances/receipts/update/concur"] = "gdcrreceiptsuconcurid25:http"
}

-- Action normalization
local ACTION_MAP = {
  create = "c", post = "c", insert = "c", add = "c",
  read = "r", get = "r", retrieve = "r", fetch = "r",
  update = "u", put = "u", modify = "u", patch = "u",
  delete = "d", remove = "d", cancel = "d",
  sync = "s", synchronize = "s", replicate = "s",
  transfer = "t", send = "t", forward = "t",
  notify = "n", notification = "n", alert = "n"
}

function GdcrHandler:access(conf)
  local start_time = ngx.now()
  local path = ngx.var.uri
  
  -- KVM lookup
  local kvm_value = KVM[path]
  
  if not kvm_value then
    kong.response.exit(404, {
      status = "error",
      test_mode = "mock_url_generation",
      message = "Route not found in KVM",
      path = path,
      timestamp = ngx.now()
    })
    return
  end
  
  -- Parse: interfaceId:protocol
  local interface_id, protocol = kvm_value:match("^(.+):(.+)$")
  
  if not interface_id or not protocol then
    kong.response.exit(500, {
      status = "error",
      message = "Invalid KVM format",
      kvm_value = kvm_value
    })
    return
  end
  
  -- Parse path: /domain/resource/action/backend
  local path_parts = {}
  for part in path:gmatch("[^/]+") do
    table.insert(path_parts, part)
  end
  
  if #path_parts < 3 then
    kong.response.exit(400, {
      status = "error",
      message = "Invalid path format",
      path = path
    })
    return
  end
  
  local domain = path_parts[1]
  local resource = path_parts[2]
  local action = path_parts[3]
  local backend = path_parts[4] or ""
  
  -- Normalize action
  local action_initial = ACTION_MAP[action:lower()] or action:sub(1,1):lower()
  
  -- Extract ID suffix
  local id_suffix = interface_id:match("(id%d+)$") or "id00"
  
  -- Build target URL
  local cpi_base = "https://your-cpi-tenant.hana.ondemand.com"
  local target_url = string.format(
    "%s/%s/gdcr/%s/%s/%s/%s",
    cpi_base,
    protocol,
    resource,
    action_initial,
    backend,
    id_suffix
  )
  
  local latency = (ngx.now() - start_time) * 1000
  
  -- Response (MOCK - no backend call)
  kong.response.exit(200, {
    status = "success",
    test_mode = "mock_url_generation",
    interface_id = interface_id,
    domain = domain,
    resource = resource,
    action = action,
    backend = backend,
    protocol = protocol,
    kvm_source = "kong_lua_local",
    generated_url = target_url,
    url_components = {
      cpi_base = cpi_base,
      protocol = protocol,
      resource = resource,
      action_normalized = action_initial,
      backend = backend,
      id_suffix = id_suffix
    },
    latency_ms = latency,
    timestamp = ngx.now()
  }, {
    ["X-GDCR-Version"] = self.VERSION,
    ["X-GDCR-Mode"] = "MOCK"
  })
end

return GdcrHandler