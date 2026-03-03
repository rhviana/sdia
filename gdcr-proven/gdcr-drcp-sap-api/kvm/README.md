# 🚀 GDCR – Domain-Centric KVM Reference Model

> Minimal reproducible KVM configuration aligned with the GDCR semantic facade.  
> Deterministic. Vendor-agnostic. Metadata-driven.

This repository demonstrates:

- Domain-centric routing
- Canonical action normalization
- Metadata-based backend resolution
- Immutable proxy + dynamic execution model

---

# 🔵 SALES (O2C)

## Semantic Facade

| ID   | Facade Path                         | Vendor          |
|------|-------------------------------------|-----------------|
| id01 | `/dcrp/o2c/orders/c/id01`           | salesforce      |
| id02 | `/dcrp/o2c/orders/u/id02`           | salesforce-emea |
| id03 | `/dcrp/o2c/customers/s/id03`        | shopify         |
| id04 | `/dcrp/o2c/payments/n/id04`         | stripe          |
| id05 | `/dcrp/o2c/orders/c/id05`           | microsoft       |
| id06 | `/dcrp/o2c/deliveries/t/id06`       | fedex           |
| id07 | `/dcrp/o2c/customers/s/id07`        | s4hana          |
| id08 | `/dcrp/o2c/payments/n/id08`         | s4hana          |
| id09 | `/dcrp/o2c/invoices/c/id09`         | quickbooks      |
| id10 | `/dcrp/o2c/invoices/c/id10`         | s4hana          |
| id11 | `/dcrp/o2c/deliveries/t/id11`       | s4hana          |
| id12 | `/dcrp/o2c/returns/c/id12`          | shopify         |

---

## KVM Configuration

### KVM Name
cpipackage-nx.sales.o2c.integrations

### Key
kvm.idinterface


### Value

```text
dcrporderscsalesforceid01:http,
dcrpordersusalesforceemeaid02:http,
dcrpcustomerssshopifyid03:http,
dcrppaymentsnstripeid04:http,
dcrporderscmicrosoftid05:cxf,
dcrpdeliveriestfedexid06:http,
dcrpcustomersss4hanaid07:cxf,
dcrppaymentsns4hanaid08:cxf,
dcrpinvoicescquickbooksid09:cxf,
dcrpinvoicescs4hanaid10:cxf,
dcrpdeliveriests4hanaid11:cxf,
dcrpreturnscshopifyid12:http
```

---

# 🟢 PROCUREMENT (P2P)

## Semantic Facade

| ID   | Facade Path                         | Vendor      |
|------|-------------------------------------|------------|
| id01 | `/dcrp/p2p/requisitions/c/id01`     | ariba      |
| id02 | `/dcrp/p2p/pos/c/id02`              | coupa      |
| id03 | `/dcrp/p2p/rfqs/c/id03`             | ariba      |
| id04 | `/dcrp/p2p/contracts/s/id04`        | jaggaer    |
| id05 | `/dcrp/p2p/invoices/a/id05`         | basware    |
| id06 | `/dcrp/p2p/suppliers/s/id06`        | ivalua     |
| id07 | `/dcrp/p2p/catalogs/u/id07`         | tradeshift |
| id08 | `/dcrp/p2p/grns/c/id08`             | wms        |
| id09 | `/dcrp/p2p/buyers/s/id09`           | oracle     |
| id10 | `/dcrp/p2p/sourcing/q/id10`         | ariba      |

---

## KVM Configuration

### KVM Name
cpipackage-nx.procurement.p2p.integrations

### Key
kvm.idinterface


### Value

```text
dcrprequisitionscaribaid01:cxf,
dcrpposccoupaid02:http,
dcrprfqscaribaid03:cxf,
dcrpcontractssjaggaerid04:http,
dcrpinvoicesabaswareid05:cxf,
dcrpsupplierssivaluaid06:http,
dcrpcatalogsutradeshiftid07:http,
dcrpgrnscwmsid08:cxf,
dcrpbuyerssoracleid09:http,
dcrpsourcingsqaribaid10:cxf
```

# 🟡 FINANCE (R2R)

## Semantic Facade

| ID   | Facade Path                     | Vendor      |
|------|---------------------------------|------------|
| id01 | `/dcrp/r2r/invoices/c/id01`     | quickbooks |
| id02 | `/dcrp/r2r/invoices/c/id02`     | s4hana     |
| id03 | `/dcrp/r2r/payments/n/id03`     | stripe     |
| id04 | `/dcrp/r2r/payments/n/id04`     | s4hana     |
| id05 | `/dcrp/r2r/accounts/s/id05`     | xero       |
| id06 | `/dcrp/r2r/journals/c/id06`     | sap        |
| id07 | `/dcrp/r2r/expenses/c/id07`     | coupa      |
| id08 | `/dcrp/r2r/receipts/u/id08`     | concur     |
| id09 | `/dcrp/r2r/budgets/s/id09`      | workday    |
| id10 | `/dcrp/r2r/taxes/c/id10`        | avalara    |

---

# 🟠 LOGISTICS (LE)

## Semantic Facade

| ID   | Facade Path                     | Vendor     |
|------|---------------------------------|-----------|
| id01 | `/dcrp/le/shipments/c/id01`     | fedex     |
| id02 | `/dcrp/le/trackings/u/id02`     | ups       |
| id03 | `/dcrp/le/deliveries/c/id03`    | dhl       |
| id04 | `/dcrp/le/shipments/q/id04`     | fedex     |
| id05 | `/dcrp/le/containers/s/id05`    | maersk    |
| id06 | `/dcrp/le/warehouses/u/id06`    | sf        |
| id07 | `/dcrp/le/freights/c/id07`      | coyote    |
| id08 | `/dcrp/le/routes/s/id08`        | project44 |
| id09 | `/dcrp/le/manifests/c/id09`     | customs   |
| id10 | `/dcrp/le/inventory/s/id10`     | wms       |

---

# Canonical Action Codes

| Code | Meaning   |
|------|----------|
| c    | Create   |
| r    | Read     |
| u    | Update   |
| d    | Delete   |
| s    | Sync     |
| n    | Notify   |
| t    | Transfer |
| a    | Approve  |
| q    | Query    |

---

# Architectural Notes

- Proxy remains immutable.
- Static domain guards enforce entity boundaries.
- Vendor resolution is metadata-only.
- New vendors require KVM insertion only.
- No proxy redeployment required.

---

# Minimal Reproducible Steps

1. Deploy domain proxy.
2. Attach DDCR routing engine.
3. Create KVM with domain-specific name.
4. Insert routing entries.
5. Test semantic facade.

---

> Stable outside. Infinite variability inside.  
> Business intent enters. Metadata decides.

---
## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** 10.5281/zenodo.xxxxx  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
