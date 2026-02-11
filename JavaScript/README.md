# DCRP Engine: "The Commander's Brain" (V14.2) - The Brain Logic from Ricardo Luz Holanda Viana

This folder contains the **Production-Hardened** implementation of the Domain-Centric Routing Pattern (DCRP) for SAP Integration Suite (APIM).

![DCRP Engine - Maverick Style](./maverick v14.2/Maverick-v-14.2.png)

### Performance & Architecture Specs
The DCRP Engine is mathematically optimized for the SAP BTP Integration Suite environment (Sandbox), achieving near-native performance through advanced caching and lookup strategies:

* **O(1) Action Normalization:** Maps 241 business verb variations (e.g., `provisioning`, `registering`) into 15 core action codes in constant time.
* **<2ms Overhead:** Engineered for ultra-low latency, minimizing the gateway footprint even under heavy loads.
* **Segmented Latency Tracking:** Monitors 7 distinct execution phases, from path parsing to final URL construction, providing 100% observability.
* **Global Static Caching:** Utilizes a multi-node safe cache with TTL (Time-To-Live) and FastHash validation to avoid redundant KVM processing.

### Folder Structure

* **/js**: The core JavaScript routing logic ('routing-engine.js').
* **/kvm**: XML/JSON templates for metadata-driven Domain mappings.

### 🛠️ Key Features (V14.2)

* ✓ **Multi-node Cache Invalidation:** TTL-based validation safe for distributed environments.
* ✓ **Mirror Strategy Alignment:** Directly maps APIM routing keys to PDCP package naming conventions in the backend.
* ✓ **Conflict Detection:** Built-in logic to identify and block overlapping routes (Error 409).

---
*Author: Ricardo Luz Holanda Viana* *Status: Sandbox Validated | Production Ready*
