# Upay Web API Reference - Transaction

## API Response

#### Response Fields

Field | Description | Possible Values | Note
--------- | ------ | ----- | -------
result_code | Request result code | 200, 400, 500 | 200: success; 400: client error; 500: server error
error_code | Request error code | String. See "Request Error Codes and Messages" | Returned only when request **fails**
error_message | Request error message | String. See "Request Error Codes and Messages" | Returned only when request **fails**
biz_response | Business response data | Object | Returned only when request **succeeds**
biz_response.result_code | Result code of business response | String. See "Business Response Result Codes" |
biz_response.error_code | Error code of business response | String. See "Business Response Error Codes and Messages" | Returned only when **error occurs** during business process
biz_response.error_message | Error message of business response | String. See "Business Response Error Codes and Messages" | Returned only when **error occurs** during business process
biz_response.data.sn | Upay order serial number | 16 digit number string | Returned only when business process is **successfully completed**
biz_response.data.client_sn | Order serial number in client system | String | Returned only when business process is **successfully completed**
biz_response.data.status | The latest transaction status | String. See "Transaction Status" | Returned only when business process is **successfully completed**
biz_response.data.order_status | The latest order status | String. See "Order Status" | Returned only when business process is **successfully completed**
biz_response.data.payer_uid | The payer's user ID in payment service provider system | String | Returned only when business process is **successfully completed**
biz_response.data.pay_login | The payer's login account in payment service provider system | String | Returned only when business process is **successfully completed**
biz_response.data.trade_no | Order number in payment service provider system | String (32-128 characters) | Returned only when business process is **successfully completed**
biz_response.data.total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | Integer string | Returned only when business process is **successfully completed**
biz_response.data.net_amount | Net amount of the order in <font color="red" style="font-weight: bold;">cents</font> | Integer string | Equals to total amount if the order has not been refunded, otherwise equals to `total amount - refund amount`. Returned only when business process is **successfully completed**
biz_response.data.payway | Payment service provider | String. See "Payment Service Providers" | Including Alipay, Wechat Payment, Jingdong Pay, Baifubao and more to come. Returned only when business process is **successfully completed**.
biz_response.data.sub_payway | Payment method | String. See "Payment Methods" | Returned only when business process is **successfully completed**.
biz_response.data.finish_time | Transaction finish time in Upay system | String. Unix Timestamp in milliseconds | Returned only when business process is **successfully completed**.
biz_response.data.channel_finish_time | Transaction finish time in payment service provider's system | String. Unix Timestamp in milliseconds | Returned only when business process is **successfully completed**.
biz_response.data.terminal_sn | Terminal serial number of the transaction | String | Returned only when business process is **successfully completed**.
biz_response.data.store_id | Store ID of the transaction | String | Returned only when business process is **successfully completed**.
biz_response.data.subject | Subject or brief summary of the transaction | String | Returned only when business process is **successfully completed**.
biz_response.data.description | Detailed description of the transaction | String | Returned only when business process is **successfully completed**.
biz_response.data.reflect | Anything that the client sent in `reflect` field of the request | String(64) | Returned only when business process is **successfully completed**.
biz_response.data.operator  | Operator of the transaction | String | Returned only when business process is **successfully completed**.

#### Response Examples

1. Pay Success

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "PAY_SUCCESS",
            "data": {
                "sn": "7894259244067349",
                "client_sn": "12345677767776",
                "status": "SUCCESS",
                "payway": "3",
                "sub_payway": "1",
                "order_status": "PAID",
                "payer_uid": "okSzXt3uY4-W8fKBH7B4z8seMzBU",
                "trade_no": "1006101016201512081965934048",
                "total_amount": "1",
                "net_amount": "1",
                "finish_time": "1449569460430",
                "channel_finish_time": "1449569460000",
                "terminal_sn": "1122234-dewls02s2",
                "store_id": "00293001928483902",
                "subject": "Domino's Pizza",
                "operator": "Kan",
            }
        }
    }
    ```

2. Pay in Progress

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "PAY_IN_PROGRESS",
            "data": {
                "sn": "789200393929142",
                "client_sn": "230202l2-2-2002",
                "trade_no": "0019101002020384822248",
                "ctime": "2015-11-01 18:01:00",
                "status": "IN_PROG",
                "order_status": "CREATED",
                "total_amount ": "1000"
            }
        }
    }
    ```

