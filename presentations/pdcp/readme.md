
# 🌐 SAP APIM: Domain-Centric Routing Pattern (DCRP)

> Enterprise API Gateway implementation for SAP BTP. Consolidates multiple technical endpoints into a single, business-aligned API Proxy using metadata-driven routing.

![Pattern](https://img.shields.io/badge/Pattern-DCRP--v1.0-blueviolet)
![Platform](https://img.shields.io/badge/Platform-SAP--APIM-blue)
![Security](https://img.shields.io/badge/Security-Shield--Enabled-red)

---

## 📖 The Problem: Proxy Sprawl
Traditional 1:1 integration creates a management nightmare. 100 

integrations typically require 100 individual API Proxies, leading to:
* 15-minute deployment per proxy.
* Inconsistent security policies.
* Massive technical debt.

## 🚀 The Solution: DCRP
DCRP reduces the proxy count by up to **96%** by using a single "Domain Proxy" (e.g., Sales, Finance) that dynamically routes traffic based on metadata.

[attachment_0](attachment)

### Key Benefits
* **Deployment Velocity:** 15 min → 30 seconds (via KVM update).
* **Consolidation:** 100 integrations → 4 strategic Domain Proxies.
* **Abstraction:** Frontend contracts remain unchanged even if the backend (CPI/S4HANA) migrates.

---

## 🧠 The Engine: KVM + JavaScript

The DCRP "Brain" resides in the **Target Endpoint Pre-Flow** of the SAP APIM Proxy.

### 1. Key-Value Map (KVM) - "The Memory"
Stores the mapping between semantic paths and technical iFlows.
* **Map Name:** `cpipackage-nx.sales.o2c.integrations`
* **Entry:** `inbound:iflow-sales-order-create`

### 2. JavaScript Policy - "The Brain"
Parses the incoming request segment and constructs the `target.url` dynamically.

```javascript
// Simplified DCRP Logic
var pathSuffix = context.getVariable("proxy.pathsuffix"); 
var routingTable = context.getVariable("kvm.iflowname"); // From KVM

// Logic to match pathSuffix with routingTable...
context.setVariable("target.url", cpiHost + "/http" + resolvedPath);
```

🛡️ Security Shield (Anti-Hacking)
​Since DCRP often uses "Catch-all" routes (/**), a Security Shield is mandatory in the Proxy Endpoint Pre-Flow to prevent:
​Path Traversal
​SQL Injection
​Unauthorized Domain Hijacking
​Whitelist Configuration


var allowedDomains = ["orders", "customers", "invoices", "payments"];
// Requests outside this list are blocked with 403 Forbidden before reaching the Brain.

🛠️ Implementation Guide
​Naming Standard
​[Provider]-[Pattern]-proxy-domain-[Domain]-[Subprocess]
​Example: cpi-dcrp-proxy-domain-sales-o2c
​Scaling Strategies
​Manual (Approach 1): Use specific Route Rules for high visibility in small domains.
​Dynamic (Approach 2): Use a single /** route with the Security Shield for enterprise-scale environments.
​📊 Analytics & BI
​We use the Statistics Collector to capture business metadata at runtime:
​X-Sender-ID: Who sent the request.
​X-IFlow-ID: Which backend processed it.
​X-Correlation-ID: End-to-end traceability.
​📚 Formal Citation
​Viana, R. L. H. (2026). Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven Architecture for Enterprise API Governance.
DOI: 10.5281/zenodo.18582469
​🤝 Contributing
​Clone the Domain Template.
​Update the mapIdentifier in the KVM Policy.
​Add your domain to the Security Shield whitelist.
​Deploy in < 2 minutes.
​<!-- end list -->

