## Quick Start – GDCR / DDCR on SAP BTP APIM + CPI

This guide shows how to run the GDCR/DDCR reference implementation end‑to‑end in a few minutes using SAP BTP API Management and Cloud Integration. It uses the public Phantom v12 engine and the sample metadata delivered in this repository. [file:79][file:77][file:78]

### 1. Prerequisites

- SAP BTP API Management instance (trial or productive)  
- SAP BTP Cloud Integration (CPI) instance  
- Postman or Newman installed locally  
- Access to import APIs, policies and integration packages [file:79][file:77]

---

### 2. Import the API Proxy and Scripts

1. Clone or download this repository.  
2. In APIM, import the provided API proxy for the Sales domain (for example `gdcr-sales-domain.zip`).  
3. Add the Phantom v12 JavaScript file (or the DCRP sample) as a policy under the **Target Endpoint Pre‑Flow**. [file:79]  
4. Configure the API base path as `/sales`. All requests for the Sales domain will enter through this single proxy. [file:78][file:96]

---

### 3. Create the KVM with Routing Metadata

1. In APIM, create a Key Value Map for the Sales domain (for example `kvm-sales-idinterface`).  
2. Insert the sample routing entries using the GDCR DNA format `[prefix][entity][actioncode][vendor][iflowid]:[adapter]`. [file:79][file:77][file:96]

   Example entries:

   ```text
   dcrporderscsalesforceid01:http
   dcrporderscs4hanaid02:cxf
   dcrpinvoicescs4hanaid10:cxf
