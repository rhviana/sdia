# iFlow Naming Convention — PDCP Deterministic “DNA” Model

## 1. Purpose
The **iFlow DNA** convention provides deterministic, machine-readable, and domain-aligned identification of integration flows within PDCP. 

It ensures:
* **Predictable discovery**
* **Domain-level governance**
* **Cross-platform traceability**
* **Zero ambiguity** in routing and ownership
* **Alignment** with GDCR semantic façade

> [!IMPORTANT]
> The iFlow name is not a label. It is an **operational contract**.

---

## 2. Formal Structure

`id[seq].[subdomain].[sender].[entity].[action].[direction].[mode]`

### Component Definition

| Component | Description | Example | Constraint |
| :--- | :--- | :--- | :--- |
| **id[seq]** | Local sequence within subprocess | `id01`, `id02` | `id\d{2}` |
| **subdomain** | Business subprocess | `o2c`, `r2r`, `s2p` | lowercase |
| **sender** | Source system | `salesforce`, `sap4hana` | lowercase, no spaces |
| **entity** | Business object | `order`, `invoice`, `customer` | singular |
| **action** | Normalized action code | `c`, `r`, `u`, `d`, `s` | 1 char |
| **direction** | Flow direction | `in`, `out` | fixed set |
| **mode** | Processing mode | `sync`, `async` | fixed set |

---

## 3. Deterministic Properties

### 3.1 Local ID Scope
`id[seq]` is local per subprocess. 

**Example:**
* `id01.o2c.salesforce.order.c.in.sync`
* `id01.r2r.sap4hana.invoice.c.out.sync`

Both may exist simultaneously. **IDs are NOT global**; they are scoped within their domain context. This avoids cross-domain collision while preserving deterministic lookup.

---

## 4. Semantic Alignment with GDCR
The iFlow DNA mirrors the gateway façade:

| Gateway URL | iFlow DNA |
| :--- | :--- |
| `/sales/orders/create` | `id01.o2c.salesforce.order.c.in.sync` |
| `/finance/invoices/create` | `id05.r2r.sap4hana.invoice.c.out.sync` |

* **The façade** expresses business intent.
* **The DNA** expresses execution identity.

---

## 5. Regional and Variant Extensions
Regional variants do not alter the semantic contract.

**Example:**
* `id02.o2c.salesforce.order.c.in.sync`
* `id02us.o2c.salesforce.order.c.in.sync`
* `id02emea.o2c.salesforce.order.c.in.sync`

Variant identifiers may extend the `id` component while preserving:
1.  Subdomain consistency
2.  Entity alignment
3.  Action normalization
4.  URL stability
5.  KVM routing invariance

The public API façade remains unchanged.

---

## 6. Design Principles
* **Deterministic** — No arbitrary naming.
* **Domain-First** — Business context precedes system logic.
* **Normalized** — Action codes align with DDCR canonical mapping.
* **Portable** — Platform-independent naming.
* **Governable** — Enables ownership by business domain.
* **Scalable** — Supports horizontal vendor expansion without structural change.

---

## 7. Why This Matters

| Without Deterministic Naming | With iFlow DNA |
| :--- | :--- |
| Discovery becomes manual | Routing is predictable |
| Governance becomes reactive | Audit is deterministic |
| Ownership becomes ambiguous | Documentation is implicit |
| Scaling introduces entropy | Expansion is metadata-only |

---
## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** 10.5281/zenodo.xxxxx  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
