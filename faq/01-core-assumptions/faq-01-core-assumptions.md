# FAQ – Core Assumptions Behind GDCR

This section clarifies what GDCR **assumes** about real landscapes and what it does **not** assume about products.

---

## Q1 – Is SAP APIM (or any gateway) limited to 1:1 routing?

**No.** Modern gateways support 1:N routing (conditional flows, routing rules, header/path‑based routing). [web:18][web:24]

What GDCR assumes:

- In many enterprise landscapes, the **prevailing configuration pattern** is:
  - one proxy per backend system or integration,
  - one integration package per application or project,
  - naming and URLs that expose vendor/system details. [file:3][web:16][web:23]

GDCR treats this as the *starting point* (a common reality), not as a technical limitation.

---

## Q2 – What problems is GDCR explicitly trying to solve?

GDCR targets three structural problems:

1. **Proxy sprawl** – too many small, system‑centric proxies at the gateway.  
2. **Package/iFlow sprawl** – too many integration packages and iFlows grouped per system or project.  
3. **Credential sprawl** – many technical users and secrets scattered across proxies and packages. [file:1][file:3]

Side effects:

- Governance based on technical artifacts instead of business flows.
- Difficulty to reason about “how many Sales Order Create operations we really have”.
- High cost and risk when changing vendors or refactoring backends.

---

## Q3 – What does GDCR *not* claim?

GDCR does *not* claim that:

- SAP APIM or other gateways cannot do conditional routing or 1:N patterns.
- Domain‑centric designs do not exist at all in the wild.
- Using OpenAPI/Swagger is “wrong”.

Instead, GDCR says:

- The **dominant pattern** in many landscapes is system‑driven and leads to sprawl. [web:16][web:23]  
- A domain‑centric, metadata‑driven approach can significantly reduce sprawl and improve governance, as shown in the BTP sandbox/trial reference implementation. [file:3]

---

## Q4 – Is GDCR SAP-specific?

No.

- The reference implementation is on SAP BTP Integration Suite (SAP API Management + Cloud Integration). [file:3]  
- The architectural concepts (domain façades, semantic control plane, naming alignment) are portable to:
  - Apigee (JS + KVM),
  - Kong / APISIX (Lua plugins + Redis/Postgres),
  - AWS API Gateway (Lambda + DynamoDB),
  - Azure APIM (C# policies + storage),
  - MuleSoft (DataWeave + Object Store). [file:2]

GDCR is **vendor‑agnostic by design**; SAP BTP is one concrete proof of concept.

---

## Q5 – Is GDCR only about routing?

No. GDCR is a **multi‑layer pattern** that covers:

- Routing (DCRP – Domain‑Centric Routing Pattern). [file:3]  
- Package and iFlow layout (PDCP – Package Domain‑Centric Pattern). [file:3]  
- Naming and indexing conventions.  
- Security model (fast‑fail, sender × domain/entity/action matrix). [file:1]  
- Governance and observability (KPIs, semantic logs).

Routing is the visible front; the **real value** is the consistent semantic model across layers.
