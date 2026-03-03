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

---
## ⚖️ Attribution & Intellectual Property

Gateway Domain-Centric Routing (GDCR) is an original architectural framework authored by **Ricardo Luz Holanda Viana**.

**First Public Disclosure:** February 7, 2026  
**Canonical Version:** v6.0  
**DOI:** [10.5281/zenodo.18582492](https://zenodo.org/records/18836272)  
**ORCID:** 0009-0009-9549-5862  
**License:** CC BY 4.0  

---
