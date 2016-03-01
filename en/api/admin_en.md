# Terminal API Reference

### Activation
The purpose of activation is to get the terminal sn and terminal key via activation interface, these parameters are used to sign the singature when using Transcation API.
A Vendor key is required to sign the signature. The signature algorithm can refered to Transcation API document.
Please use vendor serial number (vendor_sn) as signer ID, vendor key as signature key.
#### Interface Name
POST /terminal/activate
#### Request/Type
application/json
#### Reqeust/Parameter
Field | Type | Required | Description
------ | ----- | -----| -----
code | string | Y | activation code
device_id | string | Y | device identification
os_info | string | N | OS info like: Android5.0
sdk_version | string | Y | SDK version
type | string | N | device type is optional。default "2"（SQB_SDK)
#### Response
Field | Type | Required | Description
------ | ----- | -----| -----
terminal_sn | string | Y | terminal serial number
terminal_key | string | Y | terminal key

Example：

```json
{
  "result_code": "200",
  "biz_response": {
    "terminal_sn": "10298371039",
    "terminal_key": "68d499beda5f72116592f5c527465656"
  }
}
```
### Checkin
Checkin interface is used to update terminal key each day, otherwise terminal key will be expired each calendar day and you will get illegal signature response.
#### Interface Name
POST /terminal/checkin
#### Request Type
application/json
#### Request Parameter
Field | Type | Required | Description
------ | ----- | -----| -----
terminal_sn | string | Y | terminal serial number
device_id | string | Y | device identification
os_info | string | N | os info like: Android5.0
sdk_version | string | N | SDK Version
#### Response
Field | Type | Required | Description
------ | ----- | -----| -----
terminal_sn | string | Y | terminal serial number
terminal_key | string | Y | terminal key

Example：

```json
{
  "result_code": "200",
  "biz_response": {
    "terminal_sn": "10298371039",
    "terminal_key": "68d499beda5f72116592f5c527465656"
  }
}
```

### Upload Log
This interface is use to upload local SDK log files to the remote server, optional. It is highly recommended to upload logs after checkin, and remove the old one if the upload action is successfully. This interface requires terminal sn and terminal key as the singature parameter, the signature algorithm is the same as Transcation API.
#### Interface Name
POST /terminal/uploadLog
#### Request Parameter
The Body part of http request is log file input, please use zip format to compress. 
#### Resonpse
Success：

```json
{
  "result_code": "200",
  "error_code": "SUCCESS",
  "error_message": "ok"
}
```
Fail, result_code is not 200.

#### Error Code
TODO

## Security
The new gateway designed new authrization algorithm, as well as introduced new concept of terminal. 
It requires SDK provide more interfaces besides Transcation API.
### Interface Signature
The client `sn` and signature value should be in the `Authorization` header of HTTP requests, the signature parameter is based on terminal key.
 The signature algorithm can be referd by Transcation API V2.0.
### Terminal Activation
The new concept of terminal requires each of SDK instance has a set of terminal Sn and terminal Key, the configuration can be done by the the activate interface.
By the input of activation code, SDK will send request to the Transcation API and get the response of terminal Sn and terminal key, the storage of terminal key is provided by SDK.
### Terminal Key Update Strategy
Similar to the POS machine, there is a 『Checkin』strategy inside the SDK to provide daily update of terminal KEY. It can be designed to do checkin automactically before the first transcation request each calendar day, and save the terminal Key locally.

