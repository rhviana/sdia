Introduction
In this blog, I will dive deeper into the integration layer within the SAP Business Technology Platform (BTP). We are going to focus on service scenarios in BTP Integraton Suite that also reach out to external carbon-based solutions, for example MuleSoft, Bomi, SnapLogic and Solace but also SAP BTP API Management, Advanced Event Mesh and SAP Integration Advisor

This is a sort of "is what I have leaned over the years" type of discussion, as opposed to having been produced just for the purposes of microscope slide making (or framework development).

In this blog series, I want to make some experiences available as developer since SAP XI/PI/PO/CPI longterm. Here are three I need to play with that should do the trick for the community devs to get their heads around:

Also, as an SAP BTP Integration Suite Consultant, I encourage you to dream big and express what you think. Once you have this deep understanding of what is possible with the SAP BTP Integration Suite, not only SAP CPI, you’ll be able to stand as equal with architects in a conversation and shape what that effective environment should look like.

Let have this thrilling journey together.

How I saw some Frankenstein architectures being born: three real cases
In my long career, I have seen plenty of tools that offered to alleviate such complexity only to introduce complexity where none was warranted. One thing to keep in mind is that every tool or company, such as SAP, but also any other vendor has their pros and cons. But the benefits of normalizing these architectures are hard to ignore: less customization, better support, and more cohesive teams.

Case 1: Wasted Potential
When I started performing in this one “As sort of a fresh consultant with SAP BTP Integration Suite” working essentially as SAP PI/PO/CPI Consultant and my role was to glue the pieces i.e. boxes and mappings back again. I did not have the experience or courage to communicate my views back then, I believe that also led to suboptimal results. However, this was also a learning experience for the future.

The project was well-structured with explicit rules, standards, APIs and development models. Yet the external architects at the beginning of a migration to S/4HANA hadn’t considered implementations that already existed. … Even if SAP BTP (SAP Integration Suite – APIM and CPI) was there, they threw away this investment and capability on leveraging more strategic decisions and using the minimum as possible.

Consequently, no usage of the APIM was allowed at all and SAP CPI could only be classified as vanilla-prepackaged with as few adjustements. A second vendor took over the entire APIM infrastructure and bespoke integrations. The result was the undercutting of what had been a winning game plan.

Case 2: Application of External Architecture Patterns
In that case I was similarly unable to remember granular details about APIM and Events Management. The Iflow were my concern and here I spotted a considerable design issue, lets call it flaw: that the payload being kept in datastore is nothing more than an output of a mapping logic making it futile.

This was a “three layer design – Intelligence Layer, Processing/Routing Layer and the Delivery Layer” that was enforced on top of SAP CPI, which came from an entirely different area all together. To preserve this false structure, the solution became rather complex chain of hundreds JMS queues.

Case 3: Scattered teams and technologies
I am not going to discuss in depth about APIM and Events with other vendors. One organization did adopt BTP in piecemeal via Events/API but SAP CPI were the only service that came together and was used appropriately. Duties were separated into teams that didn't talk to each other. In the end, this lack of coordination resulted in higher costs and complexity – which is breaking the very synergy SAP BTP Integration Suite was designed for: SAP Integration Suite.

The Emergence Of “Frankenstein” Architectures And Why Decoupled Integration Does Not Succeed
Organizations have the tendency to spend millions in SAP BTP without fully leveraging its strategic capabilities. But what we end up with is "Frankenstein Architectures" – a collection of parts cut and sewn into a jumble of ill-formed systems. The linked parts may be powerful, but the ecosystem is inherently weak.

These are hardly ever genuine technical constraints. Rather, they emerge from:

Architectural Bigotry: Choices created by management who don’t really understanding the SAP integration terrain.
Lack of Trend Following: Excessive focus on the latest buzzwords, without considering the merits of having a complete ecosystem.
Siloed communication: A gap between high-level architects and the developers working with SAP Integration Suite.
With SAP at the core of your backend, be it ECC or S/4HANA then BTP is something else altogether on a different level, and I mean because that’s where its roots are from. Despite the necessity of third-party integrations, there comes a point when the trade-off between “market-trending” external tools and native connectors actually incurs a technical debt that negates the end customer’s requirement for stability. Different systems can live together side by side, but nothing comes close to the level of integration offered in SAP world with SAP Integration Suite.

