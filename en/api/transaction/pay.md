# Pay

### API Target

    {api_domain}/upay/v2/pay

### Request Paramters

Parameter | Description | Data Type | Required | Note | Example
------- | ------ | ----- | -----| ----- | -------------
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
payway_name | Payment service name | String(128) | Y |  | "支付宝"
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
payment_list | Preferential information |JSON | N |value of 'payment_list' is array，each elements includes 2 fields, 'type' as preferential name , amount_total as preferential amount |"payment_list": [{"type": "BANKCARD_DEBIT","amount_total": "1"},{"type": "DISCOUNT_CHANNEL_MCH","amount_total": "100"}]

### Details of payment_list
type |description
--------- | ------ 
HONGBAO_WOSAI |喔噻红包
HONGBAO_WOSAI_MCH |喔噻商户红包 免充值
DISCOUNT_WOSAI |喔噻立减
DISCOUNT_WOSAI_MCH |喔噻商户立减 免充值
DISCOUNT_CHANNEL |支付通道 折扣(立减优惠)
DISCOUNT_CHANNEL_MCH |折扣(立减优惠) 支付通道商户 免充值
DISCOUNT_CHANNEL_MCH_TOP_UP |折扣(立减优惠) 支付通道商户 充值
HONGBAO_CHANNEL |支付通道红包
HONGBAO_CHANNEL_MCH |支付通道商户红包 免充值
HONGBAO_CHANNEL_MCH_TOP_UP |支付通道商户红包 充值
CARD_PRE |支付通道商户预付卡
CARD_BALANCE |支付通道商户储值卡
BANKCARD_CREDIT |信用卡 银行卡
BANKCARD_DEBIT |储蓄卡 银行卡
WALLET_ALIPAY |余额 支付宝钱包
WALLET_ALIPAY_FINANCE |余额 余额宝
WALLET_WEIXIN |余额 微信钱包
ALIPAY_HUABEI |支付宝 花呗
ALIPAY_POINT  |支付宝 集分宝

### Response Example - Success

```json
{
       "result_code": "200",
       "biz_response": {
         "result_code": "PAY_SUCCESS",
         "data": {
           "sn": "7893259247405832",
           "client_sn": "w145206259311176",
           "client_tsn": "w145206259311176",
           "ctime": "1492506701411",
           "status": "SUCCESS",
           "payway": "3",
           "sub_payway": "1",
           "order_status": "PAID",
           "payer_login": "oyBevtwYm70JVPTFyGlvmKW3IO9U",
           "payer_uid": "oSTAxt7Rkjr7Jtk0vtf-cFWiHjcs",
           "trade_no": "4003262001201704187463804544",
           "total_amount": "101",
           "net_amount": "101",
           "finish_time": "1492506702864",
           "channel_finish_time": "1492506702000",
           "subject": "Apple iPhone 6s plus (A1699) 16G 玫瑰金色 移动联通电信4G手机",
           "store_id": "100ed809-af9a-11e5-9ec3-00163e00625b",
           "operator": "test",
           "payment_list": [
             {
               "type": "BANKCARD_DEBIT",
               "amount_total": "1"
             },
             {
               "type": "DISCOUNT_CHANNEL_MCH",
               "amount_total": "100"
             }
           ]
         }
       }
}
```
   
### Response Example - In progress

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

### Response Example - Pay Failed

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

## Questions & Answers

### 1.It will prompt `timeout` if there is no password to enter for 40s where using `pay` (BSC), then it is needed to use the `pay` interface to recall.

### 2. If you don't get the final order status of a successful payment(check it with `order_status`), then just invoke `query` to get it.
final status <a name="status"></a>
- PAID
- PAY_CANCELED
- REFUNDED
- PARTIAL_REFUNDED
- CANCELED

### 3.Suggest to add a query button to manually process possible unilateral orders.
if consumers pay successfully, but the terminal display a fail payment or unclear status, and the cashier can manually check the order status, if it is still not successful, then you need to contact to our customer service.


