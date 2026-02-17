# DCRP: Taming Enterprise-Scale SAP Integration API Proxies

**Author:** Ricardo Luz Holanda Viana  
**Year:** 2026  
**Pattern Version:** v1.0  
**Original Article:** [SAP Community Blog](https://community.sap.com/t5/technology-blog-posts-by-members/sap-btp-apim-domain-centric-routing-pattern-dcrp-governing-apis-via-cpi/ba-p/14312788)

---

## 📋 Table of Contents

1. [Authorship & Origin](#authorship--origin)
2. [Executive Summary](#executive-summary)
3. [Target Audience & Prerequisites](#target-audience--prerequisites)
4. [Introduction](#introduction)
5. [The "Sprawl" Problem](#1---the-sprawl-problem)
6. [What is DCRP?](#2---what-is-dcrp-domain-centric-routing-pattern)
7. [Implementation: Configuring the DCRP API Proxy](#3---implementation-configuring-the-dcrp-api-proxy)
8. [Operational Simulation and Architectural Flow](#4---operational-simulation-and-architectural-flow)
9. [Scaling Strategies: Manual vs Dynamic Routing](#5---scaling-strategies-manual-vs-dynamic-routing)
10. [API Contracts, Versioning & OpenAPI Management](#6---api-contracts-versioning--openapi-management)
11. [Statistics Collector – Capturing Business Intelligence](#7---statistics-collector--capturing-business-intelligence)
12. [Troubleshooting: Common Issues & Solutions](#8---troubleshooting-common-issues--solutions)
13. [Conclusion: Discipline Over Chaos](#conclusion-discipline-over-chaos)
14. [How to Reference This Work](#how-to-reference-this-work)
15. [Intellectual Property & Copyright Notice](#intellectual-property--copyright-notice)

---

## Authorship & Origin - 2026

**DCRP (Domain-Centric Routing Pattern)** and **PDCP (Package Domain-Centric Pattern)** are original architectural patterns developed by **Ricardo Luz Holanda Viana**, derived from real-world enterprise integration scenarios and governance challenges in SAP BTP Integration Suite landscapes - API Management & Cloud Platform Integration.

### PEER-REVIEWED ACADEMIC PAPER PUBLISHED

**Official DOI:** [10.5281/zenodo.18582469](https://doi.org/10.5281/zenodo.18582469)  
**Published:** February 10, 2026 | **Repository:** Zenodo (CERN)  
**Status:** Open Access, Peer-Reviewed

This Medium article is the foundational disclosure (Feb 7, 2026). The complete academic paper with validation data, vendor implementations, and 40 references is now available:

**Download Full Paper (PDF):** [https://zenodo.org/records/18582469](https://zenodo.org/records/18582469)

### Validation Results

- **90% reduction** in API proxies (40 → 4)
- **90% reduction** in CPI packages (40 → 4)
- **95% faster** deployment (273 min → 14.5 min)
- **33,000+ messages** tested, 68ms latency, 100% success

**Citation:**  
Viana, R. L. H. (2026). *Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven Architecture for Enterprise API Governance.* Zenodo. [https://doi.org/10.5281/zenodo.18582469](https://doi.org/10.5281/zenodo.18582469)

---

## Executive Summary

### The Problem

Enterprise that contains SAP APIM suffers from **"Proxy Sprawl"**—where each integration requires a dedicated API proxy, creating a 1:1 relationship that leads to:

- Deployment bottlenecks (15 min per proxy)
- Inconsistent security architecture
- Unacceptable technical debt growth

### The Solution

The **Domain-Centric Routing Pattern (DCRP)** consolidates multiple backend services into a single, domain-based API Proxy using a metadata-driven routing engine (JavaScript + KVM).

### Impact

- **Reduces proxies by up to 96%** (100 integrations → 4 proxies)
- **Deployment time:** 15 min → 30 seconds
- **Centralized security, analytics, and traceability**
- **Validated:** 4 domains deployed in 8 minutes

### My Contribution - Ricardo Viana

Dynamic routing is a native feature in SAP APIM, AWS, and Kong. However, technology alone isn't enough. DCRP provides the **governance framework** necessary to scale this technology in enterprise environments, including standardized naming conventions, KVM structures + JavaScripts (Brain Logic of the solution), organization, orientation and deployment templates.

### Time Investment

- ⏱️ **Executive summary:** 90 seconds
- ⏱️ **Full technical guide:** 30~40 minutes

---

## 🎯 Target Audience & Prerequisites

### Intended for

- Integration Architects
- Enterprise Architects
- Solution Architects
- Platform Owners
- Governance Teams
- SAP BTP Integration Suite experts with hands-on API Management experience
- Anyone passionate about integration — junior, senior, or student level

### Technical Prerequisites

- ✅ **SAP API Management:** Proxy design (ProxyEndpoint/TargetEndpoint), Policy execution flow, KeyValueMap configuration
- ✅ **JavaScript in APIM:** Context variable manipulation, error handling
- ✅ **API Proxy Flow Architecture:** PreFlow/PostFlow execution order, when `target.url` can be modified
- ✅ **Enterprise Governance:** Naming conventions, change management, security policies

### Complexity Level

**Advanced**

**Not Covered:** Basic SAP APIM tutorials, JavaScript fundamentals, beginner proxy creation.

**Estimated PoC Time:**  
- 2 hours (APIM experts)
- 1–2 days (Integration Architects new to APIM)

---

## Introduction

SAP's official documentation explains **how** to enable dynamic routing, but it often leaves a gap regarding **when, why, and how to govern it at scale**. This article aims to bridge that gap by providing a complete framework—from architectural design to hands-on implementation.

Building on my previous post about Advanced Domain Routing, we will now deep-dive into applying the **Domain-Centric Routing Pattern (DCRP)** to a real-world scenario: **Sales & Distribution (O2C)**.

### The DCRP Value Proposition

- **Consolidation:** A single API Proxy manages multiple sources (Salesforce, Microsoft D365, Vendor CRM).
- **Governance:** Full request traceability and standardized security without infrastructure sprawl.
- **Scalability:** High-performance routing without the overhead of proxy-level versioning.

### What to Expect

This is **Part I** of a four-part series on eliminating integration chaos:

- **Part I (This Post):** DCRP Gateway | Solves Proxy Sprawl | Metadata-driven routing (KVM + JavaScript)
- **Part II:** PDCP Backend | Solves Package Sprawl | Domain consolidation + iFlow DNA naming
- **Part III:** Implementation & Testing | Hands-on guide | JavaScript v8.0 | Postman | GitHub repo
- **Part IV:** Monitoring with SAP Cloud ALM | End-to-end observability | MPL filtering | Dashboards & alerts

Let's explore the architectural rationale and the step-by-step implementation to apply DCRP in your landscape.

![Figure 1: DCRP - API Proxy Model](images/figura-01-dcrp-model.png)  
*Figure 1 - DCRP - API Proxy Model detailed exploration*

---

## 1 - The "Sprawl" Problem

In many enterprise landscapes, it is common to find a **1:1 relationship** between services and API Proxies. This leads to what we identify as **"Proxy Sprawl"**: an environment where proxies are created for every individual technical service, regardless of their business domain.

Without a central governance authority or standardized naming conventions, these environments quickly become **un-governed and unsustainable**. As the integration volume grows, the complexity of managing, securing, and monitoring hundreds of individual proxies creates a significant operational bottleneck.

This pattern is not theoretical; **DCRP was developed as a direct response** to these real-world governance gaps. Following extensive architectural validation, this methodology was formalized to provide a repeatable solution for the SAP Integration Community.

![Figure 2: The Sprawl Problem](images/figura-02-sprawl-problem.png)  
*Figure 2 - The Sprawl Problem*

---

## 2 - What is DCRP (Domain Centric Routing Pattern)?

The **Domain-Centric Routing Pattern (DCRP)** is an architectural design pattern that consolidates multiple backend services into a single, business-domain-oriented API Proxy. Residing at the **Gateway Layer**, DCRP governs how backend services are exposed and routed without necessitating changes to their underlying protocols (REST or SOAP).

Instead of organizing APIs into technical silos, DCRP aligns them with the organization's **business domains**. This approach significantly reduces API fragmentation and maintenance overhead while remaining fully compatible with SAP's API Product offerings.

### Core Principles

1. **Domain-Centric Organization**  
   - APIs grouped by business domain (Sales, Finance, Logistics)
   - **NOT** by technical system (Salesforce, SAP, D365)

2. **Metadata-Driven Routing**  
   - KeyValueMap (KVM) stores `path → backend` mappings
   - Changes in **30 seconds** without redeployment

3. **Protocol-Agnostic Gateway**  
   - Supports REST and SOAP backends
   - No protocol lock-in

![Figure 3: The Three Pillars of DCRP](images/figura-03-three-pillars.png)  
*Figure 3 - The three pillars of DCRP*

### 2.2 - DCRP Decision Framework

#### ✅ Use DCRP When

- **Domain Density:** 10+ APIs in same business domain
- **High Volatility:** Integration changes monthly
- **Centralized Governance:** Critical security requirements
- **Velocity:** Rapid deployment is business-critical

#### ❌ DO NOT Use When

- Unrelated services with no business logic connection
- Only 1-2 services per domain
- Fewer than 10 total APIs
- Teams lack governance maturity

![Figure 4: DCRP Decision Framework](images/figura-04-decision-framework.png)  
*Figure 4 - DCRP Decision Framework: When to Use vs. When NOT to Use*

### 2.3 - DCRP Architecture Overview: The Power of Dynamic Routing

The diagram below illustrates how the **Domain-Centric Routing Pattern (DCRP)** transforms the integration flow. Instead of a fragmented landscape of individual proxies, we consolidate connectivity through a unified, intelligent gateway layer.

#### The Technical Workflow

1. **Unified Entry Point:** Multiple consumer systems—such as Salesforce, Dynamics 365, and Vendor CRMs—connect through a single Sales Domain APIM Proxy.

2. **The DCRP Engine:** Within the SAP API Management Gateway, the request is processed by the **"Brain"** of the pattern, which performs a KVM Lookup and executes JavaScript logic to resolve the target backend dynamically.

3. **Secure Orchestration:** The request is routed via a secure tunnel to the appropriate Cloud Platform Integration (CPI) iFlow.

4. **Backend Flexibility:** CPI handles the final orchestration with target systems (e.g., S/4HANA, Legacy Systems, or SAP ECC) using protocols like ODATA, SOAP, or HTTPS.

5. **Governance at Scale:** This model eliminates the need for separate proxies per integration, allowing for centralized monitoring, auditing, and security enforcement through the Analytics Collector and a global Governance Layer.

![Figure 5: DCRP Architecture Overview](images/figura-05-architecture-overview.png)  
*Figure 5 - DCRP Architecture Overview end-to-end: Three-CRM Integration Scenario*

### 2.4 - The Technical Foundation: KVM + JavaScript

#### KeyValueMap (KVM) | The "Memory"

The KVM is a simple lookup table that stores your routing rules.

- **Decoupled Logic:** Maps `cpi-packagename`, `iflowname` → super important for the logic (the combination of `httppath<from cpi>:<iflowname>` and `sapprocess`)
- **Instant Updates:** Change a backend URL in the KVM, and the proxy updates immediately—no deployment needed
- **Data-Driven:** Business rules are stored as configuration, keeping the codebase clean

#### JavaScript Policy | The "Brain"

The JS policy executes the logic based on what it finds in the "Memory."

- **Dynamic Routing:** It fetches the destination from the KVM and constructs the final URL
- **Governance:** Automatically injects tracking headers like `X-SenderId` and `X-CorrelationId` for auditing
- **Fail-Safe:** Implements Structured Error Handling, ensuring that if a route is missing, the user gets a clear error message instead of a "silent failure"

![Figure 6: Engine KVM + JavaScript](images/figura-06-kvm-javascript.png)  
*Figure 6 - Engine KVM + JavaScript*

### 2.5 - Proxy Sprawl vs DCRP: The Comparison

The shift from a traditional 1:1 model to a Domain-Centric approach fundamentally changes how an integration landscape scales. The following comparison highlights the efficiency gains of the DCRP methodology:

#### Real Numbers

**100 integrations across 4 domains:**

- **Traditional:** 100 proxies × 15 min = **25 hours**
- **DCRP:** 4 proxies × 2 min = **8 minutes** (96% reduction)

![Figure 7: Proxy Sprawl vs DCRP Model](images/figura-07-sprawl-vs-dcrp.png)  
*Figure 7 - Proxy Sprawl vs DCRP Model*

---

## 3 - Implementation: Configuring the DCRP API Proxy

This section defines the configuration for the **ProxyEndpoint**, **Routing Rules**, and **Target Endpoint** properties required to deploy a domain-centric architecture.

### 3.1 - The Entry Contract: One API Proxy per Business Domain

DCRP eliminates proxy sprawl by consolidating multiple technical applications into a **single entry contract** based on the business domain. This ensures each business area, such as Sales or Finance, has exactly **one governed API Proxy**.

### 3.2 - Naming Convention Strategy

A standardized naming convention provides immediate architectural context. DCRP uses the following structure:

**Format:** `[Provider]-[Pattern]-proxy-domain-[BusinessProcess]-[subprocess]`

**Example:** `cpi-dcrp-proxy-domain-sales-o2c`

- **cpi:** Identifies the provider (SAP Cloud Integration)
- **dcrp:** Defines the routing methodology
- **sales:** Identifies the business domain/process (O2C)
- **o2c:** sap-subprocess

### 3.3 Strategic Benefit: Subprocess Segregation

Breaking the naming down to the **subprocess level** (e.g., `o2c` for Order-to-Cash) is a deliberate segregation strategy rather than a simple labeling exercise.

By isolating by subprocess, you limit the scope of each API Proxy. This prevents the **"Monolithic Proxy"** trap, ensuring that updates to one specific flow—such as Warehouse Management—do not risk the stability of the entire Logistics domain.

#### DCRP Proxy Naming Convention

**Pattern:** `cpi-dcrp-proxy-domain-[Domain]-[Subprocess]`

**Examples:**

```
cpi-dcrp-proxy-domain-sales-o2c          (Order-to-Cash)
cpi-dcrp-proxy-domain-sales-crm          (CRM integrations)
cpi-dcrp-proxy-domain-finance-r2r        (Record-to-Report)
cpi-dcrp-proxy-domain-logistics-scm      (Supply Chain Management)
cpi-dcrp-proxy-domain-procurement-p2p    (Procure-to-Pay)
```

### 3.3 - API Proxy Details

The proxy serves as the unified entry point for the domain:

- **Name:** `cpi-dcrp-proxy-domain-sales-o2c`
- **Type:** REST
- **Base URL:** `https://[tenant].apimanagement.eu20.hana.ondemand.com/sales`

### 3.4 - Endpoint, Routing Configuration, Value Mapping and Explanation

The **Routing Rules** act as a gatekeeper, ensuring only authorized paths reach the dynamic engine. In this sample we are working only with **orders process**.

#### Proxy Endpoint (Proxy Endpoint)

- **Route Rule Name:** `orders`
- **Condition:** `proxy.pathsuffix MatchesPath "/orders/**"`

**Imagine your API is a big office building.** This "Condition" is the security guard at the front desk checking the labels on incoming mail.

- **proxy.pathsuffix:** This is the "address" written on the envelope after the main building name.
- **MatchesPath:** This is the guard asking: "Does this address look like the one I'm looking for?"
- **"/orders/**":** This is the specific "Department" name. The double stars (`**`) mean "I don't care what else is written after 'orders', just as long as it starts with that."

#### Examples

| Incoming Path | Does it match? | Why? |
|---|---|---|
| `/orders/123` | ✅ Yes | Starts with `/orders/` |
| `/orders/list/today` | ✅ Yes | Starts with `/orders/` (the `**` covers the rest) |
| `/customers/456` | ❌ No | It's looking for "orders," not "customers" |
| `/orders` | ✅ Yes | It is the exact folder |

**The configuration below:**

![Figure 8: Configuring the Route Rule Condition](images/figura-08-route-rule.png)  
*Figure 8 - Configuring the Route Rule Condition*

#### Target Endpoint Properties

These properties provide the base connectivity for the routing engine:

| Property | Value |
|---|---|
| `cpi.host` | `https://[tenant].cfapps.eu20.hana.ondemand.com` |
| `cpi.basepath` | `/http/orders` |

![Figure 9: Target Endpoint Properties](images/figura-09-target-properties.png)  
*Figure 9 - The main properties for the JavaScript create the SAP CPI endpoint*

### Configuration of Key Value Mapping (KVM)

Following the suggested naming convention, you must create **one Key-Value Mapping for each SAP CPI package**:

**Example Maps:**  
- `cpipackage-nx.procurement.domain.process`
- `cpipackage-nx.sales.domain.process`
- etc.

![Figure 10: API-Proxy vs Key Value Mapping](images/figura-10-proxy-kvm.png)  
*Figure 10 - API-Proxy vs Key Value Mapping*

#### KVM Structure

Each map contains **three primary entries**:

1. **packagename:** The technical CPI package name (e.g., `nx.sales.domain.process`)
2. **sapprocess:** The business domain description (e.g., `SAP SD & O2C - Sales Process`)
3. **iflowname:** The routing metadata string

![Figure 11: Key Value Mapping Configuration](images/figura-11-kvm-config.png)  
*Figure 11 - Key Value Mapping Configuration*

### Understanding the iflowname String

The **iflowname** entry is the **"routing table"** for the DCRP. It contains pairs consisting of the **Semantic Path Suffix** (used by the consumer) and the **Technical iFlow Name** (the target in CPI). This string is parsed by the JavaScript "Brain," so maintaining the pattern is critical.

**Example Configuration:**  
`httppath: inbound:SO.01.Iflow.Sales.Order.Inbound,tracking:SO.02.Iflow.Sales.Order.Tracking`

The JavaScript supports almost all types of delimiters, but you **can't use two dots (`:`)** because this is the separation of http path URL from SAP CPI and the iFlow name. Between the records you can use any; my suggestion is `,`.

```javascript
// Auto-detect delimiter used in KVM string
var supportedDelimiters = [',', ';', '|', '/', '\\', '[', ']', '(', ')', '-', '_'];
```

It maps the public HTTP URL suffix to the specific CPI technical endpoint:

- **inbound** → Routes to `/inbound`
- **tracking** → Routes to `/tracking`

**inbound**  
CPI endpoint: `/orders/inbound`

![Example: inbound endpoint](images/figura-12-inbound-endpoint.png)

**tracking**  
CPI endpoint: `/orders/tracking`

![Example: tracking endpoint](images/figura-13-tracking-endpoint.png)

#### The SAP CPI Packages

Following the DCRP methodology, SAP CPI packages are organized as **domain-specific containers** that house multiple related integration flows.

![Figure: SAP CPI Packages](images/figura-14-cpi-packages.png)

### The Full Configuration of API Proxy

1. **Condition:** The Proxy Endpoint validates the path (e.g., `proxy.pathsuffix MatchesPath "/orders/**"`)
2. **Lookup:** The "Brain" extracts the `iflowname` string from the KVM
3. **Parsing:** The JavaScript splits the string using the `,` delimiter to extract individual pairs
4. **Generation:** The engine matches the incoming suffix (e.g., `/inbound`) and generates the final CPI Target URL
5. **End url:** `https://<cpi>/orders/inbound` and any other values from the KVM records

### ARCHITECT'S DEEP DIVE: WHY SUBDOMAIN SEGREGATION?

#### Context: The KVM Scaling Challenge

You might be wondering:

> "If I store all my iFlows in a single KVM as a concatenated string like `cpihttpPath:iflowName`, won't this become a gigantic string?"

**Answer:** Yes, exactly. And this is the core problem that led to the architectural pivot.

#### The Discovery: Storage ≠ Performance

**Initial Assumption:**

- Original design: 1 API Proxy per business domain (Sales, Finance, Logistics, Procurement)
- KVM strategy: Concatenated string with all iFlow routes in a single KVM entry
- Expected limit: SAP API Management documentation states **10 KB KVM value limit**

#### KVM Size Analysis (Theoretical, Not Production-Tested)

| Scenario | Size | Entries | Storage | Runtime Concern |
|---|---|---|---|---|
| Small Domain | ~5 KB | 40 entries | ✅ Within limits | Parsing overhead manageable |
| Medium Domain | ~10 KB | 53 entries | ✅ At documented limit | JavaScript performance degrades |
| Large Domain | ~15-30 KB | 100+ entries | ⚠️ Exceeds guideline | Bottleneck: O(n) parsing, not storage |

**Key Finding:**  
Storage capacity is not the constraint—**JavaScript parsing performance at scale** is.

### 3.5 - The Semantic Facade: One Proxy, Multiple Intentions

Instead of deploying separate proxies, **all consumers use the SAME API Proxy**. Differentiation is handled via path suffixes.

#### Consumer View (Public API)

```
POST https://apim/sales/orders/inbound
POST https://apim/sales/orders/tracking
```

#### Backend Reality (CPI)

```
https://cpi/http/orders/inbound
https://cpi/http/orders/tracking
```

#### Key Benefits

- **Total Abstraction:** Consumer contract unchanged if backend migrates
- **End-to-End Monitoring:** Unified analytics for entire Sales domain
- **Centralized Security:** One OAuth2 policy for all
- **Unified Traffic Control:** Spike Arrest and Quotas by domain

![Figure 12: Public API Paths](images/figura-15-public-paths.png)  
*Figure 12 - Public API paths mapped to technical CPI endpoints*

### 3.6 - The Routing Engine: Execution Flow

Every request passes through **three stages**:

#### Stage 1: Proxy Endpoint Pre-Flow

- Security policies (OAuth2, API Key)
- Hacking Thread JavaScript
- Request validation (payload size, content type)
- Traffic control (Spike Arrest, Quotas)
- ❌ Immediate rejection if policies fail

#### Stage 2: Routing Rules

- **Evaluate:** `proxy.pathsuffix MatchesPath "/orders/**"`
- ✅ **Match** → forward to Target Endpoint
- ❌ **No match** → 404 error

#### Stage 3: Target Endpoint Pre-Flow

- **DCRP Brain executes here** (last point to modify `target.url`)

![Figure 13: Three-Stage Request Processing](images/figura-16-execution-flow.png)  
*Figure 13 - Three-stage request processing with DCRP logic in Target Pre-Flow*

### 3.7 - The DCRP Brain: Policy Stages

The routing engine executes through **four policy stages** (Target Endpoint - PRE-Flow):

1. **Key Value Mapping:** Retrieves `httppath`, `iflowname`, and `sapprocess`
2. **JavaScript Routing:** Performs variable verification, validation, and injection of headers
3. **RaiseFaultException:** Blocks the process in case of exceptions, missing variables, or KVM misconfigurations
4. **Statistics Collection:** Captures custom dimension variables for the SAP APIM Dashboard

The DCRP pattern transforms the gateway into a **high-scale, programmable router** by decoupling configuration from execution and moving routing logic into metadata.

![Figure 14: KVM + JavaScript](images/figura-17-kvm-js.png)  
*Figure 14 - KVM + JavaScript*

### 3.8 Scaling Model: Vertical vs. Horizontal

#### Vertical Scaling (30 Seconds)

Add new iFlows to an existing domain by updating the KVM string. No infrastructure changes are required.

#### Horizontal Scaling (2 Minutes)

Onboard an entirely new business domain (e.g., Finance) by cloning the domain template and updating only the `mapIdentifier`.

![Figure 15: Two-Level Scaling Strategy](images/figura-18-scaling-model.png)  
*Figure 15 - Two-Level scaling strategy*

### Real-World Validation: 4 Business Domains Deployed

The methodology was validated by deploying **four business domains**—Sales, Logistics, Finance, and Procurement—managing **8 total iFlows**.

#### Validation Metrics

- **API Proxies Deployed:** 4
- **JavaScript Policies Reused:** 1 universal routing engine
- **Total Deployment Time:** Approximately **8 minutes** (~2 minutes per domain)
- **Resilience:** While DCRP returns an HTTP 404 if a specific iFlow endpoint is missing, the routing logic itself remains correct and operational

| Business Domain | API Proxy | CPI Package | iFlows | Time |
|---|---|---|---|---|
| Sales & O2C | `cpi-dcrp-proxy-domain-sales-o2c` | `cpipackage-nx.sales.domain.process` | 2 | 2 min |
| Logistics & Shipping | `cpi-dcrp-proxy-domain-logistics-scm` | `cpipackage-nx.logistics.domain.process` | 2 | 2 min |
| Finance & Billing | `cpi-dcrp-proxy-domain-finance-r2r` | `cpipackage-nx.finance.domain.process` | 2 | 2 min |
| Procurement | `cpi-dcrp-proxy-domain-procurement-s2p` | `cpipackage-nx.procurement.domain.process` | 2 | 2 min |

**Results:**
- 4 API Proxies managing 8 iFlows
- JavaScript policies reused: 1 (universal routing engine)
- Total deployment time: ~8 minutes

**Total Time = (N domains × 2 min) + (M iFlows × 30 sec)**

### 3.9 - The JavaScript "Brain" (Complete Code)

![Figure 16: JavaScript Coding](images/figura-19-js-code.png)  
*Figure 16 - JavaScript coding*

The code of JavaScript is into spoiler below.

#### TL;DR for Non-Developers

This JavaScript performs **4 tasks**:

1. Extracts path segments (e.g., `/inbound` → httppath cpi `inbound`)
2. Looks up routing metadata from KVM
3. Constructs final CPI URL dynamically
4. Injects governance headers (`X-SenderId`, `X-CorrelationId`)

**For Architects:** Review sections 1-4 for logic flow

**For Developers:** Full code below with inline comments

#### ⚠️ IMPLEMENTATION NOTICE

> **⚠️ IMPORTANT:** This code is a simplified reference implementation designed for **Proof-of-Concept (PoC)** scenarios and educational purposes. While fully functional for demonstrating the core DCRP pattern, this routing engine assumes a basic KVM structure with simple, human-readable path identifiers like `inbound`, `outbound`, `tracking`, `status`, etc., as shown in the blog examples.

**KVM Format Used in This Blog:**

Format: `<httppath>:<iflowname>`

Examples:
```
inbound:iflow-salesforce-order-create
outbound:iflow-sap-invoice-send
tracking:iflow-fedex-shipment-track
status:iflow-order-status-query
```

This approach works well for **PoC scenarios** with single iFlow per action and straightforward naming conventions.

#### Before Production Deployment

This code **must be adapted** based on your specific requirements:

- **KVM Structure Design** - The `iflowname` string format you choose will dictate the parsing logic
- **Naming Conventions** - Adapt routing logic to match your organization's naming patterns
- **Adapter Requirements** - HTTP-only vs. mixed HTTP/SOAP landscapes require different endpoint construction
- **Multi-Vendor Scenarios** - Single-vendor vs. multi-vendor per process may need disambiguation logic

#### Production-Ready Code: DCRP Routing Engine (Part II & III)

A comprehensive, production-grade routing engine covering all enterprise scenarios—multi-vendor disambiguation, PDCP naming compliance, HTTP/SOAP adapter support, conflict resolution (id09/id10), and global-scale architecture—is available in **Part II: Package Domain-Centric Pattern (PDCP)** and fully implemented in **Part III: Implementation & Testing**.

The latest **v8.0 engine** is specifically designed for the combined **DCRP + PDCP framework**, generating CPI endpoints with the `/dcrp/` prefix and automatic adapter detection:

- `/http/dcrp/` (HTTP)
- `/cxf/dcrp/` (SOAP)

This evolution handles complex KVM structures, scales to 100+ integrations with zero-code deployment for new vendors, and includes smart vendor-aware routing with fallback logic for seamless multi-instance disambiguation.

<details>
<summary>📄 View JavaScript "Brain" Code (PoC Version)</summary>

```javascript
// ============================================
// DCRP Routing Engine - Proof of Concept
// Version: v1.0 (Simplified)
// Author: Ricardo Luz Holanda Viana
// Year: 2026
// ============================================

// Section 1: Extract path segments
var pathsuffix = context.getVariable("proxy.pathsuffix");
var pathArray = pathsuffix.split("/");
var httppath = pathArray[pathArray.length - 1]; // e.g., "inbound"

// Section 2: Retrieve KVM metadata
var iflowname = context.getVariable("kvm.iflowname");
var packagename = context.getVariable("kvm.packagename");
var sapprocess = context.getVariable("kvm.sapprocess");

// Section 3: Parse KVM entries
var supportedDelimiters = [',', ';', '|', '/', '\\', '[', ']', '(', ')', '-', '_'];
var delimiter = ','; // Default
for (var i = 0; i < supportedDelimiters.length; i++) {
    if (iflowname.indexOf(supportedDelimiters[i]) > -1) {
        delimiter = supportedDelimiters[i];
        break;
    }
}

var entries = iflowname.split(delimiter);
var targetIflow = null;

for (var j = 0; j < entries.length; j++) {
    var entry = entries[j].trim();
    var parts = entry.split(':');
    var key = parts[0].trim();
    var value = parts[1].trim();
    
    if (key === httppath) {
        targetIflow = value;
        break;
    }
}

// Section 4: Construct target URL
if (targetIflow) {
    var cpiHost = context.getVariable("cpi.host");
    var cpiBasepath = context.getVariable("cpi.basepath");
    var targetUrl = cpiHost + cpiBasepath + "/" + httppath;
    
    context.setVariable("target.url", targetUrl);
    context.setVariable("idiflow", targetIflow);
    context.setVariable("idpackage", packagename);
    context.setVariable("idsapprocess", sapprocess);
    
    // Inject governance headers
    context.setVariable("request.header.X-SenderId", "DCRP-Gateway");
    context.setVariable("request.header.X-CorrelationId", context.getVariable("messageid"));
    context.setVariable("routing.failed", "false");
} else {
    context.setVariable("routing.failed", "true");
    context.setVariable("error.message", "Route not found for: " + httppath);
}
```

</details>

Add in sequence in the **Pre-Flow TargetEndpoint** - **Raise Fault Routing:**

**Condition:** `routing.failed = "true"`

![Figure 17: Raise Fault Configuration](images/figura-20-raise-fault.png)  
*Figure 17 - Raise Fault in case of failure in the "Brain JavaScript Routing"*

<details>
<summary>📄 View RaiseFault Policy XML</summary>

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<RaiseFault async="false" continueOnError="false" enabled="true" xmlns="http://www.sap.com/apimgmt">
    <FaultResponse>
        <Set>
            <StatusCode>404</StatusCode>
            <ReasonPhrase>Route Not Found</ReasonPhrase>
        </Set>
        <Payload contentType="application/json">
            {
                "error": "DCRP_ROUTING_ERROR",
                "message": "{error.message}",
                "timestamp": "{system.timestamp}",
                "domain": "sales",
                "path": "{proxy.pathsuffix}"
            }
        </Payload>
    </FaultResponse>
    <IgnoreUnresolvedVariables>false</IgnoreUnresolvedVariables>
</RaiseFault>
```

</details>

---

## 4 - Operational Simulation and Architectural Flow

This section demonstrates the practical execution of the **DCRP (Domain-Centric Routing Pattern)** framework by simulating how the routing engine processes a request through the landscape.

### Architectural Flow Simulation

Based on the provided technical diagram, the process follows a structured path from the initiating system to the final integration endpoint:

1. **Request Initiation:** External systems such as:
   - Salesforce → `http://<apim>/sales/orders/inbound`
   - Dynamics 365 → `http://<apim>/sales/orders/status`
   - Vendor CRMs → `http://<apim>/sales/orders/tracking`

2. **The DCRP Engine:** Upon reaching the SAP API Management Gateway, the **DCRP Engine** is triggered to manage the transaction logic.

3. **Metadata Retrieval (KVM Lookup):**
   - `Inbound:iflowname | sapprocess | cpipackage`
   - `Tracking:iflowname | sapprocess | cpipackage`
   - `Status:iflowname | sapprocess | cpipackage`

4. **Logical Resolution (JavaScript):** The JavaScript component processes the `proxy.pathsuffix` against the metadata retrieved from the KVM to determine the correct technical path:
   - `http://<cpi>/orders/inbound`
   - `http://<cpi>/orders/tracking`
   - `http://<cpi>/orders/status`
   - **Header details**

5. **Dynamic Routing:** The engine resolves the target and dynamically routes the traffic to the corresponding **SAP BTP Integration Suite iFlow**.

**Architect's Note:** This simulation highlights the **decoupling of the consumer from the technical backend**. The source systems interact only with a standardized semantic layer, while the routing engine manages all technical complexities internally.

![Figure 18: Operational Simulation](images/figura-21-operational-flow.png)  
*Figure 18 - Clear orientation how works the solution from the sender to SAP APIM*

---

## 5 - Scaling Strategies: Manual vs Dynamic Routing

Scaling DCRP effectively requires choosing between two distinct deployment approaches, depending on the complexity and regional requirements of the enterprise.

### Two Strategic Approaches

### 5.1 - Approach 1: Single Global Template

**How it works:** Create **1 Routing Rule per path** (`/orders/**`, `/customers/**`)

**Configuration:**
- 1 proxy per domain
- N routing rules (1 per path)
- Fixed `cpi.basepath` per rule

**Time per new path:** ~2 minutes (add routing rule + KVM entry)

**Best for:** Small domains (<5 paths), stable environments

![Figure 19: Template Part 1](images/figura-22-template-1.png)  
*Figure 19 - Template part 1*

![Figure 20: Template Part 2](images/figura-23-template-2.png)  
*Figure 20 - Template part 2*

Most importantly, you must ensure the **Target Endpoint PRE-Flow** is ready with the DCRP logic. While this approach provides explicit routing visibility, any additional requirements—such as specific security methods, quotas, or spike control—must be adjusted accordingly.

**Required Policies (Target Endpoint PreFlow):**

1. Key Value Mapping
2. JavaScript Routing
3. Raise Fault
4. Statistics Collector

Once this setup is finalized, it takes approximately **2 to 3 minutes** to have a fully functional API Proxy ready for operation, and **less than 30 seconds** to update metadata in the Key Value Mapping.

![Figure 21: Pre-Flow Setup](images/figura-24-preflow-setup.png)  
*Figure 21 - Pre-Flow setup - DCRP brain*

### 5.2 - Approach 2: Dynamic Multi-Path Routing

**How it works:**

- Single catch-all route (`/**`)
- JavaScript extracts first segment dynamically
- `cpi.basepath` is comma-delimited string of all paths

**Configuration:**

- 1 proxy per domain
- 1 catch-all routing rule
- Security Shield validates domain whitelist

**Time per new path:** ~30 seconds (update `cpi.basepath` string + KVM + Security whitelist)

**Best for:** Enterprise scale, frequent changes

#### Example Configuration

**Target Endpoint Property:** `cpi.basepath`

**Initial Value:**

```
/http/orders,/http/customers,/http/invoices,/http/prices
```

**Adding new path (payments):**

```
/http/orders,/http/customers,/http/invoices,/http/prices,/http/payments
```

#### Request Flow

| Request Path | First Segment | Dynamic Basepath | KVM Match | Final CPI URL |
|---|---|---|---|---|
| `/sales/customers` | customers | `/http/customers` | SO.01.Customer.MasterData | `https://cpi/http/customers` |
| `/sales/orders` | orders | `/http/orders` | SO.02.Order.Process | `https://cpi/http/orders` |
| `/sales/invoices` | invoices | `/http/invoices` | SO.03.Invoice.Billing | `https://cpi/http/invoices` |

**Mechanism:** JavaScript extracts first segment → builds `/http/{firstSegment}` → KVM lookup → routes to CPI.

![Figure 22: Scalation Mode](images/figura-25-scalation-mode.png)  
*Figure 22 - Scalation mode hard*

**Architect's Note Dynamic Multi-Path Routing:** This simulation highlights the decoupling of the consumer from the technical backend. The source systems interact only with a standardized semantic layer, while the routing engine manages all technical complexities internally.

![Figure 23: Dynamic Routing Flow](images/figura-26-dynamic-flow.png)  
*Figure 23 - Clear orientation how works the solution with Dynamic Multi-Path Routing from the sender to SAP APIM*

![Figure 24: cpi.basepath Configuration](images/figura-27-basepath-config.png)  
*Figure 24 - Setup of cpi.basepath variable in the target endpoint with full string or new incoming process*

To do this setup **takes 1 minute**.

### 5.3 - Security Shield: Critical for Dynamic Routing

#### Why It's Required

Catch-all route (`/**`) = every request reaches routing engine.

| Without Shield | With Shield |
|---|---|
| ❌ Path traversal reaches KVM/JS | ✅ Blocked at PreFlow (403) |
| ❌ SQL injection processed | ✅ Saves ~100ms per blocked request |
| ❌ Resource waste | ✅ Audit compliance (SOC 2/ISO 27001) |

#### Attack Scenarios

| Attack Type | Example | Without Shield | With Shield |
|---|---|---|---|
| Path Traversal | `/sales/../admin/delete` | ❌ Reaches KVM/JS | ✅ Blocked (403) |
| SQL Injection | `/orders?id=1 OR 1=1` | ❌ Reaches KVM/JS | ✅ Blocked (403) |
| Domain Hijacking | `/hacker-domain/exploit` | ❌ Reaches KVM/JS | ✅ Blocked (403) |
| Command Injection | `/orders?cmd=;cat /etc/passwd` | ❌ Reaches KVM/JS | ✅ Blocked (403) |

#### Configuration (30 seconds per path)

Add new path (e.g., `/payments`) in **3 locations**:

**1. Target Endpoint (cpi.basepath)**

```
/http/orders,/http/customers,/http/payments
```

**2. Security Whitelist (JS-Security-Shield.js) - Inside JavaScript code**

```javascript
var allowedDomains = ["sales", "orders", "customers", "invoices", "payments"]; // <-- add here new path
```

**3. KVM Entry (iflowname)**

```
orders:SO.01...,customers:SO.02...,payments:SO.03...
```

#### Execution API-Proxy Flow Steps

```
ProxyEndpoint PreFlow:
  1. JS-Security-Shield    → Validates whitelist, blocks attacks
  2. RF-SecurityThreat     → Returns 403 if threat
  3. Quota + Spike Arrest  → Rate limiting
     ↓
TargetEndpoint PreFlow:
  4. KVM Lookup + Routing  → Only if security passed
```

#### Performance (Telemetry)

| Scenario | Time Impact |
|---|---|
| Valid request | +10ms | ✅ Acceptable (8% total) |
| Blocked attack | 10ms (no KVM/JS) | ✅ Saves 100ms |

**Key Insight:** Security Shield prevents resource waste on malicious requests.

#### Why Not Rely on KVM for 404?

**Defense-in-depth principle:**

- **Resource Efficiency:** Blocks at PreFlow (saves KVM + JS overhead)
- **Attack Intelligence:** Logs threats for SIEM
- **Blast Radius:** KVM misconfiguration doesn't expose all paths
- **Compliance:** SOC 2/ISO 27001 require gateway validation

#### JavaScript Thread Hacking Protection - (Complete Code)

![Figure 25: JavaScript Hacking Protection](images/figura-28-js-security.png)  
*Figure 25 - JavaScript Policy - Hacking thread protection*

In this case you need to add this JavaScript in the **Proxy End-point - Pre-Flow** to stop immediately any hacking or SQL injection, because now the routing mechanism is not based on path, is start - `proxy.pathsuffix MatchesPath "/**"`

![Figure 23: JavaScript Thread Protection](images/figura-29-js-preflow.png)  
*Figure 23 - JavaScript Thread Protection - ProxyEndpoint - Preflow*

Add in sequence - **RaiseFault Hacking thread:**

**Condition:** `security.raise.fault = "true"`

![Figure 24: Raise Fault Thread](images/figura-30-raise-fault-security.png)  
*Figure 24 - Raise Fault Thread of Hacking, SQL injection and others*

<details>
<summary>📄 View Security Shield JavaScript Code</summary>

```javascript
// ============================================
// DCRP Security Shield v1.0
// Purpose: Protects catch-all route (/**) from malicious requests
// Author: Ricardo Luz Holanda Viana
// Year: 2026
// ============================================

var pathsuffix = context.getVariable("proxy.pathsuffix");
var allowedDomains = ["sales", "orders", "customers", "invoices", "payments"];

// Extract first segment
var pathArray = pathsuffix.split("/");
var firstSegment = pathArray[1]; // e.g., "sales"

// Security checks
var isThreat = false;
var threatType = "";

// 1. Check if domain is in whitelist
if (allowedDomains.indexOf(firstSegment) === -1) {
    isThreat = true;
    threatType = "INVALID_DOMAIN";
}

// 2. Path traversal detection
if (pathsuffix.indexOf("..") > -1 || pathsuffix.indexOf("~") > -1) {
    isThreat = true;
    threatType = "PATH_TRAVERSAL";
}

// 3. SQL injection detection
var sqlPatterns = [/(\s*(OR|AND)\s+[\w\s]*=)/gi, /(UNION|SELECT|INSERT|UPDATE|DELETE|DROP)/gi];
for (var i = 0; i < sqlPatterns.length; i++) {
    if (sqlPatterns[i].test(pathsuffix)) {
        isThreat = true;
        threatType = "SQL_INJECTION";
        break;
    }
}

// 4. Command injection detection
var cmdPatterns = [/[;&|`$]/g];
for (var j = 0; j < cmdPatterns.length; j++) {
    if (cmdPatterns[j].test(pathsuffix)) {
        isThreat = true;
        threatType = "COMMAND_INJECTION";
        break;
    }
}

// Set variables for RaiseFault policy
if (isThreat) {
    context.setVariable("security.raise.fault", "true");
    context.setVariable("security.threat.type", threatType);
    context.setVariable("security.threat.path", pathsuffix);
} else {
    context.setVariable("security.raise.fault", "false");
}
```

</details>

<details>
<summary>📄 View RaiseFault Security Policy XML</summary>

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<RaiseFault async="false" continueOnError="false" enabled="true" xmlns="http://www.sap.com/apimgmt">
    <FaultResponse>
        <Set>
            <StatusCode>403</StatusCode>
            <ReasonPhrase>Forbidden - Security Threat Detected</ReasonPhrase>
        </Set>
        <Payload contentType="application/json">
            {
                "error": "SECURITY_THREAT",
                "type": "{security.threat.type}",
                "message": "Request blocked by DCRP Security Shield",
                "path": "{security.threat.path}",
                "timestamp": "{system.timestamp}",
                "incident_id": "{messageid}"
            }
        </Payload>
    </FaultResponse>
    <IgnoreUnresolvedVariables>false</IgnoreUnresolvedVariables>
</RaiseFault>
```

</details>

### When to Use Each Approach

#### Use Approach 1 (Manual) when

- Domain has <5 paths and rarely changes
- Team prefers explicit routing rules for visibility
- Legacy environment with existing path-based architecture

#### Use Approach 2 (Dynamic) when

- Domain has >5 paths OR frequent changes expected
- Enterprise scale with multiple regional deployments
- Need maximum deployment velocity (30s per new path)

### Comparison Table

| Feature | Approach 1 (Manual) | Approach 2 (Dynamic) |
|---|---|---|
| Routing Rule | N rules (1 per path) | 1 catch-all (`/**`) |
| cpi.basepath | Fixed per rule | Comma-delimited string |
| JavaScript | Matches KVM only | Extracts segment + matches KVM |
| Security | Rule-based | Whitelist validation required |
| Time per new path | ~2 min (add rule) | ~30 sec (update string) |
| Best for | <5 paths, stable | Enterprise, high-change |

### ROI Calculation (Approach 2)

**Scaling 4 domains with 8 paths each:**

**Approach 1 (Manual):**  
`4 domains × 8 paths × 2 min = 64 minutes`

**Approach 2 (Dynamic):**  
`4 domains × 1 setup (2 min) + 32 paths × 30 sec = 8 min + 16 min = 24 minutes`

**Savings:** 40 minutes (62% faster)

![Figure 26: Scaling Comparison](images/figura-31-scaling-comparison.png)  
*Figure 26 - Scaling Strategies: Manual vs Dynamic Multi-Path Routing*

---

## 6 - API Contracts, Versioning & OpenAPI Management

### Why DCRP Proxies Don't Need Versioning

In traditional API management, versioning is a primary driver of **Infrastructure Sprawl**. Every new version typically spawns a new proxy (e.g., `v1-api`, `v2-api`), forcing architects to manage multiple redundant infrastructures.

DCRP eliminates this proliferation by recognizing that **the proxy is a stateless router with an immutable base path**, not the owner of the API contract.

#### Fixed Entry Point

- The proxy base path remains constant (e.g., `/sales/orders/**`)
- **Versioned Routing:** API versions live in the path suffix (e.g., `/v1/`, `/v2/`)
- **Decoupled Logic:** These versions are mapped to specific iFlows via KVM metadata, keeping the proxy itself singular and unchanged

![Figure 27: Contracts & Governance](images/figura-32-contracts.png)  
*Figure 27 - Contracts & Governance*

| Step | Traditional 1:1 Proxy Model | DCRP Model |
|---|---|---|
| **Action** | Create new proxy, configure security, routing, and targets, then redeploy | Deploy new iFlow and update a single KVM metadata entry |
| **Time Effort** | ~15 minutes | ~30 seconds |
| **Outcome** | Managing 4 separate proxy infrastructures | Still managing 1 proxy infrastructure |

#### Client Interaction Examples

- **Legacy:** `POST /sales/orders/v1/inbound` → Routes to v1 iFlow
- **Current:** `POST /sales/orders/v2/inbound` → Routes to v2 iFlow
- **New:** `POST /sales/orders/v4/inbound` → Routes to v4 iFlow
- **Latest (Default):** `POST /sales/orders/inbound` → Dynamically routes to v4 via KVM

The proxy base path `/sales/orders/**` **never changed**, providing a stable, governed interface for consumers regardless of backend evolution.

### 6.1 - OpenAPI Management: The Hybrid Approach

In the DCRP model, **API contracts (OpenAPI specifications)** are decoupled from both the proxy and the iFlow, residing in a **central API Portal or repository**. This hybrid model ensures a clean separation of concerns:

- **KVM:** Stores runtime routing metadata (`path → endpoint`)
- **OpenAPI:** Stores design-time contract metadata (request/response schemas)
- **API Portal:** Provides discovery, documentation, and governance

#### The Execution Flow

When a developer needs to integrate, they download the spec (e.g., `sales-orders-v2.yaml`) from the Portal and generate their client code. When they call the DCRP proxy at `/sales/orders/v2`, the proxy consults the KVM and routes the request to the corresponding v2 iFlow.

![Figure 28: Template Perspective](images/figura-33-template-perspective.png)  
*Figure 28 - Template perspective*

### 6.2 - KVM vs OpenAPI: Complementary, Not Redundant

At first glance, KVM and OpenAPI might seem to overlap. Both describe APIs. But they serve **distinct purposes**:

**KVM answers:** "Where should I route this request?"

- **Input:** `/sales/orders/v2`
- **Output:** `https://cpi.../http/orders/v2`

**OpenAPI answers:** "What schema should this request/response have?"

- **Input:** `POST /sales/orders/v2`
- **Output:** Request body must include `{orderId, customerId, items[]}`, returns `{status, orderNumber}`

Both are necessary for complete governance:

- **Without KVM:** No dynamic routing (back to static proxy-per-integration)
- **Without OpenAPI:** No contract validation (clients and servers drift out of sync)

DCRP uses **KVM for runtime routing decisions** and **OpenAPI for design-time contract definition** and optional runtime validation.

![Figure 29: Complementary - DCRP and OpenAPI](images/figura-34-kvm-vs-openapi.png)  
*Figure 29 - Complementary - DCRP and OpenAPI*

---

## 7 - Statistics Collector – Capturing Business Intelligence

While the JavaScript "Brain" handles routing, the **Statistics Collector** provides the visibility necessary for production management. This policy captures technical metadata and transforms it into actionable business intelligence within the SAP API Management analytics database.

**Purpose:** Records routing metadata such as iFlow name, package name, domain process, and tracking IDs.

**Utility:** Enables real-time monitoring, trend analysis, and data-driven capacity planning.

### Policy Configuration Snippet

```xml
<StatisticsCollector async='false' continueOnError='false' enabled='true'>
    <Statistics>
        <Statistic name='custom_idcorrelation' ref='idcorrelation' type='string'>0</Statistic>
        <Statistic name='custom_idflow' ref='idiflow' type='string'>0</Statistic>
        <Statistic name='custom_idpackage' ref='idpackage' type='string'>0</Statistic>
        <Statistic name='custom_idsapprocess' ref='idsapprocess' type='string'>0</Statistic>
        <Statistic name='custom_idsender' ref='idsender' type='string'>0</Statistic>
    </Statistics>
</StatisticsCollector>
```

---

## 8 - Troubleshooting: Common Issues & Solutions

### 8.1 - Runtime Errors

#### 404 Not Found

- **Cause:** KVM `iflowname` delimiter mismatch
- **Fix:** Verify `iflowname` uses `:` separator (e.g., `inbound:SO.01...`)

#### 500 Internal Server Error

- **Cause:** Missing KVM entry or wrong `mapIdentifier`
- **Fix:** Check KVM map exists: `cpipackage-nx.[domain].[subprocess]`

#### 403 Forbidden (Valid Request)

- **Cause:** Domain not in Security Shield whitelist
- **Fix:** Add domain to `allowedDomains[]` in `JS-Security-Shield.js`

#### Gateway Timeout

- **Cause:** Wrong `cpi.host` or `cpi.basepath`
- **Fix:** Verify Target Endpoint properties, test CPI endpoint directly

### 8.2 - Configuration Issues

#### KVM Lookup Returns Null

- **Fix:** Deploy KVM to same environment as API Proxy (both dev or both prod)

#### JavaScript Execution Error

- **Fix:** Add error handling: `var x = context.getVariable("y") || "default";`

#### Routing Rule Doesn't Match

- **Fix:** Change to `MatchesPath "/**"` for dynamic routing (Approach 2)

#### Statistics Collector Not Logging

- **Fix:** Match variable names exactly in `<Statistic ref='idiflow' />`

### 8.3 - Security Shield Issues

#### All Requests Blocked (403)

- **Fix:** Verify `allowedDomains = ["sales", "finance"]` (lowercase)

#### SQL Injection False Positive

- **Fix:** Refine regex to exclude valid patterns (e.g., hyphens in IDs)

### 8.4 - Performance Issues

#### High Latency (>80ms)

- **Cause:** JavaScript overhead or network latency to CPI
- **Fix:** Profile with APIM trace logs, check network latency

> **Note:** Detailed performance benchmarking with 30,000+ messages will be covered in **Part III: Monitoring & Governance**.

#### Gateway Timeout (504)

- **Cause:** Slow CPI iFlow
- **Fix:** Increase timeout in Target Endpoint, optimize iFlow

### 8.6 - When to Escalate

**Escalate to SAP Support if:**

- Issue reproducible in isolated test proxy
- KVM API returns 500 errors despite correct configuration

**Collect before opening ticket:** Proxy bundle, KVM config, trace logs, network capture.

---

## Conclusion: Discipline Over Chaos

The **Domain-Centric Routing Pattern** provides the governance layer SAP API Management needs but doesn't offer out-of-the-box.

### Benefits Recap

#### Infrastructure

- **96% reduction** in proxies (20 → 4)
- **Deployment:** 15 min → 30 seconds (KVM)
- **Template-driven:** 4× faster at scale

#### Governance

- Centralized security policies
- Unified analytics per domain
- End-to-end traceability (SAP ALM ready)

#### Business Impact

- Faster time-to-market for new integrations
- Reduced operational overhead
- Future-proof: Consumer contracts unchanged during backend migrations

### The Roadmap Ahead

This is only the first step in mastering enterprise-scale integration:

**Part I: DCRP – Domain-Centric Routing Pattern (Gateway Layer)**  
✅ **YOU ARE HERE**

**Part II: PDCP – Package-Domain-Centric Pattern (Orchestration Layer)**  
Solving CPI Package and User Sprawl | Domain consolidation + iFlow DNA naming + tiered technical users  
🔗 [Part II](../blog-pdcp/)

**Part III: DCRP + PDCP Implementation & Testing**  
Hands-on guide | JavaScript v8.0 routing engine | Multi-vendor disambiguation | Conflict resolution (id09/id10) | Postman collections | Production deployment | GitHub repository with full source code  
⏳ **COMING SOON**

**Part IV: End-to-End Monitoring with SAP Cloud ALM**  
DCRP + PDCP integration with SAP Cloud ALM | MPL filtering via X-IFlow-Id headers | Automated dashboards | Real-time alerting & SLA tracking | Performance analytics  
⏳ **COMING SOON**

![Figure 30: DCRP Transformation](images/figura-35-transformation.png)  
*Figure 30 - Implementing DCRP transforms your gateway into a scalable, semantic, governed ecosystem*

### Before You Scale: Pre-Flight Checklist

- ✅ **Team Alignment:** Ensure developers understand 1:1 → domain-centric shift
- ✅ **Stakeholder Education:** Business sponsors grasp consolidation benefits
- ✅ **Establish Governance:** Define KVM update approval workflows
- ✅ **Enforce Standards:** Naming convention
- ✅ **Sandbox PoC:** Validate with 2-3 iFlows before production rollout

**This is only the first step in mastering enterprise-scale integration.**

---

## 📚 How to Reference This Work

When referencing or building upon these architectural patterns, please use the following formal citations:

- **DCRP (Domain-Centric Routing Pattern)**, introduced by Ricardo Luz Holanda Viana, 2026.
- **PDCP (Package Domain-Centric Pattern)**, introduced by Ricardo Luz Holanda Viana, 2026.

---

## 🛡️ Intellectual Property & Copyright Notice

**© 2026 Ricardo Luz Holanda Viana**  
**First published:** February 6, 2026  
**All rights reserved.**

### Legal Notice

The public disclosure of the architectural patterns described herein constitutes **prior art (state of the art)** within the global intellectual property framework. This publication establishes documented evidence of **authorship and original contribution** as of the stated publication date.

### 📜 Usage Terms

- ✅ **Free to use** for educational, research, and non-commercial purposes
- ✅ **Attribution required** when referencing or building upon these architectural patterns
- ✅ **Commercial implementations are permitted**, provided proper attribution is given
- ⚠️ **Use of the names "DCRP™" or "PDCP™" in commercial branding, offerings, or marketing materials requires prior written licensing from the author**

This restriction applies solely to the use of the names and trademarks, not to independent implementations of similar architectural concepts.

### No Implied License

Nothing in this publication shall be construed as granting any license, implied or otherwise, to use the described methodologies as branded commercial products or services without explicit authorization.

### Disclaimer

This article reflects the author's personal architectural perspective and does not represent an official SAP position or recommendation.

---

**Kind Regards,**

**Viana | SAP BTP Integration Suite Expert**

---

## 📁 Repository Structure

```
/images/
  ├── figura-01-dcrp-model.png
  ├── figura-02-sprawl-problem.png
  ├── figura-03-three-pillars.png
  ├── figura-04-decision-framework.png
  ├── figura-05-architecture-overview.png
  ├── figura-06-kvm-javascript.png
  ├── figura-07-sprawl-vs-dcrp.png
  ├── figura-08-route-rule.png
  ├── figura-09-target-properties.png
  ├── figura-10-proxy-kvm.png
  ├── figura-11-kvm-config.png
  ├── figura-12-inbound-endpoint.png
  ├── figura-13-tracking-endpoint.png
  ├── figura-14-cpi-packages.png
  ├── figura-15-public-paths.png
  ├── figura-16-execution-flow.png
  ├── figura-17-kvm-js.png
  ├── figura-18-scaling-model.png
  ├── figura-19-js-code.png
  ├── figura-20-raise-fault.png
  ├── figura-21-operational-flow.png
  ├── figura-22-template-1.png
  ├── figura-23-template-2.png
  ├── figura-24-preflow-setup.png
  ├── figura-25-scalation-mode.png
  ├── figura-26-dynamic-flow.png
  ├── figura-27-basepath-config.png
  ├── figura-28-js-security.png
  ├── figura-29-js-preflow.png
  ├── figura-30-raise-fault-security.png
  ├── figura-31-scaling-comparison.png
  ├── figura-32-contracts.png
  ├── figura-33-template-perspective.png
  ├── figura-34-kvm-vs-openapi.png
  └── figura-35-transformation.png
```

---

**⭐ If this guide helped you, please star this repository and share it with your team!**
