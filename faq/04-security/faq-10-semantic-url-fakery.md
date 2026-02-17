
# FAQ-10 – What is Semantic URL Fakery?

## Q1 – What does "Semantic URL Fakery" mean in GDCR?

In GDCR, **Semantic URL Fakery** means exposing clean, business‑oriented paths to consumers while completely masking the internal technical complexity.  
Instead of seeing technical hostnames or system-specific codes, the consumer only interacts with a stable, logical interface:

- Public path: `/sales/orders/create`  
- Hidden reality (example): `http://cpi-tenant-qa.region.aws.ondemand.com/http/v1/s4/fi/order_creation_v2`

## Q2 – What information is hidden from the consumer?

By using this abstraction layer, GDCR hides:

- **Hostnames:** No internal server names or cloud tenant IDs are exposed.  
- **System codes:** Identifiers like `ECC`, `S4H`, `SFDC` (Salesforce) or `WDAY` (Workday) are masked.  
- **Environment tags:** The URL does not change based on `dev`, `qa`, `prod` or region identifiers.  
- **Orchestration IDs:** CPI package names, iFlow technical paths and internal versioning remain private.

## Q3 – How is this resolved internally? (Architecture flow)

The gateway acts as a translator: it takes the clean URL, looks up the technical target in a metadata store (KVM) and uses a JavaScript engine to build the final route.

```text
[ EXTERNAL / PUBLIC SIDE ]             [ INTERNAL / PRIVATE SIDE ]
      Clean & Semantic                       Technical & Complex

      CONSUMER REQUEST
             |
             v
    /sales/orders/create   <--- "Fake Path" (Stable)
             |
    +--------|---------------------------------------------------+
    |        |        SAP APIM - DOMAIN FACADE                   |
    |        v                                                   |
    |  [ 1. KVM Lookup ] -----------------> [ KVM STORE ]        |
    |        |                              | Key: s_o_c         |
    |        | <--------------------------- | Value: "id01|auth" |
    |        v                                                   |
    |  [ 2. JS Engine ]                                          |
    |    - Validates "id01|auth"                                 |
    |    - Builds: http://internal-cpi/salesforce/v2/orders      |
    |    - Sets: target.url                                      |
    +--------|---------------------------------------------------+
             |
             v
    [ SAP CPI / BACKEND ]   <--- "Real Path" (Hidden)
```

## Q4 – What are the benefits of this “fakery”?

- Security: Reduces the attack surface; attackers cannot infer backend paths, vendors or environments from the URL.
- Governance: Enables analytics and monitoring by Domain/Entity/Action instead of cryptic technical IDs.

Agility: You can swap backends (for example, from SAP ECC to S/4HANA) by updating only the KVM entry; the consumer URL remains unchanged.

Professionalism: Gives APIs a product-like surface, while the legacy and integration “spaghetti” stays behind the façade.
