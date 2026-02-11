### GDCR Global Mapping Table - Full Enterprise Distribution

### ⚠️ Implementation Requirements & Sandbox Validation

### This configuration was strictly utilized for Sandbox Validation within the SAP BTP Integration Suite (API Management) environment. It serves as a high-performance template for the DCRP solution.

| SAP Business Process (kvm.sapprocess) | CPI Package Name (kvm.packagename) | KVM ID Interface (kvm.idinterface) |
| :--- | :--- | :--- |
| **SAP SD & O2C** (Sales Process) | `nx.sales.o2c.integrations` | `dcrporderscsalesforceid01:http`, `dcrpordersusalesforceemeaid02:http`, `dcrpcustomerssshopifyid03:http`, `dcrppaymentsnstripeid04:http`, `dcrporderscmicrosoftid05:cxf`, `dcrpdeliveriestfedexid06:http`, `dcrpcustomersss4hanaid07:cxf`, `dcrppaymentsns4hanaid08:cxf`, `dcrpinvoicescquickbooksid09:cxf`, `dcrpinvoicescs4hanaid10:cxf`, `dcrpdeliveriests4hanaid11:cxf`, `dcrpreturnscshopifyid12:http` |
| **SAP MM & P2P** (Procure to Pay) | `nx.procurement.p2p.integrations` | `dcrprequisitionscaribaid01:cxf`, `dcrpposcoupaid02:http`, `dcrprfqscaribaid03:cxf`, `dcrpcontractssjaggaerid04:http`, `dcrpinvoicesabaswareid05:cxf`, `dcrpsupplierssivaluaid06:http`, `dcrpcatalogsutradeshiftid07:http`, `dcrpgrnscwmsid08:cxf`, `dcrpbuyerssoracleid09:http`, `dcrpsourcingsqaribaid10:cxf` |
| **SAP FI & R2R** (Record to Report) | `nx.finance.r2r.integrations` | `dcrpinvoicescquickbooksid01:cxf`, `dcrpinvoicescs4hanaid02:cxf`, `dcrppaymentsnstripeid03:http`, `dcrppaymentsns4hanaid04:http`, `dcrpaccountssxeroid05:http`, `dcrpjournalscsapid06:cxf`, `dcrpexpensesccoupaid07:http`, `dcrpreceiptsuuconcurid08:cxf`, `dcrpbudgetssworkdayid09:cxf`, `dcrptaxescavalaraid10:http` |
| **SAP LE & WM** (Logistics Execution) | `nx.logistics.le.integrations` | `dcrpshipmentscfedexid01:http`, `dcrptrackingsuupsid02:http`, `dcrpdeliveriescdhlid03:cxf`, `dcrpshipmentsqfedexid04:http`, `dcrpcontainerssmaerskid05:http`, `dcrpwarehousesusfid06:cxf`, `dcrpfreightsccoyoteid07:http`, `dcrproutessproject44id08:http`, `dcrpmanifestsccustomsid09:cxf`, `dcrpinventoryswmsid10:cxf` |

### ⚠️ Critical Dependency:

For the "Commander's Brain" (JavaScript Engine) to function correctly, the KVM structure must strictly follow the naming convention presented in this documentation:

     . kvm.idinterface: Must contain the concatenated routing keys (e.g., dcrp + entity + action + id).
     . kvm.sapprocess: Required for business process identification.
     . kvm.packagename: Essential for the Mirror Strategy with the PDCP backend.

### Note on Design: While a fully dynamic, "loose" mapping was considered, it would introduce unnecessary complexity and latency. To ensure ultra-low latency (<2ms) and reliable Metadata-Driven execution, the engine relies on this static, well-defined contract between the Gateway and the Key Value Map.
