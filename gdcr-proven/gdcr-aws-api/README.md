# GDCR — AWS API Gateway Validation
### AWS API Gateway + SAP CPI — Lambda + DynamoDB + Python

This folder contains the validation evidence for GDCR on  
**Amazon Web Services**, using API Gateway + Lambda + DynamoDB.

Two implementation variants were validated on this platform.

---

## Implementations Validated

### Variant 1 — Lambda hardcoded + Python
Initial proof of portability on AWS infrastructure.

| Scope | Detail |
| :--- | :--- |
| Domain | Finance R2R |
| Vendors | 10 |
| Proxies | 1 |
| Implementation | Lambda + Python (hardcoded) |
| Route | Poland → USA |
| Status | ✅ PROVEN |

---

### Variant 2 — Lambda + DynamoDB + Python
Full metadata-driven routing using DynamoDB as the KVM equivalent.

| Scope | Detail |
| :--- | :--- |
| Domains | Finance R2R · Sales O2C |
| Vendors | 33 |
| Proxies | 2 |
| Implementation | Lambda + DynamoDB + Python |
| Route | Poland → USA |
| Status | ✅ PROVEN |

---

## What is proven here

- ✅ GDCR routing logic portable to AWS Lambda (Python)
- ✅ DynamoDB as KVM-equivalent metadata store
- ✅ Cross-Atlantic routing (Poland → US-East) validated
- ✅ Same DDCR lifecycle: Parse → Normalize → Lookup → Route
- ✅ 100% routing accuracy — zero routing failures

---

## Architectural Note

AWS validates two things simultaneously:  
**Language portability** (Python vs. JavaScript/Lua) and  
**Storage portability** (DynamoDB vs. KVM/Redis).

The GDCR semantic contract remains identical regardless of both.

---

## Evidence Contents
