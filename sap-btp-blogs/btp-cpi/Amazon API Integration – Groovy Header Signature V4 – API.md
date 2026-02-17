# Integrating Amazon API Services with SAP CPI: AWS Signature V4 for Label Printing

## Hello Folks,

One more interesting blog and sharing the knowledge and experience with you, basically let’s follow the topics and instructions during the reading.

### Agenda:
1.  **Introduction**
2.  **Scenario and Integration Perspective**
3.  **Amazon API services**
4.  **Adapters available in SAP CPI**
    * Open Connector Amazon
    * HTTPS
    * Amazon Web Services Adapter for SAP Integration Suite
5.  **AWS Signature via groovy – Method POST**
    * Problem to use MessageDigest – SHA256 – in groovy
    * Method GET
6.  **Integration Flow in SAP CPI using HTTPS Adapter**
7.  **Checking the result of the print label document**
8.  **Result**

---

## Introduction
In below blog I would like to share how we can integrate Amazon API services Bucket service using the HTTPS standard adapter and doing the AWS Header Signature via groovy.

You are going to see some similarities with previous blog of signature but you don't need use the code for the list of services below because in this case there is a free adapter in place for that.

### Amazon Web Services Adapter for SAP Integration Suite:
**Feature highlights:**
* Supports for S3, and SQS protocols on the sender side.
* Supports for S3, SQS, SNS, and SWF protocols on the receiver side.
* AWS S3 to read and push files from and into AWS S3 service.
* S3: Append timestamp to the file name.
* S3: Option to choose storage class.
* S3: Existing file handling option.
* S3: Server-Side Encryption.
* S3: Add customer metadata.
* S3: Option to list objects.
* AWS SQS to read and send a message from and to an AWS SQS queue.
* SQS: For standard queue, the option to provide a delay.
* SQS: For the FIFO queue, the option to provide message deduplication id and message group ID.
* SQS: Large message handling.
* AWS SNS to push real-time notification messages to interested subscribers over multiple delivery protocols.
* SNS: Option to provide Identical/Custom Payload.
* SNS: Option to provide Message attribute.
* SNS: Support for FIFO SNS Topic.
* SNS: Large message handling.
* AWS SWF to provide full control over implementing tasks and coordinating them.
* SWF: Option to determine request and response format.

---

## Scenario and Integration perspective
The scenario is the integration of SAP S4 with Amazon Label Print document Creation API.

The SAP CPI will be responsible to receive the call, with parameters as `client_id`, `client_secret` and `refreshed_token` and forward to AWS in the sequence above to in the end receive a response with **BASE64** of the label to be printed and shipped to the customer.

The free adapter of AMAZON available in SAP CPI can not be used for this service call. Due to that, I adjusted the previous groovy script code with some changes explained below.

**Previous blog reference:** *sap-cpi-amazon-s3-integration-with-https-adapter*

Using the HTTPS adapter with the POST and GET to receive the label Base64 file. The conversion from Base64 to image will be done in the backend system, but I will present the result using some online pages.

***Important information: the code must be changed for the correct details and others about your AWS Server***

---

## Amazon API Services
Amazon API Services are available to execute some processes. I'm not going into deep details here, but you can take a look at the links below to understand more about:
* **Token:** [Tokens API Use Case Guide]
* **Create Shipment Labels:** [Vendor Direct Fulfillment Shipping API v2021-12-28 reference]

---

## Adapters available in SAP CPI

### Open Connector Amazon
For this adapter there is a fantastic blog from **sriprasad.shivarambhat** explaining clearly how to setup and make the configuration in case that your company has the license for OpenConnector for SAP CPI.
Link: [Amazon Open Connector]

### HTTPS
This is the adapter that I choose for this scenario, basic and traditional HTTP(S) call with methods and authentication, in this case the authentication is made by groovy you will see later the configuration.

### Amazon Web Services Adapter
Link: [SAP API Hub]
*Note: This adapter cannot be used for this type of integration because there is no API header signature.*

---

## AWS Signature via groovy – Method POST
I will not explain in the details whole process of the signature, you can easily check in the **Amazon Header Signature V4**. To generate the signature header v4 basically it is compose of 3 steps:
1.  Canonical Request
2.  String-to-Sign
3.  Derived-signing-key

