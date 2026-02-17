## FAQ 01 — Is SAP APIM really 1:1?

### Short Answer
Technically: ❌ No  
Architecturally (in practice): ✅ Yes

### Traditional Claim

> “We don’t do 1:1. We use conditional routing (1:N).”

## Reality Check

### Traditional Proxy Model

Proxy
├── if /CreateOrder -> CPI A
├── if /ReadOrder -> CPI B
├── if /CancelOrder -> CPI C


This is **1:N inside a single artifact**.

Problems:
- Intelligence lives inside the proxy
- Routing logic is hardcoded
- Growth = more conditions
- Change = redeploy
- Governance = local, not global


## GDCR Difference

Proxy (FIXED)
|
v
Metadata Control Plane
|
v
Execution


- Proxy never changes
- N grows only in metadata
- Intelligence is externalized
- Governance is centralized


## Key Distinction

| Model | Where intelligence lives |
|-----|--------------------------|
| Conditional routing | Proxy artifact |
| GDCR | Metadata control plane |

This is a **layer shift**, not a feature comparison.
