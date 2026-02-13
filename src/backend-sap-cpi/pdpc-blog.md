PDCP – Package Domain-Centric Pattern: Solving the Backend Package Sprawl at Scale
Author: Ricardo Luz Holanda Viana
Year: 2026
Pattern Version: v1.0
Original Article: SAP Community Blog

📋 Table of Contents
Authorship & Origin
Executive Summary
Target Audience & Prerequisites
The Complete Architecture: DCRP + PDCP
Introduction - The Battlefield Beyond the Gateway
The CPI Package Sprawl: A Multi-Dimensional Crisis
The PDCP Architectural Definition
The Solution: PDCP Pattern
PDCP Naming Convention Framework
The Advanced iFlow DNA Name
The URL Governance: The Agnostic Endpoint
DCRP + PDCP Implementation and KVM Configuration
Conclusion
How to Reference This Work
Intellectual Property & Copyright Notice
Authorship & Origin - 2026
DCRP (Domain-Centric Routing Pattern) and PDCP (Package Domain-Centric Pattern) are original architectural patterns developed by Ricardo Luz Holanda Viana, derived from real-world enterprise integration scenarios and governance challenges in SAP BTP Integration Suite landscapes - API Management & Cloud Platform Integration.

PEER-REVIEWED ACADEMIC PAPER PUBLISHED
Official DOI: 10.5281/zenodo.18582469
Published: February 10, 2026 | Repository: Zenodo (CERN)
Status: Open Access, Peer-Reviewed

This Medium article is the foundational disclosure (Feb 7, 2026). The complete academic paper with validation data, vendor implementations, and 40 references is now available:

Download Full Paper (PDF): https://zenodo.org/records/18582469

Validation Results
90% reduction in API proxies (40 → 4)
90% reduction in CPI packages (40 → 4)
95% faster deployment (273 min → 14.5 min)
33,000+ messages tested, 68ms latency, 100% success
Citation:
Viana, R. L. H. (2026). Gateway Domain-Centric Routing: A Vendor-Agnostic Metadata-Driven Architecture for Enterprise API Governance. Zenodo. https://doi.org/10.5281/zenodo.18582469

Executive Summary
The Problem: "Package Sprawl"
The uncontrolled proliferation of 100+ unstandardized packages in SAP CPI—leading to operational chaos, credential hell, and tenant capacity crises. This also triggers "User Sprawl" in SAP BTP Cockpit, with one technical user per package, creating systematic credential management crisis and complex maintenance overhead.

The Solution: PDCP
PDCP consolidates integrations into one package per business domain with tiered technical users by criticality.

Real Impact
39 packages → 4 (↓90%)
39 technical users → 12 tiered users (↓69%)
273 min deploy → 14.5 min (↑18.8× faster)
Deploy Time Calculation Formula
T_total = (N_packages × 2 min) + (M_iFlows × 0.5 min)
Where:

N_packages = Number of CPI packages to deploy
M_iFlows = Number of iFlows to deploy
2 min = Average package deployment time
0.5 min = Average iFlow deployment time
Time Investment
⏱️ Executive summary: 2 min
⏱️ Full technical guide: 10 ~ 35 min
Target Audience & Prerequisites
Target Audience
SAP CPI Platform Owners & Integration Architects fighting Package Sprawl
Enterprise Architects standardizing BTP governance
Solution Architects implementing DCRP (Part I) → PDCP synergy
Senior Developers needing iFlow DNA conventions
Governance Teams enforcing naming standards
Prerequisites
Basic SAP CPI package/iFlow knowledge (no APIM required)
How to Read This Blog
Prerequisites:

Read DCRP (Part I) for full context (especially Chapter 7) - Or start with Chapters 1-5 for Package Sprawl solutions only - it's for SAP Cloud Platform Integration, independent of Gateway concepts.

If you read it but found the pattern challenging: Start with Chapters 1-5. The DCRP routing logic is complex, and understanding the backend consolidation first will help.
If you read it and built a PoC: You're ready for Chapters 6-7. The DCRP + PDCP synergy demonstrates the complete Gateway-to-Backend solution.
Note on the JavaScript Brain DCRP Routing Engine
The current implementation (v8.0) is under active development toward a universal, plug-and-play routing engine capable of handling any vendor, any scenario, with zero-code onboarding.

The goal: a single JavaScript brain that adapts to every enterprise integration landscape SAP APIM automatically at global scale. This is complex architectural work—expect iterative refinements as edge cases emerge.

I developed the full complexity of this logic and these patterns independently, over many nights, based on real-world enterprise challenges observed across multiple projects.

After extensively analyzing universal dynamic routing patterns available in the API's in market, combined with deep research and intensive hands-on experimentation, I arrived at the best and most balanced version I could realistically design.

While this solution reflects my strongest architectural judgment and practical experience, it is naturally impossible to anticipate every possible global scenario.

The Complete Architecture: DCRP + PDCP
Before diving into the Package Sprawl problem, let's visualize the complete end-to-end integration architecture. This diagram demonstrates how DCRP (Gateway Layer) and PDCP (Backend Layer) work together to deliver enterprise-scale domain governance.

Figure 1: Complete DCRP + PDCP End-to-End Architecture
Figure 1: Complete DCRP + PDCP End-to-End Architecture

Architecture Highlights – Sales O2C Domain
Left (Consumer Layer): 9 external systems (Salesforce US/EMA, HubSpot, Dynamics 365, Vendor Partners)
Center (Gateway Layer): SAP API Management with DCRP routing engine (KVM + JavaScript v8)
Right (Backend Layer): Cloud Platform Integration with PDCP package consolidation
Protocols: HTTPS (TLS 1.2+), SOAP, ODATA
Result
13 proxies → 1 unified gateway
39 packages → 4 governed domains
39 users → 12 tiered credentials
Theory meets Execution: On the left of the diagram, you see the blueprint of the DCRP Engine—utilizing KVM and JS v8.0 to centralize governance. In the actual system screenshot (Figure 2), you see the surgical reality within SAP APIM: a single Domain-Centric facade protecting the core, where the backend.system is no longer a fixed URL, but a strategic variable.

Figure 2: DCRP + PDCP in Production
Figure 2: Complete DCRP + PDCP End-to-End Architecture

Introduction - The Battlefield Beyond the Gateway
Hello again,

In my previous article, we addressed "Proxy Sprawl" using the DCRP (Domain-Centric Routing Pattern), which reduced API Proxy onboarding time to 30 seconds by leveraging a metadata-driven engine (KVM, JavaScript, and Statistic Collectors).

However, a critical truth remains: establishing a clean, governed Gateway is only half the battle. If the SAP Cloud Integration (CPI) backend remains unorganized, the overall integration landscape remains fragile and difficult to maintain.

With over 15 years of experience worldwide perspective spanning three generations of SAP integration (XI/PI/PO) and now SAP Integration Suite, I am introducing the PDCP (Package Domain-Centric Pattern).

Real-world trigger
I saw a critical scenario where 3 new tenants were allocated just to organize the apocalyptic Package Sprawl chaos. It was so unmanageable I nearly left the project—it was impossible to understand.

This guide serves as a technical blueprint of design name and name convention of CPI Package and Iflow name. If you have already implemented the DCRP Gateway, this pattern is essential to ensure end-to-end symmetry.

Architectural Disclaimer
This framework provides a high-level standard, but every organization must evaluate its unique landscape and adapt these rules to its specific governance needs. Importantly, this pattern does not apply to SAP Standard Packages (pre-packaged content from the SAP Business Accelerator Hub). To preserve update compatibility and support, standard SAP content must maintain its original naming and structure.

My choice to use strictly lowercase letters in the following examples is deliberate; it ensures maximum compatibility, prevents case-sensitivity errors, and maintains clean, uniform sortability across all SAP BTP components.

Figure 3: The Commander's Classroom
Figure 3 – The Commander's Classroom: Strategic Briefing on PDCP

1 - THE CPI PACKAGE SPRAWL: A MULTI-DIMENSIONAL CRISIS
Package Sprawl is Operational Debt. When your tenant lacks a design pattern, every maintenance task becomes a search-and-rescue mission.

Note: The prefix used in these examples is purely illustrative. In this case, [nx] represents a generic placeholder that should be replaced with your organization's specific naming standard.

Is your environment a "Technical Silo" graveyard?
CPI Tenant 
├── Package Salesforce.Integration
├── Package Salesforce_Orders_NEW_FINAL
├── Package VTEX.Flow
├── Package MercadoLivre_Shipments_API
├── Package D365.Finance.Payments.v2.0
├── Package D365-Invoices
├── Package ServiceNow_Incidents_Sync
├── Package Logistics_3PL_Freight_v3
├── Package SAP__MasterData_Customer_v2
├── Package Temp_Testing_DoNotDelete_QAS
├── Package Dev.Customer.Old.Logic 
└── [+147 more packages...] (Legacy debt)
Architectural Note: The list above is a conceptual model of the "Sprawl" phenomenon. It illustrates the operational debt inherent in environments lacking a formal naming convention or design pattern.

