# Hello Folks,

The integration seems to be simple: **SFTP --> ASYNC --> SAP CPI --> SYNC --> SAP BRM --> SAP CPI --> ASYNC --> SFTP**. It looks straightforward when interpreted like that, but let’s go together into this "spider web" complex integration.

Basically, the SAP CPI is responsible for reading a JSON payload from an SFTP folder. This payload contains multiple records of data without a pretty-printer format.

After reading the payload, SAP CPI splits the records per line and breaks them into multiple parts. It generates the respective SAP BRM JSON format for each service to perform business rules management table translations. Finally, it collects all results, merging the SAP BRM responses with the original input payload into a huge multi-mapping XML file. A 200-line Groovy script performs the final transformation from XML to JSON, producing the output expected by the receiver system in another SFTP folder.

### The Integration Diagram Perspective:
<p align="center">
  <img src="https://github.com/user-attachments/assets/6065e67a-3dbb-4730-a45a-96af6a54e34c" alt="Integration Diagram" />
</p>
---

## What is SAP BTP BRM?
**SAP Business Rules Management (SAP BRM)** enables organizations to automate decisions by using business rules. Business users participate in and control rule definition, while business process experts model, validate, deploy, update, and archive business rules through their lifecycle. As such, IT organizations can work with business users to manage business rules that drive process flow and execution.

<img width="400" height="205" alt="image" src="https://github.com/user-attachments/assets/287a5318-1dec-494b-a14e-a53ba9db8cec" />

### SAP CPI Value Mapping vs SAP BRM:
The details between those two mechanisms of data translation:

**SAP BRM:**
* **Control:** Business Rules Consultants.
* **Role:** Business specialist.
* **Dynamically Changeable:** Yes, anytime by the Business Rules Consultant without interaction with the SAP CPI developer.
* **Context:** Business rules and tables change dynamically based on business needs.

**SAP CPI Value Mapping:**
* **Control:** The CPI Developer consultant.
* **Role:** Technical.
* **Dynamically Changeable:** No, it is static based on parameters inserted by the Developer. Changes require technical interaction.

---

## Development Details
In this part, I will explore the development while suppressing sensitive information to avoid any exposure. The samples of payloads and other data are dummy data.

### The iFlow Integration Perspective:
<p align="center">
  <img src="https://github.com/user-attachments/assets/65a243a1-34ae-4d5e-a12f-7d71a1d4be0f" alt="iFlow Perspective" />
</p>

### Step-by-Step Execution:

#### First Step:
Convert JSON to XML and use the **SPLITTER** function for each line record. I developed a Groovy script for this conversion because the standard "JSON to XML Converter" was not working properly due to the lack of a clear pattern in the root elements of the input JSON.

<p align="center">
  <img src="https://github.com/user-attachments/assets/b195ac2b-8a8b-4a0a-8e69-80685147646a" alt="Local Process and Multicast" />
</p>

#### Second Step:
After the Splitter, the iFlow sends the message to a local process where a **Content-Modifier** saves the original payload and a **Parallel Multicast** triggers services to SAP BRM alongside local transformations.

<img width="491" height="562" alt="image" src="https://github.com/user-attachments/assets/59c514c6-31b6-44c5-89a4-4ca01e368dd2" />


**SAP BRM - Expected Payload:**

I developed a Groovy script with 375 lines to generate the expected payload for 7 different services.

```json
{
    "RuleServiceId": "ID_UNIQUE_CODE_FROM_SERVICE_SAP_BRM",
    "Vocabulary": [
        {
            "Service_One": {
                "Dummy_Service_One": "Value_from_XML_position"
            }
        }
    ]
}
```
SAP BTP BRM Response Sample:
```json
{
    "Result": [
        {
            "Service_One": [
                {
                    "Result_1": "value",
                    "Result_2": "value",
                    "Result_3": "value"
                }
            ]
        }
    ]
}
```
Sample for Language Translation:

<img width="999" height="429" alt="image" src="https://github.com/user-attachments/assets/03393a03-4835-4fc9-a11f-ab49e6a12a26" />

Problem:During the test I phase this problem.
<img width="803" height="407" alt="image" src="https://github.com/user-attachments/assets/7994bc5d-3a15-42d2-8787-ade6d876ffba" />
As you can see in the picture, there is a PARALLEL Multicast splitting the XML structures and the groovy generating the XML SAP BRM Payload per service, 
I developed one groovy with multiple functions by name, but when I used the Read ( inputstream ) over the same groovy with multiple functions called at same time.

