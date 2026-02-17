# FAQ-09 – Credential Sprawl and GDCR

## Q1 – How does GDCR reduce credential sprawl?

By consolidating proxies and packages into **domain‑based façades**, GDCR eliminates the need for a 1:1 ratio between technical users and interfaces. [file:80][file:81]  
Instead of “one technical user per tiny proxy”, credentials are managed at the level of backend system, trust boundary, or domain package, which drastically reduces duplication. [file:80][file:81]  
In sandbox trials, the number of technical users dropped from 39 to 12 (≈69% reduction), while keeping clear ownership boundaries. [file:80][file:81]

## Q2 – How is “credential sprawl” visualized?

Traditional models generate a “spaghetti” of credentials, whereas GDCR creates a security “funnel” that simplifies management. [file:80]

```text
[ TRADITIONAL MODEL ]                  [ GDCR / DCRP MODEL ]
   (Credential Sprawl)                    (Security Funnel)

 Proxy A --> User_A1 --> DB_1          Domain Façade --+
 Proxy B --> User_B2 --> DB_1                          |
 Proxy C --> User_C3 --> DB_1           [ KVM / JS ] --+--> Global_User_01
 Proxy D --> User_D4 --> DB_2                          |        (Target DB)
 Proxy E --> User_E5 --> DB_2           [ KVM / JS ] --+--> Global_User_02
                                                                (Target CRM)

 RESULT: 1 Proxy = 1 User               RESULT: Multiple routes share 
 Complexity grows exponentially.        secure, governed credentials.

```

## Q3 – Is it safe to reuse credentials across multiple operations?
Yes, as long as reuse is governed.

All operations target the same backend system and fall within the same trust boundary. 

The operations belong to the same integration contract or domain package.

The backend applies least‑privilege roles/scopes for that technical user. 

GDCR does not enforce “one user for everything”; it removes unnecessary duplication created by system‑driven, per‑proxy credentialing and replaces it with explicit, governed sharing. 

## Q4 – How are credentials stored and used in this model?
GDCR decouples credentials from the URL structure and from individual proxies. 

Secure storage: Credentials are held in APIM secure stores, encrypted KVMs, or the CPI credential store. 

Metadata reference: Each KVM routing entry references the target CPI endpoint and, optionally, a credential alias. 

Runtime injection: The JS engine reads the metadata, resolves the credential alias, and injects the required authentication before the request reaches the target backend. 

--------------------------

## Author: Ricardo Luz Holanda Viana
## Role: Enterprise Integration Architect · SAP BTP Integration Suite

Creator of: GDCR · DCRP · PDCP

Architectural scope: business‑semantic, domain‑centric routing architectures for API gateways and integration orchestration (vendor‑agnostic), with SAP‑specific implementations via DCRP (SAP BTP API Management) and PDCP (SAP BTP Cloud Integration). 

License: Creative Commons Attribution 4.0 International (CC BY 4.0)
DOI (Zenodo): zenodo.18661136
DOI (Figshare): figshare.31331683

This document is part of the Gateway Domain‑Centric Routing (GDCR) framework and represents original architectural work authored by Ricardo Luz Holanda Viana. Reuse, adaptation, and distribution are permitted only with proper attribution; any derivative or equivalent architectural implementation must reference the original work and associated DOIs. 

--------------------------
