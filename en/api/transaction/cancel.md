# Cancel

To avoid business conflict, if the client cannot get successful payment result or any response from Upay, it should send a cancel request to Upay to cancel the failed order.

### API Target
	
	{api_domain}/upay/v2/cancel

### Request Paramters

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | ------- | --- | ----
terminal_sn | Terminal serial number | String(32) | Y | Represents a unique identifier of a Upay terminal; returned in responses for requesting activation or check-in; number string no longer than 32 characters. | "00101010029201012912"
sn | Upay order serial number | String(16) | N | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | N | Must be unique in client system; no longer than 32 characters. | "18348290098298292838"

<font color="red"><b>Note: Either <code>sn</code> or <code>client_sn</code> must be presented in the request, otherwise the request is invalid; if both are presented, <code>sn</code> will be used to identify the order.</b></font>

### Response Paramters

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
payway  | Payment service provider |  String(32)   | Y  |  |  "3"
payway_name  |  Payment service provider name |  String(128)   | Y  |   |  "微信"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y |  | "10000"
net_amount | Net amount of the order (the actual amount seller receives) in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Equals to total amount if the order has not been refunded, otherwise equals to `total amount - refund amount` | "0"
subject | Subject or brief summary of the transaction | String(64) | Y |  | "Pizza"
finish_time | Transaction finish time in Upay system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
channel_finish_time | Transaction finish time in payment service provider's system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
operator | Operator of the transaction | String(32) | Y |  | "Peter"

### Response Example - Success
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
		"payway_name": "微信",
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
    
### Response Example - Failed

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

### Questions & Answers

#### 1. when to call `cancel`?
`cancel` is used for unilateral orders, when the order status is unclear,  in order to avoid chaos, it is needed to call `cancel` to cancel the order.
