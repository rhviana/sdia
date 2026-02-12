# Gateway Layer: DCRP Intelligence

This sector manages the **Domain-Centric Routing Pattern**, serving as the "Brain" of the integration landscape.

---

## The Routing Engine (v8.0)

We utilize a zero-allocation JavaScript engine at the SAP APIM edge to resolve backend targets dynamically via **Key-Value Maps (KVM)**.
* **Metadata-Driven**: No redeployment required to add new vendors.
* **Latency-Optimized**: Routing resolution happens in < 10ms.

---

## Security Shield

To protect catch-all routes (`/**`), we implement a perimeter defense layer:
* **Whitelist Validation**: Only authorized domain paths reach the engine.
* **Anti-Hacking**: Immediate rejection of SQLi and Path Traversal attempts.

---

## Components

* `EngineV8.js`: Core routing logic.
* `SecurityShield.js`: Edge protection logic.
* `KVM-Template.json`: Metadata structure for domain mapping.

---