3. Pay Failed

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "PAY_FAIL",
            "error_code": "EXPIRED_BARCODE",
            "error_message": "过期的支付条码",
            "data": {
                "sn": "7894259244067344",
                "client_sn": "12345677767776",
                "status": "FAIL_CANCELED",
                "payway": "3",
                "sub_payway": "1",
                "order_status": "PAY_CANCELED",
                "total_amount": "1",
                "net_amount": "1",
                "finish_time": "1449569494595"
            }
        }
    }
    ```

4. Client Error - Terminal Not Exists

    ```json
    {
        "result_code": "400",
        "error_code": "TERMINAL_NOT_EXISTS",
        "error_message": "不存在这个终端",
    }
    ```

5. Client Error - Invalid Parameter

    ```json
    {
        "result_code": "400",
        "error_code": "INVALID_PARAMETER",
        "error_message": "client_sn不可以为空；total_amount不可以为负数",
    }
    ```

6. Server Error - Unknown

    ```json
    {
        "result_code": "500",
        "error_code": "UNKNOWN_SYSTEM_ERROR",
        "error_message": "未知的系统错误",
    }
    ```

7. Server Error - Maintenance in Progress

    ```json
    {
        "result_code": "500",
        "error_code": "MAINTENANCE_INPROGRESS",
        "error_message": "服务端正在升级维护，稍候5分钟",
    }
    ```

8. Refund Success

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "REFUND_SUCCESS",
            "data": {
                "sn": "7894259244067218",
                "client_sn": "12345677767776",
                "status": "SUCCESS",
                "payway": "3",
                "sub_payway": "1",
                "order_status": "REFUNDED",
                "trade_no": "2006101016201512080095793262",
                "total_amount": "1",
                "net_amount": "0",
                "finish_time": "1449563206776",
                "channel_finish_time": "1449563206632"
            }
        }
    }
    ```

9. Query Success

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "SUCCESS",
            "data": {
                    "sn": "7894259244096963",
                    "client_sn": "1234567",
                    "ctime": "1449036464229",
                    "status": "SUCCESS",
                    "order_status": "CANCELED",
                    "total_amount": "1",
                    "net_amount": "0",
                    "finish_time": "1449563206776",
                    "channel_finish_time": "1449563206632",
                    "payway": "3",
                    "sub_payway": "1"
            }
        }
    }
    ```

10. Pre-create Success

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "PRECREATE_SUCCESS",
            "data": {
                "sn": "7894259244096169",
                "client_sn": "765432112",
                "status": "IN_PROG",
                "order_status": "CREATED",
                "total_amount": "1",
                "net_amount": "1",
                "operator ": "Sam",
                "subject ": "coca cola",
                "qr_code": "https://qr.alipay.com/bax8z75ihyoqpgkv5f"
            }
        }
    }
    ```