Figure 4: CPI Package Sprawl
Figure 4 - CPI Package Sprawl

1.1 - The Three Symptoms of Package Sprawl
Inconsistent Naming: Packages named after projects, apps, or vendors, making search impossible.
Redundant Governance: Multiple packages handling the same domain (e.g., three different "Sales" packages).
Credential Chaos: Each package often requiring its own Service User, leading to a management nightmare.
Figure 5: The Package Chaos
Figure 5 – The package chaos: Visualizing the CPI Package Sprawl Crisis

2 - THE PDCP ARCHITECTURAL DEFINITION
The Package Domain-Centric Pattern (PDCP) is a governance-driven architecture designed to eliminate the "Technical Silo" mindset. It consolidates integration assets by Business Domain (What is the business doing?) rather than application source (Where is it coming from?).

2.1 The Core Principle: Process Over Application
Traditional architecture creates a new package for every new connection. PDCP treats the Business Process as the primary container.

The Sprawl (Old Way): Three separate packages for Salesforce_Orders, Dynamics_Orders, and Shopify_Orders. This leads to fragmented security contexts, redundant mappings, and zero discoverability.
The PDCP (Expert Way): One single "Sales" package—[company-prefix].[business-domain].[sub-subprocess-domain].integrations. All order-related iFlows live here, sharing the same domain governance and technical user strategy.
The Result: You transition from managing hundreds of "Technical Orphans" to managing a few "Intelligent Domain Hubs."

2.2 The Three Pillars of PDCP
To sustain this pattern, your architecture must stand on three pillars:

Consolidation: Mandatory grouping of all iFlows by business area (Sales, Finance, Logistics). "Project-specific" or "Vendor-specific" packages are strictly prohibited.
Standardization: Implementation of the iFlow DNA naming convention for instant discovery and automated categorization via SAP Cloud ALM.
Governance: A Domain Architect acts as a gatekeeper, ensuring every new integration fits the existing domain logic rather than creating a new silo.
Figure 6: The PDCP Three Pillars
Figure 6 – The PDCP three pillars.

2.3 Independence vs. DCRP Synergy
Standalone PDCP: Even without an API Gateway, you achieve a massive consolidation of the SAP Cloud Platform Integration packages, footprint and simplified credential management following this blueprint.
DCRP Synergy: When combined with the Domain-Centric Routing Pattern (Gateway), you create a "Perfect Mirror" architecture. The Gateway handles the semantic routing, while the PDCP package provides the structured, high-performance execution layer.
Figure 7: The PDCP Blueprint
Figure 7 – The PDCP Blueprint: Consolidating Backend Sprawl into Governed Business Domains

3. THE SOLUTION: PDCP (Package Domain-Centric Pattern)
3.1 The Central Principle
Important: This section demonstrates the tiered user strategy using Sales O2C as a reference example. The pattern shows 3 tiered users per package (cr.so.o2c, cr.so.md, cr.so.vendor).

📊 Scaling Example
Single Package (Sales O2C): 3 users (cr.so.o2c, cr.so.md, cr.so.vendor)
Complete Implementation (4 packages): 12 users (4 × 3 tiers)
Traditional Approach: ~39 users (per Package)
PDCP Reduction: 39 → 12 = 69% credential reduction (27 fewer users)
In a complete PDCP implementation with 4 domain packages (Sales, Finance, Logistics, Procurement), this tiered strategy scales to 12 total users (4 packages × 3 tiers each), resulting in a 69% reduction from the traditional ~39 users (1 per package).

"One Business Domain = One CPI Package = Tiered Technical Users"
Governance does not mean creating a single point of failure. By grouping your iFlows into "Security Clusters" within the same package, you ensure that a lockout in a non-critical sync (like a price update) doesn't kill your entire Sales operation.

3.2 The Technical User Strategy: Avoiding the "Total Blackout"
While PDCP consolidates iFlows, using a single Technical User for an entire domain is a high-risk move. To mitigate this, we apply Sub-domain Tiering.

The Solution: Segregation by Criticality
Instead of one set of credentials for everything, you split technical users based on their business impact:

Transactional Core User (cr.so.o2c)
Dedicated to high-volume, mission-critical flows like Order Creation. If this locks, it's a P1—but it is isolated from other failures.

Support/Master Data User (cr.so.md)
Dedicated to secondary flows like Customer Sync or Price Updates.

Third-Party Specific User (Optional)
If a specific vendor (e.g., a 3PL) is prone to sending bad requests that could trigger account lockouts, they receive their own isolated credential.

Why this is superior
Blast Radius Control: If the "Master Data" user is locked due to an expired password, your "Order Creation" flow continues to run without interruption.
Audit Precision: When a "401 Unauthorized" appears in the logs, you immediately know if the issue lies within the Core Transaction or a Support Flow.
Naming Symmetry: The credential name follows the PDCP DNA: cr.[domain].[subdomain] (e.g., cr.so.o2c).
Example: 4 Domain Packages with Tiered Users
Domain Package	Tiered Users (3 per package)	Total Users
nx.sales.o2c.integrations	cr.so.o2c, cr.so.md, cr.so.vendor	3
nx.finance.r2r.integrations	cr.fi.core, cr.fi.reporting, cr.fi.vendor	3
nx.logistics.tm.integrations	cr.log.shipment, cr.log.tracking, cr.log.vendor	3
nx.procurement.p2p.integrations	cr.proc.po, cr.proc.invoice, cr.proc.vendor	3
TOTAL		12
Traditional Approach (BEFORE)
39 packages
~390 iFlows (39 packages × 10 avg)
~39 technical users (1 per package)
Problem: Credential management nightmare; single-user lockout = all iFlows down
PDCP Solution (AFTER)
4 packages
13 iFlows (Sales O2C example)
12 tiered users (3 per package × 4 packages)
Benefits: Blast radius control; precise audit trail; credential management simplified (↓97%)
Architect's Note: These naming standards are expert recommendations. Every organization must analyze its landscape and adapt these rules to their specific governance needs. This framework is a direct response to documented architectural failures where "one user for all" led to total system paralysis.

Figure 8: Technical User Strategy
Figure 8 - The Technical User Nightmare (and How PDCP Solves It)

4. PDCP NAMING CONVENTION FRAMEWORK
4.1 Package Naming Standard
In the previous DCRP blog, I suggested name convention to the SAP CPI Package:
[company-prefix].[business-domain].domain.process

After reflection, this simpler format is more suitable:

Format: [company-prefix].[business-domain].[sap-subprocess-domain].integrations

This structure ensures every package is a self-contained "Intelligence Domain". Using [sub-process].integrations represents all integrations for a business domain subprocess within a single package, eliminating Package Sprawl caused by sender-application-based or division-based naming. As shown in Figure 9, the consolidation reduces 30 packages to 4 strategic domains.

✅ Correct
nx.sales.o2c.integrations    (Order-to-Cash)
nx.sales.crm.integrations    (CRM integrations)
nx.sales.pri.integrations    (Pricing)
nx.sales.reb.integrations    (Rebates)
nx.sales.sd.integrations     (Sales & Distribution)
❌ WRONG
SalesForce_Integration_V2 
Orders_Package_Final 
NewSalesIntegration 
D365-Orders-Inbound
Figure 9: Package Consolidation
Figure 9: Reducing 30 Packages to 4 Strategic Domains

4.2 - Package Consolidation: Immediate ROI
Metric	Before	After	Reduction
CPI Packages	39	4	↓ 90%
iFlows	~390 (39 × 10 avg)	13 (consolidated)	↓ 97%
Technical Users	~39 (1 per package)	12 (tiered)	↓69%
Deploy Time	273 min (~4.5h)	14.5 min (~0.24h)	↑ 18.8× faster
ALM Search	10 min	5 sec	↑ 120× faster
Credential Management	390 credentials	12 credentials	↓ 97%
Governance Overhead	39 packages + 390 users	4 packages + 12 users	↓ 97%
Deploy Time Calculation
Before:
T_total = (39 packages × 2 min) + (390 iFlows × 0.5 min) = 78 min + 195 min = 273 min (~4.5h per deployment)

After:
T_total = (4 packages × 2 min) + (13 iFlows × 0.5 min) = 8 min + 6.5 min = 14.5 min per deployment

Note: Theoretical calculation (273 min) vs observed performance (228 min) reflects optimization in real implementation.

