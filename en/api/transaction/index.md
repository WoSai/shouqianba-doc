# Upay Web API Reference - Transaction

## API Response

### Response Fields

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

### Response Examples

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