```text
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                        DDCR - Dynamic Data Context Router                            ║
║                          Azure API Management + Redis Cache                          ║
╚══════════════════════════════════════════════════════════════════════════════════════╝

  CLIENT REQUEST
  ──────────────
  https://rg-gdcr-test.azure-api.net/sales/orders/create/salesforce
                                           │       │        │
                                        entity  action   vendor
                                        orders  create  salesforce

                                           │
                                           ▼
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                          AZURE API MANAGEMENT (APIM)                                 ║
║                                                                                      ║
║   ┌─────────────────────────────────────────────────────────────────────────────┐    ║
║   │                        INBOUND POLICY (C# inline)                           │    ║
║   │                                                                             │    ║
║   │   1. EXTRACT from URL                                                       │    ║
║   │      /sales / orders / create / salesforce                                  │    ║
║   │               [2]      [3]       [4]                                        │    ║
║   │                                                                             │    ║
║   │   2. NORMALIZE action                                                       │    ║
║   │      create  ──►  c                                                         │    ║
║   │      read    ──►  r                                                         │    ║
║   │      update  ──►  u                                                         │    ║
║   │      delete  ──►  d                                                         │    ║
║   │      sync    ──►  s                                                         │    ║
║   │      notify  ──►  n                                                         │    ║
║   │                                                                             │    ║
║   │   3. BUILD Redis Key                                                        │    ║
║   │      dcrp + orders + c + salesforce + id01 + :http                          │    ║
║   │      ──────────────────────────────────────────────                         │    ║
║   │      dcrporderscSalesforceid01:http                                         │    ║
║   │                                                                             │    ║
║   └─────────────────────────────────────────────────────────────────────────────┘    ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
                                           │
                                           │  cache-lookup-value (external)
                                           ▼
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                        AZURE CACHE FOR REDIS (External)                              ║
║                    ddcr-kvm-azure.redis.cache.windows.net:6380                       ║
║                                                                                      ║
║   KEY                                    VALUE                                       ║
║   ─────────────────────────────────────  ──────────────────────────────────────      ║
║   dcrporderscsalesforceid01:http    ──►  /http/dcrp/orders/c/salesforce/id01         ║
║   dcrpordersusalesforceemeaid02:http──►  /http/dcrp/orders/u/salesforce/emea/id02    ║
║   dcrpcustomerssshopifyid03:http    ──►  /http/dcrp/customers/s/shopify/id03         ║
║   dcrppaymentsnstripeid04:http      ──►  /http/dcrp/payments/n/stripe/id04           ║
║   dcrporderscmicrosoftid05:cxf      ──►  /cxf/dcrp/orders/c/microsoft/id05           ║
║   dcrpinvoicescquickbooksid01:cxf   ──►  /cxf/dcrp/invoices/c/quickbooks/id01        ║
║   ...                               ──►  ...                                         ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
                                           │
                                           │  /http/dcrp/orders/c/salesforce/id01
                                           ▼
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                              SAP CPI BACKEND                                         ║
║                                                                                      ║
║   Protocol  ──►  http  or  cxf                                                       ║
║   iFlow     ──►  /dcrp/orders/c/salesforce/id01                                      ║
║                                                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
                                           │
                                           ▼
                                    RESPONSE + DEBUG HEADERS
                                    ─────────────────────────
                                    X-DDCR-Version:      v1.0-azure-redis
                                    X-DDCR-Routing-Key:  dcrporderscSalesforceid01:http
                                    X-DDCR-Entity:       orders
                                    X-DDCR-Action-Code:  c
                                    X-DDCR-Vendor:       salesforce
                                    X-DDCR-CPI-Path:     /http/dcrp/orders/c/salesforce/id01
                                    X-DDCR-Success:      true


╔══════════════════════════════════════════════════════════════════════════════════════╗
║                              HOW TO TEST                                             ║
║                                                                                      ║
║   Portal Azure → APIM → APIs → sua API → Test                                        ║
║                                                                                      ║
║   GET https://rg-gdcr-test.azure-api.net/sales/orders/create/salesforce              ║
║   GET https://rg-gdcr-test.azure-api.net/sales/payments/notify/stripe                ║
║   GET https://rg-gdcr-test.azure-api.net/sales/invoices/create/quickbooks            ║
║                                                                                      ║
║   Verificar nos headers de resposta:                                                 ║
║   ✔  X-DDCR-CPI-Path   → valor retornado do Redis                                    ║                               
║   ✔  X-DDCR-Routing-Key → chave montada                                              ║          
║   ✘  X-DDCR-Error      → se houver erro                                              ║     
╚══════════════════════════════════════════════════════════════════════════════════════╝

  Powered by: Azure APIM + Azure Cache for Redis + SAP CPI

```
Policy testada:

<policies>
    <inbound>
        <base />
        
        <!-- Extract full path for debugging -->
        <set-variable name="fullPath" value="@(context.Request.Url.Path)" />
        
        <!-- Parse entity, action, vendor from URL -->
        <set-variable name="entity" value="@{
            var path = context.Request.Url.Path;
            var parts = path.Split('/');
            return parts.Length > 2 ? parts[2] : "unknown";
        }" />
        
        <set-variable name="action" value="@{
            var path = context.Request.Url.Path;
            var parts = path.Split('/');
            return parts.Length > 3 ? parts[3] : "unknown";
        }" />
        
        <set-variable name="vendor" value="@{
            var path = context.Request.Url.Path;
            var parts = path.Split('/');
            return parts.Length > 4 ? parts[4] : "unknown";
        }" />
        
        <!-- Normalize action to canonical code -->
        <set-variable name="actionCode" value="@{
            var action = (context.Variables.GetValueOrDefault<string>("action") ?? "").ToLower();
            
            if (action.Contains("create") || action == "c") { return "c"; }
            if (action.Contains("read") || action.Contains("get") || action == "r") { return "r"; }
            if (action.Contains("update") || action.Contains("put") || action == "u") { return "u"; }
            if (action.Contains("delete") || action == "d") { return "d"; }
            if (action.Contains("sync") || action == "s") { return "s"; }
            if (action.Contains("notify") || action == "n") { return "n"; }
            if (action.Contains("approve") || action == "a") { return "a"; }
            
            var method = context.Request.Method;
            if (method == "POST") { return "c"; }
            if (method == "GET") { return "r"; }
            if (method == "PUT" || method == "PATCH") { return "u"; }
            if (method == "DELETE") { return "d"; }
            
            return "c";
        }" />
        
        <!-- Build DDCR routing key -->
        <set-variable name="routingKey" value="@{
            var entity = context.Variables.GetValueOrDefault<string>("entity") ?? "unknown";
            var code = context.Variables.GetValueOrDefault<string>("actionCode") ?? "c";
            var vendor = context.Variables.GetValueOrDefault<string>("vendor") ?? "unknown";
            return string.Format("dcrp-{0}-{1}-{2}", entity, code, vendor);
        }" />
        
        <!-- Lookup Named Value (metadata) -->
        <set-variable name="cpiPath" value="@{
            var key = context.Variables.GetValueOrDefault<string>("routingKey");
            
            // Try to get Named Value
            try {
                var namedValue = context.Deployment.GetNamedValue(key);
                return namedValue ?? "/http/status/404";
            } catch {
                return "/http/status/404";
            }
        }" />
        
        <!-- Set backend to SAP CPI -->
        <set-backend-service backend-id="sap-cpi-backend" />
        
        <!-- Rewrite URL to CPI iFlow path -->
        <rewrite-uri template="@((string)context.Variables["cpiPath"])" copy-unmatched-params="true" />
        
        <!-- Add Basic Auth for CPI (if not using Backend credentials) -->
        <!-- Uncomment if Backend credentials are not working -->
        <!--
        <authentication-basic username="{{cpi-username}}" password="{{cpi-password}}" />
        -->
        
        <!-- Add debug headers -->
        <set-header name="X-DDCR-Version" exists-action="override">
            <value>v1.0-azure-cpi</value>
        </set-header>
        <set-header name="X-DDCR-Routing-Key" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("routingKey"))</value>
        </set-header>
        <set-header name="X-DDCR-Entity" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("entity"))</value>
        </set-header>
        <set-header name="X-DDCR-Action" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("action"))</value>
        </set-header>
        <set-header name="X-DDCR-Action-Code" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("actionCode"))</value>
        </set-header>
        <set-header name="X-DDCR-Vendor" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("vendor"))</value>
        </set-header>
        <set-header name="X-DDCR-CPI-Path" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("cpiPath"))</value>
        </set-header>
        <set-header name="X-DDCR-Full-Path" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("fullPath"))</value>
        </set-header>
    </inbound>
    
    <backend>
        <base />
    </backend>
    
    <outbound>
        <base />
        <set-header name="X-DDCR-Success" exists-action="override">
            <value>true</value>
        </set-header>
    </outbound>
    
    <on-error>
        <base />
        <set-header name="X-DDCR-Error" exists-action="override">
            <value>@(context.LastError.Message)</value>
        </set-header>
    </on-error>