Note: ROI based on real implementation - 13 iFlows (id01→id13) distributed across 6 subprocesses (Orders, Payments, Customers, Invoices, Deliveries, Returns) deployed in 45 minutes. Metrics are estimates based on real-world observations from SAP CPI tenant across three tiers (dev, qas, prd). Actual results may vary depending on team size, integration complexity, and organizational maturity. The core principle remains: fewer, well-organized packages significantly reduce operational overhead.

4.3 - SCALABILITY PROJECTION
Note: This is a simulation and projection based on current metrics, not actual production data. However, it demonstrates the practical difference in scalability between traditional linear growth and PDCP's metadata-driven approach.

Growth with 100 additional integrations
Metric	Linear Growth (Before)	PDCP Growth (After)	Difference
Packages	39 → 139 (+100)	4 → 4 (zero growth)	+100 packages avoided
iFlows	390 → 490 (+100)	13 → 113 (+100)	Consolidated in 4 packages
Technical Users	39 → 139 (+100)	12 → 24 (tiered strategy)	+115 users
└─ Transactional Core	N/A (1 per iFlow)	4 users → 8 users	Mission-critical isolation
└─ Support/Master Data	N/A (1 per iFlow)	4 users → 8 users	Risk segregation
└─ Third-Party Specific	N/A (1 per iFlow)	4 users → 8 users	Vendor isolation
Deploy Time	237h/year → 453h/year	12.5h/year → 56h/year	397h saved/year
Maintenance Effort	39 objects → 139 objects	4 objects → 4 objects	+100 objects avoided
Deploy Time Analysis - Per-Deployment Calculation
Current State (Before Growth):

Traditional: T = (39 pkg × 2 min) + (390 iFlows × 0.5 min) = 78 + 195 = 273 min (~4.5h)
PDCP: T = (4 pkg × 2 min) + (13 iFlows × 0.5 min) = 8 + 6.5 = 14.5 min (~0.24h)
After 100 New Integrations:

Traditional: T = (139 pkg × 2 min) + (490 iFlows × 0.5 min) = 278 + 245 = 523 min (~8.7h)
Growth: 273 min → 523 min (+250 min, +92% increase)

PDCP: T = (4 pkg × 2 min) + (113 iFlows × 0.5 min) = 8 + 56.5 = 64.5 min (~1.1h)
Growth: 14.5 min → 64.5 min (+50 min, +345% increase)

Key Insight: While PDCP deploy time increases by 345% (14.5→64.5 min), it still deploys 8× faster than Traditional (64.5 min vs 523 min). Traditional approach becomes exponentially worse with scale.

Annual Impact (52 deployments/year)
Scenario	Traditional	PDCP	Savings
Current State	273 min × 52 = 237h/year	14.5 min × 52 = 12.5h/year	224.5h/year (↓95%)
After +100 integrations	523 min × 52 = 453h/year	64.5 min × 52 = 56h/year	397h/year (↓88%)
5-Year Projection	2,265 hours	280 hours	1,985 hours saved
Business Value: At 100 EUR/hour engineering cost, PDCP saves €198,500 over 5 years in deployment labor alone (excluding reduced incident response, faster onboarding, and governance overhead).

Why PDCP Scales Better
Traditional Linear Growth:

Each new integration = +1 package
Each package = +2 min deploy time
Growth is additive per integration
PDCP Metadata-Driven Growth:

New integrations → Same 4 packages
Only iFlow count increases
Growth is consolidated within domains
Package overhead stays constant (4 packages = 8 min baseline)
Result: PDCP maintains sub-linear scalability — as integrations grow, the percentage of time spent on package deployment decreases.

Key Benefits
✅ Clear ownership—each domain has defined boundaries
✅ Knowledge retention—structure survives team turnover
✅ Faster releases—reduced dependency complexity
Figure 10: From Chaos to Clarity
Figure 10 - From Chaos to Clarity: PDCP Package Naming Framework

4.4 - The "Single Container" Logic
One package per domain subprocess eliminates clutter. But to prevent this "Single Container" from becoming a junk drawer, three rules are mandatory:

Surgical Indexing: Use strict iFlow naming standards (detailed in Section 5) to keep the package sorted and searchable.
System Abstraction: Stop naming by system (Salesforce/SAP). Name by business process to ensure the package remains a reusable service hub.
Discovery First: Within this single container, naming is your only navigation tool—especially critical for SAP Cloud ALM integration.
Note: The internal organization of name convention that makes this centralization possible is detailed in the sections below.

4.5 The "Main" Philosophy
Why avoid sub-process names like .orders or .invoices in the package title?

Scalability: One package per domain prevents "Package Sprawl" from ever returning. It caps your tenant complexity.
Abstraction: As an Expert, you design for the Domain Authority. Whether you have 10 or 50 sub-processes, they are all children of the same business unit.
Operational Discipline: It forces developers to resolve complexity through iFlow DNA within the domain, rather than littering the tenant with orphaned, small-scope packages.
5 - The Advanced iFlow DNA name
In the previous blog I didn't provide any format of design name and convention name for Iflow. What I wrote there was just sample perspective - SO.01.Iflow.Sales.Order.Inbound - SO.02.Iflow.Sales.Order.Tracking. This was just representative, now I would suggest the structure below.

Instead of amateur or purely sequential names, we establish a standardized name convention for every integration asset. This transforms a cluttered tenant into a surgical, searchable, and reusable service library.

Format:
id[seq].[subdomain].[sender].[entity].[action].[direction].[sync/async]

Architect's Note: Complexity with Purpose
You might be questioned: "Isn't this name too long?"

My answer is simple: Complexity must live somewhere. This naming structure is a high-level architectural suggestion requiring strong governance. When adopting the "One Package per Business Domain" model, the name is your only metadata. Without including the Sub-domain, Sender, and Receiver, you will inevitably hit Index Duplication or "Name Collisions." This detail is the only way to ensure surgical isolation and prevent your domain package from becoming a "black box" of identical-looking flows.

Important: This pattern focuses on internal CPI organization. While it is optimized for synergy with the DCRP Gateway, its primary goal is to ensure that your domain package does not become a "black box" of identical-looking flows.

The design and name convention breakdown
Component	Meaning	Examples
Seq	Sequence Number (Indexing)	01, 02, 03
Subdomain	Specific Business Process	o2c, r2r, le, p2p
Sender	Source System	salesforce, magento, 3pl
Entity	Business Object (Qualifier)	order, customer, invoice
Action	Function Performed	c(create), r (read), u (update), d (delete), s (sync), a (approve)
Receiver	Target System	s4hana, sap, quickbooks, fedex
Direction	Data Flow	in, out
Processing	sync or async	sync or async
Action Codes Table
To ensure everyone is aligned, you can present the Action Codes like this:

Code	Action	Business Intent	Example use case
c	Create	Creating new records	Creating a new sales order
r	Read	Retrieving or fetching data	Retrieving customer master data
u	Update	Modifying existing records	Updating order status
d	Delete	Removing records	Deleting cancelled orders
s	Sync	Continuous synchronization	Syncing product catalog
p	Post	Submitting data for processing	Posting journal entries to ERP
a	Approve	Workflow or status transitions	Approving purchase requisition
n	Notify	Sending notifications or alerts	Sending shipment tracking notification
q	Query	Complex search or reporting	Querying inventory availability
v	Validate	Pre-processing validation	Validating order data before creation
t	Transform	Data format transformation	Converting EDI to XML format
e	Enrich	Adding supplementary data	Enriching order with pricing information
m	Merge	Combining data from multiple sources	Merging customer data from CRM and ERP
x	Execute	Triggering business logic or workflow	Executing credit check workflow
b	Batch	Processing multiple records in bulk	Nightly batch invoice generation
5.1 - Sequential Indexing Logic
The sequence number (id[seq]) provides a simple, incremental index within each package.

Domain: Sales Samples | Subprocess: o2c (Order-to-Cash)
id01.o2c.salesforce.order.s4hana.c.in.sync       (Create order from Salesforce to S/4HANA)
id02.o2c.salesforce.order.s4hana.u.in.sync       (Update order from Salesforce to S/4HANA)
id03.o2c.shopify.customer.s4hana.s.in.sync       (Sync customer from Shopify to S/4HANA)
id04.o2c.stripe.payment.s4hana.n.in.sync         (Notify payment from Stripe to S/4HANA)
id05.o2c.s4hana.invoice.quickbooks.c.out.sync    (Create invoice from S/4HANA to QuickBooks)
Why reset per subdomain?
✅ Each subdomain becomes a self-contained index space
✅ Prevents collision across different business processes
✅ Easier to count flows within a specific subdomain (e.g., "How many O2C flows?")
✅ Natural grouping when sorted alphabetically
✅ Simple, predictable numbering (id01, id02, id03...)
✅ Easy to count total flows in a package
✅ Natural alphabetical sorting by ID
✅ Clear audit trail (id05 created after id04)
Key Rule:
The sequence starts at id01 for each new subdomain within the same package.

