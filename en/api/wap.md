# Upay WAP API (In-App Web-based Payment)

For clients interested in developing mobile shopping websites, Upay provides a special WAP API to help them building mobile payment solutions within web browsers in apps such as Wechat and Alipay.


## Payment Scenario

- A customer visits your mobile website with a built-in web browser in a mobile payment app, such as Wechat;
- The customer initiate a payment (such as by clicking a pay button on your website), and the mobile payment client app will pop up a confirmation to ask for payment authorization;
- The customer confirm the payment (a password may be required), and your website will display the payment result to the customer.

## Before Integration

Before starting your integration process, please contact our sales representatives and technical support for implementation suggestions and provide your business information to apply for a set of vendor and merchant accounts for development and testing. The Wechat related information you provide must match those of your Wechat official account.

**Note:**

`terminal_sn` and `terminal_key` (your server can be viewed as a terminal in this case) are required to sign each of your WAP API request. To get your `terminal_sn` and `terminal_key`, your service needs to initiate an activation request once and only once for each terminal. Please refer to our [documentation](https://wosai.gitbooks.io/shouqianba-doc/content/en/api/admin_en.html) for detailed explanation of the activation process.

## API Target

     https://qr.shouqianba.com/gateway
     
## Request Method

	GET
***Accessing by using 302 jump  https://qr.shouqianba.com/gateway?QUERY***

#### Request Parameters

Field | Description | Type | Required | Note | Example
------ | ----- | ----- | ----- |----- | -----
terminal_sn | Terminal serial number | String(32) | Y | Represents a unique identifier of a Upay terminal; returned in responses for requesting activation or check-in; number string no longer than 32 characters. | "23420593829"
client_sn | Order serial number in client system | String(32) | Y | Must be unique in client system; no longer than 32 characters. | "18348290098298292838"
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Number string no longer than 10 characters; please use bank transfer for larger amount. | "1000"
subject | Subject or brief summary of the transaction | String(64) | Y | No longer than 64 characters | "pizza"
payway | Payment service provider | String | N | See "Payway" in "Appendix" section. Default is "3" (Wechat) | "3"
operator | Operator of the transaction | String(32) | Y |  | "Obama"
description | Detailed description of the transaction | String(256) | N | No longer than 256 characters | "Chicago style pizza, extra cheese"
longitude | Longitude of the transaction location | String | N | Must be used simultaneously with `latitude` | "121.615459404"
latitude | Latitude of the transaction location | String | N | Must be used simultaneously with `longitude` | "31.4056441552"
extended | Extended paramters | String(256) | N | Special parameters that will be passed along to payment providers by Upay server. 24 fields at most, with keys no longer than 64 characters and values no longer than 256 characters. | 
reflect | Reflect parameter | String(64) | N | Anything that the client wants Upay server to send back. Can be used by client's ERP system to relate to its own order or to integrate with any additional business process. | { "tips" : "100"}
notify_url | Callback URL | String(128) | N | If provided, Upay server will also send payment result to the callback URL. <font color="red" style="font-weight: bold;">If payment succeeds, callbacks will be carried out in 1s, 5s, 30s, and 600s. This callback serves only as a fallback when query API is not available, and should not replace query as a method to get latest payment result.</font> | "https://www.shouqianba.com"
return_url | The URL you wish to load when the payment process finishes. | String(128) |	 Y | This is the URL which Wechat client app will load after customer confirm their payment. | "https://www.shouqianba.com"
sign | Request signature | String(32) | Y | See "Request Signature" in "Appendix" section | 

#### Return URL Callback Parameters

-  After the WAP payment process finishes, Upay will ask the web browser to redirect back to the URL which is specified by `return_url` in previous request, with additional callback parameters containing the payment result .

-  Please use query result or the callback result received in your notify_url as final payment result. The result in the return URL callback parameters should be deemed as an intermediate payment result .

-  Polling time should be 100-120 seconds, the interval between each query should be once every 2 seconds in the first 30 seconds，and then once every 5 seconds .


Field | Description | Type | Required | Note | Example
------ | ----- | -----| ----- | ----- | -----
is_success | Request acknowledgement | String(1) | Y | Represents whether Upay server accepts this request; does not represent transaction result | "T"
error_code | Error code | String | N | Returned only when `is_success` is "F" | See "Error Codes" in "Appendix" section
error_message | Error message | String | N | Returned only when `is_success` is "F" | See "Error Codes" in "Appendix" section
terminal_sn | Terminal serial number | String(32) | Y | Represents a unique identifier of a Upay terminal; returned in responses for requesting activation or check-in; number string no longer than 32 characters. | "23420593829"
sn | Upay order serial number | String(16) | Y | Unique order serial number in Upay system | "7892259488292938"
trade_no | Order number in payment service provider system | String(64)| Y | Used by payment service provider to identify its own order | "2013112011001004330000121536"
client_sn | Order serial number in client system | String(32) | Y | Must be unique in client system; no longer than 32 characters. | "18348290098298292838"
status | The latest transaction status | String | N | Represents whether the transaction succeeds | "SUCCESS"
result_code | Result code of transaction | String(64)| N | Returned only when `status` is "FAIL" | See "Result Codes" in "Appendix" section
result_message | Result message of transaction | String | N | Returned only when `status` is "FAIL" | See "Result Codes" in "Appendix" section
total_amount | Total amount of the order in <font color="red" style="font-weight: bold;">cents</font> | String(10) | Y | Number string no longer than 10 characters; please use bank transfer for larger amount. | "1000"
subject | Subject or brief summary of the transaction | String(64) | Y | No longer than 64 characters | "pizza"
operator | Operator of the transaction | String(32) | Y |  | "Obama"
reflect | Reflect parameter | String(64) | N | Anything that the client wants Upay server to send back. Can be used by client's ERP system to relate to its own order or to integrate with any additional business process. | { "tips" : "100"}
sign | Request signature | String(32) | Y | See "Request Signature" in "Appendix" section | 

## Appendix

### Payway 

Value | Definition
----- | -----
1 | Alipay
3 | Wechat
6 | QQ


### Error Codes

error_code | error_message
----- | -----
INVALID_PARAMS | 参数错误
INVALID_TERMINAL | 终端错误
ILLEGAL_SIGN | 签名错误
UNKNOWN_SYSTEM_ERROR | 系统错误
INVALID_BARCODE | 条码错误
INSUFFICIENT_FUND | 账户金额不足
EXPIRED_BARCODE | 过期的支付条码
BUYER_OVER_DAILY_LIMIT | 付款人当日付款金额超过上限
BUYER_OVER_TRANSACTION_LIMIT | 付款人单笔付款金额超过上限
SELLER_OVER_DAILY_LIMIT | 收款账户当日收款金额超过上限
TRADE_NOT_EXIST	| 交易不存在
TRADE_HAS_SUCCESS | 交易已被支付
SELLER_BALANCE_NOT_ENOUGH | 卖家余额不足
REFUND_AMT_NOT_EQUAL_TOTAL | 退款金额无效
TRADE_FAILED | 交易失败
UNEXPECTED_PROVIDER_ERROR | 不认识的支付通道
TRADE_TIMEOUT | 交易超时自动撤单
ACCOUNT_BALANCE_NOT_ENOUGH | 商户余额不足
CLIENT_SN_CONFLICT | client_sn在系统中已存在
UPAY_ORDER_NOT_EXISTS | 订单不存在
REFUNDABLE_AMOUNT_NOT_ENOUGH | 订单可退金额不足
UPAY_TERMINAL_NOT_EXISTS | 终端号在交易系统中不存在
UPAY_TERMINAL_STATUS_ABNORMAL | 终端未激活
UPAY_CANCEL_ORDER_NOOP | 无效操作，订单已经是撤单状态了
UPAY_CANCEL_INVALID_ORDER_STATE | 当前订单状态不可撤销
UPAY_REFUND_ORDER_NOOP | 无效操作，本次退款退款已经完成了
UPAY_REFUND_INVALID_ORDER_STATE | 当前订单状态不可退款
UPAY_STORE_OVER_DAILY_LIMIT | 商户日收款额超过上限
UPAY_TCP_ORDER_NOT_REFUNDABLE | 订单参与了活动并且无法撤销

###  Result Codes

result_code | result_message | Explanation
----- | ----- | -----
get_brand_wcpay_request:ok |get_brand_wcpay_request:ok | Payment succeeded
get_brand_wcpay_request:fail | get_brand_wcpay_request:fail | Payment failed
get_brand_wcpay_request:cancel |get_brand_wcpay_request:cancel | Payment canceled by customer

**Note:**

Generally, any result code other than `get_brand_wcpay_request:ok` can be treated as a failed payment.

### Request Signature

#### Instruction

The following steps explains how to generate request signature:

1. Filter

	Make a copy of all your request parameters, remove `sign`, `sign_type` and any field that is of raw type (such as file byte stream) from the copy.

2. Sort

	Sort the parameters you get from step 1 by the first letter of the key into ascending alphabetic (ASCII) order. If the first letter of two or more parameter keys are the same, then sort these parameters using the second letter of the keys and so on.
	
3. Concatenate

	Format the sorted parameters into key-value pairs like `key=value` then concatenate these pairs with `&` into a string;
	
	Append `&key={your_terminal_key}` at the end of the string;
	
	Generate an MD5 digest (all uppercase) of the string, and the digest is your request signature.
	
#### Example

For request paramter as follows:

	{
		"terminal_sn": "123",
		"client_sn": "abc",
		"total_amount": "1"
	}

Sort the parameters and concatenate them into the following string:

	paramStr = "client_sn=abc&terminal_sn=123&total_amount=1"
	
Append your terminal key (e.g. "19b820737ace6937a7808c") at the end:

	packageStr = paramStr + "&key=19b820737ace6937a7808c"
	
Generate request signature:

	sign = md5(packageStr).toUppercase()

###  Additional Notes

Please use redirect (302) to visit `https://m.wosai.cn/qr/gateway` inside the built-in browser of Wechat client app.

Example:

	<?php
		$paramsStr = "client_sn=test&operator=TEST&return_url=test&subject=TEST&terminal_sn=test&total_amount=3";
		$sign = strtoupper(md5($paramsStr.'&key=test'));
		$paramsStr = $paramsStr."&sign=".$sign;

		header("Location:https://m.wosai.cn/qr/gateway?".$paramsStr);
	?>
