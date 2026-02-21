Dynambo function withou connection with destination

<img width="1091" height="422" alt="image" src="https://github.com/user-attachments/assets/93d36def-b321-4cba-9c4b-1234f792d7f5" />

<img width="802" height="377" alt="image" src="https://github.com/user-attachments/assets/6b7150a6-a862-4997-a570-71f3a5675ffd" />

<img width="732" height="461" alt="image" src="https://github.com/user-attachments/assets/b11d37c1-98c3-4b6f-b7d5-4298c1945e00" />
<img width="865" height="435" alt="image" src="https://github.com/user-attachments/assets/a2cce6ed-a89e-4eef-b755-76c1c36e1a77" />


🔥 CONFIRMAÇÃO - LAMBDA + DYNAMODB + CPI = 100% OPERACIONAL
Copy{
  "statusCode": 200,
  "headers": {
    "Content-Type": "application/json"
  },
  "body": {
    "iFlowName": "id10.r2r.s4hana.tax.avalara.c.out.sync",
    "timestamp": "2026-02-08T21:39:44.789Z",
    "status": "SUCCESS",
    "avalara_transaction_id": "AVA-TX-789456123",
    "total_tax": 875.00,
    "tax_rate": 0.0875
  }
}
✅ ARQUITETURA COMPLETA VALIDADA
User Request
    ↓
AWS API Gateway (/finances/taxes/create/avalara)
    ↓
Lambda (Python 3.14)
    ↓
DynamoDB KVM Lookup (route: "taxes/create/avalara")
    ↓
    → interface_id: dcrptaxescavalaraid10
    → protocol: http
    ↓
URL Construction: 
https://282cc9datrial.../http/dcrp/taxes/c/avalara/id10
    ↓
SAP CPI (iFlow id10)
    ↓
✅ SUCCESS - Avalara Tax Calculation

FINANCE - 4 ROUTES
Item 1:

Copy{
  "route": {"S": "payments/notify/stripe"},
  "interface_id": {"S": "dcrppaymentsnstripeid03"},
  "protocol": {"S": "http"},
  "domain": {"S": "finances"}
}
Item 2:

Copy{
  "route": {"S": "payments/notify/s4hana"},
  "interface_id": {"S": "dcrppaymentsns4hanaid04"},
  "protocol": {"S": "http"},
  "domain": {"S": "finances"}
}
Item 3:

Copy{
  "route": {"S": "expenses/create/coupa"},
  "interface_id": {"S": "dcrpexpensesccoupaid07"},
  "protocol": {"S": "http"},
  "domain": {"S": "finances"}
}
Item 4:

Copy{
  "route": {"S": "taxes/create/avalara"},
  "interface_id": {"S": "dcrptaxescavalaraid10"},
  "protocol": {"S": "http"},
  "domain": {"S": "finances"}
}
SALES - 5 ROUTES
Item 5:

Copy{
  "route": {"S": "orders/create/salesforce"},
  "interface_id": {"S": "dcrporderscsalesforceid01"},
  "protocol": {"S": "http"},
  "domain": {"S": "sales"}
}
Item 6:

Copy{
  "route": {"S": "orders/update/salesforceus"},
  "interface_id": {"S": "dcrpordersusalesforceemeaid02"},
  "protocol": {"S": "http"},
  "domain": {"S": "sales"}
}
Item 7:

Copy{
  "route": {"S": "payments/notify/stripe"},
  "interface_id": {"S": "dcrppaymentsnstripeid04"},
  "protocol": {"S": "http"},
  "domain": {"S": "sales"}
}
Item 8:

Copy{
  "route": {"S": "deliveries/transfer/fedex"},
  "interface_id": {"S": "dcrpdeliveriestfedexid06"},
  "protocol": {"S": "http"},
  "domain": {"S": "sales"}
}
Item 9:

Copy{
  "route": {"S": "returns/create/shopify"},
  "interface_id": {"S": "dcrpreturnscshopifyid12"},
  "protocol": {"S": "http"},
  "domain": {"S": "sales"}
}

<img width="881" height="433" alt="image" src="https://github.com/user-attachments/assets/66a6ac1c-41a5-4aae-9968-aefffea6b4a0" />


kvm-bulk-load.json

{
  "gdcr-kvm": [
    {"PutRequest": {"Item": {"route": {"S": "payments/notify/stripe"}, "interface_id": {"S": "dcrppaymentsnstripeid03"}, "protocol": {"S": "http"}, "domain": {"S": "finances"}}}},
    {"PutRequest": {"Item": {"route": {"S": "payments/notify/s4hana"}, "interface_id": {"S": "dcrppaymentsns4hanaid04"}, "protocol": {"S": "http"}, "domain": {"S": "finances"}}}},
    {"PutRequest": {"Item": {"route": {"S": "expenses/create/coupa"}, "interface_id": {"S": "dcrpexpensesccoupaid07"}, "protocol": {"S": "http"}, "domain": {"S": "finances"}}}},
    {"PutRequest": {"Item": {"route": {"S": "taxes/create/avalara"}, "interface_id": {"S": "dcrptaxescavalaraid10"}, "protocol": {"S": "http"}, "domain": {"S": "finances"}}}},
    {"PutRequest": {"Item": {"route": {"S": "orders/create/salesforce"}, "interface_id": {"S": "dcrporderscsalesforceid01"}, "protocol": {"S": "http"}, "domain": {"S": "sales"}}}},
    {"PutRequest": {"Item": {"route": {"S": "orders/update/salesforceus"}, "interface_id": {"S": "dcrpordersusalesforceemeaid02"}, "protocol": {"S": "http"}, "domain": {"S": "sales"}}}},
    {"PutRequest": {"Item": {"route": {"S": "payments/notify/stripe"}, "interface_id": {"S": "dcrppaymentsnstripeid04"}, "protocol": {"S": "http"}, "domain": {"S": "sales"}}}},
    {"PutRequest": {"Item": {"route": {"S": "deliveries/transfer/fedex"}, "interface_id": {"S": "dcrpdeliveriestfedexid06"}, "protocol": {"S": "http"}, "domain": {"S": "sales"}}}},
    {"PutRequest": {"Item": {"route": {"S": "returns/create/shopify"}, "interface_id": {"S": "dcrpreturnscshopifyid12"}, "protocol": {"S": "http"}, "domain": {"S": "sales"}}}}
  ]
}

