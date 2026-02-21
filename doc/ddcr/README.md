Domain-Driven Centric Router (DDCR)
-----------------------------------

While GDCR defines the **gateway-level architecture**, the **Domain-Driven Centric Router (DDCR)** defines how routing decisions are executed at runtime behind the gateway.

DDCR operates over the **semantic URL façade** exposed by GDCR:

```text
/{domain}/{resource}/{action}/{vendor-id}
┌─────────────────────────────────────────────────────────────────────────────┐
│                    GDCR FRAMEWORK v6.0 – THREE LAYERS                       │
│                                                                             │
│   ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐        │
│   │      GDCR       │───►│      DDCR       │───►│      GDCR       │        │
│   │   (Gateway)     │    │   (Router)      │    │ (Orchestration) │        │
│   │                 │    │                 │    │                 │        │
│   │ • SAP APIM      │    │ • Runtime       │    │ • SAP CPI       │        │
│   │ • Kong          │    │ • Metadata      │    │ • iFlow DNA     │        │
│   │ • AWS / Azure   │    │ • Translation   │    │ • Packages      │        │
│   │                 │    │                 │    │                 │        │
│   │ “Facade”        │    │ “Routing”       │    │ “Execution”     │        │
│   │ /sales/...      │───►│ sf-us → id01    │───►│ id01.o2c.sf...  │        │
│   └─────────────────┘    └─────────────────┘    └─────────────────┘        │
│                                                                             │
│   GDCR exposes       DDCR translates          PDCP executes                 │
│   business language  intent into              the technical flow            │
│   at the gateway     a concrete backend       in the orchestration layer    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

Instead of binding gateway routes directly to vendors, DDCR treats this path as a business-semantic string, performs a metadata lookup (DynamoDB, KVM, Redis, etc.), and translates it into the concrete vendor invocation (iPaaS, microservice, queue, function, etc.) in real time.

Route shape and vendor identity

In GDCR/DDCR, only the first segment is strictly fixed:

- Domain is the core invariant of the semantic contract and always appears first. It anchors the request in a business context (e.g., sales, finance, logistics, masterdata) and is never reordered.
- The following segments (resource, action, and any additional qualifiers) are structurally flexible, as long as the DDCR knows how to compose the routing key from them (for example: {resource}/{action}/{vendor-id} or {resource}/{subresource}/{action}/{vendor-id} or any sequence).
- The last segment is not a generic "vendor", but a vendor identifier (vendor-id) that uniquely represents a concrete integration endpoint or tenant, including region/instance when needed. Examples:

| vendor-id         | Significado                |
| ----------------- | -------------------------- |
| `salesforce-us`   | Salesforce instância US    |
| `salesforce-emea` | Salesforce instância EMEA  |
| `salesforce-apac` | Salesforce instância APAC  |
| `s4hana-br`       | SAP S/4HANA Brasil         |
| `s4hana-eu`       | SAP S/4HANA Europa         |
| `cpi-tenant1`     | SAP CPI tenant específico  |
| `cpi-tenant2`     | SAP CPI tenant alternativo |


This uniqueness at the vendor-id level prevents routing collisions and allows the catalog (e.g., gdcr-kvm) to map multiple regions, tenants or instances for the same domain/resource/action combination without ambiguity.

Key characteristics:

| Característica        | Descrição                                                                                                                               |
| --------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| Gateway compatibility | Works behind any GDCR‑aligned gateway (SAP APIM, AWS API Gateway, Apigee, Kong, etc.)                                                   |
| Metadata catalog      | Uses `gdcr-kvm` or equivalent to resolve: domain, resource, action, vendor-id, interface\_id, protocol, target\_vendor, env, version, … |
| Runtime flexibility   | Implemented in any modern stack (JavaScript, Python, Node.js, C#, …)                                                                    |
| Fast-fail semantics   | If a route is not defined or authorization fails, the request is rejected deterministically, without exposing vendor topology           |
| Security by design    | Makes endpoint discovery by attackers impractical, since the gateway only exposes business‑semantic façades, not raw vendor URLs        |

DDCR is the execution layer of GDCR:
The gateway speaks in business language; the DDCR translates that into backend reality in a fully metadata‑driven, vendor‑agnostic way.

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                         CLIENT / API CONSUMER                              │
│                                                                             │
│    ┌─────────────────────────────────────────────────────────────────┐      │
│    │  REQUEST: POST /sales/orders/create/salesforce-us              │      │
│    │  Headers: { "X-Correlation-Id": "abc-123", ... }               │      │
│    └─────────────────────────────────────────────────────────────────┘      │
│                              │                                              │
│                              ▼                                              │
└─────────────────────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────────────────────┐
│                    DDCR – DOMAIN-DRIVEN CENTRIC ROUTER                     │
│                    ═══════════════════════════════════                     │
│                                                                             │
│  ┌──────────────── SEMANTIC API GATEWAY ──────────────────────────────┐    │
│  │                                                                     │    │
│  │  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐  ┌───────────┐ │    │
│  │  │   DOMAIN    │  │  RESOURCE   │  │    ACTION    │  │ VENDOR-ID │ │    │
│  │  │   /sales    │  │   /orders   │  │   /create    │  │ /sf-us    │ │    │
│  │  └─────────────┘  └─────────────┘  └──────────────┘  └───────────┘ │    │
│  │                                                                     │    │
│  │  Business intent encoded as path                                    │    │
│  │  (no IPs, no regions, no tech stack in the URL)                     │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                              │                                              │
│                              ▼                                              │
│  ┌──────────────── LIGHTWEIGHT RUNTIME ENGINE ─────────────────────────┐    │
│  │                                                                     │    │
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │    │
│  │  │   JS    │ │ Python  │ │ Node.js │ │   C#    │ │  Lua    │ ...   │    │
│  │  │ (SAP)   │ │ (Custom)│ │ (Edge)  │ │ (Azure) │ │ (Kong)  │       │    │
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘       │    │
│  │                              │                                      │    │
│  │  ┌─────────────────────────────────────────────────────────────┐    │    │
│  │  │  EXECUTION FLOW:                                            │    │    │
│  │  │                                                             │    │    │
│  │  │  1. PARSE      → Treat path as STRING                       │    │    │
│  │  │  2. LOOKUP     → Query METADATA CATALOG                     │    │    │
│  │  │                  ┌─────────┐ ┌─────────┐ ┌─────────┐         │    │    │
│  │  │                  │DynamoDB │ │   KVM   │ │  Redis  │ ...     │    │    │
│  │  │                  └─────────┘ └─────────┘ └─────────┘         │    │    │
│  │  │  3. RESOLVE    → Match semantic route → concrete backend    │    │    │
│  │  │  4. TRANSLATE  → Build target URL / invocation              │    │    │
│  │  │  5. FORWARD    → Route to destination                       │    │    │
│  │  │                                                             │    │    │
│  │  └─────────────────────────────────────────────────────────────┘    │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                              │                                              │
│                    ┌─────────┴─────────┐                                    │
│                    ▼                   ▼                                    │
│              ┌─────────┐         ┌─────────┐                                │
│              │ SUCCESS │         │  FAIL   │                                │
│              │ Route   │         │  FAST   │                                │
│              │ Found   │         │ (4xx/5xx)                                │
│              └────┬────┘         └────┬────┘                                │
│                   │                   │                                     │
│                   ▼                   ▼                                     │
│         ┌─────────────────┐   ┌─────────────────┐                           │
│         │  Forward Call   │   │  Return 4xx/5xx │                           │
│         │  to Backend     │   │  No endpoint    │                           │
│         │                 │   │  exposure       │                           │
│         │  • Orchestration│   │  No guessing    │                           │
│         │    Layers       │   │  No probing     │                           │
│         │  • Core ERP     │   │                 │                           │
│         │  • 3rd-Party    │   │  Attack surface │                           │
│         │    Systems      │   │  = ZERO         │                           │
│         └─────────────────┘   └─────────────────┘                           │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │  SECURITY & OBSERVABILITY PROPERTIES:                               │    │
│  │                                                                     │    │
│  │  ✓ Endpoint discovery impossible (no tech details in URL)           │    │
│  │  ✓ No infrastructure probing (semantic façade blocks reconnaissance)│    │
│  │  ✓ Observable (semantic tags: domain/resource/action/vendor-id)     │    │
│  │  ✓ Governable (centralized metadata catalog)                        │    │
│  │  ✓ Vendor-agnostic (same pattern, any runtime, any backend)         │    │
│  │                                                                     │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                         BACKEND TARGETS                                    │
│                                                                             │
│   ┌────────────────┐   ┌────────────────┐   ┌────────────────┐             │
│   │ Orchestration  │   │   Core ERP     │   │   3rd-Party    │             │
│   │  Layers        │   │  Systems       │   │   Systems      │             │
│   │                │   │                │   │                │             │
│   │ • SAP CPI      │   │ • SAP S/4HANA  │   │ • Salesforce   │             │
│   │ • Other iPaaS  │   │ • Oracle ERP   │   │ • ServiceNow   │             │
│   │ • ESB / BPM    │   │ • Dynamics 365 │   │ • Custom APIs  │             │
│   └────────────────┘   └────────────────┘   └────────────────┘             │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```


asdasdas