11. Cancel Success

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "CANCEL_SUCCESS",
            "data": {
                "sn": "7894259244064831",
                "client_sn": "22345677767776",
                "status": "SUCCESS",
                "payway": "3",
                "sub_payway": "1",
                "order_status": "CANCELED",
                "total_amount": "1",
                "net_amount": "0",
                "finish_time": "1450090828489",
                "subject": "wx",
                "store_id": "49"
            }
        }
    }
    ```


## Payment APIs

#### General Note

* All responses are in <font color="red">**JSON**</font> format,please make sure to add Content-Type header and set its value to application/json for all requests.
* All requests must be UTF-8 encoded; all responses are UTF-8 encoded as well.
* All response fields' data type is <font color="red">**string**</font>.
* Amount of money is always in <font color="red">**cents**</font>.
* All requests and responses should be encoded in <font color="red">**UTF-8**</font>.
* api_domain：https://api.shouqianba.com

#### Pay

* API Target

        {api_domain}/upay/v2/pay

* Request Paramters

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

* Response Parameters

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

* Response Example - Failed

    ```json
    {
        "result_code": "400",
        "error_code": "INVALID_PARAMS",
        "error_message": "total_amount金额为整数，长度不超过10位，以分为单位"
    }
    ```

* Client Pseudo-code Example

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

#### Refund

* API Target

		{api_domain}/upay/v2/refund

* Request Paramters

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | ------- | --- | ----
terminal_sn | Terminal serial number | String(32) | Y | Represents a unique identifier of a Upay terminal; returned in responses for requesting activation or check-in; number string no longer than 32 characters. | "00101010029201012912"
sn | Upay order serial number | String(16) | N | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | N | Must be unique in client system; no longer than 32 characters. | "18348290098298292838"
refund_request_no | Refund request number | String(20) | Y | Used to prevent duplicate refund requests | "23030349"
operator | Operator of the transaction | String(32) | Y | No longer than 32 characters | "Obama"
refund_amount | Refund amount | String(10) | Y | Should be less or equal to the total amount of the order | "100"

<font color="red"><b>Note: Either <code>sn</code> or <code>client_sn</code> must be presented in the request, otherwise the request is invalid; if both are presented, <code>sn</code> will be used to identify the order.</b></font>

* Response Paramters

All following parameters refer to the fields in `biz_response`

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | -------| --- | ----
result_code | Request result code | String | Y | Result code of business response | "REFUND_SUCCESS"
error_code | Error code of business response | String | N | See "Business Response Error Codes and Messages" | "ACCOUNT_BALANCE_NOT_ENOUGH"
error_message | Error message of business response | String | N | See "Business Response Error Codes and Messages" | "商户余额不足"
terminal_sn | Terminal serial number of the transaction | String(32) | Y | Used by Upay to identify a unique terminal | "01939202039923029"
sn | Upay order serial number | String(16) | Y | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | Y | Used by client to identify its own order | "7654321132"
client_tsn | Refund transaction serial number | String(53) | Y | Indicates the most current transaction of this order. It is basically client_sn + '-' + refund_request_no | "7654321132-123"
trade_no | Order number in payment service provider system | String(64) | Y | Used by payment service provider to identify its own order | "2013112011001004330000121536"
status | The latest transaction status | String(32) | Y |  | "SUCCESS"
order_status | The latest order status | String(32) | Y |  | "PAID"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y |  | "10000"
net_amount | Net amount of the order (the actual amount seller receives) in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Equals to total amount if the order has not been refunded, otherwise equals to `total amount - refund amount` | "0"
subject | Subject or brief summary of the transaction | String(64) | Y |  | "Pizza"
finish_time | Transaction finish time in Upay system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
channel_finish_time | Transaction finish time in payment service provider's system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
operator | Operator of the transaction | String(32) | Y |  | "Peter"

* Response Example - Failed

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "FAIL",
            "error_code": "UPAY_REFUND_INVALID_ORDER_STATE",
            "error_message": "订单已全额退款,可退金额不足"
        }
    }
    ```

#### Query

* API Target

	    {api_domain}/upay/v2/query

* Request Paramters

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | ------- | --- | ----
terminal_sn | Terminal serial number | String(32) | Y | Represents a unique identifier of a Upay terminal; returned in responses for requesting activation or check-in; number string no longer than 32 characters. | "00101010029201012912"
sn | Upay order serial number | String(16) | N | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | N | Must be unique in client system; no longer than 32 characters. | "18348290098298292838"

<font color="red"><b>Note: Either <code>sn</code> or <code>client_sn</code> must be presented in the request, otherwise the request is invalid; if both are presented, <code>sn</code> will be used to identify the order.</b></font>

* Response Paramters

