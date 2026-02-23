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
