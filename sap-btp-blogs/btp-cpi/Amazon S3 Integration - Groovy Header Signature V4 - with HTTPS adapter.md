# Integrating Amazon S3 with SAP CPI: Custom AWS Signature V4

## Hello Folks,

One more interesting blog and sharing the knowledge and experience with you, basically let's follow the topics and instructions during the reading.

### Tip in case that you still on-premise (PI or PO)
During my research about this signature I found a very good blogs from fantastic development, please take look below:
* Integrating Amazon Simple Storage Service (Amazon S3) - rajeshps
* File Upload in AWS S3 using REST API - asutoshmaharana2326

---

## Agenda
1. **Introduction**
2. **Scenario and Integration Perspective**
3. **Amazon S3 Bucket service**
4. **Adapters available in SAP CPI**
   * Open Connector Amazon
   * HTTPS
   * Amazon Web Services Adapter for SAP Integration Suite
5. **Groovy to convert XML to JSON**
6. **AWS Signature via groovy - Method PUT**
   * Problem to use MessageDigest - SHA256 - in groovy
   * Method GET
7. **Integration Flow in SAP CPI using HTTPS Adapter**
   * Adapter configuration is basic
   * Groovy - HTTP Exception
   * Possible Errors
8. **Integration Flow in SAP CPI using AmazonWebService Adapter**
9. **SOAP UI Test**

---

## Introduction
In below blog I would like to share how we can integrate Amazon S3 Bucket service using the HTTPS standard adapter doing the AWS Signature via groovy.

Also I will mention the others possibilities in case of no license to use Open Connector for Amazon or if you are not aware about the Amazon Web Service Adapter release 09 Feb 2021.

**What I will not cover in the blog?**
* The whole setup of the Amazon S3 service detail - Why? You can check in the blog of sriprasad.shivarambhat those details, no make sense repeat.
* SDK'S available from the Amazon with ready code to be used. (There is for JavaScript but not for groovy).
* How to deploy the new adapter release by SAP.

---

## Scenario and Integration perspective
The scenario is the integration of SAP MDG sending a custom XML related with material state change (create, delete, change).

The SAP CPI will be responsible to receive the call, parse the XML to JSON using a custom groovy development and also create the signature of AWS in groovy and send the binary file using the HTTPS adapter with the PUT method to store in the Amazon S3 Bucket.

*** Important information: the code must be change for the correct host information details of your AWS Server ***

---

## Amazon S3 Bucket service
An Amazon S3 bucket is a public cloud storage resource available in Amazon Web Services' (AWS) Simple Storage Service (S3), an object storage offering. Amazon S3 buckets, which are similar to file folders, store objects, which consist of data and its descriptive metadata.

Basically the S3 bucket act on-cloud repository.

**S3 Bucket vs traditional SFTP:**
I recommend you to read the advantages to think - GO TO CLOUD in your business, not only for storage perspective. Check the link for differences: [S3 vs SFTP]

---

## Adapters available in SAP CPI

### Open Connector Amazon
For this adapter there is a fantastic blog from sriprasad.shivarambhat explaining clearly how to setup and make the configuration.
Link: [Amazon Open Connector]

### HTTPS
This is the adapter that I choose for this scenario, basic and traditional HTTP(S) call with methods and authentication, in this case the authentication is made by groovy you will see later the configuration.

### Amazon Web Services Adapter
More details about this adapter - [SAP API Hub]

---

## Groovy to convert XML to JSON
Why not use the convertor XML to JSON? It is up to the developer but I did the groovy code.