All following parameters refer to the fields in `biz_response`

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | -------| --- | ----
result_code | Request result code | String | Y | Result code of business response | "SUCCESS"
error_code | Error code of business response | String | N | See "Business Response Error Codes and Messages" | "TRADE_TIMEOUT"
error_message | Error message of business response | String | N | See "Business Response Error Codes and Messages" | "交易超时自动撤单"
terminal_sn | Terminal serial number of the transaction | String(32) | Y | Used by Upay to identify a unique terminal | "01939202039923029"
sn | Upay order serial number | String(16) | Y | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | Y | Used by client to identify its own order | "7654321132"
trade_no | Order number in payment service provider system | String(64) | Y | Used by payment service provider to identify its own order | "2013112011001004330000121536"
status | The latest transaction status | String(32) | Y |  | "SUCCESS"
order_status | The latest order status | String(32) | Y |  | "PAID"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y |  | "10000"
net_amount | Net amount of the order (the actual amount seller receives) in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Equals to total amount if the order has not been refunded, otherwise equals to `total amount - refund amount` | "0"
subject | Subject or brief summary of the transaction | String(64) | Y |  | "Pizza"
finish_time | Transaction finish time in Upay system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
channel_finish_time | Transaction finish time in payment service provider's system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
operator | Operator of the transaction | String(32) | Y |  | "Peter"

#### Cancel

To avoid business conflict, if the client cannot get successful payment result or any response from Upay, it should send a cancel request to Upay to cancel the failed order.

* API Target
	
	    {api_domain}/upay/v2/cancel

* Request Paramters

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | ------- | --- | ----
terminal_sn | Terminal serial number | String(32) | Y | Represents a unique identifier of a Upay terminal; returned in responses for requesting activation or check-in; number string no longer than 32 characters. | "00101010029201012912"
sn | Upay order serial number | String(16) | N | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | N | Must be unique in client system; no longer than 32 characters. | "18348290098298292838"

<font color="red"><b>Note: Either <code>sn</code> or <code>client_sn</code> must be presented in the request, otherwise the request is invalid; if both are presented, <code>sn</code> will be used to identify the order.</b></font>

* Response Paramters

All following parameters refer to the fields in `biz_response`

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | -------| --- | ----
result_code | Request result code | String | Y | Result code of business response | "CANCEL_SUCCESS"
error_code | Error code of business response | String | N | See "Business Response Error Codes and Messages" | "UPAY_TCP_ORDER_NOT_REFUNDABLE"
error_message | Error message of business response | String | N | See "Business Response Error Codes and Messages" | "订单7894259244061958参与了活动并且无法撤销"
terminal_sn | Terminal serial number of the transaction | String(32) | Y | Used by Upay to identify a unique terminal | "01939202039923029"
sn | Upay order serial number | String(16) | Y | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | Y | Used by client to identify its own order | "7654321132"
trade_no | Order number in payment service provider system | String(64) | Y | Used by payment service provider to identify its own order | "2013112011001004330000121536"
status | The latest transaction status | String(32) | Y |  | "SUCCESS"
order_status | The latest order status | String(32) | Y |  | "PAID"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y |  | "10000"
net_amount | Net amount of the order (the actual amount seller receives) in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Equals to total amount if the order has not been refunded, otherwise equals to `total amount - refund amount` | "0"
subject | Subject or brief summary of the transaction | String(64) | Y |  | "Pizza"
finish_time | Transaction finish time in Upay system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
channel_finish_time | Transaction finish time in payment service provider's system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
operator | Operator of the transaction | String(32) | Y |  | "Peter"

