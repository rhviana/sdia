
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
  <img src="https://github.com/user-attachments/assets/8e27e2e2-af06-486d-9d3d-938ddf45012b" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

### Process Overview:
1.  **Sender:** Triggers messages to the Solace Main Queue.
2.  **Solace Routing:** Routes payloads to 3 distinct queues in **Exclusive Listen Mode**.
3.  **SAP CPI (PI Runtime):** 3 separate iFlows listen via AMQP to maintain processing isolation.

CPI IFLOW:
I will provide one sample of Iflow development, 2 receivers basically is the same and one the requirement was to send the payload as attachment in the message base64 string, so there is some differences and cross the whole development is not the focus in the blog.
<p align="center">
  <img src="https://github.com/user-attachments/assets/4e27db55-f3d5-4da3-80aa-6e31ab1df41f" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

The most and crucial part of this iflow is the exception, responsible to collaborate together with SOLACE to STOP the listeners immediately in case of any exception or error during the runtime process message and this part is what we are going to explore together with some details and imagens:

Exception mechanism to STOP Solace of listeners:
<p align="center">
  <img src="https://github.com/user-attachments/assets/bbbe4375-128b-48a0-91d0-5897f1c3af05" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

The Timer Iflow response to START Solace to listener:
This iflow I'm going to describe more in details in the end.

<p align="center">
  <img src="https://github.com/user-attachments/assets/a23df1a4-1532-48d0-b3e0-7ef32bd21595" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

Solace one queue sample setup:
Queue name: Supersession/Chain/Replacement/PIM

Incoming Colom: Payload from Source system

Outgoing Colom: SAP CPI respective Iflow based on the listen queue via AMQP adapter

<p align="center">
  <img src="https://github.com/user-attachments/assets/39a36c28-2ae3-44c3-ac81-82de25c64747" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

The health status of this queue, without off course any payload yet, is ok, ready to receive and send payloads:

<p align="center">
  <img src="https://github.com/user-attachments/assets/421e4fc3-a9dd-486d-af33-ea3efff69700" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

As you can see Exclusive is selected - Configure the Queue in solace as "exclusive".

This will ensure that regardless of how many workernodes you have in CPI only one workernode will receive the data. This ensures that the sequence of the message is maintained.

The information's how to make all setup: [SOLACE PORTAL](https://tutorials.solace.dev/rest-messaging/publish-subscribe/)

Make sure the SENDER AMQP adapter should not have Max. Number of Retries - EMPTY

<p align="center">
  <img src="https://github.com/user-attachments/assets/1a4f1c6a-675e-4062-b744-79a7ff9fbf89" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

The Solace expected payloads:
In case of exception the expected payload to STOP the queue immediately is:

**Stop Payload (JSON):**

```json
{
    "egressEnabled": false
}
```

**Start Payload (JSON):**

