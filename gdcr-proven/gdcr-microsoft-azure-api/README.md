# GDCR — Microsoft Azure Validation
### Azure API Management + SAP CPI — C# Policy + Redis

This repository contains the full validation evidence of the GDCR (Gateway Domain-Centric Routing) framework executed on Microsoft Azure API Management.

The objective was to validate:

- Domain-centric routing
- Action normalization
- Deterministic routing key construction
- Metadata-driven backend resolution
- Cross-domain validation (Sales and Finance)
- High-volume execution (200K+ requests)

---

## 1. Architecture Overview

### Request Example

Example client request:

`https://rg-gdcr-test.azure-api.net/sales/orders/create/salesforce`

Routing breakdown:

| Segment | Meaning |
|---------|---------|
| sales | Domain |
| orders | Entity |
| create | Action |
| salesforce | Vendor |

Processing steps inside Azure APIM:

1. Extract URL segments
2. Normalize action (`create → c`)
3. Build routing key: `dcrporderscsalesforceid01:http`
4. Resolve backend path
5. Rewrite URI to SAP CPI
6. Return debug headers

---

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
## 2. Azure API Management Setup

### Domain Proxies Created

<img width="688" height="652" alt="image" src="https://github.com/user-attachments/assets/9ffd4dc6-6ad9-47d0-b1f6-4e0a02726003" />

Two domain-level proxies:

- `gdcr-microsoft-sales-o2c-proxy`
- `gdcr-microsoft-finances-r2r-proxy`

Domain consolidation validated: multiple vendors served through one domain proxy.

---

## 3. Implementation Variants

### Variant 1 — Redis (Metadata-Driven Routing)

Full DDCR logic using Azure Cache for Redis as external metadata store.

#### Redis Key Format

`dcrp{entity}{actionCode}{vendor}id01:http`

Example:

`dcrporderscsalesforceid01:http`

#### Redis Population Script

```python
import redis

r = redis.StrictRedis(
    host='ddcr-kvm-azure.redis.cache.windows.net',
    port=6380,
    password='***',
    ssl=True
)

r.set('dcrporderscsalesforceid01:http', '/http/dcrp/orders/c/id01')
r.set('dcrpordersusalesforceemeaid02:http', '/http/dcrp/orders/u/id02')
r.set('dcrpcustomerssshopifyid03:http', '/http/dcrp/customers/s/id03')
r.set('dcrppaymentsnstripeid04:http', '/http/dcrp/payments/n/id04')

print("Done")
```
### Redis Population Execution

<img width="692" height="791" alt="image" src="https://github.com/user-attachments/assets/5900f9f1-5eb0-4f85-85c3-f240bbf9ca70" />


---

### Redis Key Verification

<img width="712" height="690" alt="image" src="https://github.com/user-attachments/assets/2d65e95c-b5f0-4bc3-b78a-94d544fb54d7" />


---

### Trial Limitation

Azure Free Trial tier blocks external cache access inside APIM policy runtime.

Result:

- Architecture correct
- Redis validated externally
- Not executable inside trial-tier APIM

This is a sandbox constraint, not a GDCR limitation.

---

## Variant 2 — C# Hardcoded Policy (Validated)

Due to trial restriction, routing resolution was implemented via C# `switch` inside inbound policy.

This is the validated execution variant.

### Action Normalization

```csharp
var code = action switch {
    "create" => "c",
    "read"   => "r",
    "update" => "u",
    "delete" => "d",
    "sync"   => "s",
    "notify" => "n",
    "approve"=> "a",
    _        => "c"
};
```
<img width="1867" height="990" alt="image" src="https://github.com/user-attachments/assets/341f23ec-4deb-4607-8306-6c0f7d309d88" />
    
// 3. Build routing key
var routingKey = $"dcrp{entity}{code}{vendor}id01";
<img width="911" height="981" alt="image" src="https://github.com/user-attachments/assets/97f87e20-c68a-41ab-be44-3a475ec82d2e" />


Policy com redis 
```xml
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
```
### Routing Key Construction

`string.Format("dcrp{0}{1}{2}id01", entity, code, vendor);`

---

## 4. Load Testing — 200K Messages

### Execution Summary

| Domain  | Routes | Iterations | Total Messages |
|---------|--------|------------|----------------|
| Sales   | 13     | 8696       | 113,048        |
| Finance | 10     | 8696       | 86,960         |
| Total   | —      | —          | 200,008        |

Execution characteristics:

- Parallel execution
- 250ms delay
- No routing failures
- Stable runtime
<img width="1702" height="927" alt="image" src="https://github.com/user-attachments/assets/bc70aa24-eaab-4623-8dfb-30bbcb4de15a" />

---

### Sales Execution

Validated per iteration:

- Status 2xx
- Routing key present
- CPI path present

---

### Finance Execution

Same validation logic applied.

---

## 5. Azure Cloud Shell — Redis Validation

### Insert Script Execution

### Key Verification

---

## 6. Python Route Validation — Sales

Base URL:

`https://rg-gdcr-test.azure-api.net/sales`

Execution result:

- OK
- Routing key header present
- CPI path header present

---

## 7. Python Route Validation — Finance

Base URL:

`https://rg-gdcr-test.azure-api.net/finances`

Execution result:

All routes validated successfully.

---

## 8. Debug Headers Returned by GDCR

| Header | Description |
|--------|-------------|
| X-DDCR-Version | Engine version |
| X-DDCR-Routing-Key | Constructed routing key |
| X-DDCR-Entity | Extracted entity |
| X-DDCR-Action-Code | Normalized action |
| X-DDCR-Vendor | Extracted vendor |
| X-DDCR-CPI-Path | Resolved backend path |
| X-DDCR-Success | Routing resolution result |
| X-DDCR-Error | Error message (if any) |

This guarantees routing transparency and auditability.

---

## 9. Latency Observation

Environment:

- Client: Poland
- Azure APIM: USA
- SAP CPI Trial: USA

Average latency observed:

`~175ms (cross-Atlantic)`

No routing resolution failures.

---

## 10. Architectural Conclusion

The Microsoft Azure validation demonstrates:

- Domain-centric proxy consolidation
- Deterministic routing key generation
- Multi-vendor orchestration
- Cross-domain separation (Sales / Finance)
- Runtime traceability
- High-volume stability (200K+ requests)

Redis variant proves metadata-driven portability.

Hardcoded variant validates routing correctness under sandbox constraints.

GDCR is vendor-agnostic and portable across API gateway platforms.

---
## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** 10.5281/zenodo.xxxxx  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---

