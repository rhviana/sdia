Sales

<img width="763" height="1025" alt="image" src="https://github.com/user-attachments/assets/52380b29-ad00-42d8-bf3e-dc00a1f5422d" />

<img width="848" height="633" alt="image" src="https://github.com/user-attachments/assets/ea701522-ec52-4841-85a5-5db5f5deee40" />


<img width="762" height="1000" alt="image" src="https://github.com/user-attachments/assets/361c8ac5-de69-41e3-8930-80b1205e9a04" />

<img width="1088" height="712" alt="image" src="https://github.com/user-attachments/assets/6ba9c8eb-c371-4c79-b52f-88b51f763a1f" />


Finances - 

<img width="1241" height="908" alt="image" src="https://github.com/user-attachments/assets/5d25fa46-7f24-400d-bff2-72479783a08b" />

→ taxes/create/avalara [JSON]
  POST https://rg-gdcr-test.azure-api.net/finances/taxes/create/avalara [200 OK, 2.06kB, 238ms]
  √  Status 2xx
  √  Routing key presente
  √  CPI path presente

Iteration 8696/8696

→ invoices/create/quickbooks [SOAP]
  POST https://rg-gdcr-test.azure-api.net/finances/invoices/create/quickbooks [200 OK, 1.05kB, 133ms]
  √  Status 2xx
  √  Routing key presente
  √  CPI path presente

→ invoices/create/s4hana [SOAP]
  POST https://rg-gdcr-test.azure-api.net/finances/invoices/create/s4hana [200 OK, 1.07kB, 127ms]
  √  Status 2xx
  √  Routing key presente
  √  CPI path presente

→ payments/notify/stripe [JSON]
  POST https://rg-gdcr-test.azure-api.net/finances/payments/notify/stripe [200 OK, 2.02kB, 151ms]
  √  Status 2xx
  √  Routing key presente
  √  CPI path presente

→ payments/notify/s4hana [SOAP]
  POST https://rg-gdcr-test.azure-api.net/finances/payments/notify/s4hana [200 OK, 985B, 126ms]
  √  Status 2xx
  √  Routing key presente
  √  CPI path presente

→ accounts/sync/xero [JSON]
  POST https://rg-gdcr-test.azure-api.net/finances/accounts/sync/xero [200 OK, 2.03kB, 125ms]
  √  Status 2xx
  √  Routing key presente
  √  CPI path presente

→ journals/create/sap [SOAP]
  POST https://rg-gdcr-test.azure-api.net/finances/journals/create/sap [200 OK, 1.03kB, 211ms]
  √  Status 2xx
  √  Routing key presente
  √  CPI path presente

→ expenses/create/coupa [JSON]
  POST https://rg-gdcr-test.azure-api.net/finances/expenses/create/coupa [200 OK, 2.05kB, 128ms]
  √  Status 2xx
  √  Routing key presente
  √  CPI path presente

→ receipts/update/concur [SOAP]
  POST https://rg-gdcr-test.azure-api.net/finances/receipts/update/concur [200 OK, 2.07kB, 713ms]
  √  Status 2xx
  √  Routing key presente
  √  CPI path presente

→ budgets/sync/workday [SOAP]
  POST https://rg-gdcr-test.azure-api.net/finances/budgets/sync/workday [200 OK, 1.04kB, 168ms]
  √  Status 2xx
  √  Routing key presente
  √  CPI path presente

→ taxes/create/avalara [JSON]
  POST https://rg-gdcr-test.azure-api.net/finances/taxes/create/avalara [200 OK, 2.06kB, 133ms]
  √  Status 2xx
  √  Routing key presente
  √  CPI path presente

```text
┌─────────────────────────┬────────────────────┬────────────────────┐
│                         │           executed │             failed │
├─────────────────────────┼────────────────────┼────────────────────┤
│              iterations │               8696 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│                requests │              86960 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│            test-scripts │              86960 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│      prerequest-scripts │                  0 │                  0 │
├─────────────────────────┼────────────────────┼────────────────────┤
│              assertions │             260880 │                  1 │
├─────────────────────────┴────────────────────┴────────────────────┤
│ total run duration: 12h 44m 47.2s                                 │
├───────────────────────────────────────────────────────────────────┤
│ total data received: 24.71MB (approx)                             │
├───────────────────────────────────────────────────────────────────┤
│ average response time: 172ms [min: 106ms, max: 5.1s, s.d.: 142ms] │
└───────────────────────────────────────────────────────────────────┘

  #  failure                detail

 1.  AssertionError         Status 2xx
     iteration: 177         expected 500 to be one of [ 200, 201, 202 ]
                            at assertion:0 in test-script
                            inside "expenses/create/coupa [JSON]"
```