```json
{
    "egressEnabled": true
}
```
---
Those details you can see in the [Solace Development Configuration Portal portal](https://docs.solace.com/Messaging/Guaranteed-Msg/Queues.htm)

Solace STOP listeners mechanism

HTTPS URL Solace - Method PATCH:

You should add exactly this format of URL HTTP's with special chars different then that the adapter in the call will convert proper and Solace will accept the call, if you add just the "/" it's going to fail ALWAYS

Need to use a DOUBLE URL Encoding mechanism, where the HTTPS Standard CPI ADAPTER is responsible to translate the respective value %252F to "/" - Slash:

Sample of URL:
https://<solaceDetailsofYourInstance>/queues/Supersession%252FChain%252FReplacement%252FPIM

Strange SAP PI runtime behavior:

If you add directly in the HTTPS receiver adapter the address above, also will fail internally during the process in SAP PI, I really could not understand deeply the reason, to solve this you should add as property and read via camel expression as the sample below:

Content modifier generating the property and body to stop, remind, this is inside the exception, I didn't talk yet about the SAP CPI Timer Iflow.

<p align="center">
  <img src="https://github.com/user-attachments/assets/f6ecec7b-b0c3-43bf-a101-8e8c200648f9" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

Address via external parameter of the property from previous content modifier:

<p align="center">
  <img src="https://github.com/user-attachments/assets/1502510e-fe30-4829-8c43-2318a38c568e" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

Body:
```json
{
    "egressEnabled": false
}
```
Solace START listeners mechanism:
In this point we are going to cross the logic behind Value Mapping and Timer Iflow:

<p align="center">
  <img src="https://github.com/user-attachments/assets/fae34d8b-85b8-4ebd-8b9a-aed8c6cc79eb" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

As you can see there is a header with only the ID's of Receiver systems as SolaceAPIQueueRecSystem, after that I generate a simple payload XML via groovy:
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
Result after the groovy:
```xml
<Supersession>
  <Detail>
    <ReceiverSystem>KP1</ReceiverSystem>
  </Detail>
  <Detail>
    <ReceiverSystem>P2A</ReceiverSystem>
  </Detail>
  <Detail>
    <ReceiverSystem>PIM</ReceiverSystem>
  </Detail>  
</Supersession>
```
After that Splitter is generating 3 calls for those listen system, in this case 3, if you have more than more calls, the XPATH reference for Splitter: //Detail - Break in 3 different messages per <DETAIL>.

In the end of Iflow a groovy to read such details per DETAIL receiver system ID from the value mapping, generating the property of HTTPS, as I explain above because of the Double Encoding Process HTTPS call.

<p align="center">
  <img src="https://github.com/user-attachments/assets/2057caba-c455-465f-b34d-bce0ee77f123" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

START Payload (JSON):
```json
{
    "egressEnabled": true
}
```
Ok, now let's go for simple test.

Test Phase:
After the full explanation deploy the object in SAP PI runtime:

<p align="center">
  <img src="https://github.com/user-attachments/assets/da94088c-a98a-4b19-b04c-eacbf21bf2b7" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

Now via postman I'm sending the payload simulating the SENDER SYSTEM:
<p align="center">
  <img src="https://github.com/user-attachments/assets/cf519c84-175d-4138-9c7c-d0954e0ec934" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

Configuration of Subscriptions for the queue ( Supersession/Chain/Replacement/PIM ) - SOLACE:
<p align="center">
  <img src="https://github.com/user-attachments/assets/a2d589e0-95c7-4844-b3b5-a696273f5fc9" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

What is means ? 

What ever message comes to - /Supersession/Chain/Replacement/XT0, replicate the payload in respective queue.

So let's see if there is something in the queue - 1 Payload:
<p align="center">
  <img src="https://github.com/user-attachments/assets/b3bc14af-220c-49a4-aaa9-eee526ddedab" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

But before send the data I replace some information in the object in SAP PI runtime to produce exception and looks the queue status:

Trace of SAP PI:
<p align="center">
  <img src="https://github.com/user-attachments/assets/15f7d4ab-a1a5-44c2-b826-1e3663757cd5" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

Block the queue to be listen and keep the EOIO (Exactly Once In Order).

<p align="center">
  <img src="https://github.com/user-attachments/assets/7b16fb7c-5cdd-473d-bfdb-60f4c1fc8eda" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

The result of logs from TIMER IFLOW:
So now the stage of the outgoing - Listener's of this queue in solace is STOP.

Let's see more less the illustrations below

 Iflow deployed in SAP PI runtime
Started with Success
After listen the queue in solace
Failed, the queue is blocked to maintained the EOIO

<p align="center">
  <img src="https://github.com/user-attachments/assets/6cfe8f8b-f42b-4716-90ed-64cefaccdf01" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

Now I'm going to deploy the TIMER IFlow to release the queue and read the payload:

<p align="center">
  <img src="https://github.com/user-attachments/assets/787684e5-c92b-4aff-b496-e998fec77ea7" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

The previously payload NUMER 1 on the queue was reader with success and processed internally.

<p align="center">
  <img src="https://github.com/user-attachments/assets/05189d27-e997-4f1b-a628-51f82a1d4452" alt="Integration Diagram" width="700" />
  <br>
  <i>Figure 1: High-level architectural flow between Solace, SAP PI Runtime, and Receivers.</i>
</p>

I hope with this blog you understand that YES, it is possible to EOIO (Exactly Once In Order) with AMQP Adapter, exclusively collaborating with Solace Message Broker or another one from the Market, the ADAPTER it self is not able to do that.

Kind regards,

### By Ricardo Viana | SAP BTP Integration Suite Expert Developer
