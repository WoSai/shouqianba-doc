# Pay

### API Target

    {api_domain}/upay/v2/pay

### Request Paramters

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | -------| --- | ----
terminal_sn | Terminal serial number | String(32) | Y | Represents a unique identifier of a Upay terminal; returned in responses for requesting activation or check-in; number string no longer than 32 characters. | "00101010029201012912"
client_sn* | Order serial number in client system | String(32) | Y | Must be unique in client system; no longer than 32 characters. | "18348290098298292838"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Number string no longer than 10 characters; please use bank transfer for larger amount. | "1000"
payway | Payment service provider | String | N | Number string; if present, Upay server will not use `dynamic_id` to decide payment service provider | "1"
dynamic_id | Content of the payment barcode | String(32) | Y | No longer than 32 characters | "130818341921441147"
subject | Subject or brief summary of the transaction | String(64) | Y | No longer than 64 characters | "Pizza"
operator | Operator of the transaction | String(32) | Y | No longer than 32 characters | "Obama"
description | Detailed description of the transaction | String(256) | N | No longer than 256 characters | "Chicago style pizza, extra cheese"
longitude | Longitude of the transaction location | String | N | Must be used simultaneously with `latitude` | "121.615459404"
latitude | Latitude of the transaction location | String| N | Must be used simultaneously with `longitude` | "31.4056441552"
device_id | Terminal device's unique identifier | String(32) | N | No longer than 32 characters | Such as IMEI of an Android device or `indentifierForVendor` of an iOS device
extended | Extended paramters | JSON object | N | Special parameters that will be passed along to payment providers by Upay server. 24 fields at most, with keys no longer than 64 characters and values no longer than 256 characters. | { "goods_tag": "beijing"}
reflect | Reflect parameter | String(64) | N | Anything that the client wants Upay server to send back. Can be used by client's ERP system to relate to its own order or to integrate with any additional business process. | { "tips": "200" }
notify_url| Callback URL | String(128) | N | If provided, Upay server will also send payment result to the callback URL | www.baidu.com

<font color="red"><b>*: <code>client_sn</code> must be unique in the client system. Also, if a payment transaction fails, to retry, new transaction must be submitted with a new <code>client_sn</code>. Otherwise Upay system will complain about duplicate <code>client_sn</code>.</b></font>

### Response Parameters

All following parameters refer to the fields in `biz_response`

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | -------| --- | ----
result_code | Request result code | String | Y | Result code of business response | "PAY_SUCCESS"
error_code | Error code of business response | String | N | See "Business Response Error Codes and Messages" | "INVALID_BARCODE"
error_message | Error message of business response | String | N | See "Business Response Error Codes and Messages" | "不合法的支付条码"
terminal_sn | Terminal serial number of the transaction | String(32) | Y | Used by Upay to identify a unique terminal | "01939202039923029"
sn | Upay order serial number | String(16) | Y | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | Y | Used by client to identify its own order | "7654321132"
trade_no | Order number in payment service provider system | String(64) | Y | Used by payment service provider to identify its own order | "2013112011001004330000121536"
status | The latest transaction status | String(32) | Y |  | "SUCCESS"
order_status | The latest order status | String(32) | Y |  | "PAID"
payway | Payment service provider | String(2) | Y | See "Payment Service Providers" | "1"
sub_payway | Payment method | String(2)| Y | See "Payment Methods" | "1"
payer_uid | The payer's user ID in payment service provider system | String(64) | N |  | "2801003920293239230239"
payer_login | The payer's login account in payment service provider system | String(128) | N |  | "134****3920"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y |  | "10000"
net_amount | Net amount of the order (the actual amount seller receives) in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Equals to total amount if the order has not been refunded, otherwise equals to `total amount - refund amount` | "0"
subject | Subject or brief summary of the transaction | String(64) | Y |  | "Pizza"
finish_time | Transaction finish time in Upay system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
channel_finish_time | Transaction finish time in payment service provider's system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
operator | Operator of the transaction | String(32) | Y |  | "Peter"
reflect	 | Anything that the client sent in `reflect` field of the request | String(64) | N |  | {"tips": "200"}

### Response Example - Failed

```json
{
    "result_code": "400",
    "error_code": "INVALID_PARAMS",
    "error_message": "total_amount金额为整数，长度不超过10位，以分为单位"
}
```

### Client Pseudo-code Example

```python
Sub pay(request, timeout):
  Try:
    response = POST (pay_url, request)
  Except NetworkConnectError ex:
    raise ("Network error", ex)
  Except NetworkIOError ex:
    return poll (request.client_sn, timeout)
  handle_response_error(response)
  biz_response = response.biz_response
  if biz_response.result_code == "PAY_SUCCESS":
    return ("Payment received", response)
  elif biz_response.result_code == "PAY_FAIL":
    return ("Payment failed and refunded, please retry", response)
  elif biz_response.result_code == "PAY_FAIL_ERROR":
    raise ("Payment error, please contact Upay customer service", response)
  elif biz_response.result_code == "FAIL":
    raise ("Payment failed and no transaction was made", response)
  else:
    return poll(request.client_sn, timeout)

Sub poll(client_sn, remaining_time):
  if remaining_time < 0:
    Try:
      response = POST(cancel_url, client_sn)
    Except NetworkError ex:
      raise "Order cancellation failed due to network error, please contact Upay customer service", ex
    handle_response_error(response)
    result_code = response.biz_response.result_code
    error_code = response.biz_response.error_code
    if result_code == "CANCEL_SUCCESS" or 
       result_code == "CANCEL_ABORT_SUCCESS":
      return ("Order expired and has been canceled", response)
    elif result_code == "FAIL" and error_code == "UPAY_ORDER_NOT_EXISTS":
      return ("Order expired and does not require cancellcation", response)
    else:
      raise ("Order cancellation error, please contact Upay customer service", response)
  else:
    stopwatch.start()
    Try
      response = POST(query_url, client_sn)
    Except NetworkError ex:
      sleep(5)
      return poll(client_sn, remaining_time – stopwatch.reading())
    handle_reponse_error(response)
    biz_response = response.biz_response
    if biz_response.result_code == "FAIL" and
       biz_response.error_code == "UPAY_ORDER_NOT_EXISTS":
      return ("Order payment failed and does not require cancellcation", response)
    elif biz_response.result_code == "SUCCESS":
      if biz_response.data.order_status == "CREATED":
        sleep(5)
        return poll(client_sn, remaining_time – stopwatch.reading())
      elif biz_response.data.order_status == "PAID":
        return ("Payment received", response)
      elif biz_response.data.order_status == "PAY_CANCELED":
        return ("Payment failed and refunded, please retry", response)
      elif biz_response.data.order_status == "PAY_ERROR":
        return ("Payment error, please contact Upay customer service", response)

Sub handle_response_error(response):
  if response.result_code == "400":
    raise ("Please contact terminal manufacturer", response.error_message)
  elif response.result_code == "500":
    raise ("Payment error, please contact Upay customer service", response.error_message)
```