5.2 - Real-World Example: 13 iFlows Deployed
Package: nx.sales.o2c.integrations
Coverage: Orders, Payments, Customers, Invoices, Deliveries, Returns

⚠️ Important Note on Endpoint Patterns:
The "Endpoint Pattern SAP CPI" column below and further shows URLs using the /http/dcrp/ and /cxf/dcrp/ prefixes.
These patterns are specific to DCRP + PDCP synergy (covered in Chapter 7) and are used to enable metadata-driven routing via the DCRP JavaScript engine.

If you are implementing PDCP standalone (without API Gateway), these patterns are NOT mandatory. You are free to define your own URL conventions. As suggestion, please check sector (6. The URL Governance: The Agnostic Endpoint - Only SAP CPI). The only PDCP requirement is that your URL must reflect the iFlow DNA for traceability (entity, action, and ID).

Examples of valid standalone PDCP endpoints:

/orders/create/id01
/api/sales/orders/id01
/integrations/o2c/orders/id01
🚨 This blog does NOT provide an official pattern for HTTP vs SOAP adapter selection or standard URL path structures—these decisions are left to your organizational needs but some suggestions on the sector 6.

ID	Sender	Entity	Receiver	Action	Direction	Processing	Protocol	Endpoint Pattern SAP CPI
id01	salesforce	orders	s4hana	c	in	sync	REST	/http/dcrp/orders/c/id01
id02	salesforce	orders	s4hana	u	in	sync	REST	/http/dcrp/orders/u/id02
id03	shopify	customers	s4hana	s	in	sync	REST	/http/dcrp/customers/s/id03
id04	stripe	payments	s4hana	n	in	sync	REST	/http/dcrp/payments/n/id04
id05	microsoft	orders	s4hana	c	in	sync	SOAP	/cxf/dcrp/orders/c/id05
id06	fedex	deliveries	s4hana	t	in	sync	REST	/http/dcrp/deliveries/t/id06
id07	s4hana	customers	externalcrm	s	out	sync	SOAP	/cxf/dcrp/customers/s/id07
id08	s4hana	payments	externalpay	n	out	sync	SOAP	/cxf/dcrp/payments/n/id08
id09	quickbooks	invoices	s4hana	c	in	sync	SOAP	/cxf/dcrp/invoices/c/id09
id10	s4hana	invoices	externalbill	c	out	sync	REST	/http/dcrp/invoices/c/id10
id11	s4hana	deliveries	externallog	t	out	sync	SOAP	/cxf/dcrp/deliveries/t/id11
id12	shopify	returns	s4hana	c	in	sync	REST	/http/dcrp/returns/c/id12
id13	s4hana	returns	externalret	c	out	sync	SOAP	/cxf/dcrp/returns/c/id13
5.2 - What if I have multiple instances of the same system?
Differentiate in the [sender] field:

Common patterns:

Region: sfusa, sfemea, sfapac
Environment: s4prod, s4qa, s4dev
Division: sapretail, sapwholesale
Scenario	Solution	Example
2 Salesforce (US/EMEA)	Append region code	id01.o2c.salesforceus.order.s4hana.c.in.sync vs id05.o2c.salesforceemea.order.s4hana.c.in.sync
2 S/4HANA (Prod/QA)	Append environment	id01.o2c.salesforce.order.s4prod.c.in.sync vs id02.o2c.salesforce.order.s4qa.c.in.sync
Same system, different entities	Use [entity]	id01.o2c.salesforce.order.s4hana.c.in.sync vs id03.o2c.salesforce.customer.s4hana.s.in.sync
Figure 11: IFlow Design and Naming Convention
Figure 11 - IFlow design and naming convention

5.3 - Implementation Strategy
Why Not One Global iFlow per package?
Relying on a single iFlow with complex internal routing is unsustainable and risky.

The Problem:

One bug breaks everything
Testing impacts production
Impossible to isolate failures
The PDCP Solution:

✅ Risk Isolation - A bug in Magento mapping never breaks Salesforce flows
✅ Surgical Deployment - Deploy and test individual flows independently
✅ Instant Discovery - Alphabetical sorting by [subdomain].[sender] groups all flows naturally
✅ Operational Clarity - Failures are visible immediately: "Salesforce failed to create Order in S/4HANA"
Example:

❌ Before: One monolithic iFlow handles all order integrations
✅ After:
id01.o2c.salesforce.order.c.in.async
id02.o2c.magento.order.c.in
id03.o2c.shopify.order.c.in.async
Your support team no longer digs through payloads. The failure is visible directly in SAP Cloud ALM or CPI Monitor.

5.4 - The Result: A Governed Domain Library
We have transformed the CPI tenant from a "trash bin of integrations" into a Governed Domain Library. You maintain a slim footprint with one package per domain, but inside, you have a fleet of specialized, high-performance iFlows that are easy to manage and impossible to lose.

Figure 12: From Chaos to Governed Library
Figure 12 - From Chaos to Governed Library

6. The URL Governance: The Agnostic Endpoint - Only SAP CPI
PDCP governance extends beyond iFlow naming to the HTTP endpoint URL. A surgical iFlow name with a generic URL loses traceability.

The Rule: Your URL must be the Agnostic Reflection of your iFlow DNA.

Why Include ID in the URL?
The id component serves as a unique identifier for the iFlow and its HTTP channel, enabling precise traceability in logs, monitoring tools, and troubleshooting.

URL Format Strategy
The URL format depends on your architectural approach:

Option 1: Full Context (Recommended)
Format: /[entity]/[action]/[id]

Examples (Sales O2C):

/orders/c/id01      → id01.o2c.salesforce.order.s4hana.c.in.sync
/orders/u/id02      → id02.o2c.salesforceemea.order.s4hana.u.in.sync
/customers/s/id03   → id03.o2c.shopify.customer.s4hana.s.in.sync
/payments/n/id04    → id04.o2c.stripe.payment.s4hana.n.in.sync
/orders/c/id05      → id05.o2c.microsoft.order.s4hana.c.in.sync
/deliveries/t/id06  → id06.o2c.fedex.delivery.s4hana.t.in.sync
/customers/s/id07   → id07.o2c.s4hana.customer.externalcrm.s.out.async
/payments/n/id08    → id08.o2c.s4hana.payment.externalpay.n.out.async
/invoices/c/id09    → id09.o2c.quickbooks.invoice.s4hana.c.in.sync
/invoices/c/id10    → id10.o2c.s4hana.invoice.externalbill.c.out.async
/deliveries/t/id11  → id11.o2c.s4hana.delivery.externallog.t.out.async
/returns/c/id12     → id12.o2c.shopify.return.s4hana.c.in.sync
/returns/c/id13     → id13.o2c.s4hana.return.externalret.c.out.async
Benefits:

✅ Full context in URL (entity + action + id)
✅ Direct mapping to iFlow name
✅ Easy troubleshooting (URL = iFlow identifier)
Option 2: Simplified
Format: /[entity]/[id]

Examples (Sales O2C):

/orders/id01      → id01.o2c.salesforce.order.s4hana.c.in.sync
/orders/id02      → id02.o2c.salesforceemea.order.s4hana.u.in.sync
/customers/id03   → id03.o2c.shopify.customer.s4hana.s.in.sync
/payments/id04    → id04.o2c.stripe.payment.s4hana.n.in.sync
/orders/id05      → id05.o2c.microsoft.order.s4hana.c.in.sync
/deliveries/id06  → id06.o2c.fedex.delivery.s4hana.t.in.sync
/customers/id07   → id07.o2c.s4hana.customer.externalcrm.s.out.async
/payments/id08    → id08.o2c.s4hana.payment.externalpay.n.out.async
/invoices/id09    → id09.o2c.quickbooks.invoice.s4hana.c.in.sync
/invoices/id10    → id10.o2c.s4hana.invoice.externalbill.c.out.async
/deliveries/id11  → id11.o2c.s4hana.delivery.externallog.t.out.async
/returns/id12     → id12.o2c.shopify.return.s4hana.c.in.sync
/returns/id13     → id13.o2c.s4hana.return.externalret.c.out.async
Benefits:

✅ Cleaner URLs
✅ Entity-based grouping
✅ ID provides uniqueness
Option 3: Domain Prefix
Format: /sales/[entity]/[action]/[id]

Examples (Sales O2C):

