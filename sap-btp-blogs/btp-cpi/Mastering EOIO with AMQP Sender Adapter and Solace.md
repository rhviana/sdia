
# Mastering EOIO with AMQP Sender Adapter and Solace

### By Ricardo Viana | Enterprise Integration Architect

---

## Introduction
In this technical deep dive, I share a specialized integration pattern to achieve **EOIO (Exactly Once In Order)** quality of service using the **AMQP Sender Adapter** in SAP CPI, orchestrated with **Solace**.

**The Challenge:** The standard SAP AMQP Sender adapter cannot natively control EOIO if an exception occurs during the iFlow runtime. To solve this, we leverage Solace’s queue management capabilities to pause and resume message consumption based on the iFlow's health status.

**Key Architectural Decisions:**
* **Strict Sequencing:** The business logic requires absolute message ordering; no sequence gaps are allowed.
* **Hybrid Runtime:** Due to security requirements (data must not leave the corporate network), I utilized a **Hybrid Concept** (developed in SAP CPI, deployed in **SAP PI Runtime**).
* **Automated Recovery:** A creative combination of Groovy scripts, Value Mappings, and Timer-led iFlows to release queues without manual intervention.

---

## 1. Integration Landscape & Diagram

<p align="center">
  <img src="YOUR_DIAGRAM_URL" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

### Process Overview:
1.  **Sender:** Triggers messages to the Solace Main Queue.
2.  **Solace Routing:** Routes payloads to 3 distinct queues in **Exclusive Listen Mode**.
3.  **SAP CPI (PI Runtime):** 3 separate iFlows listen via AMQP to maintain processing isolation.

---

## 2. The Core Mechanism: Exception Handling

The most crucial part of this implementation is the **Exception Subprocess**. It collaborates with Solace to **STOP** listeners immediately upon any runtime error.

### STOP Listener Mechanism (Exception Path)
When a failure occurs, the iFlow sends a `PATCH` request to the Solace API to disable the queue egress.

* **URL Encoding Trick:** To handle slashes in queue names (e.g., `Supersession/Chain/...`), you must use **Double URL Encoding** (`%252F`).
* **SAP PI Behavior:** In the PI Runtime, the address must be passed as a **Property** via Camel Expression to avoid internal translation errors.

**Stop Payload (JSON):**
```json
{
    "egressEnabled": false
}
```
3. Automated Recovery: The Timer iFlow
To maintain the flow without manual restarts, a Timer-triggered iFlow monitors the situation and releases the queues.

Dynamic Queue Selection (Groovy)
This script generates an XML structure to drive a splitter, allowing the iFlow to release multiple queues dynamically based on Receiver IDs.

```js
import com.sap.gateway.ip.core.customdev.util.Message;

def Message supersessionSystems(Message message) {
    def headers = message.getHeaders()
    def body = headers.get("SolaceAPIQueueRecSystem").toString()
    def inputArray = body.split(",")
    def xmlString = """
        <Supersession>
        ${inputArray.collect { input ->
            """
            <Detail>
                <ReceiverSystem>${input}</ReceiverSystem>
            </Detail>
            """
        }.join('\n')}
        </Supersession>
    """
    message.setBody(xmlString.toString())
    return message
}
```
START Payload (JSON):
```json
{
    "egressEnabled": true
}
```
4. Solace Configuration Strategy
To ensure only one worker node processes the data at a time, the Solace Queue must be configured as Exclusive.
  Parameter,Configuration
Access Type,Exclusive
Max Number of Retries,Empty (Managed by iFlow Logic)
Egress,Controlled via API (Enabled/Disabled)

O Gemini disse
Esta é uma contribuição técnica de altíssimo nível. Você resolveu uma das maiores limitações do adaptador AMQP padrão do SAP (a falta de suporte nativo a EOIO em cenários de exceção) utilizando uma arquitetura de "Circuit Breaker" ativa entre o SAP CPI (PI Runtime) e o Solace.

Abaixo, formatei o conteúdo para o GitHub (Markdown), organizando a estrutura técnica, destacando os blocos de código Groovy e garantindo que as imagens e spoilers fiquem bem apresentados.

Markdown
# Mastering EOIO with AMQP Sender Adapter and Solace

