/# Kong GDCR Routing Table

This project defines a single routing table used by Kong Gateway to resolve
business API calls into downstream systems using the GDCR v15.3 pattern.

The routing table is stored as key → value entries where:

```text
route-path → interfaceId:protocol
Examples:
/sales/orders/create/salesforce   → gdcrorderscsalesforceid01:http
/sales/customers/sync/s4hana      → gdcrcustomersss4hanaid07:cxf
```
Kong itself does not use the term “KVM” (Key-Value Map).

In this project we call it a Routing Table, which can be stored either
locally in Lua or globally in Redis, while keeping the same naming convention
used in SAP API Management and Apigee for cross‑platform comparison.

Local Routing Table (Lua)
The simplest option is to embed the routing table directly in Lua as a
static map in memory.

```lua
local ROUTES = {
  ["/sales/orders/create/salesforce"]      = "gdcrorderscsalesforceid01:http",
  ["/sales/orders/update/salesforceus"]    = "gdcrordersusalesforceusid02:http",
  ["/sales/orders/update/salesforceemea"]  = "gdcrordersusalesforceemeaid03:http",
  ["/sales/payments/notify/stripe"]        = "gdcrpaymentsnstripeid04:http",
  ["/sales/orders/create/Microsoft"]       = "gdcrorderscmicrosoftid05:cxf",
  ["/sales/deliveries/transfer/fedex"]     = "gdcrdeliveriestfedexid06:http",
  ["/sales/customers/sync/s4hana"]         = "gdcrcustomersss4hanaid07:cxf",
  ["/sales/payments/notify/s4hana"]        = "gdcrpaymentsns4hanaid08:cxf",
  ["/sales/invoices/create/quickbooks"]    = "gdcrinvoicescquickbooksid09:cxf",
  ["/sales/invoices/create/s4hana"]        = "gdcrinvoicescs4hanaid10:cxf",
  ["/sales/deliveries/transfer/s4hana"]    = "gdcrdeliveriests4hanaid11:cxf",
  ["/sales/returns/create/shopify"]        = "gdcrreturnscshopifyid12:http",
  ["/sales/returns/create/s4hana"]         = "gdcrreturnscs4hanaid13:http",
  ["/sales/customers/sync/shopify"]        = "gdcrcustomerssshopifyid14:http",
  ["/sales/customers/sync/salesforceemea"] = "gdcrcustomersssalesforceemeaid15:http",

  ["/finances/taxes/create/avalara"]       = "gdcrtaxescavalaraid16:http",
  ["/finances/budgets/sync/workday"]       = "gdcrbudgetssworkdayid17:http",
  ["/finances/journals/create/sap"]        = "gdcrjournalscsapid18:cxf",
  ["/finances/accounts/sync/xero"]         = "gdcraccountssxeroid19:http",
  ["/finances/payments/notify/s4hana"]     = "gdcrpaymentsns4hanaid20:cxf",
  ["/finances/payments/notify/stripe"]     = "gdcrpaymentsnstripeid21:http",
  ["/finances/invoices/create/s4hana"]     = "gdcrinvoicescs4hanaid22:cxf",
  ["/finances/invoices/create/quickbooks"] = "gdcrinvoicescquickbooksid23:cxf",
  ["/finances/expenses/create/coupa"]      = "gdcrexpensesccoupaid24:http",
  ["/finances/receipts/update/concur"]     = "gdcrreceiptsuconcurid25:http"
}

local _M = {}

function _M.resolve(route_path)
  return ROUTES[route_path]
end

return _M
```

This approach is ideal when the routing table does not change frequently and
you want maximum performance with no external dependency.

Global Routing Table (Redis)
If you need to update routes without restarting Kong, the routing table
can be stored in Redis.

To populate Redis you can use:
```bash
bash
SET "/sales/orders/create/salesforce"      "gdcrorderscsalesforceid01:http"
SET "/sales/orders/update/salesforceus"    "gdcrordersusalesforceusid02:http"
SET "/sales/orders/update/salesforceemea"  "gdcrordersusalesforceemeaid03:http"
SET "/sales/payments/notify/stripe"        "gdcrpaymentsnstripeid04:http"
SET "/sales/orders/create/Microsoft"       "gdcrorderscmicrosoftid05:cxf"
SET "/sales/deliveries/transfer/fedex"     "gdcrdeliveriestfedexid06:http"
SET "/sales/customers/sync/s4hana"         "gdcrcustomersss4hanaid07:cxf"
SET "/sales/payments/notify/s4hana"        "gdcrpaymentsns4hanaid08:cxf"
SET "/sales/invoices/create/quickbooks"    "gdcrinvoicescquickbooksid09:cxf"
SET "/sales/invoices/create/s4hana"        "gdcrinvoicescs4hanaid10:cxf"
SET "/sales/deliveries/transfer/s4hana"    "gdcrdeliveriests4hanaid11:cxf"
SET "/sales/returns/create/shopify"        "gdcrreturnscshopifyid12:http"
SET "/sales/returns/create/s4hana"         "gdcrreturnscs4hanaid13:http"
SET "/sales/customers/sync/shopify"        "gdcrcustomerssshopifyid14:http"
SET "/sales/customers/sync/salesforceemea" "gdcrcustomersssalesforceemeaid15:http"

SET "/finances/taxes/create/avalara"       "gdcrtaxescavalaraid16:http"
SET "/finances/budgets/sync/workday"       "gdcrbudgetssworkdayid17:http"
SET "/finances/journals/create/sap"        "gdcrjournalscsapid18:cxf"
SET "/finances/accounts/sync/xero"         "gdcraccountssxeroid19:http"
SET "/finances/payments/notify/s4hana"     "gdcrpaymentsns4hanaid20:cxf"
SET "/finances/payments/notify/stripe"     "gdcrpaymentsnstripeid21:http"
SET "/finances/invoices/create/s4hana"     "gdcrinvoicescs4hanaid22:cxf"
SET "/finances/invoices/create/quickbooks" "gdcrinvoicescquickbooksid23:cxf"
SET "/finances/expenses/create/coupa"      "gdcrexpensesccoupaid24:http"
SET "/finances/receipts/update/concur"     "gdcrreceiptsuconcurid25:http"
```
The Lua handler that reads from Redis can look like this:
```bash
lua
local redis = require "resty.redis"

local _M = {}

function _M.resolve(route_path)
  local red = redis:new()
  red:set_timeout(1000)

  local ok, err = red:connect("redis-host", 6379)
  if not ok then
    return nil, "failed to connect to redis: " .. (err or "")
  end

  local val, err = red:get(route_path)
  if not val or val == ngx.null then
    return nil, "route not found"
  end

  return val
end

return _M
```
This approach allows you to change or add routes by updating Redis keys,
without deploying new code or restarting the gateway.

Routes Included
The routing table currently includes:

15 Sales O2C routes such as order creation, updates, payments, deliveries,
returns and customer sync for Salesforce, Microsoft, Shopify, SAP S/4HANA,
Stripe, FedEx and QuickBooks.

10 Finance R2R routes such as taxes, budgets, journals, accounts, payments,
invoices, expenses and receipts for Avalara, Workday, SAP, Xero, SAP S/4HANA,
Stripe, QuickBooks, Coupa and Concur.

All of these routes are represented by the keys and values in the single
routing table described above; there is no separate structure per domain.

Usage

Mount the routing table implementation (Lua local or Redis-based) inside your Kong custom plugin or request handler.

Call resolve(route_path) with the incoming request path.

Parse the returned interfaceId:protocol string and route the request to
the appropriate upstream implementation.
