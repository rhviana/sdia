local GdcrHandler = {
  PRIORITY = 9999,
  VERSION = "1.0.0",
}

local kvm = {
  ["/sales/orders/create/salesforce"] = "gdcrorderscsalesforceid01:http",
  ["/sales/orders/update/salesforceus"] = "gdcrordersusalesforceusid02:http",
  ["/sales/orders/update/salesforceemea"] = "gdcrordersusalesforceemeaid03:http",
  ["/sales/orders/create/Microsoft"] = "gdcrorderscmicrosoftid05:cxf",
  ["/sales/payments/notify/stripe"] = "gdcrpaymentsnstripeid04:http",
  ["/sales/payments/notify/s4hana"] = "gdcrpaymentsns4hanaid08:cxf",
  ["/sales/customers/sync/s4hana"] = "gdcrcustomersss4hanaid07:cxf",
  ["/sales/customers/sync/shopify"] = "gdcrcustomerssshopifyid14:http",
  ["/sales/customers/sync/salesforceemea"] = "gdcrcustomersssalesforceemeaid15:http",
  ["/sales/invoices/create/quickbooks"] = "gdcrinvoicescquickbooksid09:cxf",
  ["/sales/invoices/create/s4hana"] = "gdcrinvoicescs4hanaid10:cxf",
  ["/sales/deliveries/transfer/fedex"] = "gdcrdeliveriestfedexid06:http",
  ["/sales/deliveries/transfer/s4hana"] = "gdcrdeliveriests4hanaid11:cxf",
  ["/sales/returns/create/shopify"] = "gdcrreturnscshopifyid12:http",
  ["/sales/returns/create/s4hana"] = "gdcrreturnscs4hanaid13:http",
  ["/finances/taxes/create/avalara"] = "gdcrtaxescavalaraid14:http",
  ["/finances/budgets/sync/workday"] = "gdcrbudgetssworkdayid15:http",
  ["/finances/journals/create/sap"] = "gdcrjournalscsapid16:cxf",
  ["/finances/accounts/sync/xero"] = "gdcraccountssxeroid17:http",
  ["/finances/payments/notify/s4hana"] = "gdcrpaymentsns4hanaid18:cxf",
  ["/finances/payments/notify/stripe"] = "gdcrpaymentsnstripeid19:http",
  ["/finances/invoices/create/s4hana"] = "gdcrinvoicescs4hanaid20:cxf",
  ["/finances/invoices/create/quickbooks"] = "gdcrinvoicescquickbooksid21:cxf",
  ["/finances/expenses/create/coupa"] = "gdcrexpensesccoupaid22:http",
  ["/finances/receipts/update/concur"] = "gdcrreceiptsuconcurid23:http",
}

local cpi_base = "http://your-cpi-host.com"

function GdcrHandler:access(conf)
  local path = ngx.var.uri
  local kvm_value = kvm[path]
  
  if not kvm_value then
    kong.service.request.set_header("X-GDCR-Cache", "MISS")
    return kong.response.exit(404, {
      status = "error",
      message = "Route not found in GDCR KVM",
      path = path
    })
  end
  
  local interface_id, protocol = kvm_value:match("([^:]+):([^:]+)")
  
  if not interface_id or not protocol then
    return kong.response.exit(500, {
      status = "error",
      message = "Invalid KVM format",
      kvm_value = kvm_value
    })
  end
  
  local domain, resource, action, backend = path:match("/([^/]+)/([^/]+)/([^/]+)/([^/]+)")
  
  if not domain or not resource or not action or not backend then
    return kong.response.exit(400, {
      status = "error",
      message = "Invalid path format",
      path = path,
      expected = "/domain/resource/action/backend"
    })
  end
  
  local id_suffix = interface_id:match("(id%d+)$") or "id00"
  local action_initial = action:sub(1, 1)
  local target_url = string.format("%s/%s/gdcr/%s/%s/%s/%s", 
    cpi_base, 
    protocol, 
    resource, 
    action_initial, 
    backend, 
    id_suffix
  )
  
  kong.service.request.set_header("X-GDCR-Interface-ID", interface_id)
  kong.service.request.set_header("X-GDCR-Domain", domain)
  kong.service.request.set_header("X-GDCR-Resource", resource)
  kong.service.request.set_header("X-GDCR-Action", action)
  kong.service.request.set_header("X-GDCR-Backend", backend)
  kong.service.request.set_header("X-GDCR-Protocol", protocol)
  kong.service.request.set_header("X-GDCR-Target", target_url)
  kong.service.request.set_header("X-GDCR-Cache", "HIT")
  
  return kong.response.exit(200, {
    status = "success",
    interface_id = interface_id,
    domain = domain,
    resource = resource,
    action = action,
    backend = backend,
    protocol = protocol,
    target_url = target_url,
    timestamp = ngx.now()
  })
end

return GdcrHandler
