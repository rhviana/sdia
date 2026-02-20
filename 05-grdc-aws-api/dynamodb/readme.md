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
