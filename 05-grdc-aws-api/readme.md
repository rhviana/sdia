<img width="1157" height="850" alt="image" src="https://github.com/user-attachments/assets/c7f1ce58-0b32-45df-bb4e-bcb6daf798cc" />
<img width="1047" height="443" alt="image" src="https://github.com/user-attachments/assets/a514db48-2f5e-4115-8d12-0836beb6f76a" />

<img width="577" height="328" alt="image" src="https://github.com/user-attachments/assets/5ed36407-ea5f-4e68-808a-fad19eee7522" />
<img width="1141" height="482" alt="image" src="https://github.com/user-attachments/assets/d080530a-9a8d-4412-94a6-67ef00f9f489" />

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
