


<img width="1867" height="990" alt="image" src="https://github.com/user-attachments/assets/341f23ec-4deb-4607-8306-6c0f7d309d88" />



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
Policy com redis - Nao funcionou devido TRIAL:

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
        <!-- Build Redis routing key -->
        <set-variable name="routingKey" value="@{
            var entity = (context.Variables.GetValueOrDefault<string>("entity") ?? "unknown").ToLower();
            var code = context.Variables.GetValueOrDefault<string>("actionCode") ?? "c";
            var vendor = (context.Variables.GetValueOrDefault<string>("vendor") ?? "unknown").ToLower();
            return string.Format("dcrp{0}{1}{2}id01:http", entity, code, vendor);
        }" />
        <!-- Lookup value from Redis (External Cache) -->
        <cache-lookup-value key="@(context.Variables.GetValueOrDefault<string>("routingKey"))" variable-name="cpiPath" caching-type="external" />
        <!-- Se nao encontrou no Redis, usa fallback -->
        <set-variable name="cpiPath" value="@{
            var path = context.Variables.GetValueOrDefault<string>("cpiPath");
            return string.IsNullOrEmpty(path) ? "/http/status/404" : path;
        }" />
        <!-- Rewrite URL to CPI iFlow path -->
        <rewrite-uri template="@((string)context.Variables["cpiPath"])" copy-unmatched-params="true" />
        <!-- Debug headers -->
        <set-header name="X-DDCR-Version" exists-action="override">
            <value>v1.0-azure-redis</value>
        </set-header>
        <set-header name="X-DDCR-Routing-Key" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("routingKey"))</value>
        </set-header>
        <set-header name="X-DDCR-Entity" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("entity"))</value>
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
r.set('2_dcrporderscsalesforceid01:http', '/http/dcrp/orders/c/id01')
r.set('2_dcrpordersusalesforceemeaid02:http', '/http/dcrp/orders/u/id02')
r.set('2_dcrpcustomerssshopifyid03:http', '/http/dcrp/customers/s/id03')
r.set('2_dcrppaymentsnstripeid04:http', '/http/dcrp/payments/n/id04')
r.set('2_dcrporderscmicrosoftid05:cxf', '/cxf/dcrp/orders/c/id05')
r.set('2_dcrpdeliveriestfedexid06:http', '/http/dcrp/deliveries/t/id06')
r.set('2_dcrpcustomersss4hanaid07:cxf', '/cxf/dcrp/customers/s/id07')
r.set('2_dcrppaymentsns4hanaid08:cxf', '/cxf/dcrp/payments/n/id08')
r.set('2_dcrpinvoicescquickbooksid09:cxf', '/cxf/dcrp/invoices/c/id09')
r.set('2_dcrpinvoicescs4hanaid10:cxf', '/cxf/dcrp/invoices/c/id10')
r.set('2_dcrpdeliveriests4hanaid11:cxf', '/cxf/dcrp/deliveries/t/id11')
r.set('2_dcrpreturnscshopifyid12:http', '/http/dcrp/returns/c/id12')
r.set('2_dcrpreturnscs4hanaid13:http', '/http/dcrp/returns/c/id13')
r.set('2_dcrpinvoicescquickbooksid01:cxf', '/cxf/dcrp/invoices/c/id01')
r.set('2_dcrpinvoicescs4hanaid02:cxf', '/cxf/dcrp/invoices/c/id02')
r.set('2_dcrppaymentsnstripeid03:http', '/http/dcrp/payments/n/id03')
r.set('2_dcrppaymentsns4hanaid04:http', '/http/dcrp/payments/n/id04')
r.set('2_dcrpaccountssxeroid05:http', '/http/dcrp/accounts/s/id05')
r.set('2_dcrpjournalscsapid06:cxf', '/cxf/dcrp/journals/c/id06')
r.set('2_dcrpexpensesccoupaid07:http', '/http/dcrp/expenses/c/id07')
r.set('2_dcrpreceiptsuuconcurid08:cxf', '/cxf/dcrp/receipts/u/id08')
r.set('2_dcrpbudgetssworkdayid09:cxf', '/cxf/dcrp/budgets/s/id09')
r.set('2_dcrptaxescavalaraid10:http', '/http/dcrp/taxes/c/id10')
print('Feito!')
"

