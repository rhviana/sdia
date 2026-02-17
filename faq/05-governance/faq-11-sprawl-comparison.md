```markdown
# FAQ-11 – Sprawl Comparison: Traditional vs GDCR

## Q1 – What were the observed numbers in the reference landscape?

In SAP BTP sandbox/trial validation:

- API proxies: 41 → 4 (≈90% reduction).  
- CPI packages: 39 → 4 (≈90% reduction).  
- Technical users: 39 → 12 (≈69% reduction).  
- Deployment time: 273 → 14.5 minutes (≈95% reduction). [file:3]

More than 106,000 routed calls were executed with 99.92–100% success and low single‑digit ms routing overhead. [file:1][file:3]

---

## Q2 – Why does system-driven design tend to sprawl?

Because:

- Each new project/system gets:
  - its own proxies,
  - its own packages,
  - often its own technical users.
- Naming and URLs reflect systems, not domains:
  - `Salesforce_Orders_API`, `Z_SAP_FI_INV_01`, etc. [web:16][web:23]

This leads to:

- difficulty in reuse,
- difficulty in governance,
- exploding inventories of proxies/packages.

---

## Q3 – How does GDCR structurally limit sprawl?

GDCR enforces:

- **few façades** (per domain/subprocess),
- **few packages** (per domain/subprocess),
- **semantic reuse**:
  - many operations and vendors under the same façade and package via metadata.

This doesn’t prevent growth, but **channels** it into domain‑aligned structures rather than uncontrolled proxy/package multiplication.