aws dynamodb batch-write-item --request-items file://kvm-bulk-load.json --region ap-northeast-1


Item 1 (Finance - Stripe):
route: payments/notify/stripe
interface_id: dcrppaymentsnstripeid03
protocol: http
domain: finances
Item 2 (Finance - S4HANA):
route: payments/notify/s4hana
interface_id: dcrppaymentsns4hanaid04
protocol: http
domain: finances
Item 3 (Finance - Coupa):
route: expenses/create/coupa
interface_id: dcrpexpensesccoupaid07
protocol: http
domain: finances
Item 4 (Finance - Avalara):
route: taxes/create/avalara
interface_id: dcrptaxescavalaraid10
protocol: http
domain: finances
Item 5 (Sales - Salesforce):
route: orders/create/salesforce
interface_id: dcrporderscsalesforceid01
protocol: http
domain: sales
Item 6 (Sales - Salesforce US):
route: orders/update/salesforceus
interface_id: dcrpordersusalesforceemeaid02
protocol: http
domain: sales
Item 7 (Sales - Stripe):
route: payments/notify/stripe
interface_id: dcrppaymentsnstripeid04
protocol: http
domain: sales
Item 8 (Sales - FedEx):
route: deliveries/transfer/fedex
interface_id: dcrpdeliveriestfedexid06
protocol: http
domain: sales
Item 9 (Sales - Shopify):
route: returns/create/shopify
interface_id: dcrpreturnscshopifyid12
protocol: http
domain: sales

Codigo Phyton DybamoDB -

import json
import urllib.request
import urllib.error
import base64
import boto3

# DynamoDB client
dynamodb = boto3.resource('dynamodb', region_name='ap-northeast-1')
table = dynamodb.Table('gdcr-kvm')

# Action Normalization
ACTION_MAP = {
    "create": "c", "read": "r", "update": "u", "delete": "d",
    "notify": "n", "sync": "s", "transfer": "t"
}

# SAP CPI Credentials
CPI_USER = "sb-5f5f4edd-3aff-44cd-b212-89c6805273f6!b601470|it-rt-282cc9datrial!b26655"
CPI_PASSWORD = "ebe8a89b-2583-46d0-9aa5-21522aab6815$oIfzW3sV76-x82dNXwnaUjscVuQLCjBKN_28AtQIGR8="
CPI_BASE = "https://282cc9datrial.it-cpitrial06.cfapps.us10-001.hana.ondemand.com"

def lambda_handler(event, context):
    try:
        raw_path = event['rawPath']
        path_parts = raw_path.strip('/').split('/')
        domain = path_parts[0]
        proxy_parts = path_parts[1:]
        proxy = '/'.join(proxy_parts)
        
        # Lookup DynamoDB
        response = table.get_item(Key={'route': proxy})
        
        if 'Item' not in response:
            return {'statusCode': 404, 'body': json.dumps({'error': 'Route not found', 'route': proxy})}
        
        item = response['Item']
        interface_id = item['interface_id']
        protocol = item['protocol']
        
        # Parse route
        parts = proxy.split('/')
        resource = parts[0]
        action = parts[1]
        backend = parts[2]
        action_short = ACTION_MAP.get(action, action[0])
        id_suffix = interface_id[-4:]
        
        # Build CPI URL
        generated_url = f"{CPI_BASE}/{protocol}/dcrp/{resource}/{action_short}/{backend}/{id_suffix}"
        
        # Prepare auth
        auth_string = f"{CPI_USER}:{CPI_PASSWORD}"
        auth_base64 = base64.b64encode(auth_string.encode()).decode()
        
        # Get body
        body_raw = b''
        if event.get('body'):
            if event.get('isBase64Encoded'):
                body_raw = base64.b64decode(event['body'])
            else:
                body_raw = event['body'].encode('utf-8')
        
        content_type = event.get('headers', {}).get('content-type', 'application/json')
        
        # Call CPI
        req = urllib.request.Request(
            generated_url,
            data=body_raw,
            headers={
                'Authorization': f'Basic {auth_base64}',
                'Content-Type': content_type
            },
            method='POST'
        )
        
        with urllib.request.urlopen(req, timeout=30) as resp:
            cpi_response_body = resp.read().decode('utf-8')
            cpi_status = resp.status
        
        return {
            'statusCode': cpi_status,
            'headers': {'Content-Type': content_type},
            'body': cpi_response_body
        }
        
    except urllib.error.HTTPError as e:
        return {'statusCode': e.code, 'body': e.read().decode('utf-8')}
    except urllib.error.URLError as e:
        return {'statusCode': 504, 'body': json.dumps({'error': f'CPI timeout: {str(e)}'})}
    except Exception as e:
        return {'statusCode': 500, 'body': json.dumps({'error': str(e)})}

<img width="1415" height="890" alt="image" src="https://github.com/user-attachments/assets/51e25d5c-8422-40ed-86f7-06df68759a43" />

