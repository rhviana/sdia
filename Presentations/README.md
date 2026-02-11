GDCR: Global Domain-Centric Routing

Global Definition:

GDCR is the comprehensive "Umbrella Domain-Centric Framework" designed to eradicate chaos in large-scale SAP integration landscapes. It acts as the governance layer that synchronizes external traffic (APIM) with internal organization (CPI), 
ensuring technology follows the business structure, not the other way around.

GDCR is composed of two fundamental pillars focused on the SAP BTP Integration ecosystem:

1. The Gateway Pillar: DCRP (Domain-Centric Routing Pattern - SAP BTP Integration Suite - Especific)

Focus: SAP API Management (APIM)

   . DCRP is the architectural pattern responsible for solving "Proxy Sprawl" at the integration edge.

   . The Problem: The traditional 1:1 model (one proxy per service), generating thousands of unmanageable endpoints.

   . The SAP Solution: Consolidates multiple backend services into a Single API Proxy per Business Domain (e.g., Sales, Finance), utilizing metadata-driven routing (KVM) and a central JavaScript engine.

Result: 96% complexity reduction and deployments in 14.5 minutes.

2. The Backend Pillar: PDCP (Package Domain-Centric Pattern - SAP BTP Integration Suite - Especific)

Focus: SAP Cloud Integration (CPI)

   . PDCP is the "Urbanization" strategy for the backend, solving "Package Sprawl" within the Integration Suite.

   . The Problem: Hundreds of fragmented packages (one package per interface), making maintenance impossible.

The SAP Solution: 

    . Organizes the packages into Unified Domain Packages per business process (e.g., nx.sales.o2c.integrations, nx.logistic.tm.integrations)

The Mirror Strategy: 

   . The package naming convention in CPI strictly follows the DCRP routing keys in APIM. This creates perfect alignment between "who calls" (Gateway) and "who executes" (Backend).

Architecture Summary:

   . While DCRP controls the front door (Smart Routing), PDCP organizes the house (Logical Structure). Together, they form GDCR, transforming chaotic SAP integration into a governed, scalable, and domain-oriented system.

In short: 

   . GDCR is the 'Clean Enterprise Integration Architecture'. Spanning from the Gateway, through Orchestration, to the Backend, it acts as a total abstraction framework, transforming technical complexity into a fully Business-Domain Centric layer.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Official Identification:

   . Author: Ricardo Luz Holanda Viana (Enterprise Integration Architect).

   . DOI: 10.5281/zenodo.18582469.

Status: Peer-Reviewed Paper | Open Access.Status: Peer-Reviewed Paper | Open Access.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DCRP: Domain-Centric Routing Pattern - (SAP BTP integration Suite Specific)

Architectural Definition:

DCRP is an architectural design pattern developed for the SAP Integration Suite (BTP) that solves the "Proxy Sprawl" problem (uncontrolled expansion of proxies) in enterprise environments. Unlike the traditional 1:1 model, 
DCRP consolidates multiple backend services into a Single API Proxy per Business Domain (e.g., Sales, Finance, Logistics), utilizing metadata-driven routing.

How It Works (The Engine):

   . The architecture decouples routing logic from proxy code, shifting it to a dynamic configuration layer:

   . Metadata-Driven Routing: Uses Key Value Maps (KVM) to store path mappings, allowing changes in ~30 seconds without requiring proxy redeployment.

   . JavaScript Engine: A centralized script (the "Brain - Viana Logic") parses the incoming URL, queries the KVM, and dynamically routes traffic to the correct iFlow in CPI.

   . Semantic Facade: The consumer sees a clean, standardized URL (e.g., /sales/orders), while the engine handles backend complexity.

Impact & Metrics (Sandbox Validated)

   . Complexity Reduction: Consolidated 40 fragmented proxies into just 4 domain proxies (-96% complexity).

   . Deployment Speed: Deployment time reduced from 273 minutes (manual model) to 14.5 minutes (95% faster).

   . High Performance: Average latency of 68ms while processing over 33,000 messages with a 100% success rate.

In short:

   . DCRP is the 'Clean API-Proxy Business-Centric' strategy for your integration landscape, turning a messy list of API Proxies into a structured, domain-oriented architecture.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

PDCP Package Domain-Centric Pattern - (SAP BTP integration Suite Specific)

Definition:

PDCP is the architectural methodology designed to organize and govern artifacts within the SAP Integration Suite (CPI) by Business Domain rather than by project or technical silos.

Key Pillars:

   . Solving "Package Sprawl": It eliminates the chaos of having hundreds of fragmented packages (e.g., one package per interface) by consolidating them into unified, high-level Domain Packages and business process per domain
      (e.g., nx.sales.o2c.integrations, nx.finance.p2p.integrations, nx.logistics.sm.integrations).

   . Backend Urbanization: While DCRP manages the traffic at the Gateway (APIM), PDCP organizes the "house" at the Backend (CPI). It ensures that every iFlow has a logical, predictable address.

   . Mirror Strategy: It creates a perfect structural reflection of the DCRP routing logic. The Naming Convention used in the PDCP packages (e.g., cpipackage-nx.sales.o2c.integrations) directly aligns with the KVM Keys used in the Gateway, 
     allowing for seamless metadata-driven routing.

In short:

PDCP is the "Clean CPI Package and Iflow Code" strategy for your integration landscape, turning a messy list of iFlows into a structured, domain-oriented architecture.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