rhviana_0-1767600837094.png
Figure 1: Frankenstein Architecture

The Trap of the “Legacy Mindset”: The Real Barrier to True Innovation
Although we can critique tools, vendors and platforms till the cows come home, on some level our constraints are not technological at all. The greatest hindrance to a successful innovation experience is habit, accumulated over years of dependence on legacy systems. Such statements as “we won’t touch it, it’s working,” “the developer already is not with a project” and “there are no any docs” belong to the type that depends on stable but inflexible architecture. This leads to known experiences that do not evolve, led by a strong fear of the new.

There are many that still operate under the paradigm of on-premise integration landscapes from a decade ago. This oldskool attitude results in a frustration tainted with fear of the new, or unfamiliar paradigms and perhaps more often than not, a mis-appreciation of what today's platforms are capable of.

A real innovation requires to think differently. The question should not be “How do I generate this map?” a closer look: “Is this a map? Should it be an event? An API? Or whether it should exist at all in its current version?”

Without such a crucial change, old habits can die hard for companies looking more innocently to roll the past forward without realizing it is in danger of imposing historical limitations on new opportunities and tools. Thus, the result is not genuine modernization.

The Voice of the SAP Integration Suite Consultant: You’re the Strategic Bridge
A highly experience Integration Consultant—either in a senior role or that of an expert one—needs to have full knowledge of the SAP Business Technology Platform (BTP) integration suite Event Mesh (EM), Enterprise Assessment Management (EAM), API Management (APIM), Integration Assessment (IA) and Cloud Integration (CPI). But such technical proficiency is only the beginning. If you want to add value, then we need to do more than just drive “tickets” or be used as a “delivery“ service, not only SAP CPI developer.

What you think about SAP BTP Integration Suite Consultant ?

Apart from SAP PO: Migration to SAP CPI or Migrating the Legacy (Snap Logic, Boomi, MuleSoft, Informatica, Microsoft etc.)
With middleware, many companies find themselves managing a hodgepodge of technologies. The 1,000 interfaces that need to be migrated from the likes of Snap Logic, MuleSoft, Informatica, Dell Boomi or webMethods to SAP BTP – SAP Integration Suite is not simply a question of technical mapping; it’s actually a functional exercise.

Think of migration from SAP PI/PO to CPI. How many of you've seen flows with mapping layers having tons of UDF's, field-field mappings assigning to lots of standard functions (remove context, collapse context & rely on it), Conditional operators and Java mapping (as well) or Adapter module performing entirely different job.

When dealing with such intricate mappings and modules, typically when you run the SAP Migration Assessment your migration status may be "non-migratable." Another point of consideration is that even if a  integration consultant has the skills to migrate these interfaces, do you really want them reverse engineering extracting prodcution payloads and manually testing for so long just to validate the results?

Furthermore, where is the documentation? Is the developer of this interface already gone?

Instead of looking at migration exclusively, it perhaps makes more sense to look rebuilding and examining the interfaces using native capabilities within SAP Integration Suite. Some of them could be transformed to events, others may become simple APIs.

If the move from SAP PI/PO to SAP CPI is daunting, it’s even trickier when you have third-party interfaces in the mix. The details of such migrations can certainly complicate matters.

rhviana_1-1767872347932.png
 Figure 2: SAP Integration Consultants

Dismantling the Frankenstein Architecture in case of Multiples Platforms
The Int4 Suite (previously known as Int4 IFTT/Shield) is a test automation and service virtualization tool designed specifically for SAP ecosystems. It acts as an “accelerator” to dismantle the Frankenstein architecture and simplify complex migrations.

rhviana_0-1767876653433.png
Image 3 – Dismantling the Frankenstein Architecture

Functional regression is the biggest challenge when changing from SAP PI/PO to BTP. Testing convoluted, undocumented legacy mappings may appear to be testing hell—but it need not be.

