# GDCR — Validation Evidence

This folder contains the cross-platform validation evidence for the 
Gateway Domain-Centric Routing (GDCR) framework.

All validations were executed on free trial and sandbox environments.  
Results demonstrate **architectural correctness and cross-platform 
portability** — not production throughput or SLA guarantees.

---

## Validated Platforms

| Platform | Folder |
| :--- | :--- |
| SAP BTP API Management + CPI | [`gdcr-drcp-sap-api`](./gdcr-drcp-sap-api/) |
| Kong Gateway (Docker) | [`gdcr-kong-api`](./gdcr-kong-api/) |
| AWS API Gateway + CPI | [`gdcr-aws-api`](./gdcr-aws-api/) |
| Microsoft Azure APIM + CPI | [`gdcr-microsoft-azure-api`](./gdcr-microsoft-azure-api/) |

---

## What is validated here?

Each platform folder contains:
- Newman test execution reports
- Performance screenshots
- Error classification logs
- Raw request/response evidence

The validation objective was not to benchmark raw throughput.  
The objective was to prove:

- ✅ **Architectural correctness** — DDCR engine resolves every semantic 
path deterministically
- ✅ **Cross-platform portability** — same routing logic executes on 
SAP, Kong, AWS, and Azure
- ✅ **Zero routing failures** — 100% routing accuracy across all 
platforms and engine generations
- ✅ **Fail-fast behavior** — invalid routes rejected before reaching 
any backend

---

## Full Results

Consolidated results are available in the main white paper:

📄 [GDCR v6.0 — The Foundation](../doc/academic-paper/)  
🔗 DOI: [10.5281/zenodo.18582492](https://doi.org/10.5281/zenodo.18582492)

---

*Part of the [GDCR Framework](https://github.com/rhviana/gdcr) — 
CC BY 4.0 — Ricardo Luz Holanda Viana*
