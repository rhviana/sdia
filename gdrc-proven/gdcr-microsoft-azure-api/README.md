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

<img width="1278" height="427" alt="image" src="https://github.com/user-attachments/assets/01bc9688-15d7-4a67-afb9-b9807336dd5e" />
<img width="1523" height="512" alt="image" src="https://github.com/user-attachments/assets/6ba0346f-1427-4a76-b0a4-8c92bda89e04" />
<img width="752" height="696" alt="image" src="https://github.com/user-attachments/assets/c2a20131-36f5-4492-8e16-7aa71871b251" />

<img width="1036" height="950" alt="image" src="https://github.com/user-attachments/assets/b9d4ae30-40d1-4345-aeaa-51e4971eb223" />


<img width="558" height="606" alt="image" src="https://github.com/user-attachments/assets/ea476cfb-fed3-4f41-b907-82bf8b18c59b" />


Powershell Redis Cloud

python3 -c "import redis; r = redis.StrictRedis(host='ddcr-kvm-azure.redis.cache.windows.net', port=6380, password='<yourpass>', ssl=True); print(r.ping())"

python3 -c "
import redis
r = redis.StrictRedis(host='ddcr-kvm-azure.redis.cache.windows.net', port=6380, password='Eg5vlkENh3azdqK7HYKU2XQ74r13OEWdnAzCaMuNoJ0=', ssl=True)
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
<img width="1517" height="717" alt="image" src="https://github.com/user-attachments/assets/6b72b5b9-b6ed-4029-8b2f-a29efa8465f1" />


<img width="895" height="902" alt="image" src="https://github.com/user-attachments/assets/2c0b7111-2a52-4f9f-8534-c1f1d809c68d" />



