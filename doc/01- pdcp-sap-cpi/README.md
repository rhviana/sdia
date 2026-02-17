
# PDCP – Package Domain-Centric Pattern (Orchestration Layer)

The **Package Domain-Centric Pattern (PDCP)** reorganizes integration artifacts (e.g. SAP Cloud Integration iFlows)
into domain-aligned packages with a strict, semantic naming convention. PDCP mirrors the GDCR/DCRP façade in the orchestration layer, so that:

- URLs in the gateway,
- metadata keys in KVM,
- package and iFlow names in CPI

all speak the **same domain language**. [file:3]

---

## Domain Packages

Instead of `Package_Salesforce_Orders`, `Package_Salesforce_Customers`, `Package_QuickBooks_Invoices`, etc., PDCP uses domain/subprocess-centric packages such as:

```text
nx.sales.o2c.integrations      # Sales – Order-to-Cash
nx.sales.crm.integrations      # Sales – CRM
nx.finance.r2r.integrations    # Finance – Record-to-Report
nx.finance.p2p.integrations    # Finance – Procure-to-Pay
nx.logistics.wms.integrations  # Logistics – Warehouse Management
