### Metadata CI/CD: The GitOps Engine
This directory contains the automation logic for Project DCRP. By utilizing GitHub Actions, we have successfully deleted the "human middleman" in the integration onboarding process.

---

## First Principles: No-Redeploy Governance
In traditional SAP BTP environments, updating an integration route often requires manual intervention or a full API Proxy redeployment. Project DCRP eliminates this bottleneck by treating routing as Data, not Infrastructure.

---

The Goal: 30-second onboarding for new billion-dollar vendors.
The Method: Automated synchronization between GitHub and SAP API Management Key-Value Maps (KVM).
The Result: 18.8x faster deployment cycles compared to legacy 1:1 models.

---

Deployment Workflow: deploy-metadata.yml
This YAML script executes the following mission-critical steps:

Change Detection: The engine triggers only when modifications are pushed to templates/kvm-config.json.
Secure Authentication: Uses SAP BTP XSUAA (OAuth2) to obtain a short-lived access token, ensuring zero exposure of credentials.
Atomic Update: Executes a PUT request to the SAP APIM Management API to overwrite the KVM entry cpipackage-sales-o2c.
Instant Propagation: Because the DCRP "Brain" (JavaScript) reads from the KVM at runtime, the new route is active globally within seconds of the Git commit.

-----------------------------------

**Author:** Ricardo Luz Holanda Viana  
**Role:** Enterprise Integration Architect · SAP BTP Integration Suite  
**Creator of:** GDCR · DCRP · PDCP  

**Architectural scope:** Business‑semantic, domain‑centric routing architectures for API Gateways and Integration Orchestration (vendor‑agnostic), with SAP‑specific implementations via DCRP (SAP BTP API Management) and PDCP (SAP BTP Cloud Integration).  

**License:** Creative Commons Attribution 4.0 International (CC BY 4.0)  
**DOI:** [zenodo.18661136](https://doi.org/10.5281/zenodo.18582492)  
**DOI:**  [figshare.31331683](https://doi.org/10.6084/m9.figshare.31331683)

This document is part of the **Gateway Domain‑Centric Routing (GDCR)** framework and represents original architectural work authored by Ricardo Luz Holanda Viana. Reuse, adaptation, and distribution are permitted only with proper attribution. Any derivative or equivalent architectural implementation must reference the original work and associated DOI.

-----------------------------------
