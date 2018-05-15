# Query

### API Target

	{api_domain}/upay/v2/query

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
result_code | Request result code | String | Y | Result code of business response | "SUCCESS"
error_code | Error code of business response | String | N | See "Business Response Error Codes and Messages" | "TRADE_TIMEOUT"
error_message | Error message of business response | String | N | See "Business Response Error Codes and Messages" | "交易超时自动撤单"
terminal_sn | Terminal serial number of the transaction | String(32) | Y | Used by Upay to identify a unique terminal | "01939202039923029"
sn | Upay order serial number | String(16) | Y | Unique order serial number in Upay system | "7892259488292938"
client_sn | Order serial number in client system | String(32) | Y | Used by client to identify its own order | "7654321132"
trade_no | Order number in payment service provider system | String(64) | Y | Used by payment service provider to identify its own order | "2013112011001004330000121536"
status | The latest transaction status | String(32) | Y |  | "SUCCESS"
payway | Payment service provider | String(2) | Y | See "Payment Service Providers" | "2"
payway_name | Payment service name | String(128) | Y |  | "支付宝"
order_status | The latest order status | String(32) | Y |  | "PAID"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y |  | "10000"
net_amount | Net amount of the order (the actual amount seller receives) in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Equals to total amount if the order has not been refunded, otherwise equals to `total amount - refund amount` | "0"
subject | Subject or brief summary of the transaction | String(64) | Y |  | "Pizza"
finish_time | Transaction finish time in Upay system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
channel_finish_time | Transaction finish time in payment service provider's system | String(13) | Y | Unix Timestamp in milliseconds | "1449646835244"
operator | Operator of the transaction | String(32) | Y |  | "Peter"
payment_list | Preferential information |JSON | N |value of 'payment_list' is array，each elements includes 2 fields, 'type' as
preferential name , amount_total as preferential amount |"payment_list": [{"type": "BANKCARD_DEBIT","amount_total": "1"},{"type": "DISCOUNT_CHANNEL_MCH","amount_total": "100"}]

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

### Response example - Success

```json
    {
      "biz_response": {
        "result_code": "SUCCESS",
        "data": {
          "client_tsn": "726d47ded14818c906cd1a006d4e5050",
          "store_id": "test",
          "subject": "test",
          "payway": "2",
          "description": "[{\"id\":\"\",\"name\":\"未命名商品\",\"num\":\"1\",\"price\":\"3000\"}]\n",
          "payment_list": [ {
          "type": "BANKCARD_DEBIT",
          "amount_total": "1"
        },
        {
          "type": "DISCOUNT_CHANNEL_MCH",
          "amount_total": "100"
        }],
          "client_sn": "test",
          "operator": "test",
          "sub_payway": "1",
          "order_status": "PAID",
          "total_amount": "300000",
          "ctime": "1498446309605",
          "sn": "7895259867120667",
          "net_amount": "0",
          "terminal_id": "a2369b8b-546f-42e1-baec-e1d54690bab8",
          "status": "SUCCESS"
        }
      },
      "result_code": "200"
}
```
