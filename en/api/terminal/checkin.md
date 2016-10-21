# Check-in

The purpose of terminal check-in is to limit the valid duration of your current `terminal_key` so to reduce the theoretical risk of someone using brute-force algorithm to decrypt your request and steal your `terminal_key`.

Your terminal needs to check in at least once per day to get latest `terminal_key`. Please keep in mind that ~~a `terminal_key` is only valid for at most 48 hours, and~~ after each check-in, only current and last `terminal_key`s are valid.

Use the terminal's `terminal_sn` and its current `terminal_key` to sign its check-in request. Please refer to [API Guide](../api_guide.md) on how to sign your requests. Using expired or invalid `terminal_key` to sign your requests will result in illegal signature responses (response code: `ILLEGAL_SIGN`).

We recommend that each terminal check in before the first transaction of the day.

## API

### General Information

Target | Protocol | Method | Content Type
------ | ----- | ----- | -----
`/terminal/checkin` | `HTTPS` | `POST` | `application/json`

### Request Parameters

Field | Type | Required | Description
------ | ----- | -----| -----
terminal_sn | String | Y | Terminal serial number
device_id | String | Y | Device identification, such as IMEI of an Android device or `indentifierForVendor` of an iOS device.
os_info | String | N | Terminal OS information, such as: Android 6.0.
sdk_version | String | N | Upay SDK version

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