### Input XML:
```xml
<n0:BlogAwsS3HTTPSAdapter xmlns:n0="urn:sap-com:document:sap:soap:functions:mc-style">
   <Assets>
      <Documents>
         <Type>
            <Id>REF</Id>
            <Name>Cad 3D</Name>
         </Type>
         <Id>794290</Id>
         <Name>Cad 3D_1189.102</Name>
         <Version>AA</Version>
         <Part>000"</Part>
         <Path>/Bola/Produtos/1189.BL102.MT.T06</Path>
         <Atributes>
            <item>
               <Id>asset.filename</Id>
               <Name>asset.filename</Name>
               <Values>
                  <Valueid/>
                  <Value>Cad 3D_1189.102.dwg</Value>
                  <Uom/>
               </Values>
            </item>
         </Atributes>
      </Documents>
   </Assets>
   <Attributes>
      <item>
         <Id>TP_MEC</Id>
         <Name>Tipo de Mecanismo utilizado</Name>
         <Values>
            <item>
               <Valueid>LOV_TP_MEC_SOLEN</Valueid>
               <Value>Solenóide</Value>
               <Uom/>
            </item>
         </Values>
      </item>
   </Attributes>
   <EvBrand>Ceusa</EvBrand>
   <EvName>1985.C.CT-CHUV TUBO PAR CUBO - CR</EvName>
   <EvType>children</EvType>
   <Keys>
      <item>
         <Id>COD_MATERIAL</Id>
         <Name>Código do material</Name>
         <Value>1189.BL102.MT.T06</Value>
      </item>
   </Keys>
</n0:BlogAwsS3HTTPSAdapter>
```
Groovy Script (Conversion):
```groovy
import com.sap.gateway.ip.core.customdev.util.Message
import groovy.json.*
import groovy.xml.*
import java.nio.charset.StandardCharsets;

def Message processData(Message message) {
    java.io.InputStream reader = message.getBody(java.io.InputStream)
    def JsonFile = new XmlParser().parse(reader)
    def builder = new JsonBuilder()
    builder {
        'id'
        'name' JsonFile.EvName.text()
        'type' JsonFile.EvType.text()
        'brand' JsonFile.EvBrand.text()
        def arrayKeys = JsonFile.Keys.item
        'Keys' arrayKeys.collect { item->
            [
                'id': item.Id.text(),
                'name': item.Name.text(),
                'value': item.Value.text(),
            ]
        }
        assets{
            documents{
                    type{
                        'id' JsonFile.Assets.Documents.Type.Id.text()
                        'name' JsonFile.Assets.Documents.Type.Name.text()
                        }
                    'id' JsonFile.Assets.Documents.Id.text()
                    'name' JsonFile.Assets.Documents.Name.text()
                    'version' JsonFile.Assets.Documents.Version.text()
                    'part' JsonFile.Assets.Documents.Part.text() 
                    'path' JsonFile.Assets.Documents.Path.text() 
                    }
                    attributes{
                        def arrayItemAssets = JsonFile.Assets.Documents.Atributes.item
                        'item' arrayItemAssets.collect { item -> 
                            [
                                'id': item.Id.text(),
                                'name': item.Name.text(),
                                'values': item.Values.collect { item2 ->
                                    [
                                      'valueId': item2.Valueid.text(),
                                      'value':  item2.Value.text(),
                                      'uom':  item2.Uom.text(),
                                    ]
                                }
                            ]
                        }    
                    }
        }
        def arrayAttributes = JsonFile.Attributes.item
        'attributes' arrayAttributes.collect { item3 ->
            [
             'id': item3.Id.text(),
             'name': item3.Name.text(),
             'group': item3.Group.text(),
             'values': item3.Values.item.collect { item4 ->
                                        [
                                       'valueId': item4.Valueid.text(),
                                       'value':  item4.Value.text(),
                                       'uom':  item4.Uom.text(),
                                        ]
                                    }
             ]
            }
    }
    
    def jsonString = JsonOutput.prettyPrint(builder.toString())
    jsonString = unescapeUnicode(jsonString)
    message.setProperty("NomeArquivo", "JsonFileBlog_SAPCPI_HttpsAdapter.json")
    message.setBody(jsonString)
    return message
}

def unescapeUnicode(def inp){
    (inp =~ /\\u([0-9a-f]{2})([0-9a-f]{2})/).each { m ->        
        def uniAsString = new String([
                                Integer.parseInt(m[1], 16),
                                Integer.parseInt(m[2], 16)
                            ] as byte[], StandardCharsets.UTF_16)
        inp = inp.replace(m[0], uniAsString)
    }
    return inp
}
```
Why I'm using unescapeUnicode function?
There is some accents in some strings - Código - "ó". This function keeps the encoding proper.

AWS Signature via groovy - Method PUT
To generate the signature header v4, it is composed of 3 steps:

Canonical Request

String-to-Sign

Derived-signing-key

