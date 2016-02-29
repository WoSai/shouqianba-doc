# Upay API Workflow

## Step 1 - Apply

Please contact our customer representative for application:

- For Chinese & English: Stanley Lu (Cell: +86 13917862326)
- For Chinese only: Jianqiang Zang (Cell: +86 18005736061) 

## Step 2 - Submit Application Materials

Please submit required materials as instructed for review. Once approved, you will get your `vendorSn` and `vendorKey` for Upay Web API.

Submit store information for activation code to activate Upay terminals of the store.

Now, you are ready to use Upay Web API.

## Step 3 - Develop Your Client Application

Upay Web API domain: `https://api.shouqianba.com`

Upay Web API accepts only JSON formatted HTTP requests. Please make sure to add `Content-Type` header and set its value to `application/json` for all requests.

All requests must be `UTF-8` encoded; all responses are `UTF-8` encoded as well.

All requests must be signed as instructed below: 

### Request Signature

* Upay Web API uses application layer signature mechanism. The `UTF-8` encoded body (regardless of any formatting) byte stream is used for signature.
* The client `sn` and signature value should be in the `Authorization` header of HTTP requests. It will be validated by Upay Web API service.
* Signature algorithm: `sign = MD5(CONCAT(body + key))`
* HTTP header: `Authorization: sn + " " + sign`

### sn & key

* For activation(`{api_domain}/terminal/activate`), please use `vendorSn` and `vendorKey` for signature.
* For other requests (checkin, pay, refund, query, etc.), please use `terminalSn` and `terminalKey` returned in successful activation or checkin responses.