* Response Example - Failed

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "CANCEL_ERROR",
            "error_code": "UPAY_TCP_ORDER_NOT_REFUNDABLE",
            "error_message": "订单7894259244061958参与了活动并且无法撤销"
        }
    }
    ```

#### Revoke

After a certain amount of time after the order is paid, the client can issue a revoke request to ask for a full refund and avoid any service fee. The actual logic is the same as cancel, but it serves for a different purpose.

* API Target

	    {api_domain}/upay/v2/revoke

* Request Paramters

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | ------- | --- | ----
terminal_sn | Terminal serial number | String(32) | Y | Represents a unique identifier of a Upay terminal; returned in responses for requesting activation or check-in; number string no longer than 32 characters. | "00101010029201012912"
sn | Upay order serial number | String(16) | N | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | N | Must be unique in client system; no longer than 32 characters. | "18348290098298292838"

<font color="red"><b>Note: Either <code>sn</code> or <code>client_sn</code> must be presented in the request, otherwise the request is invalid; if both are presented, <code>sn</code> will be used to identify the order.</b></font>

* Response Paramters

All following parameters refer to the fields in `biz_response`

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | -------| --- | ----
result_code | Request result code | String | Y | Result code of business response | "CANCEL_SUCCESS"
error_code | Error code of business response | String | N | See "Business Response Error Codes and Messages" | "UPAY_TCP_ORDER_NOT_REFUNDABLE"
error_message | Error message of business response | String | N | See "Business Response Error Codes and Messages" | "订单7894259244061958参与了活动并且无法撤销"
terminal_sn | Terminal serial number of the transaction | String(32) | Y | Used by Upay to identify a unique terminal | "01939202039923029"
sn | Upay order serial number | String(16) | Y | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | Y | Used by client to identify its own order | "7654321132"
trade_no | Order number in payment service provider system | String(64) | Y | Used by payment service provider to identify its own order | "2013112011001004330000121536"
status | The latest transaction status | String(32) | Y |  | "SUCCESS"
order_status | The latest order status | String(32) | Y |  | "PAID"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y |  | "10000"
net_amount | Net amount of the order (the actual amount seller receives) in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Equals to total amount if the order has not been refunded, otherwise equals to `total amount - refund amount` | "0"
subject | Subject or brief summary of the transaction | String(64) | Y |  | "Pizza"
finish_time | Transaction finish time in Upay system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
channel_finish_time | Transaction finish time in payment service provider's system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
operator | Operator of the transaction | String(32) | Y |  | "Peter"

* Response Example - Failed

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "CANCEL_ERROR",
            "error_code": "UPAY_TCP_ORDER_NOT_REFUNDABLE",
            "error_message": "订单7894259244061958参与了活动并且无法撤销"
        }
    }
    ```

#### Pre-create

* API Target

		{api_domain}/upay/v2/precreate

* Request Paramters

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | -------| --- | ----
terminal_sn | Terminal serial number | String(32) | Y | Represents a unique identifier of a Upay terminal; returned in responses for requesting activation or check-in; number string no longer than 32 characters. | "00101010029201012912"
client_sn | Order serial number in client system | String(32) | Y | Must be unique in client system; no longer than 32 characters. | "18348290098298292838"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Number string no longer than 10 characters; please use bank transfer for larger amount. | "1000"
payway | Payment service provider | String | Y | Number string; if present, Upay server will not use `dynamic_id` to decide payment service provider | "1"
sub_payway	| Payment method | String | N | See "Payment Methods" | "3"
payer_uid | The payer's user ID in payment service provider system | String(64) | N | **`open_id` if using Wechat WAP payment** | "okSzXt_KIZVhGZe538aOKIMswUiI"
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

* Response Parameters

All following parameters refer to the fields in `biz_response` and `biz_response.data`

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | -------| --- | ----
result_code | Request result code | String | Y | Result code of business response | "PRECREATE_SUCCESS"
error_code | Error code of business response | String | N | See "Business Response Error Codes and Messages" | "UNEXPECTED_PROVIDER_ERROR"
error_message | Error message of business response | String | N | See "Business Response Error Codes and Messages" | "不认识的支付通道"
sn | Upay order serial number | String(16) | Y | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | Y | Used by client to identify its own order | "7654321132"
trade_no | Order number in payment service provider system | String(64) | Y | Used by payment service provider to identify its own order | "2013112011001004330000121536"
status | The latest transaction status | String(32) | Y |  | "CREATED"
order_status | The latest order status | String(32) | Y |  | "CREATED"
payway | Payment service provider | String(2) | Y | See "Payment Service Providers" | "1"
sub_payway | Payment method | String(2)| Y | See "Payment Methods" | "2"
qr_code | Payment QR code | String(128) | Y | "https://qr.alipay.com/bax00069h45nvvfc3tu9803a"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y |  | "10000"
net_amount | Net amount of the order (the actual amount seller receives) in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Equals to total amount if the order has not been refunded, otherwise equals to `total amount - refund amount` | "0"
subject | Subject or brief summary of the transaction | String(64) | Y |  | "Pizza"
operator | Operator of the transaction | String(32) | Y |  | "Peter"
reflect	 | Anything that the client sent in `reflect` field of the request | String(64) | N |  | {"tips": "200"}
wap_pay_request | The parameters needed to call WAP payment function, returned from payment service providers | String(1024) | N | Returned when using WAP payment

