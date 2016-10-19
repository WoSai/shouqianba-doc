# 接入流程

##申请接入资格

- 请联系我们工作人员洽谈接入事宜：陆斯维(13917862326), 藏建强(18005736061)

- 如果您需要英文服务洽谈接入事宜：Stanley Lu (+86 13917862326)

##提交资料

向申请接入资格的工作人员提供必要的资料，以获取您的服务商序列号（vendor_sn）和服务商密钥（vendor_key）和服务商平台,并在服务商平台生成服务商开发者的appid。

向工作人员提供商户资料，获取激活该商户终端的激活码,正式商户上线激活终端时需要商户自己去商户平台下生成需要的激活码。

至此，您已经可以开始使用收钱吧支付平台的API了。


##对接过程的业务流程

正常使用支付平台的交易功能，至少需要经历如下三个步骤：

1. 激活(一次)
2. 签到(可选)
3. 交易

## 对接过程的签名和需要注意的细节
* 接入域名(api_domain)：`https://api.shouqianba.com`
* 支付平台所有的API仅支持JSON格式的请求调用，请务必在HTTP请求头中加入`Content-Type: application/json`。
* 所有请求的body都需采用`UTF-8`编码，所有响应也会采用相同编码。
* 支付平台所有的API调用都需要签名验证。
* 采用应用层签名机制。将HTTP请求body部分的`UTF-8`编码字节流视为被签名的内容，不关心主体的格式。
* 签名人序列号(sn)和签名值(sign)放在HTTP请求头中，在接入服务中统一校验。
* 签名算法: sign = MD5( CONCAT( body + key ) )
* 签名首部: `Authorization: sn + " " + sign`
* 所有返回参数都为 <font color="red">**JSON**</font> 格式，请务必在HTTP请求头中加入Content-Type: application/json。
* 所有请求的body都需采用UTF-8编码，所有响应也会采用相同编码。
* 所有返回数据的类型都是 <font color="red">**字符串**</font>。
* 接口中所有涉及金额的地方都以 <font color="red">**分**</font> 为单位。


## 签名所用的sn和key

* 激活接口（/terminal/activate）的签名使用服务商序列号（vendor_sn）和（vendor_key）
* 其他接口均使用激活接口成功返回的终端号（terminal_sn）和终端密钥（terminal_key）

## Demo程序代码
* Python：[Demo的github项目链接=>] https://github.com/WoSai/shouqianba-webapi-pythondemo
* Java：[Demo的github项目链接=>] https://github.com/WoSai/shouqianba-webapi-javademo
* C#:[Demo的github项目链接=>] https://github.com/WoSai/shouqianba-webapi-csharpdemo


## 激活 

激活接口用于通过终端激活码（code）来获取终端号（terminal_sn）和终端密钥（terminal_key），以用于调用其他接口时的签名。

激活接口对于同一台终端，只需要调用一次。

![](../img/NotActivited.png?raw=true) 

## 签到

签到接口用于更新终端密钥（terminal_key）。出于安全考虑，开发者可以自行决定何时调用签到接口。终端密钥（terminal_key）一旦更新，旧密钥将会失效。
 注：签到后secret丢失怎么办？
   若因网络或其他原因未收到签到响应，可使用旧密钥再次发起签到请求。
   极特殊情况下，两次签到均未收到响应，请联系客服处理。

![](../img/Activited.png?raw=true) 

## 交易
支付平台提供如下类的交易功能：

* **支付(pay)**： B扫C支付模式，支付平台会自动根据支付码识别支付方式。
* **二维码预下单(precreate)**： C扫B当面付模式，调用接口生成二维码，消费者扫码完成支付，接口返回的是二维码内容，开发者需要自己生成二维码图片，预下单完成后需要主动发起轮询去获取支付状态。

* **退款(refund)**： 根据支付平台订单号完成退款，可支持同一笔订单分多次退款。

* **撤单(revoke)**： 当天的订单可以通过这个接口撤销。和退款接口相比，调用撤单接口在实现全额退款的同时不会向商户加收手续费。

* **冲正(cancel)**：当终端的支付流程在进行过程中如果调用支付接口没有返回成功，为了避免交易纠纷，需要调用自动撤单接口完成冲正。

* **查询(query)**： 获取订单的最新状态。




### 主要交易功能时序

#### 支付
pay接口何时发起轮询：如果pay同步返回的order_status不是[最终状态](#status)，就需要马上发起轮询。轮询时间可以在3~5s，总时长控制在40~50s左右。

	pay接口返回：biz_response.result_code是指一个动作的状态。biz_response.data罗列订单信息，biz_response.data.order_status是指订单状态。

![](../img/pay_sd.jpg?raw=true) 

#### 二维码预下单

precreate接口何时发起轮询：

	Web API接入：在得到预下单成功的结果后，即可向收钱吧服务器发起轮询请求。
	
		预下单成功:biz_response.result_code="PRECREATE_SUCCESS" or biz_response.data.order_status="CREATED")
		
		收钱吧目前所有预下单的订单有效支付时长约为4分钟，若超时仍未支付，收钱吧会自动取消该订单；因此轮询时间请控制在240秒左右。
		
		轮询的间隔建议为前30秒内2秒一次，之后5秒一次。
	
![](../img/precreate_sd.jpg?raw=true) 

#### 退款

