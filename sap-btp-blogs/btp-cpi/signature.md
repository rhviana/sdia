Hello Folks,

In this blog I'm going to share the details and aspects how to generate the signature with PRIVATE KEY and PUBLIC Key over the requirement of integration with NHN KCP Korean Payment Service, throught this blog you will see the explanation in details and translation of the requirement to groovy script.

Integration diagram:
<img width="999" height="463" alt="image" src="https://github.com/user-attachments/assets/49af9b58-1679-4fbd-8a85-a6c2697e3dee" />

The requirements from NHK you can see in details over this link:

[NHK Korean Developer](https://developer.kcp.co.kr/en/page/refer/server)

Why I need do this?
Requirement:
NHNKCP Server Signature Data

Impact of this problem:
Without following the requirement the NHN KCP API refuse the call for CAPTURE or REFUND payment process

KCP Requirement
As per of link above, check in details the image below where the full logic must be applied.
<img width="999" height="617" alt="image" src="https://github.com/user-attachments/assets/90f89ad9-f10f-4f96-89aa-c5efcc4b9681" />

The text value within the certificate must be serialized and delivered as the value of kcp_cert_info.

<img width="999" height="617" alt="image" src="https://github.com/user-attachments/assets/d5402484-048c-4db2-ab48-b1abfb836ab9" />

1 ) The text value within the certificate must be serialized and delivered as the value of kcp_cert_info.

Means in the json element kcp_cert_info you should keep the string of PUBLIC KEY without serialize with HEADER ( -----BEGIN CERTIFICATE----- ) and foot ( -----END CERTIFICATE-----)

Sample: "kcp_cert_info":"-----BEGIN CERTIFICATE-----MI....VNeequGLUZSx1il+tJU=-----END CERTIFICATE-----"

2 ) Send signature data

First part of the requirement:

KCP signature for MOD API is as follows
```text
site_cd + "^" + tno + "^" + mod_type
```
 Means that you should concatenate the values from the elements with ^ + ^ and encoding with SHA256withRSA

Second part of the requirement:

KCP Signature (kcp_sign_data) should be generated using the hash string listed below and encoded with SHA256withRSA algorithm with the given Private Key.

Means the json element kcp_sign_data should keep the encoded SHA256withRSA of the concatenate string (site_cd + "^" + tno + "^" + mod_type) with given private key string serialized and password of private key in BASE64

Serialized means remove the HEADER (-----BEGIN ENCRYPTED PRIVATE KEY-----) and FOOT (-----END ENCRYPTED PRIVATE KEY-----) from private certificate

Sample:  "kcp_sign_data":"QdwMF6y3GU1JTVkSv7Yn20CCCTeFrKkjvrdZOjShiFibFo...." 

Below there is some orientation about CAPTURE and REFUND, the groovy signature can be used for both process because there is no difference in the payload only in the values. 

Sample of input payload:
 
```json
{
  "site_cd": "VALUE PROVIDE BY KCP API",
  "kcp_cert_info": "-----BEGIN CERTIFICATE-----MIIDjDCCAnSgA...-----END CERTIFICATE-----",
  "tno": "24484446800942",
  "mod_type": "STMR",
  "mod_desc": "7001034211",
  "kcp_sign_data": "Erpu5FgW...."
}
```

Differences between finance process ?
The main difference between CAPTURE and REFUND is the value of mod_type:

Capture:

"mod_type": "STMR"

Sample:
 ```json
{
  "site_cd": "VALUE PROVIDE BY KCP API",
  "kcp_cert_info": "-----BEGIN CERTIFICATE-----MIIDjDCCAnSgA...-----END CERTIFICATE-----",
  "tno": "24484446800942",
  "mod_type": "STMR",
  "mod_desc": "7001034211",
  "kcp_sign_data": "Erpu5FgW...."
}
```

Refund:

"mod_type": "STSC"

