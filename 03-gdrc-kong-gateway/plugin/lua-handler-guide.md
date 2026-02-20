# Lua Handler Guide

Kong GDCR plugin implementation in Lua language.

## Files

### handler-lua-local.lua
- **Purpose**: 30k message validation test
- **Storage**: Hard-coded Lua table (in-memory)
- **Performance**: ~15ms average latency
- **Scalability**: Limited to ~100 routes

### handler-redis.lua
- **Purpose**: 1M message stress test
- **Storage**: External Redis key-value store
- **Performance**: ~12ms average latency
- **Scalability**: Supports 10k+ routes

## Lua Table Structure (handler-lua-local.lua)

```lua
local ROUTES = {
  ["/sales/orders/create/salesforce"] = "gdcrorderscsalesforceid01:http",
  ["/sales/customers/sync/s4hana"] = "gdcrcustomersss4hanaid07:cxf",
  -- ... 25 routes total
}
Redis Structure (handler-redis.lua)
Copy# Key: route path
# Value: interfaceId:protocol

SET "/sales/orders/create/salesforce" "gdcrorderscsalesforceid01:http"
SET "/sales/customers/sync/s4hana" "gdcrcustomersss4hanaid07:cxf"
Core Logic (both handlers)
Copyfunction GdcrHandler:access(conf)
  local path = ngx.var.uri
  
  -- 1. Lookup route
  local route_value = ROUTES[path]  -- OR redis:get(path)
  
  -- 2. Parse interfaceId:protocol
  local interface_id, protocol = route_value:match("^(.+):(.+)$")
  
  -- 3. Parse path: /domain/resource/action/backend
  local parts = split_path(path)
  local domain = parts[1]
  local resource = parts[2]
  local action = parts[3]
  local backend = parts[4]
  
  -- 4. Normalize action (create→c, update→u, sync→s)
  local action_norm = ACTION_MAP[action:lower()] or action:sub(1,1)
  
  -- 5. Extract ID suffix (id01, id02, etc.)
  local id_suffix = interface_id:match("(id%d+)$")
  
  -- 6. Build target URL
  local target_url = string.format(
    "https://cpi-host/%s/gdcr/%s/%s/%s/%s",
    protocol, resource, action_norm, backend, id_suffix
  )
  
  -- 7. Return mock response (NO backend call)
  kong.response.exit(200, {
    status = "success",
    test_mode = "mock_url_generation",
    interface_id = interface_id,
    protocol = protocol,
    generated_url = target_url
  })
end
Copy
Action Normalization Map
Copylocal ACTION_MAP = {
  create = "c", post = "c", insert = "c",
  read = "r", get = "r", retrieve = "r",
  update = "u", put = "u", modify = "u",
  delete = "d", remove = "d",
  sync = "s", synchronize = "s",
  transfer = "t", send = "t",
  notify = "n", notification = "n"
}
Performance Comparison
Handler	Storage	Latency	Memory	Scalability
Lua Local	In-memory table	~15ms	~50KB	~100 routes
Redis	External store	~12ms	~1MB	10k+ routes
Deployment
Lua Local
Copydocker cp plugin/handler-lua-local.lua kong-gateway:/usr/local/share/lua/5.1/kong/plugins/gdcr/handler.lua
docker restart kong-gateway
Redis
```

Copy# 1. Load routes to Redis

-docker exec -it redis redis-cli
-SET "/sales/orders/create/salesforce" "gdcrorderscsalesforceid01:http"
# ... (load all 25 routes)

# 2. Deploy handler
-docker cp plugin/handler-redis.lua kong-gateway:/usr/local/share/lua/5.1/kong/plugins/gdcr/handler.lua
-docker restart kong-gateway
Mock Mode Warning
⚠️ IMPORTANT: Both handlers run in MOCK mode:

✅ Validates routing logic
✅ Generates target URLs
❌ Does NOT call real backend systems
❌ Does NOT execute SAP CPI iFlows
For production use, replace mock response with real service call.

---

## 📄 CORRIGIR: `kvm/README.md` → `routing-table/README.md`

**RENOMEAR PASTA:**
kvm/ → routing-table/


**NOVO CONTEÚDO `routing-table/README.md`:**

```markdown
# Routing Table Structure

Kong Gateway dynamic routing configuration.

> **Terminology Note**: Kong doesn't use "KVM" (Key-Value Map).  
> This is a **Routing Table** stored in Lua or Redis.  
> We document the same pattern as SAP APIM/Apigee for comparison purposes.

## Structure

Route Path → interfaceId:protocol


Example:
/sales/orders/create/salesforce → gdcrorderscsalesforceid01:http /sales/customers/sync/s4hana → gdcrcustomersss4hanaid07:cxf


## Files

- `routes-sales.csv` - 15 Sales O2C routes
- `routes-finance.csv` - 10 Finance R2R routes

## Implementation

### Lua Local (handler-lua-local.lua)
```lua
local ROUTES = {
  ["/sales/orders/create/salesforce"] = "gdcrorderscsalesforceid01:http",
  ["/sales/customers/sync/s4hana"] = "gdcrcustomersss4hanaid07:cxf"
}
Redis (handler-redis.lua)
CopySET "/sales/orders/create/salesforce" "gdcrorderscsalesforceid01:http"
SET "/sales/customers/sync/s4hana" "gdcrcustomersss4hanaid07:cxf"
Sales O2C Routes (15)
Route	Interface ID	Protocol
/sales/orders/create/salesforce	gdcrorderscsalesforceid01	http
/sales/orders/update/salesforceus	gdcrordersusalesforceusid02	http
/sales/orders/update/salesforceemea	gdcrordersusalesforceemeaid03	http
/sales/payments/notify/stripe	gdcrpaymentsnstripeid04	http
/sales/orders/create/Microsoft	gdcrorderscmicrosoftid05	cxf
/sales/deliveries/transfer/fedex	gdcrdeliveriestfedexid06	http
/sales/customers/sync/s4hana	gdcrcustomersss4hanaid07	cxf
/sales/payments/notify/s4hana	gdcrpaymentsns4hanaid08	cxf
/sales/invoices/create/quickbooks	gdcrinvoicescquickbooksid09	cxf
/sales/invoices/create/s4hana	gdcrinvoicescs4hanaid10	cxf
/sales/deliveries/transfer/s4hana	gdcrdeliveriests4hanaid11	cxf
/sales/returns/create/shopify	gdcrreturnscshopifyid12	http
/sales/returns/create/s4hana	gdcrreturnscs4hanaid13	http
/sales/customers/sync/shopify	gdcrcustomerssshopifyid14	http
/sales/customers/sync/salesforceemea	gdcrcustomersssalesforceemeaid15	http
Finance R2R Routes (10)
Route	Interface ID	Protocol
/finances/taxes/create/avalara	gdcrtaxescavalaraid16	http
/finances/budgets/sync/workday	gdcrbudgetssworkdayid17	http
/finances/journals/create/sap	gdcrjournalscsapid18	cxf
/finances/accounts/sync/xero	gdcraccountssxeroid19	http
/finances/payments/notify/s4hana	gdcrpaymentsns4hanaid20	cxf
/finances/payments/notify/stripe	gdcrpaymentsnstripeid21	http
/finances/invoices/create/s4hana	gdcrinvoicescs4hanaid22	cxf
/finances/invoices/create/quickbooks	gdcrinvoicescquickbooksid23	cxf
/finances/expenses/create/coupa	gdcrexpensesccoupaid24	http
/finances/receipts/update/concur	gdcrreceiptsuconcurid25	http
