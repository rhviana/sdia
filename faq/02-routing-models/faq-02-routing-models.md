My apologies! Let’s get that back into English and optimized for a GitHub README or Wiki (Markdown).FAQ – Routing Models: Traditional vs GDCR/DCRPThis section compares common routing models with the GDCR/DCRP (Domain-Centric Routing Pattern) approach on SAP API Management.Q1 – What is the "traditional" routing model?The traditional pattern is system-oriented. It creates a rigid, 1:1 relationship between the API Proxy and the technical backend.Typical Characteristics:One Proxy per Backend: Every unique interface or application requires a new proxy.System-Encoded URLs: Paths explicitly mention the system (e.g., /sap/fi/invoices, /salesforce/opportunities).Static Routing: The mapping from proxy to endpoint is fixed in the Target Endpoint configuration.Technical Flow (ASCII):PlaintextClient
  |
  +--> [Proxy: Salesforce_Orders]  -> SAP CPI iFlow A -> Salesforce
  |
  +--> [Proxy: SAP_FI_Invoices]   -> SAP CPI iFlow B -> SAP S/4HANA
  |
  +--> [Proxy: Workday_Employees] -> SAP CPI iFlow C -> Workday
Result:Proxy Sprawl: Dozens (or hundreds) of proxies and packages to manage.High Friction: Adding a new vendor requires developing and deploying a new proxy.Rigid Architecture: Logic is tied to specific systems rather than business domains.Q2 – How does DCRP routing differ?DCRP introduces Domain Façades and Semantic Routing. It abstracts the backend complexity away from the consumer.Key Concepts:Domain Façades: One stable entry point per business area (e.g., /sales/*, /finance/*).Semantic Pattern: URLs follow a logical structure: /domain/entity/action[/variant].Metadata-Driven: Routing is handled via Key Value Maps (KVM) instead of hardcoded paths.Technical Flow (ASCII):PlaintextClient 
  |  
  |   POST /sales/orders/create/salesforce
  v
+------------------------------------+
|       SAP APIM: Sales Facade       |
|       Path: /sales/** |
+------------------------------------+
  |
  |  Logic:
  |  parse: domain  = sales
  |         entity  = orders
  |         action  = create
  |         variant = salesforce
  |
  |  Lookup KVM: 
  |  Key:   sales_orders_create_sf
  |  Value: http://cpi/http/dcrp/orders
  v
+------------------------------------+
|    SAP CPI: /http/dcrp/...         |
+------------------------------------+
  |
  v
[ Backend: Salesforce ]
Key Differences:FeatureTraditional ModelDCRP / GDCR ModelFocusSystem-orientedDomain-orientedRoutingStatic (Hardcoded)Dynamic (KVM-based)ScalabilityNew proxies for every interfaceNew KVM entries onlyMaintenanceHigh (Requires redeployment)Low (Runtime configuration)URL StabilityChanges with backend systemsRemains stable for the client