## Appendix

#### Request Error Codes and Messages

- `error_code` is the error code for the **request** (not transaction)
- `error_message` is the corresponding error description (currently Chinese only)
- `error_code` and `error_message` are returned only when `result_code` is not 200

result_code | error_code | error_message 
--------- | ------ | -----  
**400** | INVALID_PARAMS | 参数错误
**400** | INVALID_TERMINAL | 终端错误
**400** | ILLEGAL_SIGN | 签名错误
**500** | UNKNOWN_SYSTEM_ERROR | 系统错误

#### Business Response Result Codes

`biz_response.result_code` indicates the result of requested transaction (pay, pre-create, refund, cancel, query, etc.). The possible values can be devided into the following categories:

- **SUCCESS**: The transaction is successfully completed;
- **FAIL**: The transaction has failed for some reason;
- **INPROGRESS**: The transaction is still in progress;
- **ERROR**: Some error occurred during the transaction and the result is unknown

Below is a complete list of `biz_response.result_code`s: 

Value | Description | Indication
--------- | ------ | -----  
<font color="red">PAY_SUCCESS</font> | Payment is successful | Payment is guaranteed to be successful
<font color="red">PAY_FAIL</font> | Payment has failed and the order has been canceled | Please retry with a new order
<font color="red">PAY_FAIL_ERROR</font>	 | Payment has failed and the transaction's result is unknown | Please contact Upay's customer support
<font color="green">CANCEL_SUCCESS</font> | The order has been successfully canceled | 	
<font color="green">CANCEL_ERROR</font> | Cancellation has failed and the transaction's result is unknown | Please contact Upay's customer support
<font color="green">CANCEL_ABORT_ERROR</font> | Trying to cancel an order being paid, but failed; the order status is unknown | Please contact Upay's customer support
<font color="green">CANCEL_ABORT_SUCCESS</font> | Trying to cancel an order being paid and succeeded | 
<font color="pink">REFUND_SUCCESS</font> | Refund is successful | 
<font color="pink">REFUND_ERROR</font> | Refund has failed and the transaction's result is unknown | Please contact Upay's customer support
<font color="blue">PRECREATE_SUCCESS</font> | Order pre-creation is successful | 
<font color="blue">PRECREATE_FAIL</font> | Order pre-creation has failed | 
<font color="red">SUCCESS</font> | Transaction (such as query) successful | 
<font color="red">FAIL</font> | Transaction failed (will not affect order status) | 

#### Business Response Error Codes and Messages

`biz_response.error_code` and `biz_response.error_message` (currently Chinese only) are returned when requested transaction fails. Possible values are as follows:

error_code |error_message
--------- | ------
INVALID_BARCODE | 条码错误
INSUFFICIENT_FUND | 账户金额不足
EXPIRED_BARCODE | 过期的支付条码
BUYER_OVER_DAILY_LIMIT | 付款人当日付款金额超过上限
BUYER_OVER_TRANSACTION_LIMIT | 付款人单笔付款金额超过上限
SELLER_OVER_DAILY_LIMIT | 收款账户当日收款金额超过上限
TRADE_NOT_EXIST | 交易不存在
TRADE_HAS_SUCCESS | 交易已被支付
SELLER_BALANCE_NOT_ENOUGH | 卖家余额不足
REFUND_AMT_NOT_EQUAL_TOTAL | 退款金额无效
TRADE_FAILED | 交易失败
UNEXPECTED_PROVIDER_ERROR | 不认识的支付通道
TRADE_TIMEOUT | 交易超时自动撤单
ACCOUNT_BALANCE_NOT_ENOUGH | 商户余额不足
CLIENT_SN_CONFLICT | client_sn在系统中已存在
UPAY_ORDER_NOT_EXIST | 订单不存在
REFUNDABLE_AMOUNT_NOT_ENOUGH | 订单可退金额不足
UPAY_TERMINAL_NOT_EXISTS | 终端号在交易系统中不存在
UPAY_TERMINAL_STATUS_ABNORMAL | 终端未激活
UPAY_CANCEL_ORDER_NOOP | 无效操作，订单已经是撤单状态了
UPAY_CANCEL_INVALID_ORDER_STATE | 当前订单状态不可撤销
UPAY_REFUND_ORDER_NOOP | 无效操作，本次退款退款已经完成了
UPAY_REFUND_INVALID_ORDER_STATE | 当前订单状态不可退款
UPAY_STORE_OVER_DAILY_LIMIT | 商户日收款额超过上限
UPAY_TCP_ORDER_NOT_REFUNDABLE | 订单参与了活动并且无法撤销