Groovy Script (Signature V4):
```groovy
import com.sap.gateway.ip.core.customdev.util.Message;
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat
import java.lang.Object
import java.util.List;
import java.util.TimeZone;
import org.apache.commons.codec.digest.DigestUtils;

def Message processData(Message message) {
    def body = message.getBody(java.lang.String) as String
    def hashBody = DigestUtils.sha256Hex(body)
    def map = message.getProperties()
    
    String method = "PUT";    
    String host = "<yourbuket>.s3.us-east-2.amazonaws.com";    
    String region = "us-east-2";    
    String service = "s3";
    String endpoint = "s3.us-east-2.amazonaws.com";
    
    def access_key = "ID_GeneratedInAWS"
    def secret_key = "Key_GeneratedInAWS"
    
    def now = new Date()
    def amzFormat = new SimpleDateFormat( "yyyyMMdd'T'HHmmss'Z'" )
    def stampFormat = new SimpleDateFormat( "yyyyMMdd" )
    def amzDate = amzFormat.format(now)
    def date_stamp = stampFormat.format(now)
    
    String canonical_uri = "/<yourFolder>/"+map.get('NomeArquivo');
    String canonical_querystring = "";
    String canonical_headers = "host:" + host + "\n"+ "x-amz-content-sha256:" + hashBody + "\n" + "x-amz-date:" + amzDate + "\n";
    String signed_headers = "host;x-amz-content-sha256;x-amz-date";
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
    message.setHeader("Host", "<yourBucket>.s3.us-east-2.amazonaws.com");
    message.setHeader("content-type", "application/json");
    
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
```
Problems to use the Message Digest in Groovy:
Error about Security Exception in line 83:
[Local da Imagem: Erro de Security Exception em amarelo]

Solution: Use org.apache.commons.codec.digest.DigestUtils.

import org.apache.commons.codec.digest.DigestUtils;
def hashBody = DigestUtils.sha256Hex(body)

Method GET
For method GET, there is no body, so the hash must be fixed: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855. Change method = "GET".

Integration Flow in SAP CPI - HTTPS Adapter
[Local da Imagem: Diagrama do iFlow usando HTTPS Adapter]

Adapter configuration:
Method: PUT

Authentication: None (managed by Groovy)

Address: <yourAwsDetailBuket> and <yourFolder>

Dynamic Filename: ${property.NameArquivo}

Groovy - HTTP Exception:
```groovy
import com.sap.gateway.ip.core.customdev.util.Message
import java.util.HashMap
import org.w3c.dom.Node
import groovy.xml.*

def Message processData(Message message) {
    java.io.InputStream reader = message.getBody(java.io.InputStream)
    def messageLog = messageLogFactory.getMessageLog(message)
    def xHeaders = message.getHeaders()
    def map = message.getProperties()
    String sResponseCode = xHeaders.get("CamelHttpResponseCode")
    def ex = map.get("CamelExceptionCaught");
    if (ex!=null) {
            if (ex.getClass().getCanonicalName().equals("org.apache.camel.component.ahc.AhcOperationFailedException")) {
                messageLog.addAttachmentAsString("HTTP Response body: ", ex.getResponseBody(), "text/plain");
                throw new Exception("Error in the routing details in the Iflow");
            }
    }
    return message;
}
```
Possible Errors
AccessDenied: Credential missing proper AWS Roles. [Link: Bucket Policy AWS]

SignatureDoesNotMatch: Calculation error in Groovy.

MethodNotAllowed: Using "POST" instead of "PUT".

Integration Flow using AmazonWebService Adapter
[Local da Imagem: Diagrama do iFlow usando AmazonWebService Adapter]

Configuration:
Select protocol AWS (S3).

Select region and bucket details.

Create Security Material for Access Key and Secret Key.

[Local da Imagem: Configuração do Adapter AWS Parte 1]
[Local da Imagem: Configuração do Adapter AWS Parte 2]

SOAP UI Test
Check S3 bucket state:
[Local da Imagem: Bucket S3 vazio antes do teste]

Send data from SOAP UI:
[Local da Imagem: SOAP UI enviando request]

Check S3 Bucket again - BOOM:
[Local da Imagem: Arquivo aparecendo no S3 Bucket]

Verify content with Postman (GET):
[Local da Imagem: Postman validando o conteúdo do arquivo]

I hope that you enjoy the read and what I presented in this blogs.

Kind Regards,
Viana.
