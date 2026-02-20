```text
{
  "info": {
    "name": "AWS GDCR - 5K Test (9 routes)",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "variable": [
    {
      "key": "base_url_finance",
      "value": "https://rtp379zm9a.execute-api.ap-northeast-1.amazonaws.com"
    },
    {
      "key": "base_url_sales",
      "value": "https://78cp1pnfd0.execute-api.ap-northeast-1.amazonaws.com"
    }
  ],
  "item": [
    {
      "name": "Finance R2R (4 routes)",
      "item": [
        {
          "name": "01. POST /finances/payments/notify/stripe",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\"payment_id\":\"PAY-STRIPE-{{$randomInt}}\",\"amount\":{{$randomInt}}.00,\"status\":\"completed\",\"currency\":\"USD\"}"
            },
            "url": "{{base_url_finance}}/finances/payments/notify/stripe"
          }
        },
        {
          "name": "02. POST /finances/payments/notify/s4hana",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\"payment_id\":\"PAY-S4-{{$randomInt}}\",\"amount\":{{$randomInt}}.00,\"currency\":\"EUR\"}"
            },
            "url": "{{base_url_finance}}/finances/payments/notify/s4hana"
          }
        },
        {
          "name": "03. POST /finances/expenses/create/coupa",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\"expense_id\":\"EXP-COUPA-{{$randomInt}}\",\"amount\":{{$randomInt}}.00,\"category\":\"Travel\"}"
            },
            "url": "{{base_url_finance}}/finances/expenses/create/coupa"
          }
        },
        {
          "name": "04. POST /finances/taxes/create/avalara",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\"transaction_id\":\"TAX-AVA-{{$randomInt}}\",\"amount\":{{$randomInt}}.00,\"tax_rate\":0.0875}"
            },
            "url": "{{base_url_finance}}/finances/taxes/create/avalara"
          }
        }
      ]
    },
    {
      "name": "Sales O2C (5 routes)",
      "item": [
        {
          "name": "01. POST /sales/orders/create/salesforce",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\"order_id\":\"ORD-SF-{{$randomInt}}\",\"customer\":\"ACME Corp\",\"amount\":{{$randomInt}}.00}"
            },
            "url": "{{base_url_sales}}/sales/orders/create/salesforce"
          }
        },
        {
          "name": "02. PUT /sales/orders/update/salesforceus",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\"order_id\":\"ORD-SFUS-{{$randomInt}}\",\"status\":\"Shipped\",\"tracking\":\"UPS{{$randomInt}}\"}"
            },
            "url": "{{base_url_sales}}/sales/orders/update/salesforceus"
          }
        },
        {
          "name": "03. POST /sales/payments/notify/stripe",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\"payment_id\":\"PAY-STRIPE-{{$randomInt}}\",\"amount\":{{$randomInt}}.00,\"status\":\"success\"}"
            },
            "url": "{{base_url_sales}}/sales/payments/notify/stripe"
          }
        },
        {
          "name": "04. POST /sales/deliveries/transfer/fedex",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\"delivery_id\":\"DEL-FDX-{{$randomInt}}\",\"tracking\":\"FDX{{$randomInt}}\",\"status\":\"in_transit\"}"
            },
            "url": "{{base_url_sales}}/sales/deliveries/transfer/fedex"
          }
        },
        {
          "name": "05. POST /sales/returns/create/shopify",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\"return_id\":\"RET-SHOP-{{$randomInt}}\",\"order_id\":\"ORD-{{$randomInt}}\",\"reason\":\"Defective\"}"
            },
            "url": "{{base_url_sales}}/sales/returns/create/shopify"
          }
        }
      ]
    }
  ]
}
```
<img width="738" height="245" alt="image" src="https://github.com/user-attachments/assets/de52e982-fa8d-4a58-93cd-f6d88f3c6c9f" />

<img width="1157" height="850" alt="image" src="https://github.com/user-attachments/assets/c7f1ce58-0b32-45df-bb4e-bcb6daf798cc" />
<img width="1047" height="443" alt="image" src="https://github.com/user-attachments/assets/a514db48-2f5e-4115-8d12-0836beb6f76a" />

<img width="577" height="328" alt="image" src="https://github.com/user-attachments/assets/5ed36407-ea5f-4e68-808a-fad19eee7522" />
<img width="1141" height="482" alt="image" src="https://github.com/user-attachments/assets/d080530a-9a8d-4412-94a6-67ef00f9f489" />