<img width="1263" height="842" alt="image" src="https://github.com/user-attachments/assets/309fb8df-e37b-40a1-8647-a64af53846d4" />

Select for check entries

python3 -c "
import redis
r = redis.StrictRedis(host='ddcr-kvm-azure.redis.cache.windows.net', port=6380, password='<yourpass>', ssl=True)
keys = r.keys('*')
for k in sorted(keys):
    print(k.decode(), '->', r.get(k).decode())
"

<img width="1291" height="610" alt="image" src="https://github.com/user-attachments/assets/aac416b2-86f0-4512-8e93-963cae677a54" />


Policy hardcode - Unica possivel no Microsoft:
<policies>
    <inbound>
        <base />
        <set-variable name="fullPath" value="@(context.Request.Url.Path)" />
        <set-variable name="entity" value="@{
            var path = context.Request.Url.Path;
            var parts = path.Split('/');
            return parts.Length > 0 ? parts[0] : "unknown";
        }" />
        <set-variable name="action" value="@{
            var path = context.Request.Url.Path;
            var parts = path.Split('/');
            return parts.Length > 1 ? parts[1] : "unknown";
        }" />
        <set-variable name="vendor" value="@{
            var path = context.Request.Url.Path;
            var parts = path.Split('/');
            return parts.Length > 2 ? parts[2] : "unknown";
        }" />
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
        <set-variable name="routingKey" value="@{
            var entity = (context.Variables.GetValueOrDefault<string>("entity") ?? "unknown").ToLower();
            var code = context.Variables.GetValueOrDefault<string>("actionCode") ?? "c";
            var vendor = (context.Variables.GetValueOrDefault<string>("vendor") ?? "unknown").ToLower();
            return string.Format("dcrp{0}{1}{2}id01", entity, code, vendor);
        }" />
        <set-variable name="cpiPath" value="@{
            var key = context.Variables.GetValueOrDefault<string>("routingKey");
            switch(key) {
                case "dcrporderscsalesforceid01": return "/http/dcrp/orders/c/id01";
                case "dcrpordersusalesforceemeaid02": return "/http/dcrp/orders/u/id02";
                case "dcrpcustomerssshopifyid03": return "/http/dcrp/customers/s/id03";
                case "dcrppaymentsnstripeid04": return "/http/dcrp/payments/n/id04";
                case "dcrporderscmicrosoftid05": return "/cxf/dcrp/orders/c/id05";
                case "dcrpdeliveriestfedexid06": return "/http/dcrp/deliveries/t/id06";
                case "dcrpcustomersss4hanaid07": return "/cxf/dcrp/customers/s/id07";
                case "dcrppaymentsns4hanaid08": return "/cxf/dcrp/payments/n/id08";
                case "dcrpinvoicescquickbooksid09": return "/cxf/dcrp/invoices/c/id09";
                case "dcrpinvoicescs4hanaid10": return "/cxf/dcrp/invoices/c/id10";
                case "dcrpdeliveriests4hanaid11": return "/cxf/dcrp/deliveries/t/id11";
                case "dcrpreturnscshopifyid12": return "/http/dcrp/returns/c/id12";
                case "dcrpreturnscs4hanaid13": return "/http/dcrp/returns/c/id13";
                case "dcrpinvoicescquickbooksid01": return "/cxf/dcrp/invoices/c/id01";
                case "dcrpinvoicescs4hanaid02": return "/cxf/dcrp/invoices/c/id02";
                case "dcrppaymentsnstripeid03": return "/http/dcrp/payments/n/id03";
                case "dcrppaymentsns4hanaid04": return "/http/dcrp/payments/n/id04";
                case "dcrpaccountssxeroid05": return "/http/dcrp/accounts/s/id05";
                case "dcrpjournalscsapid06": return "/cxf/dcrp/journals/c/id06";
                case "dcrpexpensesccoupaid07": return "/http/dcrp/expenses/c/id07";
                case "dcrpreceiptsuuconcurid08": return "/cxf/dcrp/receipts/u/id08";
                case "dcrpbudgetssworkdayid09": return "/cxf/dcrp/budgets/s/id09";
                case "dcrptaxescavalaraid10": return "/http/dcrp/taxes/c/id10";
                default: return "/http/status/404";
            }
        }" />
        <set-backend-service base-url="https://282cc9datrial.it-cpitrial05-rt.cfapps.us10-001.hana.ondemand.com" />
        <rewrite-uri template="@((string)context.Variables["cpiPath"])" copy-unmatched-params="true" />
        <set-header name="X-DDCR-Version" exists-action="override">
            <value>v1.0-hardcode-poc</value>
        </set-header>
        <set-header name="X-DDCR-Routing-Key" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("routingKey"))</value>
        </set-header>
        <set-header name="X-DDCR-Entity" exists-action="override">
            <value>@(context.Variables.GetValueOrDefault<string>("entity"))</value>
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

