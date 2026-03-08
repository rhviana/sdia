# Quick Start: GDCR / DDCR on SAP BTP APIM + CPI

This guide demonstrates how to run the **GDCR/DDCR** (Global/Domain Component Routing) reference implementation end‑to‑end in a few minutes using **SAP BTP API Management** and **Cloud Integration (CPI)**. It utilizes the public **Phantom v12** engine and the sample metadata provided in this repository.

---

## 1. Prerequisites

* SAP BTP API Management instance (Trial or Productive).
* SAP BTP Cloud Integration (CPI) instance.
* Postman or Newman installed locally.
* Access to import APIs, policies, and integration packages.

---

## 2. Import the API Proxy and Scripts

1. **Clone or Download:** Get the files from this repository.
2. **APIM Import:** In APIM, import the provided API proxy for the Sales domain (e.g., `gdcr-sales-domain.zip`).
3. **Engine Script:** Add the **Phantom v12** JavaScript file (or the DCRP sample) as a policy under the **Target Endpoint Pre‑Flow**.
4. **Base Path:** Configure the API base path as `/sales`. All requests for the Sales domain will enter through this single proxy.

---

## 3. Create the KVM with Routing Metadata

1. In APIM, create a **Key Value Map (KVM)** for the Sales domain (e.g., `kvm-sales-idinterface`).
2. Insert the sample routing entries using the **GDCR DNA** format: `[prefix][entity][actioncode][vendor][iflowid]:[adapter]`.

### Example Entries:
```text
dcrporderscsalesforceid01:http
dcrporderscs4hanaid02:cxf
dcrpinvoicescs4hanaid10:cxf
Expose this KVM to the Phantom v12 policy via the variable kvm.idinterface.
```
[!NOTE]
At this point, all routing intelligence lives in metadata. The proxy and engine are static.

## 4. Deploy the CPI Package and iFlows
In Cloud Integration, import the provided integration package for the Sales domain (e.g., nx.sales.o2c.integrations).

Deploy the sample iFlows using the deterministic iFlow DNA naming convention:

Plaintext
id01.o2c.salesforce.order.s4hana.c.in.sync
id02.o2c.s4hana.order.target.c.in.sync
Ensure the internal HTTP endpoints match the adapter and idXX suffix referenced in the KVM keys.

The idXX value in the iFlow name must match the iflowid encoded in the KVM key.

## 5. Configure Gateway Variables
In the APIM proxy, set the following environment variables:

target.cpi.host: Your CPI runtime host (e.g., https://<tenant>-rt.cfapps.eu10.hana.ondemand.com).

kvm.idinterface: The name of the KVM containing your GDCR routing entries.

Optional: kvm.packagename, kvm.sapprocess for observability headers.

## 6. Run Sample Tests with Postman/Newman
Import the provided Postman collection (e.g., gdcr-sales.postman_collection.json).

Send requests such as:

HTTP
POST {{apim_url}}/sales/orders/create/salesforce
POST {{apim_url}}/sales/orders/create/s4hana
Key Benefits Observed:
Business Intent: The external URL only exposes intent: domain/entity/action/vendor.

Metadata Resolution: The engine resolves the correct backend from the KVM with no static URLs in the proxy.

Agility: Switching vendors or adding backends requires only KVM changes; no proxy or engine redeploys.

Summary: You now have a working GDCR/DDCR stack on SAP BTP: one proxy per domain, a deterministic routing engine, and metadata‑only onboarding.