SAP CPI pop up error, I read the payloads as String, it was the fasts solution to achive the target delived date also I didn’t want develop one groovy per each SAP BRM definition, 
not practical in my point of vew.

Solving Technical Problems:

During the test phase, I encountered a groovy.lang.GroovyRuntimeException: Ambiguous method overloading. This happened because multiple functions were calling XmlSlurper#parse simultaneously over the same input stream.

To solve this within the project timeline, I decided to read the body as a String. This prevented variable overloading during runtime and allowed the functions to process the small, split payloads efficiently without breaking the logic into 8 different scripts.

Third Step:
After collecting the JSON responses from SAP BRM, I applied a JSON to XML Converter. I used a Groovy script to suppress the XML header (<?xml version="1.0" ... ?>) to avoid formatting errors during the Gather mechanism.
<img width="485" height="558" alt="image" src="https://github.com/user-attachments/assets/62534c62-c4e5-4932-96db-96cef76c7f6c" />

Fourth & Fifth Steps:
I used the JOIN function to combine all results and a Gather to merge responses from SAP BRM with local transformations.

Sixth Step:
A Content-Modifier generates the full result from the gather, combined with the original incoming message.
<img width="999" height="326" alt="image" src="https://github.com/user-attachments/assets/7067552a-95df-4386-9f30-2d3245b9805b" />

Seventh step of development:
Another gather after the result from the local process responsible to consume SAP BRM plus local transformation generate a full Multimapping XML with all content and records reader from SFTP per file.
<img width="711" height="497" alt="image" src="https://github.com/user-attachments/assets/7a2c4c1b-992f-4702-b22e-a99e71f0ae92" />

Eighth step of development:
The complex groovy to read all different contexts from the result from SAP BRM plus the input payload per line into the file, controlling indexes and others, basically around 200 lines to produce the output file, in this case off course, I'm reading the body as inputstream to don't overload the memory in SAP CPI node.

Test phase:
In this part I'm going to present some short cuts of payload, iflow prespective and result

Input payload sample ( Off course detailed information is surpress this is just sample ), not imagine a input payload with 2000 thousand of files with those details below and each of this lines it's different logic, service SAP BRM call, rules, complex business transformations.

Sample of file with one record:
```json
{
    "id": 587,
    "baseId": null,
    "versionNumber": 1,
    "versionHistoryId": 187,
    "releaseDate": "2022-05-16T13:00:04.663801+02:00",
    "lastUpdate": "2024-01-03T19:04:02.014922+01:00",
    "metadata": {
        "2": "",
        "5": "",
        "6": {
            "id": 289
        },
        "8": "",
        "9": "2022-06-21T22:00:00Z",
        "10": {
            "id": 4
        },
        "11": {
            "ids": [
                421
            ]
        },
        "13": {
            "ids": [
                465,
                466,
                475,
                484,
                485,
                486
            ]
        },
        "19": "",
        "24": "",
        "25": ""
    },
    "topicIds": [
        69,
        110
    ],
    "attachmentFileNames": [
        "587_English_Original_Full Version_3669_UN-R_14-09_S2_EN_2022-05-12.pdf"
    ]
}
```
Input payload folder file:
<img width="399" height="88" alt="image" src="https://github.com/user-attachments/assets/c01d0c64-cbfd-4f67-ba2f-566b2f1ae356" />

Processing the message in SAP CPI:
<img width="887" height="592" alt="image" src="https://github.com/user-attachments/assets/59179b2d-1317-4f08-b391-a1706472b4eb" />

Output folder result transformation:
<img width="448" height="38" alt="image" src="https://github.com/user-attachments/assets/6e4812d5-9360-4a4a-a38d-cd99b7ceef68" />

Result content:
The content for each line from input payload generates and regulations structure for each, in the sample presented is only the first one:
<img width="400" height="241" alt="image" src="https://github.com/user-attachments/assets/2ab2e68a-00a9-4013-8dbf-a68218be79cf" />
Conclusion:

The intention of this blog is present the integration between SAP CPI and SAP BRM, translation, this is a purely business decision, because of that I didn't explore the chance to use SAP CPI Value Mapping.

I really hope that you enjoy.

Kind regards,

SAP Integration Expert - Viana.