Powershell test 1:1 - verification:


python3 -c "
import urllib.request

base = 'https://rg-gdcr-test.azure-api.net/sales'
key = '7522c9500132428b91fc879814e8af80'

calls = [
    ('orders', 'create', 'salesforce'),
    ('orders', 'update', 'salesforceemea'),
    ('customers', 'sync', 'shopify'),
    ('payments', 'notify', 'stripe'),
    ('orders', 'create', 'microsoft'),
    ('deliveries', 'track', 'fedex'),
    ('customers', 'sync', 's4hana'),
    ('payments', 'notify', 's4hana'),
    ('invoices', 'create', 'quickbooks'),
    ('invoices', 'create', 's4hana'),
    ('deliveries', 'track', 's4hana'),
    ('returns', 'create', 'shopify'),
    ('returns', 'create', 's4hana'),
    ('accounts', 'sync', 'xero'),
    ('journals', 'create', 'sap'),
    ('expenses', 'create', 'coupa'),
    ('receipts', 'update', 'concur'),
    ('budgets', 'sync', 'workday'),
    ('taxes', 'create', 'avalara'),
]

for entity, action, vendor in calls:
    url = f'{base}/{entity}/{action}/{vendor}'
    req = urllib.request.Request(url, method='POST')
    req.add_header('Ocp-Apim-Subscription-Key', key)
    try:
        with urllib.request.urlopen(req, timeout=10) as r:
            print(f'OK {entity}/{action}/{vendor} -> {r.status}')
    except Exception as e:
        print(f'ERRO {entity}/{action}/{vendor} -> {e}')
"

testes:
<img width="692" height="791" alt="image" src="https://github.com/user-attachments/assets/6bd64b65-6b4b-48b0-83a3-724bcc7a1951" />

Finances:
python3 -c "
import urllib.request

base = 'https://rg-gdcr-test.azure-api.net/finances'
key = '7522c9500132428b91fc879814e8af80'

calls = [
    ('invoices', 'create', 'quickbooks'),
    ('invoices', 'create', 's4hana'),
    ('payments', 'notify', 'stripe'),
    ('payments', 'notify', 's4hana'),
    ('accounts', 'sync', 'xero'),
    ('journals', 'create', 'sap'),
    ('expenses', 'create', 'coupa'),
    ('receipts', 'update', 'concur'),
    ('budgets', 'sync', 'workday'),
    ('taxes', 'create', 'avalara'),
]

for entity, action, vendor in calls:
    url = base + '/' + entity + '/' + action + '/' + vendor
    req = urllib.request.Request(url, method='POST')
    req.add_header('Ocp-Apim-Subscription-Key', key)
    try:
        with urllib.request.urlopen(req, timeout=10) as r:
            rk = r.headers.get('x-ddcr-routing-key', 'sem-key')
            cp = r.headers.get('x-ddcr-cpi-path', 'sem-path')
            print('OK ' + entity + '/' + action + '/' + vendor + ' key=' + rk + ' path=' + cp)
    except urllib.error.HTTPError as e:
        rk = e.headers.get('x-ddcr-routing-key', 'sem-key')
        cp = e.headers.get('x-ddcr-cpi-path', 'sem-path')
        print('ERRO ' + entity + '/' + action + '/' + vendor + ' key=' + rk + ' path=' + cp)
"

<img width="712" height="690" alt="image" src="https://github.com/user-attachments/assets/172a59ab-3fe9-43cb-b5db-5d70a9e4d9a0" />






