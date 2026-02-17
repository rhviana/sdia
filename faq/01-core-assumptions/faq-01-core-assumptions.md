```markdown
# FAQ – Core Assumptions Behind GDCR

This FAQ clarifies what GDCR assumes about real‑world landscapes and what it does **not** assume about products.

---

## Q1 – Is SAP APIM (or any gateway) limited to 1:1 routing?

**No.** Modern gateways support 1:N routing (conditional flows, routing rules, header/path‑based routing). [web:18][web:24]

GDCR’s observation:

- In many enterprise landscapes, the **prevailing configuration pattern** is:
  - one proxy per backend system or integration,
  - one integration package per application or project,
  - URLs and names that expose vendor/system details. [file:3][web:16][web:23]

This is a **usage pattern**, not a product limitation.

---

## Q2 – What problems is GDCR explicitly trying to solve?

GDCR targets three structural problems:

1. **Proxy sprawl** – too many small, system‑centric proxies at the gateway.  
2. **Package/iFlow sprawl** – too many integration packages and iFlows grouped per system or project.  
3. **Credential sprawl** – many technical users and secrets scattered across proxies and packages. [file:1][file:3]

Consequences:

- Governance based on technical artifacts instead of business flows.
- Difficult to answer simple questions like “how many Sales Order Create operations do we have across vendors?”.
- High cost and risk when changing vendors or refactoring backends.

---

## Q3 – What does GDCR *not* claim?

GDCR does **not** claim that:

- SAP APIM cannot do conditional routing or 1:N patterns.
- Domain‑centric API designs do not exist anywhere.
- Using OpenAPI/Swagger is “wrong”.

GDCR claims that:

- The **dominant pattern** in many landscapes is system‑driven and leads to sprawl. [web:16][web:23]  
- A domain‑centric, metadata‑driven approach can significantly reduce sprawl and improve governance, as shown in the SAP BTP sandbox/trial reference implementation. [file:3]

---

## Q4 – Is GDCR SAP‑specific?

No.

- The reference implementation is on SAP BTP Integration Suite (SAP API Management + Cloud Integration). [file:3]  
- The same ideas (domain façades, semantic control plane, naming alignment) can be implemented on:
  - Apigee (JavaScript + KVM),
  - Kong/APISIX (Lua plugins + Redis/Postgres),
  - AWS API Gateway (Lambda + DynamoDB),
  - Azure APIM (C# policies + storage),
  - MuleSoft (DataWeave + Object Store). [file:2]

GDCR is **vendor‑agnostic**; SAP BTP is one concrete proof.

---

## Q5 – Is GDCR only about routing?

No.

GDCR is a **multi‑layer pattern** covering:

- Routing (DCRP – Domain‑Centric Routing Pattern at the gateway). [file:3]  
- Package and iFlow layout (PDCP – Package Domain‑Centric Pattern in CPI). [file:3]  
- Naming and indexing conventions.  
- Security model (fast‑fail, sender × domain/entity/action matrix). [file:1]  
- Governance and observability (metrics, KPIs, logs).

Routing is only the visible tip; the value is the **consistent semantic model across all layers**.
