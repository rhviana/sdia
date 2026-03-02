{
  "info": {
    "name": "DDCR - Sales",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "orders/create/salesforce [JSON]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "application/json" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/orders/create/salesforce", "host": ["{{base}}"], "path": ["orders","create","salesforce"] },
        "body": {
          "mode": "raw",
          "raw": "{\n  \"id\": \"test-001\",\n  \"entity\": \"orders\",\n  \"action\": \"create\",\n  \"vendor\": \"salesforce\",\n  \"payload\": { \"orderId\": \"ORD-001\", \"amount\": 100.00, \"currency\": \"USD\" }\n}"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "orders/update/salesforceemea [JSON]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "application/json" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/orders/update/salesforceemea", "host": ["{{base}}"], "path": ["orders","update","salesforceemea"] },
        "body": {
          "mode": "raw",
          "raw": "{\n  \"id\": \"test-002\",\n  \"entity\": \"orders\",\n  \"action\": \"update\",\n  \"vendor\": \"salesforceemea\",\n  \"payload\": { \"orderId\": \"ORD-002\", \"status\": \"updated\" }\n}"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "customers/sync/shopify [JSON]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "application/json" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/customers/sync/shopify", "host": ["{{base}}"], "path": ["customers","sync","shopify"] },
        "body": {
          "mode": "raw",
          "raw": "{\n  \"id\": \"test-003\",\n  \"entity\": \"customers\",\n  \"action\": \"sync\",\n  \"vendor\": \"shopify\",\n  \"payload\": { \"customerId\": \"CUST-003\", \"email\": \"test@shopify.com\" }\n}"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "payments/notify/stripe [JSON]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "application/json" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/payments/notify/stripe", "host": ["{{base}}"], "path": ["payments","notify","stripe"] },
        "body": {
          "mode": "raw",
          "raw": "{\n  \"id\": \"test-004\",\n  \"entity\": \"payments\",\n  \"action\": \"notify\",\n  \"vendor\": \"stripe\",\n  \"payload\": { \"paymentId\": \"PAY-004\", \"amount\": 250.00, \"status\": \"paid\" }\n}"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "orders/create/microsoft [SOAP]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "text/xml;charset=UTF-8" },
          { "key": "SOAPAction", "value": "dcrp:orders:create:microsoft" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/orders/create/microsoft", "host": ["{{base}}"], "path": ["orders","create","microsoft"] },
        "body": {
          "mode": "raw",
          "raw": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dcrp=\"http://dcrp.example.com/\">\n  <soapenv:Header/>\n  <soapenv:Body>\n    <dcrp:OrdersCreateRequest>\n      <dcrp:id>test-005</dcrp:id>\n      <dcrp:entity>orders</dcrp:entity>\n      <dcrp:action>create</dcrp:action>\n      <dcrp:vendor>microsoft</dcrp:vendor>\n      <dcrp:payload>\n        <dcrp:orderId>ORD-005</dcrp:orderId>\n        <dcrp:amount>500.00</dcrp:amount>\n        <dcrp:currency>USD</dcrp:currency>\n      </dcrp:payload>\n    </dcrp:OrdersCreateRequest>\n  </soapenv:Body>\n</soapenv:Envelope>"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "deliveries/track/fedex [JSON]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "application/json" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/deliveries/track/fedex", "host": ["{{base}}"], "path": ["deliveries","track","fedex"] },
        "body": {
          "mode": "raw",
          "raw": "{\n  \"id\": \"test-006\",\n  \"entity\": \"deliveries\",\n  \"action\": \"track\",\n  \"vendor\": \"fedex\",\n  \"payload\": { \"trackingId\": \"FDX-006\", \"status\": \"in-transit\" }\n}"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "customers/sync/s4hana [SOAP]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "text/xml;charset=UTF-8" },
          { "key": "SOAPAction", "value": "dcrp:customers:sync:s4hana" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/customers/sync/s4hana", "host": ["{{base}}"], "path": ["customers","sync","s4hana"] },
        "body": {
          "mode": "raw",
          "raw": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dcrp=\"http://dcrp.example.com/\">\n  <soapenv:Header/>\n  <soapenv:Body>\n    <dcrp:CustomersSyncRequest>\n      <dcrp:id>test-007</dcrp:id>\n      <dcrp:entity>customers</dcrp:entity>\n      <dcrp:action>sync</dcrp:action>\n      <dcrp:vendor>s4hana</dcrp:vendor>\n      <dcrp:payload>\n        <dcrp:customerId>CUST-007</dcrp:customerId>\n        <dcrp:name>Test Customer</dcrp:name>\n      </dcrp:payload>\n    </dcrp:CustomersSyncRequest>\n  </soapenv:Body>\n</soapenv:Envelope>"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "payments/notify/s4hana [SOAP]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "text/xml;charset=UTF-8" },
          { "key": "SOAPAction", "value": "dcrp:payments:notify:s4hana" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/payments/notify/s4hana", "host": ["{{base}}"], "path": ["payments","notify","s4hana"] },
        "body": {
          "mode": "raw",
          "raw": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dcrp=\"http://dcrp.example.com/\">\n  <soapenv:Header/>\n  <soapenv:Body>\n    <dcrp:PaymentsNotifyRequest>\n      <dcrp:id>test-008</dcrp:id>\n      <dcrp:entity>payments</dcrp:entity>\n      <dcrp:action>notify</dcrp:action>\n      <dcrp:vendor>s4hana</dcrp:vendor>\n      <dcrp:payload>\n        <dcrp:paymentId>PAY-008</dcrp:paymentId>\n        <dcrp:amount>750.00</dcrp:amount>\n      </dcrp:payload>\n    </dcrp:PaymentsNotifyRequest>\n  </soapenv:Body>\n</soapenv:Envelope>"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "invoices/create/quickbooks [SOAP]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "text/xml;charset=UTF-8" },
          { "key": "SOAPAction", "value": "dcrp:invoices:create:quickbooks" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/invoices/create/quickbooks", "host": ["{{base}}"], "path": ["invoices","create","quickbooks"] },
        "body": {
          "mode": "raw",
          "raw": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dcrp=\"http://dcrp.example.com/\">\n  <soapenv:Header/>\n  <soapenv:Body>\n    <dcrp:InvoicesCreateRequest>\n      <dcrp:id>test-009</dcrp:id>\n      <dcrp:entity>invoices</dcrp:entity>\n      <dcrp:action>create</dcrp:action>\n      <dcrp:vendor>quickbooks</dcrp:vendor>\n      <dcrp:payload>\n        <dcrp:invoiceId>INV-009</dcrp:invoiceId>\n        <dcrp:amount>1000.00</dcrp:amount>\n      </dcrp:payload>\n    </dcrp:InvoicesCreateRequest>\n  </soapenv:Body>\n</soapenv:Envelope>"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "invoices/create/s4hana [SOAP]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "text/xml;charset=UTF-8" },
          { "key": "SOAPAction", "value": "dcrp:invoices:create:s4hana" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/invoices/create/s4hana", "host": ["{{base}}"], "path": ["invoices","create","s4hana"] },
        "body": {
          "mode": "raw",
          "raw": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dcrp=\"http://dcrp.example.com/\">\n  <soapenv:Header/>\n  <soapenv:Body>\n    <dcrp:InvoicesCreateRequest>\n      <dcrp:id>test-010</dcrp:id>\n      <dcrp:entity>invoices</dcrp:entity>\n      <dcrp:action>create</dcrp:action>\n      <dcrp:vendor>s4hana</dcrp:vendor>\n      <dcrp:payload>\n        <dcrp:invoiceId>INV-010</dcrp:invoiceId>\n        <dcrp:amount>1200.00</dcrp:amount>\n      </dcrp:payload>\n    </dcrp:InvoicesCreateRequest>\n  </soapenv:Body>\n</soapenv:Envelope>"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "deliveries/track/s4hana [SOAP]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "text/xml;charset=UTF-8" },
          { "key": "SOAPAction", "value": "dcrp:deliveries:track:s4hana" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/deliveries/track/s4hana", "host": ["{{base}}"], "path": ["deliveries","track","s4hana"] },
        "body": {
          "mode": "raw",
          "raw": "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:dcrp=\"http://dcrp.example.com/\">\n  <soapenv:Header/>\n  <soapenv:Body>\n    <dcrp:DeliveriesTrackRequest>\n      <dcrp:id>test-011</dcrp:id>\n      <dcrp:entity>deliveries</dcrp:entity>\n      <dcrp:action>track</dcrp:action>\n      <dcrp:vendor>s4hana</dcrp:vendor>\n      <dcrp:payload>\n        <dcrp:deliveryId>DEL-011</dcrp:deliveryId>\n        <dcrp:status>shipped</dcrp:status>\n      </dcrp:payload>\n    </dcrp:DeliveriesTrackRequest>\n  </soapenv:Body>\n</soapenv:Envelope>"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "returns/create/shopify [JSON]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "application/json" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/returns/create/shopify", "host": ["{{base}}"], "path": ["returns","create","shopify"] },
        "body": {
          "mode": "raw",
          "raw": "{\n  \"id\": \"test-012\",\n  \"entity\": \"returns\",\n  \"action\": \"create\",\n  \"vendor\": \"shopify\",\n  \"payload\": { \"returnId\": \"RET-012\", \"orderId\": \"ORD-001\", \"reason\": \"defective\" }\n}"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    },
    {
      "name": "returns/create/s4hana [JSON]",
      "request": {
        "method": "POST",
        "header": [
          { "key": "Content-Type", "value": "application/json" },
          { "key": "Ocp-Apim-Subscription-Key", "value": "{{apiKey}}" }
        ],
        "url": { "raw": "{{base}}/returns/create/s4hana", "host": ["{{base}}"], "path": ["returns","create","s4hana"] },
        "body": {
          "mode": "raw",
          "raw": "{\n  \"id\": \"test-013\",\n  \"entity\": \"returns\",\n  \"action\": \"create\",\n  \"vendor\": \"s4hana\",\n  \"payload\": { \"returnId\": \"RET-013\", \"orderId\": \"ORD-002\", \"reason\": \"wrong-item\" }\n}"
        }
      },
      "event": [{
        "listen": "test",
        "script": { "exec": [
          "pm.test('Status 2xx', function() { pm.expect(pm.response.code).to.be.oneOf([200,201,202]); });",
          "pm.test('Routing key presente', function() { pm.expect(pm.response.headers.get('x-ddcr-routing-key')).to.not.be.null; });",
          "pm.test('CPI path presente', function() { pm.expect(pm.response.headers.get('x-ddcr-cpi-path')).to.not.be.null; });"
        ]}
      }]
    }
  ],
  "variable": [
    { "key": "base", "value": "https://rg-gdcr-test.azure-api.net/sales" },
    { "key": "apiKey", "value": "7522c9500132428b91fc879814e8af80" }
  ]
}