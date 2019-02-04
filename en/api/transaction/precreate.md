# Pre-create

### API Target

    {api_domain}/upay/v2/precreate

### Request Paramters

Parameter | Description | Data Type | Required | Note | Example
--------- | ------ | ----- | -------| --- | ----
terminal_sn | Terminal serial number | String(32) | Y | Represents a unique identifier of a Upay terminal; returned in responses for requesting activation or check-in; number string no longer than 32 characters. | "00101010029201012912"
client_sn | Order serial number in client system | String(32) | Y | Must be unique in client system; no longer than 32 characters. | "18348290098298292838"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Number string no longer than 10 characters; please use bank transfer for larger amount. | "1000"
payway | Payment service provider | String | Y | Number string; if present, Upay server will not use `dynamic_id` to decide payment service provider | "1"
sub_payway	| Payment method | String | N | See "Payment Methods" | "3"
payer_uid | The payer's user ID in payment service provider system | String(64) | N | <font color="red" style="font-weight: bold;">Necessary when using WAP or Mini payment </font>，**`open_id` if using Wechat WAP payment** | "okSzXt_KIZVhGZe538aOKIMswUiI"
subject | Subject or brief summary of the transaction | String(64) | Y | No longer than 64 characters | "Pizza"
operator | Operator of the transaction | String(32) | Y | No longer than 32 characters | "Obama"
description | Detailed description of the transaction | String(256) | N | No longer than 256 characters | "Chicago style pizza, extra cheese"
longitude | Longitude of the transaction location | String | N | Must be used simultaneously with `latitude` | "121.615459404"
latitude | Latitude of the transaction location | String| N | Must be used simultaneously with `longitude` | "31.4056441552"
device_id | Terminal device's unique identifier | String(32) | N | No longer than 32 characters | Such as IMEI of an Android device or `indentifierForVendor` of an iOS device
extended | Extended paramters | JSON object | N | Special parameters that will be passed along to payment providers by Upay server. 24 fields at most, with keys no longer than 64 characters and values no longer than 256 characters. | { "goods_tag": "beijing"}
goods_details | Description of the goods | JSON | N | The value of goods_details is Array,each element contains five fields,including goods_id,goods_name,quantity,price,promotion_type,respectively represent the serial number of goods,the name of the goods,the number of the goods,commodity price,preferential type | "goods_details": [{"goods_id": "wx001","goods_name": "mac pro","quantity": 1,"price": 2,"promotion_type": 0},{"goods_id": "wx002","goods_name":"tesla","quantity": 1,"price": 2,"promotion_type": 1}]
reflect | Reflect parameter | String(64) | N | Anything that the client wants Upay server to send back. Can be used by client's ERP system to relate to its own order or to integrate with any additional business process. | { "tips": "200" }
notify_url| Callback URL | String(128) | N | If provided, Upay server will also send payment result to the callback URL | www.baidu.com

<font color="red"><b>*: <code>client_sn</code> must be unique in the client system. Also, if a payment transaction fails, to retry, new transaction must be submitted with a new <code>client_sn</code>. Otherwise Upay system will complain about duplicate <code>client_sn</code>.</b></font>

### Description of goods_details in request parameters

Parameter | Data Type | Length | Required | Description | Example
--------- | ------ | ----- | -------| --------- | ----
goods_id       | String | 32 | Y | The serial number of goods
goods_name     | String | 32 | Y | The name of the goods    | "ipad"
quantity       | Number | 10 | Y | The number of the goods  |  10
price          | Number | 9  | Y | Commodity price in cents | 2000
promotion_type | Number | 1  | Y | Preferential type,0 represents no discount,1 represents institution discount and will send the information to the payment institution

### Response Parameters

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
payway | Payment service provider | String(2) | Y | [Appendix-Payment Service Providers](https://doc.shouqianba.com/en/api/transaction/appendix.html) | "1"
payway_name | Payment service name | String(128) | Y |  | "支付宝"
sub_payway | Payment method | String(2)| Y | [Appendix-Payment Service Providers](https://doc.shouqianba.com/en/api/transaction/appendix.html) | "2"
qr_code | Payment QR code | String(128) | Y | "https://qr.alipay.com/bax00069h45nvvfc3tu9803a"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y |  | "10000"
net_amount | Net amount of the order (the actual amount seller receives) in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Equals to total amount if the order has not been refunded, otherwise equals to `total amount - refund amount` | "0"
subject | Subject or brief summary of the transaction | String(64) | Y |  | "Pizza"
operator | Operator of the transaction | String(32) | Y |  | "Peter"
reflect	 | Anything that the client sent in `reflect` field of the request | String(64) | N |  | {"tips": "200"}
wap_pay_request | The parameters needed to call WAP payment function, returned from payment service providers | String(1024) | N | Returned when using WAP payment

### Callback Parameters

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
payway | Payment service provider | String(2) | Y | [Appendix-Payment Service Providers](https://doc.shouqianba.com/en/api/transaction/appendix.html) | "1"
payway_name | Payment service name | String(128) | Y |  | "支付宝"
sub_payway | Payment method | String(2)| Y | [Appendix-Payment Service Providers](https://doc.shouqianba.com/en/api/transaction/appendix.html) | "2"
qr_code | Payment QR code | String(128) | Y | "https://qr.alipay.com/bax00069h45nvvfc3tu9803a"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y |  | "10000"
net_amount | Net amount of the order (the actual amount seller receives) in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Equals to total amount if the order has not been refunded, otherwise equals to `total amount - refund amount` | "0"
subject | Subject or brief summary of the transaction | String(64) | Y |  | "Pizza"
operator | Operator of the transaction | String(32) | Y |  | "Peter"
reflect	 | Anything that the client sent in `reflect` field of the request | String(64) | N |  | {"tips": "200"}
wap_pay_request | The parameters needed to call WAP payment function, returned from payment service providers | String(1024) | N | Returned when using WAP payment
payment_list | Preferential information |JSON | N |value of 'payment_list' is array，each elements includes 2 fields, 'type' as preferential name , amount_total as preferential amount |"payment_list": [{"type": "BANKCARD_DEBIT","amount_total": "1"},{"type": "DISCOUNT_CHANNEL_MCH","amount_total": "100"}]

### Response Example - Success

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
                "operator ": "张三丰",
                "subject ": "coca cola",
                "qr_code": "https://qr.alipay.com/bax8z75ihyoqpgkv5f"
            }
        }
}
```

### Questions & Answers

#### 1.Take the initiative to query the order status after calling the `precreate` successfully
Once you get the successful result(`biz_response.result_code="PRECREATE_SUCCESS" or biz_response.data.order_status="CREATED"`), then just send polling requests to the Upay server.
The effective payment time of precreate orders is about 4 minutes, if it times out without payment, upay gateway will automatically cancel the oreder, so please control the polling time,  we suggest that every 2s as a polling interval in the first 30s ,then 5s each time. 