### By Ricardo Viana | Enterprise Integration Architect

---

## Introduction
In this technical deep dive, I share a specialized integration pattern to achieve **EOIO (Exactly Once In Order)** quality of service using the **AMQP Sender Adapter** in SAP CPI, orchestrated with **Solace**.

**The Challenge:** The standard SAP AMQP Sender adapter cannot natively control EOIO if an exception occurs during the iFlow runtime. To solve this, we leverage Solace’s queue management capabilities to pause and resume message consumption based on the iFlow's health status.

**Key Architectural Decisions:**
* **Strict Sequencing:** The business logic requires absolute message ordering; no sequence gaps are allowed.
* **Hybrid Runtime:** Due to security requirements (data must not leave the corporate network), I utilized a **Hybrid Concept** (developed in SAP CPI, deployed in **SAP PI Runtime**).
* **Automated Recovery:** A creative combination of Groovy scripts, Value Mappings, and Timer-led iFlows to release queues without manual intervention.

---

## 1. Integration Landscape & Diagram

<p align="center">
  <img src="YOUR_DIAGRAM_URL" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

### Process Overview:
1.  **Sender:** Triggers messages to the Solace Main Queue.
2.  **Solace Routing:** Routes payloads to 3 distinct queues in **Exclusive Listen Mode**.
3.  **SAP CPI (PI Runtime):** 3 separate iFlows listen via AMQP to maintain processing isolation.

---

## 2. The Core Mechanism: Exception Handling

The most crucial part of this implementation is the **Exception Subprocess**. It collaborates with Solace to **STOP** listeners immediately upon any runtime error.

### STOP Listener Mechanism (Exception Path)
When a failure occurs, the iFlow sends a `PATCH` request to the Solace API to disable the queue egress.

* **URL Encoding Trick:** To handle slashes in queue names (e.g., `Supersession/Chain/...`), you must use **Double URL Encoding** (`%252F`).
* **SAP PI Behavior:** In the PI Runtime, the address must be passed as a **Property** via Camel Expression to avoid internal translation errors.

**Stop Payload (JSON):**
```json
{
    "egressEnabled": false
}
3. Automated Recovery: The Timer iFlow
To maintain the flow without manual restarts, a Timer-triggered iFlow monitors the situation and releases the queues.

Dynamic Queue Selection (Groovy)
This script generates an XML structure to drive a splitter, allowing the iFlow to release multiple queues dynamically based on Receiver IDs.

Groovy
import com.sap.gateway.ip.core.customdev.util.Message;

def Message supersessionSystems(Message message) {
    def headers = message.getHeaders()
    def body = headers.get("SolaceAPIQueueRecSystem").toString()
    def inputArray = body.split(",")
    def xmlString = """
        <Supersession>
        ${inputArray.collect { input ->
            """
            <Detail>
                <ReceiverSystem>${input}</ReceiverSystem>
            </Detail>
            """
        }.join('\n')}
        </Supersession>
    """
    message.setBody(xmlString.toString())
    return message
}
START Payload (JSON):

JSON
{
    "egressEnabled": true
}
4. Solace Configuration Strategy
To ensure only one worker node processes the data at a time, the Solace Queue must be configured as Exclusive.

Parameter	Configuration
Access Type	Exclusive
Max Number of Retries	Empty (Managed by iFlow Logic)
Egress	Controlled via API (Enabled/Disabled)

<p align="center">
<img src="" alt="Solace Setup" width="600" />
</p>

5. Test Results & Validation
Scenario: Exception Triggered
Postman: Simulates the Sender system.

Failure: iFlow produces an exception.

Result: Solace Queue Egress is immediately disabled. EOIO is preserved because the next message in line stays in the queue until the block is lifted.

Scenario: Recovery
Timer iFlow: Executes and calls the Solace API.

Result: Egress is re-enabled (egressEnabled: true).

Processing: The previously blocked message is consumed and processed successfully.

Conclusion
This pattern proves that EOIO is possible with the AMQP Adapter when you treat the message broker (Solace) as an active participant in the integration logic, rather than just a passive queue.

Technical Takeaway: Don't rely on the adapter alone for complex QoS. Use the Broker's Management API to control the state of the integration.

Kind regards,

Viana
SAP BTP Integration Suite Expert