![](../img/refund_sd.jpg?raw=true) 


## 接口响应

### 返回字段列表

字段名 | 字段含义 | 取值 | 备注
--------- | ------ | ----- | -------
result_code | 通讯响应码 |200，400，500|200：通讯成功；400：客户端错误；500:服务端错误
error_code  | 通讯错误码 |见附录《公共错误码》 |通讯 **失败** 的时候才返回
error_message  |通讯错误信息描述 |见附录《公共错误码》 |通讯 **失败** 的时候才返回
biz_response  | 业务响应数据 |数组结构 |通讯 **成功** 的时候才返回
biz\_response.result_code  | 业务执行响应码 |见附录《业务数据响应码列表》|
biz\_response.error_code  | 业务执行结果返回码 |见附录《业执行错误码列表》 |
biz\_response.error_message  |业务执行错误信息 |见附录《业务执行错误码列表》|业务执行成功才返回
biz\_response.data.sn  |收钱吧系统订单号 |16位数字 |业务执行 **成功** 才返回
biz\_response.data.client_sn  | 客户系统订单号 | |业务执行 **成功** 才返回
biz\_response.data.status  | 最新流水状态 |见附录《流水状态列表》 |业务执行 **成功** 才返回
biz\_response.data.order_status  | 最新订单状态 |见附录《订单状态列表》 |业务执行 **成功** 才返回
biz\_response.data.payer_uid  | 付款人在支付服务商系统中的用户ID |字符串 |业务执行 **成功** 才返回
biz\_response.data.pay_login | 付款人在支付服务商系统中的登录账户 |字符串 |业务执行 **成功** 才返回
biz\_response.data.trade_no  | 第三方支付通道订单号|32-128位 |业务执行 **成功** 才返回
biz\_response.data.total_amount  | 有效交易总金额 |整数，以 <font color="red">分</font> 为单位 |业务执行 **成功** 才返回
biz\_response.data.net\_amount  | 如果没有退款，这个字段等于total_amount。否则等于total\_amount减去退款金额 |整数，以分为单位 |业务执行 **成功** 才返回
biz\_response.data.payway  | 支付方式 |见附录《支付方式列表》 |业务执行 **成功**才返回。包括支付宝，微信，京东，百度钱包等，未来会不断增加
biz\_response.data.sub_payway  | 二级支付方式 |见附录《二级支付方式列表》 |业务执行 **成功**才返回
biz\_response.data.finish_time  | 本次业务操作在收钱吧系统中执行完成的时间 |时间戳 |业务执行 **成功**才返回
biz\_response.data.channel\_finish_time  | 本次业务操作在第三方支付通道执行完成的时间 |时间戳|业务执行 **成功**才返回
biz\_response.data.terminal_sn  | 发起本次业务请求的终端ID |字符串| 业务执行 **成功**才返回
biz\_response.data.store_id  | 本次交易所属门店 |字符串 |业务执行 **成功**才返回
biz_response.data.data.subject | 本次交易概述 |字符串 |业务执行 **成功**才返回
biz_response.data.description | 本次交易详情 |字符串 |业务执行 **成功**才返回
biz_response.data.reflect | 商户透传参数 |字符串 |业务执行 **成功**才返回
biz_response.data.operator  | 本次业务执行的操作员 |字符串 |业务执行 **成功**才返回

## 通讯错误返回实例

1. 客户端错误

    ```json
    {
        "result_code": "400",
        "error_code": "TERMINAL_NOT_EXISTS",
        "error_message": "不存在这个终端",
    }
    ```

2. 客户端错误

    ```json
    {
        "result_code": "400",
        "error_code": "INVALID_PARAMETER",
        "error_message": "client_sn不可以为空；total_amount不可以为负数",
    }
    ```

3. 服务端错误

    ```json
    {
        "result_code": "500",
        "error_code": "UNKNOWN_SYSTEM_ERROR",
        "error_message": "未知的系统错误",
    }
    ```

4. 服务端系统错误

    ```json
    {
        "result_code": "500",
        "error_code": "MAINTENANCE_INPROGRESS",
        "error_message": "服务端正在升级维护，稍候5分钟",
    }
    ```

## 附录	

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
<font color="red">PAY\_FAIL_ERROR</font>	|支付操作失败并且不确定第三方支付通道状态|联系客服
<font color="green">CANCEL_SUCCESS	|撤单操作成功	
<font color="green">CANCEL_ERROR	|撤单操作失败并且不确定第三方支付通道状态|联系客服
<font color="green">CANCEL\_ABORT_ERROR|	撤单操作试图终止进行中的支付流程，但是失败，不确定第三方支付通道的状态|联系客服
<font color="green">CANCEL\_ABORT_SUCCESS|	撤单操作试图终止进行中的支付流程并且成功	
<font color="pink">REFUND_SUCCESS|	退款操作成功	
<font color="pink">REFUND_ERROR|	退款操作失败并且不确定第三方支付通状态|联系客服
<font color="blue">PRECREATE_SUCCESS	|预下单操作成功
<font color="blue">PRECREATE_FAIL	|预下单操作失败	
<font color="red">SUCCESS|	操作成功
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

**目前qq钱包只支持b扫c**

### 二级支付方式列表

	biz_response.data.sub_payway

取值 |含义  
--------- | ------
1   |条码支付
2   |二维码支付
3   |wap支付