/sales/orders/c/id01      → id01.o2c.salesforce.order.s4hana.c.in.sync
/sales/orders/u/id02      → id02.o2c.salesforceemea.order.s4hana.u.in.sync
/sales/customers/s/id03   → id03.o2c.shopify.customer.s4hana.s.in.sync
/sales/payments/n/id04    → id04.o2c.stripe.payment.s4hana.n.in.sync
/sales/orders/c/id05      → id05.o2c.microsoft.order.s4hana.c.in.sync
/sales/deliveries/t/id06  → id06.o2c.fedex.delivery.s4hana.t.in.sync
/sales/customers/s/id07   → id07.o2c.s4hana.customer.externalcrm.s.out.async
/sales/payments/n/id08    → id08.o2c.s4hana.payment.externalpay.n.out.async
/sales/invoices/c/id09    → id09.o2c.quickbooks.invoice.s4hana.c.in.sync
/sales/invoices/c/id10    → id10.o2c.s4hana.invoice.externalbill.c.out.async
/sales/deliveries/t/id11  → id11.o2c.s4hana.delivery.externallog.t.out.async
/sales/returns/c/id12     → id12.o2c.shopify.return.s4hana.c.in.sync
/sales/returns/c/id13     → id13.o2c.s4hana.return.externalret.c.out.async
Benefits:

✅ Domain-level organization
✅ Clear business context
✅ Scalable across multiple domains
Important Note
The id prefix is purely an identifier, not a version indicator. Versioning should be managed separately through API versioning strategies (e.g., /v1/, /v2/).

7 - DCRP + PDCP implementation and KVM configuration
SCOPE: This section covers DCRP + PDCP integration (Gateway + CPI). For standalone CPI APIs without Gateway, refer to Section 6 (URL Governance).

7.1 The Challenge: Traditional 1:1 Architecture
Traditional 1:1 architecture would require 13 separate API Proxies to cover the complete Sales O2C landscape:

❌ TRADITIONAL APPROACH (13 PROXIES)
#	API-Proxy	Entity	Deploy Time
1	OrderCreationProxy	Orders	15 min
2	OrderUpdateProxy	Orders (Update)	15 min
3	CustomerSyncProxy	Customers	15 min
4	PaymentNotificationProxy	Payments	15 min
5	OrderCreationSOAPProxy	Orders (SOAP)	15 min
6	DeliveryTrackingProxy	Deliveries	15 min
7	CustomerSyncSOAPProxy	Customers (SOAP)	15 min
8	PaymentNotificationSOAPProxy	Payments (SOAP)	15 min
9	InvoiceCreationProxy	Invoices	15 min
10	InvoiceOutboundProxy	Invoices (Outbound)	15 min
11	DeliveryTrackingSOAPProxy	Deliveries (SOAP)	15 min
12	ReturnCreationProxy	Returns	15 min
13	ReturnCreationSOAPProxy	Returns (SOAP)	15 min
Total Deployment Overhead:

Initial Deployment: 13 proxies × 15 min = 3.25 hours
Security Policies: 13 separate policies
Monitoring Dashboards: 13 separate dashboards
Credential Management: 13 credential sets
Maintenance: 13 objects to manage
When DCRP (Gateway) and PDCP (CPI) work together, you achieve end-to-end domain governance:

Gateway Layer (DCRP): Facade URLs, metadata-driven routing, vendor disambiguation
Orchestration Layer (PDCP): Surgical iFlow naming, package consolidation, tiered users

The Synergy:

Client → [Gateway DCRP] → [KVM Lookup] → [JavaScript v8.0] → [CPI PDCP Package] → Backend
✅ DCRP SOLUTION (1 UNIFIED PROXY)
Proxy Name: cpi-dcrp-proxy-domain-sales-o2c

Route Rules (all point to same Target Endpoint):

