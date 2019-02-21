# API Guide

Upay Web API domain: `https://api.shouqianba.com`

Upay Web API accepts only JSON formatted HTTP requests. Please make sure to add `Content-Type` header and set its value to `application/json` for all requests.

All requests must be `UTF-8` encoded; all responses are `UTF-8` encoded as well.

All requests must be signed as instructed below: 

### Request Signature

* Upay Web API uses application layer signature mechanism. The `UTF-8` encoded body (regardless of any formatting) byte stream is used for signature.
* The client `sn` and signature value should be in the `Authorization` header of HTTP requests. It will be validated by Upay Web API service.
* Signature algorithm: `sign = MD5(CONCAT(body + key))`
* HTTP header: `Authorization: sn + " " + sign`

### Upay different sn & key

* For activation (`/terminal/activate`), please use `vendor_sn` and `vendor_key` for signature.Verdor_sn and key will be provided offline.
* For other requests (check-in, pay, refund, query, etc.), please use `terminal_sn` and `terminal_key` , which is returned in successful activation or check-in responses.
