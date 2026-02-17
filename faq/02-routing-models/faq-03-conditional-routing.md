# FAQ-03 – Traditional Conditional Routing

## Q1 – What is conditional routing in SAP APIM?

Conditional routing allows a single APIM proxy to:

- inspect the request path, method, headers, query parameters,
- route to different backend endpoints based on conditions. [web:18]

Example:

- Proxy base path: `/v1/Order`
- Conditions:
  - `/v1/Order/CreateOrder` → CPI iFlow A
  - `/v1/Order/ReadOrder`   → CPI iFlow B

Inside the proxy, conditional flows apply different:

- target endpoints,
- policies (quotas, transformations, etc.).

---

## Q2 – How does this help compared to strict 1:1?

Benefits over pure 1:1:

- multiple operations can share one proxy,
- some reuse of policies and configuration,
- fewer proxies than “one per method”.

However:

- routing logic is still **static and system‑centric**,
- paths often encode technical terms (`CreateOrder`, `ReadOrder`) instead of domain semantics,
- changing backends still requires editing proxy configuration and redeploying. [web:16][file:3]

---

## Q3 – How is this different from GDCR/DCRP?

Key differences:

- Traditional conditional routing:
  - hardcodes routing decisions in proxy policies,
  - often uses system or operation names with no global semantic model.

- GDCR/DCRP:
  - enforces a **uniform URL pattern**: `/{domain}/{entity}/{action}/{variant?}`,  
  - normalizes `action` to canonical codes (c/r/u/d/…),  
  - delegates routing decisions to a **semantic dictionary** (KVM),  
  - keeps proxy logic generic and metadata‑driven. [file:1][file:3]

Conditional routing is a **building block**; GDCR is an **architectural pattern** that uses it with a domain semantics framework.