#### Order Status

Order status refers to current status of the order. The value of `biz_response.data.order_status` in responses may be one of the following:
	
Value | Description  
--------- | ------
<font color="green">CREATED</font> | <font color="red">Order has been created and is ready to be paid</font>
<font color="green">PAID</font> | <font color="red">Order has been successfully paid</font>
<font color="green">PAY_CANCELED</font> | <font color="red">Payment has failed and the order has been successfully canceled</font>
<font color="green">PAY_ERROR</font> | <font color="red">Payment has failed and the transaction's result is unknown</font>
<font color="green">REFUNDED</font> | <font color="red">The order has been fully refunded</font>
<font color="green">PARTIAL_REFUNDED</font> | <font color="red">The order has been partially refunded</font>
<font color="green">REFUND_ERROR</font>	 | <font color="red">Refund has failed and the transaction's result is unknown</font>
<font color="green">CANCELED</font> | <font color="red">The order has been successfully canceled by client</font>
<font color="green">CANCEL_ERROR</font>	 | <font color="red">Cancellation by client has failed and the transaction's result is unknown</font>

#### Transaction Status

Value | Description | Indication 
--------- | ------ | -----  
SUCCESS | Transaction successful (Upay and payment service provider) | The transaction is guaranteed to be successful
FAIL_CANCELED	| Transaction failed (Upay and payment service provider) | The transaction is guaranteed to be failed
FAIL_PROTOCOL_1 |	Protocol error | Small probability event. Upay cannot confirm the transaction result from payment service provider:<br><ul><li>In case of payment transaction, you are not guaranteed to receive the money even if customer's device receives successful result. Please **do not make the deal** and contact customer service immediately;</li><li>In case of refund transaction, you may **collect the returned item** even if customer's device does not receive any refund result. Please contact customer service immediately and we will make sure the refund is made.</li></ul>
FAIL_IO_1 | System IO Error | Same as FAIL_PROTOCOL_1
FAIL_PROTOCOL_2| Protocol error | Same as FAIL_PROTOCOL_1
FAIL_IO_2 | System IO Error | Same as FAIL_PROTOCOL_1
FAIL_PROTOCOL_3| Protocol error | Same as FAIL_PROTOCOL_1
FAIL_ERROR | After a failed payment transaction, Upay automatically initiates a cancallation but failed | Same as FAIL_PROTOCOL_1
CANCEL_ERROR | A cancallation requested by client is initiated but failed | Same as FAIL_PROTOCOL_1
REFUND_ERROR | A refund requested by client is initiated but failed | Same as FAIL_PROTOCOL_1	

<font style="color:red;"><b>Note: If Upay responds with <code>FAIL*</code> status, the transaction is guaranteed to be failed, no matter what result the customer gets. If the customer does pay successfully, Upay system will eventually make sure the cancellation of this transaction. Please do not make deal in this situation, and contact our customer service to avoid any possible financial loss.</b></font>

#### Payment Service Providers

The value of `biz_response.data.payway` in responses may be one of the following:

Value | Description  
--------- | ------
1 | Alipay
3 | Wechat Payment
4 | Baidu Wallet
5 | Jingdong Pay
6 | QQ Wallet

**Note: For QQ Wallet, pre-create is not supported.**


#### Payment Methods

The value of `biz_response.data.sub_payway` in responses may be one of the following:

Value | Description 
--------- | ------
1 | Barcode Payment
2 | QR Code Payment
3 | WAP Payment
