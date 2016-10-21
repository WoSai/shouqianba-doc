# Log Upload

Though not required, we recommend each terminal log its own activities and upload its log file each day after check-in. Terminal log is an important asset for debugging all sorts of terminal errors and failures.

The terminal may delete the log file after a successful upload. We strongly recommend developers to keep log entries concise and rotate the log file on daily basis, so that log files are small enough to be uploaded without interfering other terminal functionalities.

Use `terminal_sn` and `terminal_key` to sign your log upload requests just like other types of requests.

## API

### General Information

Target | Protocol | Method | Content Type
------ | ----- | ----- | -----
`/terminal/uploadLog ` | `HTTPS` | `POST` | `application/json`

### Request Parameters

The body of the request is the log file's binary stream compressed using gzip.

### Response Parameters

Example:

```json
{
    "result_code": "200",
    "error_code": "SUCCESS",
    "error_message": "ok"
}
```

`result_code` is not `"200"` if request fails.