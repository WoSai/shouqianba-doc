# Business API Reference

### Activation
The purpose of activation is to get the terminal sn and terminal key via activation code. It is used to sign the singature when using trade API.
Activation interface require vendor key to build the signature. The signature algorithm can refered to trade api document.
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
Checkin interface is used to update terminal key each day, otherwise terminal key will be expired and you will get illegal signature response from trade API.



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

#### 响应
Field | Type | Required | Description
------ | ----- | -----| -----
terminal_sn | string | Y | terminal serial number
terminal_key | string | Y | terminal key

如：

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
该接口用于上传SDK本地的日志数据到服务器，非必须。建议SDK每次签到完成后，上传历史日志文件，上传成功后删除已上传的日志文件。该接口需要使用终端sn和终端key做签名，方式同支付接口。
This interface is use to upload local SDK log files to the remote server, optional. It is highly recommended to upload logs after checkin, and remove the old one if the upload action is successfully. This interface require terminal sn and terminal key for the singature parameter, the signature algorithm is the same as trade API.

#### Interface Name
POST /terminal/uploadLog

#### Request Parameter
Body内容即为日志，请使用zip格式压缩。
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
Fail, then result_code is not 200.

#### Error Code
TODO

## Security

The new gateway designed new authrization algorithm, as well as introduced new concept of terminal. 
It requires SDK provide more interfaces besides trade API.

### Interface Signature
It is required to put header of signature on the HTTP header part, the signature parameter is based on terminal key.
 The signature algorithm can be referd by Trade API V2.0.

### Terminal Activation

The new concept of terminal requires each of SDK instance has a set of terminal ID and terminal Key, the configuration can be done by the the activate interface.

By the input of activation code, SDK will send request to the shouqianba server and get the response of terminal ID and terminal key, the storage of terminal key is provided by SDK.

### Terminal Key Update Strategy

Similar to the POS machine, there is a 『Checkin』strategy inside the SDK to provide daily update of terminal KEY. It can be designed to do checkin automactically before the first trade request each calendar days, and save the terminal Key locally.

