# Upay Web API Reference - Terminal

## Terminal Activation

The purpose of activation is to register the terminal device information and to get `terminal_sn` and `terminal_key` to sign the terminal's transaction requests. Any request without a signature will be deemed invalid by Upay Web API.

Similarly, `vendor_sn` and `vendor_key` should be used to sign activation requests. Please refer to *Workflow* and *Developer Guide* on how to sign your requests.

### API Target

POST `/terminal/activate`

### Content-Type

`application/json`

### Reqeust Parameters

Field | Type | Required | Description
------ | ----- | -----| -----
code | String | Y | Terminal activation code
device_id | String | Y | Device identification, such as IMEI of an Android device or `indentifierForVendor` of an iOS device.
os_info | String | N | Terminal OS information, such as: Android 5.0.
sdk_version | String | Y | Upay SDK version
type | String | N | Terminal device type. Default is "2" (SQB_SDK).

### Response Parameters

Field | Type | Required | Description
------ | ----- | -----| -----
terminal_sn | String | Y | Terminal serial number
terminal_key | String | Y | Terminal key

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

## Terminal Checkin

Your terminal needs to check in at least once per day to get latest `terminal_key`. Please keep in mind that a `terminal_key` is only valid for at most 48 hours, and after each checkin, only current and last `terminal_key`s are valid.

Using expired or invalid `terminal_key` to sign your requests will result in illegal signature responses.

We recommend that each terminal check in before the first transaction of each day.

### API Target

POST `/terminal/checkin`

### Content-Type

`application/json`

### Request Parameters

Field | Type | Required | Description
------ | ----- | -----| -----
terminal_sn | String | Y | Terminal serial number
device_id | String | Y | Device identification, such as IMEI of an Android device or `indentifierForVendor` of an iOS device.
os_info | String | N | Terminal OS information, such as: Android 5.0.
sdk_version | String | Y | Upay SDK version

### Response Parameters

Field | Type | Required | Description
------ | ----- | -----| -----
terminal_sn | String | Y | Terminal serial number
terminal_key | String | Y | Terminal key

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

## Upload Terminal Log

Even though not required, we recommend each terminal log its own activities and upload its log file each day after checking in. Terminal log is an important asset for debugging all sorts of terminal errors and failures.

The terminal may delete the log file after a sucessful upload. We strongly recommend developers to keep log entries consise and rotate the log file on daily basis, so that log files are small enough to be uploaded without interfering other terminal functionalities.

Use `terminal_sn` and `terminal_key` to sign your log upload requests just like other types of requests.

### API Target

POST `/terminal/uploadLog`

### Request Parameters

The body of the request is the log file's binary stream compressed using gzip.

### Resonpse Parameters

Success:

```json
{
    "result_code": "200",
    "error_code": "SUCCESS",
    "error_message": "ok"
}
```

Result_code is not `"200"` if request fails.

### Error Codes

[TODO]

## Security

Upay Web API adopts several mechanisms to ensure high level of transaction security:

### HTTPs Protocol

All Upay Web APIs use HTTPs protocol to encrypt communications between servers and clients.

### Request Signature

The client's `terminal_sn` and request signature should be in the `Authorization` header of each Upay Web API request. Request signature makes sure the request is signed by the right entity and not modified by any third party.

### Terminal Activation

Each Upay terminal needs to be activated before any transaction takes place. The terminal will get `terminal_sn` and `terminal_key` in successful activation response. The terminal is also responsible for saving and managing the `terminal_sn` and `terminal_key` which will be used for signature of every transaction request.

### Terminal Key Update

Similar to a POS terminal, a Upay terminal needs to check in everyday to get latest `terminal_key`. Updating the `terminal_key` everyday helps keep your terminal and transactions safe.

