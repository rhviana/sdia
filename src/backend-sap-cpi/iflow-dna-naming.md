---
# iFlow DNA: The Standard for Domain Consolidation

To prevent consolidated packages from becoming "black boxes," all integration assets must adhere to this 7-segment naming convention.
---
## The 7-Segment Format
`id[seq].[subdomain].[sender].[entity].[action].[direction].[processing]`

------
### Segment Breakdown
------
| Segment | Meaning | Examples |
| :--- | :--- | :--- |
| **id[seq]** | Sequential Index (Reset per subdomain) | `id01`, `id02` |
| **subdomain** | Business Process / Sub-domain | `o2c` (Order-to-Cash), `p2p` |
| **sender** | Source System / Vendor | `salesforce`, `shopify`, `s4hana` |
| **entity** | Business Object | `order`, `customer`, `invoice` |
| **action** | Operation Code (1 character) | `c` (Create), `u` (Update), `s` (Sync) |
| **direction** | Data Flow | `in`, `out` |
| **processing** | Mode | `sync`, `async` |

---

## Implementation Example

**Integration:** Creating a Sales Order from Salesforce to S/4HANA.
**DNA Name:** `id01.o2c.salesforce.order.s4hana.c.in.sync`

---

## Why reset per subdomain?

1. **Surgical Indexing**: Each subdomain becomes a self-contained index space.
2. **Alphabetical Grouping**: Naturally groups all related flows (e.g., all O2C flows stay together).
3. **Traceability**: Direct mapping between the URL endpoint and the technical iFlow.

---