Virtualization: Test Without Limits
Int4 Shield "feels" the behaviour of external systems from within APIM itself. And since this is possible, you guessed it also can we make against SAP BTP E2E full flows, even if the backend does not yet exist.
No More Reverse Engineering
Quit spending weekends trying to decode obsolescent Java mappings, User Defined Functions (UDFs) with no documentation. Instead of building these factors by hand, Int4 Shield uses the Comparison Approach:
Automated Extraction : Securely captures real production messages to make a "test case repository."
Parallel Execution: The old PI/PO mapping and the new BTP mapping are executed in parallel by this tool.
Automatic comparison: for a penny or to the last character – Int4 shield checks each single difference and shows where logic diverges.
Massive Resource Savings
The demand of manual testing is also greatly decreased by comparing with the real-world data as ground truth.
Reduce manual testing efforts up to 80%.
Test hundreds of scenarios in minutes, not weeks.
Remove paperwork barriers: If the output matches, the logic works.
Take apart the Frankenstein SAP PI/PO mappings and others
The tool Figaf has these integration challenges in mind. The Figaf DevOps Suite, especially the Migration Edition, is built for the integration layer and has become the favored option when it comes to moving off SAP PI/PO and into the SAP Integration Suite (BTP).

It is not a "generic" migration tool for all non-SAP external systems, like legacy databases and non-SAP ERP systems), but it supp (where integration flows connect those external systems with the SAP world).

rhviana_0-1767860556941.png
Image 4 - Figaf migration SAP PI/PO

Figaf: Focus and Capabilities
Figaf is a key component to DevOps and migration projects beyond the simple movement of code, as legacy logic is transformed into the modern Business Technology Platform (BTP) environment.

Automatic Migration: The system automatically migrates PI/PO ICOs to iFlows, making the migration easy and allowing you to execute the migration flexibly with respect to architecture.
Translation to Predicate Logic: Figaf skillfully converts complex Java and Mapping User-Defined Functions (UDFs) into Groovy scripts that adhere to BTP guidelines, so that legacy system functionalities are maintained in the transition to novel environments.
Lifecycle Management: The set of tools consists of transport management, Git versioning and automatic documentation that covers the missing parts in the standard SAP BTP service.
Focus:: Figaf is designed for SAP PI/PO, the SAP Integration Suite (CPI) and API Management which provides a clear focus on integration problems.
RISE with SAP and Clean Core: Integration Must Not Be Forgotten
RISE with SAP is about more than transitioning to S/4HANA; it’s a fantastic time to eliminate historical sources of waste.

The Classic Clean Core approach as it has been seen until now, for the most part only attacking the backend and identifying archived code that uses older ABAP "Z" code combined with customer modifications. This is necessary, but only a part of the meta-morphosis. Refining the backend result without the integration layer is a partial transformation.

Why "Clean Integration" Matters:
Integration Suite as a Filter: SAP BTP – which includes API Management, Event Mesh, Integration Advisor and Cloud Integration - is designed to keep your core stable. This suite helps put the ugliness in its place - far away from your backend.

Not Embracing the “Frankenstein” Anti-Pattern : Depending on miscellaneous external tools to enrich the inbuilt capability violates the ethos of a Clean Core. These are the sorts of practices that drive "borrowed architectures" which gradually acquire technical debt over time.

How to Future-Proof Your Systems: A standard core demands a standard connection. If you don’t Integrate Clean, you’re likely just putting off big problems for another day.

Bottom Line: A Clean Core and a Messy Integration Layer cannot both exist. That’s crucial no matter how you currently are reevaluating 20 to 30 years of ECC custom code; it is just as necessary for the manner through which your systems will get linked.


Image 5 – Rise and Clean core backend plus Integration refactoring

Conclusion
The intention of this post was to start a conversation between integration developers such as me. Note – this is not a discussion around the various other systems that help you run-the-business. Rather, my interest lies purely with the type of features that SAP BTP Integration Suite has relative to other industry-leading platforms in a similar space.

I wanted to take a deeper look, with closer readers at trade-offs from within the space of API Management (APIM), Event Management (EM), Application Event Management (AEM), SAP Integration Advisor ( IA ) and Cloud Platform Integration (CPI).

This study is conducted to expand our knowledge and understanding of how overlapping functionalities should be addressed in a modern, homogeneous integration architecture.

In the end the decision is from the Integration Architecture responsable, because he must make all the checks between the plataforms and see what can be done with SAP BTP Integration Suite against others plataforms overlapping the services where you can focous in the homogeneos landscape with SAP BTP IS.

Thank you.

Kind regards,

Viana.