Sample:
```json
{
  "site_cd": "VALUE PROVIDE BY KCP API",
  "kcp_cert_info": "-----BEGIN CERTIFICATE-----MIIDjDCCAnSgA...-----END CERTIFICATE-----",
  "tno": "24484446800942",
  "mod_type": "STSC",
  "mod_desc": "7001034211",
  "kcp_sign_data": "Erpu5FgW...."
}
``` 

Challenges:

The KCP NHK provides both certificates, public key and private key as .PEM extension, such extension CPI doesn't accept, the SSL conversion is needed from .PEM to P.12 for the public key merging PUBLIC + Private
```text
Sample of code: openssl pkcs12 -export -out KCP_AUTH_AO55U_CERT.p12 -in KCP_AUTH_AO55U_CERT.pem -inkey KCP_AUTH_AO55U_PRIKEY.pem
```
2 ) Read correctly the PRIVATE PEM KEY ENCRYPTED from KEYSTORE, I hard code the value in groovy in duty of project timeline 

What are possible solutions?
1 ) Store the public certificate in KEYSTORE

2 ) Store the private certificate as SECURITY MATERIAL the whole ENCRYPTED String from .PEM FILE.

3 ) Store the password of private certificate in USER CREDENTIAL or SECURITY MATERIAL

Those activities is to keep the security and not use a hardcode values in the groovy script.