### Deriver-signing-key function:
```groovy
byte[] getSignatureKey(String key, String dateStamp, String regionName, String serviceName) throws Exception {
    byte[] kSecret = ("AWS4" + key).getBytes("UTF8");
    byte[] kDate = HmacSHA256(dateStamp, kSecret);
    byte[] kRegion = HmacSHA256(regionName, kDate);
    byte[] kService = HmacSHA256(serviceName, kRegion);
    byte[] kSigning = HmacSHA256("aws4_request", kService);
    return kSigning;
}
Differences between S3 and API Signature:
Signature S3 Bucket:

Groovy
String method = "PUT";    
String host = "<yourbuket>.s3.us-east-2.amazonaws.com";    
String region = "us-east-2";    
String service = "s3";
String endpoint = "s3.us-east-2.amazonaws.com";
String canonical_uri = "/<yourFolder>/"+map.get('NomeArquivo');
String canonical_headers = "host:" + host + "\n"+ "x-amz-content-sha256:" + hashBody + "\n" + "x-amz-date:" + amzDate + "\n";
Signature API:

Groovy
String method = "POST";
String region = "us-west-2";
String service = "execute-api";
String host = "us-east-2.amazonaws.com";
String canonical_uri = "[https://sellingpartnerapi-fe.amazon.com/tokens/2021-03-01/restrictedDataToken](https://sellingpartnerapi-fe.amazon.com/tokens/2021-03-01/restrictedDataToken)";
String canonical_headers = "accept: application/json"+";\n"+"content-length:"+ body.length() + ";\n"+"content-type:application/json"+";\n"+"host:" + host + ";\n"+ "x-amz-content-sha256:" + hashBody + ";\n" + "x-amz-date:" + amzDate + ";\n";
Full Groovy Script:
Groovy
/*****************************************************************
* Developer: Viana - SAP Senior Integration Consultant
******************************************************************/
import com.sap.gateway.ip.core.customdev.util.Message;
import java.util.HashMap;
import groovy.json.*;
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat
import java.lang.Object
import java.util.List;
import java.util.TimeZone;
import org.apache.commons.codec.digest.DigestUtils;

// STEP 1: Extract access_token and refresh_token
def Message getTokens(Message message) {
    Reader reader = message.getBody(Reader)
    def json = new JsonSlurper().parse(reader)
    message.setProperty("TokenAWS", json.access_token)
    message.setProperty("RefreshTokenAWS",json.refresh_token)
    return message
}

// STEP 2: Extract restrictedDataToken
def Message getRestrictedDataToken (Message message){
    Reader reader = message.getBody(Reader)
    def json = new JsonSlurper().parse(reader)
    message.setHeader("x-amz-access-token", json.restrictedDataToken)
    return message
}

// STEP 3: Generate AWS Signature
def Message signatureAWS(Message message) {
    def body = message.getBody(java.lang.String) as String
    def hashBody = DigestUtils.sha256Hex(body)
    def map = message.getProperties()
    
    String method = "POST";    
    String region = "us-west-2";    
    String service = "execute-api";
    String host = "us-east-2.amazonaws.com";
    
    // Read credentials from properties
    def access_key = map.get("access_key_property")
    def secret_key = map.get("secret_key_property")
    
    def now = new Date()
    def amzFormat = new SimpleDateFormat( "yyyyMMdd'T'HHmmss'Z'" )
    def stampFormat = new SimpleDateFormat( "yyyyMMdd" )
    def amzDate = amzFormat.format(now)
    def date_stamp = stampFormat.format(now)
    
    String canonical_uri = "[https://sellingpartnerapi-fe.amazon.com/tokens/2021-03-01/restrictedDataToken](https://sellingpartnerapi-fe.amazon.com/tokens/2021-03-01/restrictedDataToken)";
    String canonical_querystring = "";
    String canonical_headers = "accept: application/json"+";\n"+"content-length:"+ body.length() + ";\n"+"content-type:application/json"+";\n"+"host:" + host + ";\n"+ "x-amz-content-sha256:" + hashBody + ";\n" + "x-amz-date:" + amzDate + ";\n";
    
    String signed_headers = "accept;content-length;content-type;host;x-amz-content-sha256;x-amz-date";
    String canonical_request = method + "\n" + canonical_uri + "\n" + canonical_querystring + "\n" + canonical_headers + "\n" + signed_headers + "\n" + hashBody;
    
    String algorithm = "AWS4-HMAC-SHA256";
    String credential_scope = date_stamp + "/" + region + "/" + service + "/" + "aws4_request";
    String string_to_sign = algorithm + "\n" +  amzDate + "\n" +  credential_scope + "\n" + DigestUtils.sha256Hex(canonical_request);
    
    byte[] signing_key = getSignatureKey(secret_key, date_stamp, region, service);
    byte[] signature = HmacSHA256(string_to_sign,signing_key);
    String strHexSignature = bytesToHex(signature);
    
    String authorization_header = algorithm + " " + "Credential=" + access_key + "/" + credential_scope + ", " +  "SignedHeaders=" + signed_headers + ", " + "Signature=" + strHexSignature;
    
    message.setHeader("x-amz-date",amzDate);
    message.setHeader("x-amz-content-sha256", hashBody)
    message.setHeader("Authorization", authorization_header);
    message.setHeader("Host", "us-east-2.amazonaws.com");
    message.setHeader("Content-type", "application/json");
    message.setHeader("x-amz-access-token", message.getProperty("TokenAWS"))
    message.setHeader("Accept","application/json")
    
    message.setBody(body)
    return message
}

String bytesToHex(byte[] bytes) {
    char[] hexArray = "0123456789ABCDEF".toCharArray();           
    char[] hexChars = new char[bytes.length * 2];
    for (int j = 0; j < bytes.length; j++) {
        int v = bytes[j] & 0xFF;
        hexChars[j * 2] = hexArray[v >>> 4];
        hexChars[j * 2 + 1] = hexArray[v & 0x0F];
    }
    return new String(hexChars).toLowerCase();
}

byte[] HmacSHA256(String data, byte[] key) throws Exception {
    String algorithm="HmacSHA256";
    Mac mac = Mac.getInstance(algorithm);
    mac.init(new SecretKeySpec(key, algorithm));
    return mac.doFinal(data.getBytes("UTF8"));
}

byte[] getSignatureKey(String key, String dateStamp, String regionName, String serviceName) throws Exception {
    byte[] kSecret = ("AWS4" + key).getBytes("UTF8");
    byte[] kDate = HmacSHA256(dateStamp, kSecret);
    byte[] kRegion = HmacSHA256(regionName, kDate);
    byte[] kService = HmacSHA256(serviceName, kRegion);
    byte[] kSigning = HmacSHA256("aws4_request", kService);
    return kSigning;
}

// STEP 4: Extract base64 content
def Message getContentB64 (Message message){
    Reader reader = message.getBody(Reader)
    def json = new JsonSlurper().parse(reader)
    String base64AwsResponse = json.labelData.content
    message.setBody(base64AwsResponse.substring( 1, base64AwsResponse.length() - 1 ) )
    return message
}
Problems to use the Message Digest – SHA256 – in Groovy
Lib: import java.security.MessageDigest;

Error about Security Exception in line 83:

Solution: Import org.apache.commons.codec.digest.DigestUtils.
Lib: import org.apache.commons.codec.digest.DigestUtils;
Replace the function: def hashBody = DigestUtils.sha256Hex(body)

Integration Flow in SAP CPI – HTTPS Adapter
The SAP S4 is sending data via SOAP. Here are the steps:

Content-type: application/x-www-form-urlencoded.

Body Content:
grant_type=${header.grant_type}&refresh_token=${header.refresh_token}&client_id=${header.client_id}&client_secret=${header.client_secret}

Call Tokens API: Extract the refresh_token value.

Groovy: getTokens.

Content Modifier: Set body for the shipping label request.

JSON
{
    "restrictedResources": [
        {
            "method": "POST",
            "path": "/vendor/directFulfillment/shipping/2021-12-28/shippingLabels/{purchaseOrderNumber}"
        }
    ]
}
Groovy: signatureAWS.

Call Data Token API: Response extraction.

Groovy: getRestrictedDataToken – Set header x-amz-access-token.

Final Call: Call API to receive BASE64 of the label.

Groovy: getContentB64.

Checking the result of the print label document
To check the image:

Decode the base64 using: [Base64 Decode and Encode - Online]

View the ZPL result: [Labelary Online ZPL Viewer]

You can also use the public API from ZPL Viewer to return the image directly to SAP (PNG, PDF, etc.) by setting the Accept header.

Result:
Success !!!
I hope that you enjoy the read that gives you a overview and possibilities to use the API's from Amazon with SAP Integration Suite.

Kind regards,
Viana.