{
  "info": {
    "name": "AWS GDCR - HTTP Only (12 routes)",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "variable": [
    {"key": "base_url_finance", "value": "https://rtp379zm9a.execute-api.ap-northeast-1.amazonaws.com"},
    {"key": "base_url_sales", "value": "https://78cp1pnfd0.execute-api.ap-northeast-1.amazonaws.com"}
  ],
  "item": [
    {
      "name": "Finance (4 routes)",
      "item": [
        {"name": "01. POST /finances/payments/notify/stripe", "request": {"method": "POST", "header": [{"key": "Content-Type", "value": "application/json"}], "body": {"mode": "raw", "raw": "{\"payment_id\":\"PAY-001\",\"amount\":2500.00}"}, "url": "{{base_url_finance}}/finances/payments/notify/stripe"}},
        {"name": "02. POST /finances/payments/notify/s4hana", "request": {"method": "POST", "header": [{"key": "Content-Type", "value": "application/json"}], "body": {"mode": "raw", "raw": "{\"payment_id\":\"PAY-002\",\"amount\":10000.00}"}, "url": "{{base_url_finance}}/finances/payments/notify/s4hana"}},
        {"name": "03. POST /finances/expenses/create/coupa", "request": {"method": "POST", "header": [{"key": "Content-Type", "value": "application/json"}], "body": {"mode": "raw", "raw": "{\"expense_id\":\"EXP-003\",\"amount\":1200.00}"}, "url": "{{base_url_finance}}/finances/expenses/create/coupa"}},
        {"name": "04. POST /finances/taxes/create/avalara", "request": {"method": "POST", "header": [{"key": "Content-Type", "value": "application/json"}], "body": {"mode": "raw", "raw": "{\"transaction_id\":\"TAX-004\",\"amount\":10000.00}"}, "url": "{{base_url_finance}}/finances/taxes/create/avalara"}}
      ]
    },
    {
      "name": "Sales (8 routes)",
      "item": [
        {"name": "01. POST /sales/orders/create/salesforce", "request": {"method": "POST", "header": [{"key": "Content-Type", "value": "application/json"}], "body": {"mode": "raw", "raw": "{\"order_id\":\"ORD-001\",\"amount\":15000.00}"}, "url": "{{base_url_sales}}/sales/orders/create/salesforce"}},
        {"name": "02. PUT /sales/orders/update/salesforceus", "request": {"method": "POST", "header": [{"key": "Content-Type", "value": "application/json"}], "body": {"mode": "raw", "raw": "{\"order_id\":\"ORD-002\",\"status\":\"Shipped\"}"}, "url": "{{base_url_sales}}/sales/orders/update/salesforceus"}},
        {"name": "03. POST /sales/payments/notify/stripe", "request": {"method": "POST", "header": [{"key": "Content-Type", "value": "application/json"}], "body": {"mode": "raw", "raw": "{\"payment_id\":\"PAY-003\",\"amount\":5000.00}"}, "url": "{{base_url_sales}}/sales/payments/notify/stripe"}},
        {"name": "04. POST /sales/deliveries/transfer/fedex", "request": {"method": "POST", "header": [{"key": "Content-Type", "value": "application/json"}], "body": {"mode": "raw", "raw": "{\"delivery_id\":\"DEL-004\",\"tracking\":\"FDX789\"}"}, "url": "{{base_url_sales}}/sales/deliveries/transfer/fedex"}},
        {"name": "05. POST /sales/returns/create/shopify", "request": {"method": "POST", "header": [{"key": "Content-Type", "value": "application/json"}], "body": {"mode": "raw", "raw": "{\"return_id\":\"RET-005\",\"reason\":\"Defective\"}"}, "url": "{{base_url_sales}}/sales/returns/create/shopify"}}
      ]
    }
  ]
}


import json
import requests
import base64

# KVM Mapping (Sales O2C - 15 routes)
KVM_SALES = {
    "orders/create/salesforce": "dcrporderscsalesforceid01:http",
    "orders/update/salesforceus": "dcrpordersualesforceusid02:http",
    "orders/update/salesforceemea": "dcrpordersualesforceemeaid03:http",
    "payments/notify/stripe": "dcrppaymentsnstripeid04:http",
    "orders/create/Microsoft": "dcrporderscmicrosoftid05:http",
    "deliveries/create/fedex": "dcrpdeliveriescfedexid06:http",
    "customers/sync/s4hana": "dcrpcustomerssshhanaid07:cxf",
    "returns/read/zendesk": "dcrpreturnsrzendeskid08:http",
    "invoices/create/netsuite": "dcrpinvoicescnetsuiteid09:cxf",
    "orders/delete/shopify": "dcrpordersdshopifyid10:http",
    "payments/create/paypal": "dcrppaymentsccaypalid11:http",
    "customers/update/hubspot": "dcrpcustomersuhubspotid12:http",
    "deliveries/notify/ups": "dcrpdeliveriesnupsid13:http",
    "invoices/update/xero": "dcrpinvoicesuxeroid14:cxf",
    "returns/create/servicenow": "dcrpreturnscservicenowid15:http"
}

# KVM Mapping (Finance R2R - 10 routes)
KVM_FINANCE = {
    "taxes/create/avalara": "dcrptaxescavalaraid16:http",
    "budgets/sync/workday": "dcrpbudgetssworkdayid17:cxf",
    "journals/create/ariba": "dcrpjournalscaibaid18:http",
    "accounts/read/concur": "dcrpaccountsrconcurid19:http",
    "payments/notify/stripe": "dcrppaymentsnstripeid20:http",
    "invoices/update/coupa": "dcrpinvoicesucoupaid21:cxf",
    "expenses/create/expensify": "dcrpexpensescexpensifyid22:http",
    "budgets/delete/fieldglass": "dcrpbudgetsdfieldglassid23:http",
    "journals/sync/successfactors": "dcrpjournalssuccessfactorsid24:cxf",
    "receipts/update/concur": "dcrpreceiptsuconcurid25:http"
}

# Action Normalization
ACTION_MAP = {
    "create": "c", "read": "r", "update": "u", "delete": "d",
    "notify": "n", "sync": "s", "transfer": "t"
}

# SAP CPI Credentials (substituir pelos seus)
CPI_USER = "your_cpi_user"
CPI_PASSWORD = "your_cpi_password"
CPI_BASE = "https://your-tenant.hana.ondemand.com"

def lambda_handler(event, context):
    try:
        # Extract full path
        raw_path = event['rawPath']
        path_parts = raw_path.strip('/').split('/')
        domain = path_parts[0]
        proxy_parts = path_parts[1:]
        proxy = '/'.join(proxy_parts)
        
        # Determine KVM
        if domain == "sales":
            kvm = KVM_SALES
        elif domain == "finances":
            kvm = KVM_FINANCE
        else:
            return {
                'statusCode': 400,
                'body': json.dumps({'error': f'Invalid domain: {domain}'})
            }
        
        # Lookup KVM
        kvm_value = kvm.get(proxy)
        if not kvm_value:
            return {
                'statusCode': 404,
                'body': json.dumps({'error': 'Route not found'})
            }
        
        # Parse KVM value
        interface_id, protocol = kvm_value.split(':')
        parts = proxy.split('/')
        resource = parts[0]
        action = parts[1]
        backend = parts[2]
        action_short = ACTION_MAP.get(action, action[0])
        id_suffix = interface_id[-4:]
        
        # Build CPI URL (DCRP pattern)
        generated_url = f"{CPI_BASE}/{protocol}/dcrp/{resource}/{action_short}/{backend}/{id_suffix}"
        
        # Prepare authentication
        auth_string = f"{CPI_USER}:{CPI_PASSWORD}"
        auth_base64 = base64.b64encode(auth_string.encode()).decode()
        
        # Get request body
        body = {}
        if event.get('body'):
            if event.get('isBase64Encoded'):
                import base64
                body = json.loads(base64.b64decode(event['body']))
            else:
                body = json.loads(event['body'])
        
        # Call SAP CPI
        cpi_response = requests.post(
            generated_url,
            headers={
                'Authorization': f'Basic {auth_base64}',
                'Content-Type': 'application/json'
            },
            json=body,
            timeout=30
        )
        
        # Return CPI response
        return {
            'statusCode': cpi_response.status_code,
            'headers': {
                'Content-Type': 'application/json'
            },
            'body': cpi_response.text
        }
        
    except requests.exceptions.Timeout:
        return {
            'statusCode': 504,
            'body': json.dumps({'error': 'CPI request timeout'})
        }
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }
