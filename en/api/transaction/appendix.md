# Appendix

### Request Error Codes and Messages

- `error_code` is the error code for the **request** (not transaction)
- `error_message` is the corresponding error description (currently Chinese only)
- `error_code` and `error_message` are returned only when `result_code` is not 200

result_code | error_code | error_message 
--------- | ------ | -----  
**400** | INVALID_PARAMS | 参数错误
**400** | INVALID_TERMINAL | 终端错误
**400** | ILLEGAL_SIGN | 签名错误
**500** | UNKNOWN_SYSTEM_ERROR | 系统错误

### Business Response Result Codes

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

### Business Response Error Codes and Messages {#business_errors}

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

### Order Status

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

### The final status of order are below:
- PAID
- PAY_CANCELED
- REFUNDED
- PARTIAL_REFUNDED
- CANCELED

### Transaction Status

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

### Payment Service Providers

The value of `biz_response.data.payway` in responses may be one of the following:

payway | payway_name | note 
--------- | ------ | ---------
1 | 支付宝1.0 / Alipay-Local |`Alipay-Local` represents Overseas local Alipay wallet , else displays `支付宝1.0`
2 | 支付宝 | representing `Alipay`
3 | 微信 | representing `Wechat pay`
4 | 百度钱包 | representing `Baidu Wallet`
5 | 京东钱包 | representing `JD wallet`
6 | qq钱包 | representing `qq wallet`
7 | NFC支付 | representing `NFC`
8 | 拉卡拉钱包 | representing `Lakala wallet`
9 | 和包支付 | representing `China Mobile Wallet`
15 | 拉卡拉微信 | representing `Lakala wechat payment`
16 | 招商银行 | representing `China Merchants Bank`
17 | 银联云闪付 | representing `UnionPay`
18 | 翼支付 | representing `China Telecom Wallet`
19 | Weixin-Local | Oversea Wechat wallet displays `Weixin-Local`
20 | Alipay global | 
100 | 储值支付 | representing `Stored-value-card payment`
101 | 礼品卡 | representing `Gift card payment`


**Note: For QQ Wallet, pre-create is not supported.**


### Payment Methods

The value of `biz_response.data.sub_payway` in responses may be one of the following:

Value | Description 
--------- | ------
1 | Barcode Payment
2 | QR Code Payment
3 | WAP Payment
4 | Mini Payment
5 | APP Payment
6 | H5 Payment
