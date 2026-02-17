# FAQ-10 – Deploy-Heavy vs Metadata-Driven Change

## Q1 – How do traditional designs handle change?

Traditional model:

- New process → new endpoint + new proxy or major proxy change.
- Backend change → proxy configuration update + redeploy.
- Payload change → new API version (`v2`, `v3`) + migration.

Every change tends to imply:

- new deployment,
- potential client impact,
- more artifacts to govern.

---

## Q2 – How does GDCR handle change?

With GDCR/DCRP:

- **Façade is stable** (e.g. `/sales/orders/create`).
- New vendor/region:
  - add KVM entries for new variants,
  - deploy new iFlows in CPI,
  - no change in façade or proxy logic.
- Backend refactor:
  - adjust KVM value to point to new iFlow/endpoint,
  - clients keep the same URL. [file:3]

ASCII:

```text
Change in traditional:
  change backend -> change proxy -> redeploy -> maybe change URL

Change in GDCR:
  change backend -> update KVM entry -> no façade change, no proxy redeploy
Q3 – What is the governance benefit?
Fewer deployments at the gateway layer.

Clear separation:

façade governance (domain/entity/action),

implementation governance (KVM + CPI).

Easier rollback and experimentation:

switching pointers in KVM is safer than swapping proxies.