Groovy script: 
```js
/************
* 
* Developer: Viana - SAP Expert Integration Consultant
* Project: PSP Koren KCP Finance/Payment Process
* Description of Integration: The capture and refund finance process for payment with Korean KCP system
* Groovy: Responsable to read the public certificate, private certificate, password as security material, generate the message body and signature required by KCP
*
*************/
/************  
*        
* Libraries 
*           
*************/
import com.sap.gateway.ip.core.customdev.util.Message
import java.security.*
import java.security.spec.PKCS8EncodedKeySpec
import java.security.KeyStore
import java.security.cert.X509Certificate
import java.util.Base64
import javax.crypto.EncryptedPrivateKeyInfo
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.PBEKeySpec
import javax.crypto.Cipher
import groovy.json.*
import com.sap.it.api.securestore.SecureStoreService
import com.sap.it.api.ITApiFactory
import com.sap.it.api.securestore.exception.SecureStoreException
import java.security.cert.Certificate
import com.sap.it.api.keystore.KeystoreService
 
Message KCPSignature(Message message) {
    
    def mapProperties =  message.getProperties()
    
    // Alias of the PUBLIC certificate in the keystore
    def publicKey = mapProperties.get("PublicKeyAlias")
    // Get encoded bas64 string serealized PUBLIC KEY the Keystore Service API
    KeystoreService keystoreService = ITApiFactory.getApi(KeystoreService.class, null)
    Certificate pubkey= keystoreService.getCertificate(publicKey)
    // Serialize the string of public Certificate with HEADER and FOOT
    publicKey = "-----BEGIN CERTIFICATE-----"
    publicKey += Base64.encoder.encodeToString(pubkey.getEncoded())
    publicKey += "-----END CERTIFICATE-----"
    
    
    // Alias of the PRIVATE certificate in the keystore
    def privateKey = mapProperties.get("PrivateKeyAlias")
    def servicepk = ITApiFactory.getApi(SecureStoreService.class, null); 
    // Get credential details
    def pkstring = servicepk.getUserCredential(privateKey); 
    // Password to decrypt the private key
    def privateKeyString = pkstring.getPassword().toString();
    
    // Specify the name of the credential in Security Material to extract the password
    def credentialName = mapProperties.get("PasswordPrivateKey")
    def service = ITApiFactory.getApi(SecureStoreService.class, null); 
    // Get credential details
    def credentialpw = service.getUserCredential(credentialName); 
    // Password to decrypt the private key
    def PASSWORD = credentialpw.getPassword().toString();
    
    // Encrypted PEM key string (example)
    def ENCRYPTED_PRIVATE_KEY = privateKeyString
     // Reader the input body as InputStream
    Reader reader = message.getBody(Reader)
    def header = message.getHeaders()
    // Instance of XmlSlurper to parsing the input stream
    def inputJson = new JsonSlurper().parse(reader)
    def stringSign =   inputJson.site_cd + "^" + inputJson.tno + "^" + inputJson.mod_type
    def modSignature = generateKcpSignData(stringSign, ENCRYPTED_PRIVATE_KEY, PASSWORD)
    def builder = new JsonBuilder()
    builder{
            "site_cd" inputJson.site_cd
            "kcp_cert_info" publicKey
            "tno" inputJson.tno
            "mod_type" inputJson.mod_type
            "mod_desc" inputJson.mod_desc
            "kcp_sign_data" modSignature
    }
    message.setBody(builder.toPrettyString())
       // Generate the signatures
    return message
}


def generateKcpSignData(String dataString, String encryptedPrivateKeyPem, String password) {
    // Remove PEM headers and decode the encrypted private key
    encryptedPrivateKeyPem = encryptedPrivateKeyPem.replace("-----BEGIN ENCRYPTED PRIVATE KEY-----", "")
                                                   .replace("-----END ENCRYPTED PRIVATE KEY-----", "")
                                                   .replaceAll("\\s", "")
    byte[] encryptedPrivateKeyBytes = Base64.decoder.decode(encryptedPrivateKeyPem)

    // Parse the encrypted private key
    EncryptedPrivateKeyInfo encryptedPrivateKeyInfo = new EncryptedPrivateKeyInfo(encryptedPrivateKeyBytes)
    
    // Create a PBEKeySpec with the provided password
    PBEKeySpec pbeKeySpec = new PBEKeySpec(password.toCharArray())
    
    // Get the secret key factory for the encryption algorithm
    SecretKeyFactory secretKeyFactory = SecretKeyFactory.getInstance(encryptedPrivateKeyInfo.getAlgName())
    
    // Generate the PBEKey for decryption
    Key pbeKey = secretKeyFactory.generateSecret(pbeKeySpec)
    
    // Decrypt the private key
    Cipher cipher = Cipher.getInstance(encryptedPrivateKeyInfo.getAlgName())
    cipher.init(Cipher.DECRYPT_MODE, pbeKey, encryptedPrivateKeyInfo.getAlgParameters())
    byte[] privateKeyBytes = cipher.doFinal(encryptedPrivateKeyInfo.getEncryptedData())

    // Load the private key
    KeyFactory keyFactory = KeyFactory.getInstance("RSA")
    PrivateKey privateKey = keyFactory.generatePrivate(new PKCS8EncodedKeySpec(privateKeyBytes))

    // Sign the data string using SHA256withRSA
    Signature signature = Signature.getInstance("SHA256withRSA")
    signature.initSign(privateKey)
    signature.update(dataString.bytes)
    byte[] signedBytes = signature.sign()

    // Base64 encode the signature
    return Base64.encoder.encodeToString(signedBytes)
}
``` 
Input payload after message mapping to receive the signature:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <site_cd>AO55U</site_cd>
  <tno>24484446800942</tno>
  <mod_type>STMR</mod_type>
  <mod_desc>7001034211</mod_desc>
</root>
``` 

After the groovy script signature and transformation from XML to JSON result:
```json
{
  "site_cd": "AO55U",
  "kcp_cert_info": "-----BEGIN CERTIFICATE-----MIIDjDCCAnSgAwIBAgIHBz  DELETED SENSIBLE INFORMATION-----END CERTIFICATE-----",
  "tno": "24484446800942",
  "mod_type": "STMR",
  "mod_desc": "7001034211",
  "kcp_sign_data": "Erpu5FgWdT+KcYsuD1- DELETED SENSIBLE INFORMATION"
}
```

Test Result:

<img width="997" height="211" alt="image" src="https://github.com/user-attachments/assets/ea52546e-564b-4a06-b03e-00f79e90222a" />

So, if your project going to integrate wit NHK Korean Payment service, this groovy with adaptations of input payload is the solution.

I hope you enjoy.

Kind regards,

SAP Integration Expert - Viana.