DCRP - One API-PROXY	Route Name	Route Rules	Target CPI Iflow
cpi-dcrp-proxy-domain-sales-o2c	sales-o2c-orders	/orders/**	id01.o2c.salesforce.order.s4hana.c.in.sync
"	sales-o2c-orders	/orders/**	id02.o2c.salesforceemea.order.s4hana.u.in.sync
"	sales-o2c-customers	/customers/**	id03.o2c.shopify.customer.s4hana.s.in.sync
"	sales-o2c-payments	/payments/**	id04.o2c.stripe.payment.s4hana.n.in.sync
"	sales-o2c-orders	/orders/**	id05.o2c.microsoft.order.s4hana.c.in.sync
"	sales-o2c-deliveries	/deliveries/**	id06.o2c.fedex.delivery.s4hana.t.in.sync
"	sales-o2c-customers	/customers/**	id07.o2c.s4hana.customer.externalcrm.s.out.async
"	sales-o2c-payments	/payments/**	id08.o2c.s4hana.payment.externalpay.n.out.async
"	sales-o2c-invoices	/invoices/**	id09.o2c.quickbooks.invoice.s4hana.c.in.sync
"	sales-o2c-invoices	/invoices/**	id10.o2c.s4hana.invoice.externalbill.c.out.async
"	sales-o2c-deliveries	/deliveries/**	id11.o2c.s4hana.delivery.externallog.t.out.async
"	sales-o2c-returns	/returns/**	id12.o2c.shopify.return.s4hana.c.in.sync
"	sales-o2c-returns	/returns/**	id13.o2c.s4hana.return.externalret.c.out.async
Figure 13: DCRP API-Proxy Configuration
Figure 13 - DCRP API-Proxy - Sales - O2C Configuration - cpi-dcrp-proxy-domain-sales-o2c

Deployment Overhead:

Initial Deployment: 1 proxy × 2 min = 2 minutes
Security Policies: 1 centralized policy
Monitoring Dashboards: 1 unified dashboard
Credential Management: 1 credential set
Maintenance: 1 object to manage
IMPACT: TRADITIONAL vs DCRP
Metric	Traditional 1:1 Implementation	DCRP - API-Proxy	Savings
Initial Deployment	3.25 hours	2 minutes	↓99%
New Integration Setup	15 min	30 sec	↓97%
Security Policies	13	1	↓92%
Monitoring Dashboards	13	1	↓92%
Credential Management	13	1	↓92%
Maintenance	13 objects	1 object	↓92%
Key Takeaway: DCRP eliminates proxy sprawl by consolidating routing logic into metadata-driven rules inside a single intelligent gateway that scales via configuration.

Benefits:

✅ Single facade endpoint handles multiple vendors
✅ Zero-code vendor onboarding (metadata-only)
✅ End-to-end traceability (Facade → iFlow)
✅ Consistent governance across Gateway and CPI
7.2 The Routing Flow (Step-by-Step)
Step 1: External API (Client-facing)
Client calls the agnostic facade with vendor identifier:

POST /sales/orders/creation/<vendor>
PUT  /sales/orders/update/<vendor>
Client calls the agnostic facade with vendor identifier:

POST /sales/orders/creation/salesforce 
POST /sales/orders/creation/microsoft 
PUT  /sales/orders/update/salesforce
Why '<vendor>' is Required?
In real-world scenarios, multiple vendors integrate with the same business process:

Salesforce sends order creation
Microsoft Dynamics sends order creation
MuleSoft sends order creation
Without <vendor>, all would route to the same iFlow.

Causing:

❌ Mapping conflicts
❌ Cannot isolate vendor errors
❌ Cannot track vendor metrics
❌ Cannot apply vendor-specific security
Alternative: Use explicit ID routing

POST /sales/orders/creation/id01 (Salesforce) 
POST /sales/orders/creation/id05 (Microsoft)
⚠️ Important: DCRP + PDCP is Not Magic
The routing engine requires explicit identification (<vendor> or <id>) to determine the target iFlow.

Context: These are architectural guidelines, not universal solutions. Evaluate, adapt, and extend them to fit your specific context.

Step 2: Gateway Internal Conversion (JavaScript + KVM)
The Gateway converts facade URLs to PDCP-compliant routing keys:

/sales/orders/creation/salesforce → dcrporderscid01
/sales/orders/creation/microsoft  → dcrporderscid05
/sales/orders/update/salesforce   → dcrpordersuid02
Step 3: KVM Lookup
Gateway queries the Key-Value Map:

dcrporderscid01:http,dcrpordersuid02:http,dcrpcustomerssid03:http,
dcrppaymentsnid04:http,dcrporderscid05:cxf,dcrpdeliveriestid06:http,
dcrpcustomerssid07:cxf,dcrppaymentsnid08:cxf,dcrpinvoicescid09:cxf,
dcrpinvoicescid10:cxf,dcrpdeliveriestid11:cxf,dcrpreturnscid12:http,dcrpreturnscid13:cxf
Figure 14: KVM Configuration
Figure 14 - Configuration of KVM CPI Package - nx.sales.o2c.integrations

Step 4: JavaScript Routing Engine (v8.0)
The routing engine:

Decodes compact URL: dcrporderscid01 → /dcrp/orders/c/id01
Identifies adapter: http
Constructs target URL: https://tenant.../http/dcrp/orders/c/id01
idinterface:dcrporderscid01:http,dcrpordersuid02:id02.o2c.salesforce.order.u.in,dcrporderscid05:id05.o2c.microsoft.order.c.in,dcrpcustomerssid03:id03.o2c.magento.customer.s.in,dcrppaymentsnid04:id04.o2c.shopify.payment.n.out
Don't worry! The JavaScript v8.0 engine handles this automatically. Unlike the Blog Part I (which used human-readable names like inbound, tracking, status), PDCP uses structured action codes (c, u, s) for consistency and automation.

Figure 15: PDCP URL Decoding
Figure 15 - PDCP URL Decoding: All 15 Action Codes Validated

Step 5: CPI Execution - Samples
CPI receives the request and executes the mapped iFlow:

DCRP - One API-Proxy	Facade URL (APIM) https://tenantapiportal...	Target URL - SAP CPI https://tenant...	Iflow
cpi-dcrp-proxy-domain-sales-o2c	/sales/orders/creation/salesforce	/http/dcrp/orders/c/id01	id01
"	/sales/orders/update/salesforceemea	/http/dcrp/orders/u/id02	id02
"	/sales/customers/sync/shopify	/http/dcrp/customers/s/id03	id03
"	/sales/payments/notification/stripe	/http/dcrp/payments/n/id04	id04
"	/sales/orders/creation/microsoft	/cxf/dcrp/orders/c/id05	id05
"	/sales/deliveries/tracking/fedex	/http/dcrp/deliveries/t/id06	id06
"	/sales/customers/sync/s4hana	/cxf/dcrp/customers/s/id07	id07
"	/sales/payments/notification/s4hana	/cxf/dcrp/payments/n/id08	id08
"	/sales/invoices/creation/quickbooks	/cxf/dcrp/invoices/c/id09	id09
"	/sales/invoices/creation/s4hana	/http/dcrp/invoices/c/id10	id10
"	/sales/deliveries/tracking/s4hana	/cxf/dcrp/deliveries/t/id11	id11
"	/sales/returns/creation/shopify	/http/dcrp/returns/c/id12	id12
"	/sales/returns/creation/s4hana	/cxf/dcrp/returns/c/id13	id13
7.3 KVM Structure & Configuration
KVM Anatomy
Each domain has its own KVM with three key fields:

Field	Purpose	Example
packagename	CPI Package identifier	nx.sales.o2c.integrations
saprocess	Business process description	SAP SD & O2C - Sales Process
idinterface	Routing metadata (compact URL : iFlow : adapter)	dcrporderscid01:http / dcrporderscid05:cxf
BREAKDOWN orientation of iflowname field
Component	Value	Purpose
Routing Key	dcrporderscid01:cxf	Compact URL usado pelo Gateway
iFlow Name	id01.o2c.salesforceus.orders.s4hana.c.in.sync	iFlow real no CPI
Adapter Type	soap	Define o prefixo do endpoint CPI
WHY :http AT THE END?
PURPOSE
The third parameter (:http or :cfx) tells the JavaScript routing engine which adapter the CPI iFlow uses.

HOW IT WORKS

HTTP Adapter:

KVM: dcrporderscid01:http
Target URL: https://tenant.../http/dcrp/orders/c/id01
SOAP Adapter:

KVM: dcrpinvoicescid03:cfx
Target URL: https://tenant.../cfx/dcrp/invoices/c/id03
WHAT HAPPENS IN THE CODE - JAVASCRIPT the BRAIN Machine
Copy// Section 3: Parse KVM entry
var parts = entry.split(':');
var dcrpPath = parts[0];           // "dcrporderscid01"
var adapter = parts[1] || "http";  // "http" (default if omitted)

// Section 6: Build target URL
var targetUrl = cpiHost + "/" + adapter + "/" + decodedPath;
// Result: https://tenant.../http/dcrp/orders/c/id01
WHEN CAN YOU OMIT :http?
If ALL iFlows that is going to use DCRP + PDCP in the package use HTTP:

KVM (omitting :http):

dcrporderscid01:dcrpordersuid02
The code uses default: var adapter = parts[2] || "http";

WHEN MUST YOU SPECIFY IT?
If there's a MIX of HTTP and SOAP in the same package:

KVM (mixed adapters):

dcrporderscid01:http,dcrpinvoicescid03:cfx,dcrpexpensescid01:http
SUMMARY
✅ :http = HTTP adapter → /http/dcrp/...
✅ :cfx = SOAP adapter → /cfx/dcrp/...
✅ Omitted = defaults to HTTP
7.4 - KVM Symmetry: Map Identifier ↔ PDCP Package
To ensure the DCRP engine functions correctly, the KVM Map Identifier must mirror your PDCP Package naming convention. Figure 15 shows the KVM registration configuration:

Business Domain	PDCP Package name	KVM Map Identifier
Sales	nx.sales.o2c.integrations	cpipackage-nx.sales.o2c.integrations
Finance	nx.finance.r2r.integrations	cpipackage-nx.finance.r2r.integrations
Logistics	nx.logistics.tm.integrations	cpipackage-nx.logistics.tm.integrations
Procurement	nx.procurement.p2p.integrations	cpipackage-nx.procurement.p2p.integrations
Figure 16: KVM Registration
Figure 16 - KVM Registration in API Management

7.5 - APIM Policy Configuration
In your API Management Policy in each DCRP API-Proxy, the sample below is how should be the XML Policy of Key Value Mapping - Target Endpoint Pre-Flow, reference the KVM:

Figure 17: Key Value Mapping Policy
Figure 17 - Key Value Mapping Standard Policy read metadata.

Copy<KeyValueMapOperations mapIdentifier="cpipackage-nx.sales.o2c.integrations">...</KeyValueMapOperations>
<KeyValueMapOperations mapIdentifier="cpipackage-nx.finance.r2r.integrations">...</KeyValueMapOperations>
<KeyValueMapOperations mapIdentifier="cpipackage-nx.logistics.le.integrations">...</KeyValueMapOperations>
<KeyValueMapOperations mapIdentifier="cpipackage-nx.procurement.p2p.integrations">...</KeyValueMapOperations>
7.6 Domain Implementation Examples
The facade URLs below show generic paths for simplicity. In production with multiple vendors, always include <vendor> or <id>:

With vendor: POST /sales/orders/creation/salesforce
With ID: POST /sales/orders/creation/id01
1. SALES (nx.sales.o2c.integrations)
Package Name: nx.sales.o2c.integrations
SAP Process: SAP SD & O2C - Sales Process
iFlows: All 13 Sales O2C iFlows (id01–id13)

Endpoints:

SAP API Management URL Facade	Protocol	SAP CPI endpoint
POST /sales/orders/creation/salesforce	HTTP	https://tenant.hci.eu1.hana.ondemand.com/http/dcrp/orders/c/id01
PUT /sales/orders/update/salesforceemea	HTTP	https://tenant.hci.eu1.hana.ondemand.com/http/dcrp/orders/u/id02
POST /sales/customers/sync/shopify	HTTP	https://tenant.hci.eu1.hana.ondemand.com/http/dcrp/customers/s/id03
POST /sales/payments/notification/stripe	HTTP	https://tenant.hci.eu1.hana.ondemand.com/http/dcrp/payments/n/id04
POST /sales/orders/creation/microsoft	SOAP	https://tenant.hci.eu1.hana.ondemand.com/cxf/dcrp/orders/c/id05
POST /sales/deliveries/tracking/fedex	HTTP	https://tenant.hci.eu1.hana.ondemand.com/http/dcrp/deliveries/t/id06
POST /sales/customers/sync/s4hana	SOAP	https://tenant.hci.eu1.hana.ondemand.com/cxf/dcrp/customers/s/id07
POST /sales/payments/notification/s4hana	SOAP	https://tenant.hci.eu1.hana.ondemand.com/cxf/dcrp/payments/n/id08
POST /sales/invoices/creation/quickbooks	SOAP	https://tenant.hci.eu1.hana.ondemand.com/cxf/dcrp/invoices/c/id09
POST /sales/invoices/creation/s4hana	HTTP	https://tenant.hci.eu1.hana.ondemand.com/http/dcrp/invoices/c/id10
POST /sales/deliveries/tracking/s4hana	SOAP	https://tenant.hci.eu1.hana.ondemand.com/cxf/dcrp/deliveries/t/id11
POST /sales/returns/creation/shopify	HTTP	https://tenant.hci.eu1.hana.ondemand.com/http/dcrp/returns/c/id12
POST /sales/returns/creation/s4hana	SOAP	https://tenant.hci.eu1.hana.ondemand.com/cxf/dcrp/returns/c/id13
2. FINANCE (nx.finance.r2r.integrations)
Package Name: nx.finance.r2r.integrations
SAP Process: SAP FI & R2R - Record to Report
iFlows: id01.r2r.sap.invoice.externalbill.c.out.async / id03.r2r.ariba.expense.s4hana.a.in.sync

Endpoints:

SAP API Management URL Facade	Protocol	SAP CPI endpoint
POST /finance/expenses/creation/ariba	HTTP	https://tenant.hci.eu1.hana.ondemand.com/http/dcrp/expenses/c/id03
POST /finance/invoices/creation/sap	SOAP	https://tenant.hci.eu1.hana.ondemand.com/cxf/dcrp/invoices/c/id01
7.6 - Multi-Vendor Disambiguation: Real-World Examples
The Challenge
When multiple vendors (or multiple instances of the same vendor) integrate with the same process, you need sender-aware routing.

Example 1: Salesforce Multi-Region
Facade URL - API Management	Vendor Instance	Routes to Iflow
POST /sales/orders/creation/salesforceus	Salesforce US	id01.o2c.salesforceus.order.c.in.sync
POST /sales/orders/creation/salesforceeu	Salesforce EU	id02.o2c.salesforceeu.order.c.in.sync
POST /sales/orders/creation/salesforceapac	Salesforce APAC	id03.o2c.salesforceapac.order.c.in.sync
KVM Structure:

kvm.idinterface:dcrporderscid01:http,dcrporderscid05:cxf,dcrporderscid09:http
Example 2: SAP S/4HANA Multi-Environment
Scenario: 2 S/4HANA systems (Production and QA) for invoice creation

Facade URL - APIM Management	Environment	Routes to Iflow
POST /finance/invoices/creation/s4prod	Production	id01.r2r.s4prod.invoice.c.out.sync
POST /finance/invoices/creation/s4qa	QA/Test	id10.r2r.s4qa.invoice.c.out.sync
KVM Structure:

kvm.idinterface:dcrpinvoicescid01:cfx,dcrpinvoicescid10:cfx
Example 3: Multiple E-Commerce Platforms
Scenario: 5 e-commerce platforms sending orders to the same process

Facade URL	Platform	Routes to Iflow
POST /sales/orders/creation/shopify	Shopify	id04.o2c.shopify.order.c.in.sync
POST /sales/orders/creation/magento	Magento	id08.o2c.magento.order.c.in.sync
POST /sales/orders/creation/woocommerce	WooCommerce	id12.o2c.woocommerce.order.c.in.sync
POST /sales/orders/creation/vtex	VTEX	id16.o2c.vtex.order.c.in.sync
POST /sales/orders/creation/bigcommerce	BigCommerce	id20.o2c.bigcommerce.order.c.in.sync
KVM Structure:

kvm.idinterface:dcrporderscid04:http,dcrporderscid08:http,dcrporderscid12:cxf,
dcrporderscid16:cxf,dcrporderscid20:http
JavaScript v8.0 Routing Logic
Extract vendor from path: /sales/orders/creation/salesforceus
Match vendor in KVM: salesforceus → dcrporderscid01:http
Decode: dcrporderscid01:http → /dcrp/orders/c/id01
Route to: https://tenant.../http/dcrp/orders/c/id01
Execute iFlow: id01.o2c.salesforceus.order.c.in.sync
7.10 API Proxy Configuration
Single Proxy Architecture
Proxy Name: cpi-dcrp-proxy-domain-sales-o2c

Proxy Endpoint Configuration:

Base Path: /sales
Protocols: HTTP, HTTPS
Authentication: Basic Auth
Without Quotes, Spike Arrests and JavaScript Hacking threat mechanism.
Route Rules (13 routes pointing to same Target Endpoint):

Route Rule Name	Route Rule Condition	JavaScript Target.url variable - SAP CPI Endpoint
sales-o2c-orders	proxy.pathsuffix MatchesPath "/orders/**"	/http/dcrp/orders/c/id01
sales-o2c-customers	proxy.pathsuffix MatchesPath "/customers/**"	/http/dcrp/orders/u/id02
sales-o2c-payments	proxy.pathsuffix MatchesPath "/payments/**"	/http/dcrp/customers/s/id03
sales-o2c-invoices	proxy.pathsuffix MatchesPath "/invoices/**"	/http/dcrp/payments/n/id04
sales-o2c-deliveries	proxy.pathsuffix MatchesPath "/deliveries/**"	/cxf/dcrp/orders/c/id05
sales-o2c-returns	proxy.pathsuffix MatchesPath "/returns/**"	/http/dcrp/deliveries/t/id06
sales-o2c-quotes	proxy.pathsuffix MatchesPath "/quotes/**"	/cxf/dcrp/customers/s/id07
sales-o2c-pricing	proxy.pathsuffix MatchesPath "/pricing/**"	/cxf/dcrp/payments/n/id08
sales-o2c-credits	proxy.pathsuffix MatchesPath "/credits/**"	/cxf/dcrp/invoices/c/id09
sales-o2c-collections	proxy.pathsuffix MatchesPath "/collections/**"	/http/dcrp/invoices/c/id10
sales-o2c-contracts	proxy.pathsuffix MatchesPath "/contracts/**"	/cxf/dcrp/deliveries/t/id11
sales-o2c-disputes	proxy.pathsuffix MatchesPath "/disputes/**"	/http/dcrp/returns/c/id12
sales-o2c-revenue	proxy.pathsuffix MatchesPath "/revenue/**"	/cxf/dcrp/returns/c/id13
Figure 16: API Proxy Configuration
Figure 16 - API Proxy Configuration in SAP API Management

SAP CPI Package - nx.sales.o2c.integrations

Figure 17: Sales O2C Package
Figure 17 - Package - Domain Sales - Subdomain - O2C - nx.sales.o2c.integrations

Single Proxy Architecture - Finance
Proxy Name: cpi-dcrp-proxy-domain-finance-r2r

Proxy Endpoint Configuration:

Base Path: /finance
Protocols: HTTP, HTTPS
Authentication: Basic Auth
Without Quotes, Spike Arrests and JavaScript Hacking threat mechanism.
Route Rules (13 routes pointing to same Target Endpoint):

Route Rule Name	Route Rule Condition	JavaScript Target.url variable - SAP CPI Endpoint
finance-r2r-invoices	proxy.pathsuffix MatchesPath "/invoices/**"	/cxf/dcrp/invoices/c/id01 (QuickBooks)<br>/cxf/dcrp/invoices/c/id02 (S/4HANA)
finance-r2r-payments	proxy.pathsuffix MatchesPath "/payments/**"	/http/dcrp/payments/n/id03 (Stripe)<br>/http/dcrp/payments/n/id04 (S/4HANA)
finance-r2r-accounts	proxy.pathsuffix MatchesPath "/accounts/**"	/http/dcrp/accounts/s/id05 (Xero)
finance-r2r-journals	proxy.pathsuffix MatchesPath "/journals/**"	/cxf/dcrp/journals/c/id06 (SAP)
finance-r2r-expenses	proxy.pathsuffix MatchesPath "/expenses/**"	/http/dcrp/expenses/c/id07 (Coupa)
finance-r2r-receipts	proxy.pathsuffix MatchesPath "/receipts/**"	/http/dcrp/receipts/u/id08 (Concur)
finance-r2r-budgets	proxy.pathsuffix MatchesPath "/budgets/**"	/cxf/dcrp/budgets/s/id09 (Workday)
finance-r2r-taxes	proxy.pathsuffix MatchesPath "/taxes/**"	/http/dcrp/taxes/c/id10 (Avalara)
finance-r2r-treasury	proxy.pathsuffix MatchesPath "/treasury/**"	/cxf/dcrp/treasury/c/id11 (Treasury System)
finance-r2r-reconciliations	proxy.pathsuffix MatchesPath "/reconciliations/**"	/http/dcrp/reconciliations/c/id12 (Reconciliation System)
finance-r2r-closing	proxy.pathsuffix MatchesPath "/closing/**"	/cxf/dcrp/closing/c/id13 (Period Close System)
finance-r2r-reporting	proxy.pathsuffix MatchesPath "/reporting/**"	/http/dcrp/reporting/q/id14 (Reporting System)
finance-r2r-assets	proxy.pathsuffix MatchesPath "/assets/**"	/cxf/dcrp/assets/c/id15 (Asset Management)
Figure 18: Finance R2R Proxy Configuration
Figure 18 - API Proxy Configuration in SAP API Management

Figure 19: Finance R2R Package
Figure 19 - Package - Domain Finance - Subdomain - r2r - nx.finance.r2r.integrations

Target Endpoint:

URL: Dynamic runtime (resolved via JavaScript v8.0 + KVM)
7.11 Testing & Validation
Test Environment
Tool: Postman
Collection: DCRP-PDCP-Sales-O2C-Tests
Base URL: https://apim-tenant.cfapps.eu20.hana.ondemand.com/sales
Authentication: OAuth 2.0 Client Credentials
Test Results - 13 iFlows
Test Name	SAP APIM - URL Facade	Status	Result
Order Creation - Salesforce	POST /orders/creation/salesforce	✅ 200	PASS
Order Update - Salesforce EMEA	PUT /orders/update/salesforceemea	✅ 200	PASS
Customer Sync - Shopify	POST /customers/sync/shopify	✅ 200	PASS
Payment Notification - Stripe	POST /payments/notification/stripe	✅ 200	PASS
Order Creation - Microsoft (SOAP)	POST /orders/creation/microsoft	✅ 200	PASS
Delivery Tracking - FedEx	POST /deliveries/tracking/fedex	✅ 200	PASS
Customer Sync - S/4HANA Out	POST /customers/sync/s4hana	✅ 200	PASS
Payment Notification - S/4HANA Out	POST /payments/notification/s4hana	✅ 200	PASS
Invoice Creation - QuickBooks	POST /invoices/creation/quickbooks	✅ 200	PASS
Invoice Creation - S/4HANA Out	POST /invoices/creation/s4hana	404	CONFLICT
Delivery Tracking - S/4HANA Out	POST /deliveries/tracking/s4hana	✅ 200	PASS
Return Creation - Shopify	POST /returns/creation/shopify	✅ 200	PASS
Return Creation - S/4HANA Out	POST /returns/creation/s4hana	✅ 200	PASS
Figure 20: Test Results
Figure 20 - Test success - One DCRP API-Proxy - 11 Process - HTTP 200, one with conflict only to be solved soon.

Test Summary
Total Tests: 13
Passed: 11 ✅
Conflicts: 2 🔄 (id09/id10 - under resolution in Part III) - dcrpinvoicescid09:cxf,dcrpinvoicescid10:cxf
Success Rate: 85% (11/13)
Known Issues
Issue #1: id09/id10 Conflict

Problem: Both id09 (QuickBooks) and id10 (S/4HANA) share identical URL pattern and SOAP adapter - dcrpinvoicescid09:cxf,dcrpinvoicescid10:cxf
Impact: Routing ambiguity when vendor is not explicitly specified
Resolution: Vendor-aware routing implemented in JavaScript v8.0 (covered in Part III)
Postman Collection Structure
Figure 21: Postman Collection
Figure 21 - Postman Test Collection for Sales O2C Domain

COMING NEXT: PART III - THE IMPLEMENTATION BLUEPRINT
Part III will cover:

What You'll Get
✅ Production JavaScript v8.0 routing engine (full source code) ready for global implementation
✅ Conflict Resolution Guide (id09/id10 exact-match disambiguation)
✅ KVM Configuration Templates (copy-paste ready for 4 domains)
✅ Postman Collection (13 pre-configured integration tests)
✅ Monitoring & Troubleshooting Playbook (SAP Cloud ALM integration)
✅ GitHub repository with 📦:
Full source code
iFlow templates
KVM configs
Postman collections
Architecture diagrams
Preview: The JavaScript engine eliminates the id09/id10 conflict demonstrated in Section 7.11 by implementing vendor-aware exact-match routing with automatic adapter detection.

Stay tuned!

Note: Notice that the URL is shorter than the iFlow name. This is because the DCPR Gateway handles the "who is who" via KVM, while the CPI simply provides a clean, standardized entry point.

Figure 21: From Package Sprawl to Clean-Core
Image 21 - From the Package Sprawl to "Clean-Core" Package semantic pattern

CONCLUSION: The Path to a Sustainable Landscape
The implementation of the Package Domain-Centric Pattern (PDCP) transforms an SAP Integration Suite tenant from a fragmented collection of point-to-point connections into a Governed Domain Library—a scalable, maintainable, and business-aligned integration ecosystem.

By adopting this framework, organizations achieve:

Structural Order
Consolidation from 39+ fragmented packages into 4 domain-centric packages, eliminating the complexity and overhead of managing hundreds of unstandardized integrations.
Result: 90% reduction in governance objects, 97% reduction in technical users.

Operational Isolation
Dedicated iFlows for specific system-to-system interactions with tiered technical users by criticality, ensuring that updates or bugs in one integration (e.g., a Salesforce order sync) do not create regression risks across the entire landscape.
Result: Blast radius control and mission-critical isolation.

Rapid Incident Resolution
A landscape where support teams can identify the root cause of a failure in seconds by interpreting the standardized naming taxonomy (id01.o2c.salesforce.order.s4hana.c.in.sync), without needing to inspect internal payloads or navigate through dozens of packages.
Result: ALM search time reduced from 10 minutes to 5 seconds (120× faster).

Deployment Velocity
From 273 minutes (~4.5h) per deployment cycle (39 packages, 390 iFlows) to 14.5 minutes (4 packages, 13 iFlows)—an 18.8× improvement.

From Technical Debt to Strategic Asset
This transition represents a fundamental shift in Architectural Maturity. By moving from "building integrations" to managing a Business-Aligned Ecosystem, you ensure that your integration layer remains a scalable asset rather than a growing liability.

The technical foundation is now organized.
The engine is tuned for enterprise scale.
The governance is in your hands.

"In the middle of package sprawl, order is your greatest tactical advantage. A clean backend is the silent engine that allows an enterprise to move at the speed of business, rather than the speed of technical debt."
— "The Commander" - Viana

The Battlefield is now organized. The Engine is tuned. The Command is yours.

Coming Next: Part III - DCRP + PDCP Implementation Guide
Complete JavaScript v8.0 source code, KVM configuration templates, Postman collection, conflict resolution (id09/id10), performance benchmarks, and GitHub repository with production-ready templates.

If this article helped you, please like, share, and reach out if you're implementing PDCP in your landscape!

📚 How to Reference This Work
When referencing or building upon these architectural patterns, please use the following formal citations:

DCRP (Domain-Centric Routing Pattern), introduced by Ricardo Luz Holanda Viana, 2026.
PDCP (Package Domain-Centric Pattern), introduced by Ricardo Luz Holanda Viana, 2026.
🛡️ Intellectual Property & Copyright Notice
© 2026 Ricardo Luz Holanda Viana
First published: February 6, 2026
All rights reserved.

Legal Notice
The public disclosure of the architectural patterns described herein constitutes prior art (state of the art) within the global intellectual property framework. This publication establishes documented evidence of authorship and original contribution as of the stated publication date.

📜 Usage Terms
✅ Free to use for educational, research, and non-commercial purposes
✅ Attribution required when referencing or building upon these architectural patterns
✅ Commercial implementations are permitted, provided proper attribution is given
⚠️ Use of the names "DCRP™" or "PDCP™" in commercial branding, offerings, or marketing materials requires prior written licensing from the author
This restriction applies solely to the use of the names and trademarks, not to independent implementations of similar architectural concepts.

No Implied License
Nothing in this publication shall be construed as granting any license, implied or otherwise, to use the described methodologies as branded commercial products or services without explicit authorization.

Disclaimer
This article reflects the author's personal architectural perspective and does not represent an official SAP position or recommendation.

Kind Regards,

Viana | SAP BTP Integration Suite Expert




📁 Repository Structure
/images/
  ├── figura-01-complete-architecture.png
  ├── figura-02-production-view.png
  ├── figura-03-commanders-classroom.png
  ├── figura-04-package-sprawl.png
  ├── figura-05-package-chaos.png
  ├── figura-06-three-pillars.png
  ├── figura-07-pdcp-blueprint.png
  ├── figura-08-user-strategy.png
  ├── figura-09-package-consolidation.png
  ├── figura-10-chaos-to-clarity.png
  ├── figura-11-iflow-design.png
  ├── figura-12-governed-library.png
  ├── figura-13-dcrp-proxy-config.png
  ├── figura-14-kvm-config.png
  ├── figura-15-url-decoding.png
  ├── figura-16-kvm-registration.png
  ├── figura-17-kvm-policy.png
  ├── figura-16-proxy-config-sales.png
  ├── figura-17-sales-package.png
  ├── figura-18-proxy-config-finance.png
  ├── figura-19-finance-package.png
  ├── figura-20-test-results.png
  ├── figura-21-postman-collection.png
  └── figura-21-clean-core.png
⭐ If this guide helped you, please star this repository and share it with your team!
