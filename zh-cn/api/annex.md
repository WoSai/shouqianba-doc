## 附录	

### 通讯响应码说明
200：通讯成功；400：客户端错误；500:服务端错误

error_code为本次通讯的错误码，error_message为对应的中文描述。当result_code不等于200的时候才会出现error_code和error_message。

result_code:400，客户端错误。客户端请求错误。INVALID_PARAMS/参数错误；INVALID_TERMINAL/终端错误；ILLEGAL_SIGN/签名错误。

result_code:500，服务端错误。收钱吧服务端异常。可提示“服务端异常，请联系收钱吧客服”。

### 通讯错误码列表

error_code为本次通讯的错误码

error_message为对应的中文描述

当result_code不等于200的时候才会出现

result_code |error_code | error_message 
--------- | ------ | -----  
**400** |INVALID_PARAMS	|参数错误
**400**|INVALID_TERMINAL	|终端错误
**400**|ILLEGAL_SIGN	|签名错误
**500**|	UNKNOWN_SYSTEM_ERROR	|系统错误

### 业务结果码列表

biz_response.result_code,状态分为：状态分为 SUCCESS、FAIL、INPROGRESS和 ERROR 四类，

SUCCESS: 本次业务执行成功

FAIL: 本次业务执行失败

INPROGRESS: 本次业务进行中

ERROR: 本次业务执行结果未知

具体到业务场景，分别有下列状态：

取值 |含义 | 下一步动作 
--------- | ------ | -----  
<font color="red">PAY_SUCCESS</font>|	支付操作成功	| 银货两讫
<font color="red">PAY_FAIL</font>	| 支付操作失败并且已冲正	| 重新进行一笔交易
<font color="red">PAY_IN_PROGRESS</font> | 支付中  | 调用查询接口查询
<font color="red">PAY\_FAIL_ERROR</font>	|支付操作失败并且不确定第三方支付通道状态|联系客服
<font color="red">PAY_\FAIL_IN_PROGRESS</font>  |支付操作失败中并且不清楚状态 |联系客服
<font color="green">CANCEL_SUCCESS</font>	|撤单操作成功	
<font color="green">CANCEL_ERROR</font>	|撤单操作失败并且不确定第三方支付通道状态|联系客服
<font color="green">CANCEL\_ABORT_ERROR</font>|	撤单操作试图终止进行中的支付流程，但是失败，不确定第三方支付通道的状态|联系客服
<font color="green">CANCEL\_ABORT_SUCCESS</font>|	撤单操作试图终止进行中的支付流程并且成功	
<font color="green">CANCEL\_IN_PROGRESS</font>  |撤单进行中调用查询接口进行查询
<font color="green">CANCEL\_ABORT_IN_PROGRESS</font> |撤单操作试图终止进行中的支付流程，但是撤单状态不明确
<font color="green">撤单交易状态不正确</font> |
<font color="green">撤单交易类型不正确</font> |
<font color="pink">REFUND_SUCCESS</font>|	退款操作成功	
<font color="pink">REFUND_ERROR</font>|	退款操作失败并且不确定第三方支付通状态|联系客服
<font color="pink">REFUND\_IN_PROGRESS</font>  |撤单进行中
<font color="pink">撤单交易类型不正确</font> | 
<font color="blue">PRECREATE_SUCCESS</font>	|预下单操作成功
<font color="blue">PRECREATE_FAIL</font>	|预下单操作失败	
<font color="blue">PRECREATE\_FAIL_ERROR</font> |预下单状态失败并且不确定第三方支付通道状态|联系客服
<font color="blue">PRECREATE_FAIL_IN_PROGRESS</font> |预下单状态失败并且不清楚状态|联系客服
<font color="blue">预下单状态错误</font> |
<font color="red">SUCCESS|	操作成功,**开发者根据返回的biz_response.data.order_status属性判断当前收钱吧订单的状态。**
<font color="red">FAIL	|操作失败（不会触发流程）

### 订单状态列表

biz_response.data.order_status	

取值 |含义  
--------- | ------
<font color="green">CREATED</font>	| <font color="red">订单已创建/支付中</font>
<font color="green">PAID</font>	    | <font color="red">订单支付成功</font>
<font color="green">PAY_CANCELED</font> |   <font color="red">支付失败并且已经成功充正</font>
<font color="green">PAY_ERROR</font>    |   <font color="red">支付失败，不确定是否已经成功充正</font>
<font color="green">REFUNDED</font>     |   <font color="red">已成功全额退款</font>
<font color="green">PARTIAL_REFUNDED</font>|    <font color="red">已成功部分退款</font>
<font color="green">REFUND_ERROR</font>	   |    <font color="red">退款失败并且不确定第三方支付通道的最终退款状态</font>
<font color="green">CANCELED</font>        |    <font color="red">客户端发起的撤单已成功</font>
<font color="green">CANCEL_ERROR</font>	   |    <font color="red">客户端发起的撤单失败并且不确定第三方支付通道的最终状态</font>
<font color="green">CANCEL_INPROGRESS</font>  | <font color="red">撤单进行中</font>
<font color="green">INVALID_STATUS_CODE</font> |<font color="red">无效的状态码</font>

**开发者根据返回的biz_response.data.order_status属性判断当前收钱吧订单的状态。**

### 哪些状态是订单最终状态
- PAID
- PAY_CANCELED
- REFUNDED
- PARTIAL_REFUNDED
- CANCELED


### 流水状态列表

取值 |含义 | 处理逻辑 
--------- | ------ | -----  
SUCCESS	|业务执行确认成功（即收钱吧后台和消费者端均成功）|银货两讫（无论是交货还是退货）
FAIL_CANCELED	|确认失败（即收钱吧后台和消费者端均失败）|银货两讫，（不交货或是不退货）
FAIL\_PROTOCOL_1|	协议错误| 小概率事件，失败但不确认消费者端状态<br>（即收钱吧后台强制认为是失败，但不确认消费者端是否同步失败）<br>（如果是收款，则不交货，但立即联系收钱吧客服，<br>（即算是消费者显示成功付款；<br>（如果是退货，则马上把货品回收，<br>（同时立即联系收钱吧客服，由收钱吧客服负责将钱款退回。
FAIL\_IO_1	|IO错误|	同上
FAIL\_PROTOCOL_2|	协议错误|同上	
FAIL\_IO_2	|IO错误|	同上
FAIL\_PROTOCOL_3|	协议错误	|同上
FAIL_ERROR	|支付流程失败后进行自动撤单操作，和支付通道通信成功，但是返回结果为撤单失败。|同上
CANCEL_ERROR	|撤单流程调用支付通道的撤单接口通信成功，但是返回结果为撤单失败。|同上
REFUND_ERROR	|退款流程调用支付通道的退款接口通信成功，但是返回的结果为退款失败。|同上

* 备注：当系统返回状态为 失败但不确认消费者端状态的时候，
一定要明确这笔订单是失败的，收钱吧会最终负责将这笔交易撤销。
不能交货或者退货，请立即进行人工介入，联系客服人员，以防遭受损失。


### 业务执行错误码列表

biz_response.error_code为业务执行结果返回码；biz_response.error_message为对应的中文描述,

当业务执行失败(即biz_response.result不为success)的时候，会返回如下内容

error_code |error_message
--------- | ------
INVALID_BARCODE	|条码错误
INSUFFICIENT_FUND|	账户金额不足
EXPIRED_BARCODE|	过期的支付条码
BUYER\_OVER\_DAILY_LIMIT	|付款人当日付款金额超过上限
BUYER\_OVER\_TRANSACTION_LIMIT|付款人单笔付款金额超过上限
SELLER\_OVER\_DAILY_LIMIT|	收款账户当日收款金额超过上限
TRADE\_NOT_EXIST|	交易不存在
TRADE\_HAS_SUCCESS	|交易已被支付
SELLER\_BALANCE\_NOT_ENOUGH|	卖家余额不足
REFUND\_AMT\_NOT\_EQUAL_TOTAL|退款金额无效
TRADE_FAILED	|交易失败
UNEXPECTED\_PROVIDER_ERROR|	不认识的支付通道
TRADE_TIMEOUT | 交易超时自动撤单
ACCOUNT\_BALANCE\_NOT\_ENOUGH | 商户余额不足
CLIENT\_SN\_CONFLICT	|client_sn在系统中已存在
UPAY\_ORDER\_NOT_EXISTS	|订单不存在
REFUNDABLE\_AMOUNT\_NOT\_ENOUGH | 订单可退金额不足
UPAY\_TERMINAL\_NOT\_EXISTS | 终端号在交易系统中不存在
UPAY\_TERMINAL\_STATUS\_ABNORMAL | 终端未激活
UPAY\_CANCEL\_ORDER\_NOOP | 无效操作，订单已经是撤单状态了
UPAY\_CANCEL\_INVALID\_ORDER\_STATE | 当前订单状态不可撤销
UPAY\_REFUND\_ORDER\_NOOP | 无效操作，本次退款退款已经完成了
UPAY\_REFUND\_INVALID\_ORDER\_STATE | 当前订单状态不可退款
UPAY\_STORE\_OVER\_DAILY\_LIMIT | 商户日收款额超过上限
UPAY\_TCP\_ORDER\_NOT\_REFUNDABLE | 订单参与了活动并且无法撤销


### 支付方式列表

	biz_response.data.payway

取值 |含义  
--------- | ------
1	|支付宝
3	|微信
4	|百付宝
5   |京东
6   |qq钱包


### 二级支付方式列表

	biz_response.data.sub_payway

取值 |含义  
--------- | ------
1   |条码支付
2   |二维码支付
3   |wap支付
