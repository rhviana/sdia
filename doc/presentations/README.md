# GDCR Framework: DCRP & PDCP Reference

This directory contains the technical documentation and core principles of the **Global Domain-Centric Routing (GDCR)** framework, designed for deterministic governance across API Gateways and Orchestration layers.

---

## Core Architecture Components

The framework is built upon three primary pillars that ensure technology serves the business domain, rather than the other way around.

### 1. GDCR (Global Domain-Centric Routing)
The overarching framework. It is a semantic control system where routing is based on the **Business Domain**, making vendors (Salesforce, SAP, etc.) mere implementation details.

* **Goal:** Deterministic routing and unified governance.
* **Key Value:** Eliminates hardcoded routing logic and centralizes decision-making via Metadata (KVM/Redis).

### 2. DCRP (Domain-Centric Routing Pattern)
The pattern applied at the **API Gateway** layer. It defines how URLs are exposed to the outside world.

* **Structure:** `/domain/entity/action`
* **Example:** `/sales/orders/create`
* **Benefit:** The API consumer does not need to know if the backend is SAP or a Legacy system; the interface remains stable and semantic.

### 3. PDCP (Package Domain-Centric Pattern)
The pattern applied at the **Orchestration** layer (e.g., SAP Cloud Integration). It organizes technical artifacts by domain rather than by system.

* **Structure:** `prefix.domain.subprocess.integrations`
* **Example:** `nx.sales.o2c.integrations`
* **Benefit:** Groups all flows for a specific process (e.g., Order-to-Cash) into a single package, simplifying governance and discovery.

---

## Architectural Mapping

```text
       [ API GATEWAY ]            [ METADATA ]            [ ORCHESTRATION ]
```
# 📂 Folder Structure

## Document Overview

| File | Description |
|------|-------------|
| **DCRP.md** | Detailed Gateway route patterns and Semantic Façade definition |
| **PDCP.md** | Package organization model and domain-based artifact governance |
| **iFlow-DNA.md** | Deterministic naming convention for integration flows |
| **Mapping.md** | Interdependency mapping between the seven GDCR core patterns |
| **Audit-Compliance.md** | Structured traceability model and compliance primitives (SOX / GDPR aligned) |

---

# 🛠 Quick Implementation Guide

## 1. Define Domains
Map business subprocesses such as:
- O2C (Order-to-Cash)
- R2R (Record-to-Report)
- P2P (Procure-to-Pay)
- CRM
- WMS

Domains must reflect stable business capabilities, not vendor systems.

---

## 2. Normalize Actions
Adopt canonical action codes:

| Code | Meaning |
|------|---------|
| C | Create |
| R | Read |
| U | Update |
| D | Delete |
| S | Sync |
| A | Approve |
| N | Notify |

All heterogeneous API verbs must map into this canonical set.

---

## 3. Configure Gateway (DCRP)

- Create domain-level proxies
- Apply static route guards by entity
- Forward requests to the Dynamic Router (DDCR)
- Avoid vendor-specific proxies

The gateway façade must remain stable and business-semantic.

---

## 4. Implement Dynamic Routing (DDCR)

- Extract semantic path context
- Normalize action
- Resolve routing key via metadata
- Bind backend target dynamically
- Enforce fail-fast validation

No hardcoded vendor logic should exist in the proxy.

---

## 5. Organize Backend (PDCP)

- Create one package per business subprocess
- Avoid vendor-centric package fragmentation
- Apply iFlow DNA naming convention
- Maintain domain-level governance
---
## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** 10.5281/zenodo.xxxxx  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
            (DCRP)                    (DDCR)                    (PDCP)
              |                         |                         |
    /sales/orders/create  --->  Lookup Routing Key  --->  id01.o2c.salesforce...