</policies>


Add URL CPI:

Powershell Redis Cloud

python3 -c "import redis; r = redis.StrictRedis(host='ddcr-kvm-azure.redis.cache.windows.net', port=6380, password='<yourpass>', ssl=True); print(r.ping())"

python3 -c "
import redis
r = redis.StrictRedis(host='ddcr-kvm-azure.redis.cache.windows.net', port=6380, password='<yourpass>', ssl=True)
r.set('dcrporderscsalesforceid01:http', '/http/dcrp/orders/c/salesforce/id01')
r.set('dcrpordersusalesforceemeaid02:http', '/http/dcrp/orders/u/salesforce/emea/id02')
r.set('dcrpcustomerssshopifyid03:http', '/http/dcrp/customers/s/shopify/id03')
r.set('dcrppaymentsnstripeid04:http', '/http/dcrp/payments/n/stripe/id04')
r.set('dcrporderscmicrosoftid05:cxf', '/cxf/dcrp/orders/c/microsoft/id05')
r.set('dcrpdeliveriestfedexid06:http', '/http/dcrp/deliveries/t/fedex/id06')
r.set('dcrpcustomersss4hanaid07:cxf', '/cxf/dcrp/customers/s/s4hana/id07')
r.set('dcrppaymentsns4hanaid08:cxf', '/cxf/dcrp/payments/n/s4hana/id08')
r.set('dcrpinvoicescquickbooksid09:cxf', '/cxf/dcrp/invoices/c/quickbooks/id09')
r.set('dcrpinvoicescs4hanaid10:cxf', '/cxf/dcrp/invoices/c/s4hana/id10')
r.set('dcrpdeliveriests4hanaid11:cxf', '/cxf/dcrp/deliveries/t/s4hana/id11')
r.set('dcrpreturnscshopifyid12:http', '/http/dcrp/returns/c/shopify/id12')
r.set('dcrpreturnscs4hanaid13:http', '/http/dcrp/returns/c/s4hana/id13')
r.set('dcrpinvoicescquickbooksid01:cxf', '/cxf/dcrp/invoices/c/quickbooks/id01')
r.set('dcrpinvoicescs4hanaid02:cxf', '/cxf/dcrp/invoices/c/s4hana/id02')
r.set('dcrppaymentsnstripeid03:http', '/http/dcrp/payments/n/stripe/id03')
r.set('dcrppaymentsns4hanaid04:http', '/http/dcrp/payments/n/s4hana/id04')
r.set('dcrpaccountssxeroid05:http', '/http/dcrp/accounts/s/xero/id05')
r.set('dcrpjournalscsapid06:cxf', '/cxf/dcrp/journals/c/sap/id06')
r.set('dcrpexpensesccoupaid07:http', '/http/dcrp/expenses/c/coupa/id07')
r.set('dcrpreceiptsuuconcurid08:cxf', '/cxf/dcrp/receipts/u/concur/id08')
r.set('dcrpbudgetssworkdayid09:cxf', '/cxf/dcrp/budgets/s/workday/id09')
r.set('dcrptaxescavalaraid10:http', '/http/dcrp/taxes/c/avalara/id10')
print('Feito!')
"

<img width="895" height="902" alt="image" src="https://github.com/user-attachments/assets/2c0b7111-2a52-4f9f-8534-c1f1d809c68d" />

python3 -c "
import redis
r = redis.StrictRedis(host='ddcr-kvm-azure.redis.cache.windows.net', port=6380, password='<yourpass>', ssl=True)
keys = r.keys('*')
for k in keys:
    print(k.decode(), '->', r.get(k).decode())
"

<img width="1421" height="773" alt="image" src="https://github.com/user-attachments/assets/206a142e-4ac9-48d6-95e1-e1dbb9ef913a" />




