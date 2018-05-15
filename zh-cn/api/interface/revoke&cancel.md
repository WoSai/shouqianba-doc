# 自动撤单

当终端的支付流程在进行过程中如果调用支付接口没有返回成功，为了避免交易纠纷，需要调用自动撤单接口完成冲正。

## 入口
	
	    {api_domain}/upay/v2/cancel

## 签名验证

  请参考[签名机制文档](https://doc.shouqianba.com/zh-cn/api/sign.html)
  
## 请求参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
terminal_sn|	收钱吧终端ID|	String(32)|	Y|	收钱吧终端ID |	"00101010029201012912"
sn|	收钱吧系统订单号	|String(16)|	N|	收钱吧系统唯一订单号|	"7894259244061958"
client_sn	|商户自己的订单号|	String(64)|	N	|商户自己订号| "2324545839"

<p style="color:red; font-weight: bold;">sn与client_sn不能同时为空，优先按照sn查找订单，如果没有，再按照client_sn查询</p>


## 同步返回参数

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
result\_code | 结果码 | String | Y | 结果码表示接口调用的业务逻辑是否成功 | "CANCEL_SUCCESS"
error\_code | 错误码 | String | N | 参考附录：业务执行错误码列表 | "UPAY\_TCP\_ORDER\_NOT_REFUNDABLE"
error\_message | 错误消息 | String | N | 参考附录：业务执行错误码列表 | "订单7894259244061958参与了活动并且无法撤销"
terminal_sn	|收钱吧终端ID	|String(32)|	Y	|收钱吧终端ID| 	"01012010201201029"
sn	|收钱吧唯一订单号	|String(16)	|Y	|收钱吧系统内部唯一订单号|	"7894259244061958"
client_sn|	商户订单号|	String(64)|	Y	|商户系统订单号|	"22345677767776"
status|	流水状态	|String(32)|	Y	|本次操作对应的流水的状态|	"SUCCESS"
order_status	|订单状态	|String(32)|	Y	|当前订单状态|	"CANCELED"
payway  | 支付方式  |  String(32)   | Y  |  订单支付方式  |  "3"
payway_name  | 支付方式名称  |  String(128)   | Y  |   |  "微信"
trade_no	|支付平台的订单凭证号|	String(64)|	Y	|支付宝或微信的订单号|	"2006101016201512090096528672"
total_amount	|交易总金额	|String(10)|	Y	|原始交易实收金额	| "100"
net_amount|	剩余金额	|String(10)|	Y	|实收金额减退款金额| "0"
finish_time	|上次操作在收钱吧的完成时间|String(13)|		Y|时间戳，本次动作在收钱吧的完成时间| "1449646835244"
channel\_finish_time	|上次操作在支付平台完成的时间|String(13)|	Y	|时间戳，本次动作在微信或支付宝的完成时间|"1449646835221"
subject	|商品概述	|String(32)|	Y	|交易时候的商品概述	| "wx"
operator|	操作员|	String(64)|	Y	|执行上次业务动作的操作员	| "Obama"

返回的状态码请参考<font color="red">**附录**</font>

# 手动撤单
如果一笔订单已经支付成功，在系统规定的时间范围内，可以调用这个接口完成全额退款，并且不会触发任何手续费。手动撤单和自动撤单的区别只是撤单目的不同，实际执行的业务逻辑是完全一样的。

## 入口

	    {api_domain}/upay/v2/revoke

## 签名验证

  请参考[签名机制文档](https://doc.shouqianba.com/zh-cn/api/sign.html)
  
## 请求参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
terminal_sn|	收钱吧终端ID|	String(32)|	Y|	收钱吧终端ID |	"00101010029201012912"
sn|	收钱吧系统订单号	|String(16)|	N|	收钱吧系统唯一订单号|	"7894259244061958"
client_sn	|商户自己的订单号|	String(64)|	N	|商户自己订号|"2324545839"

<p style="color:red; font-weight: bold;">sn与client_sn不能同时为空，优先按照sn查找订单，如果没有，再按照client_sn查询</p>


## 同步返回参数

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
result\_code | 结果码 | String | Y | 结果码表示接口调用的业务逻辑是否成功 | "CANCEL_SUCCESS"
error\_code | 错误码 | String | N | 参考附录：业务执行错误码列表 | "UPAY\_TCP\_ORDER\_NOT_REFUNDABLE"
error\_message | 错误消息 | String | N | 参考附录：业务执行错误码列表 | "订单7894259244061958参与了活动并且无法撤销"
terminal_sn	|收钱吧终端ID	|String(32)|	Y	|收钱吧终端ID| 	"01012010201201029"
sn	|收钱吧唯一订单号	|String(16)	|Y	|收钱吧系统内部唯一订单号|	"7894259244061958"
client_sn|	商户订单号|	String(64)|	Y	|商户系统订单号|	"22345677767776"
status|	流水状态	|String(32)|	Y	|本次操作对应的流水的状态|	"SUCCESS"
order_status	|订单状态	|String(32)|	Y	|当前订单状态|	"CANCELED"
payway  | 支付方式  |  String(32)   | Y  |  订单支付方式  |  "3"
payway_name  | 支付方式名称  |  String(128)   | Y  |   |  "微信"
trade_no	|支付平台的订单凭证号|	String(64)|	Y	|支付宝或微信的订单号|	"2006101016201512090096528672"
total_amount	|交易总金额	|String(10)|	Y	|原始交易实收金额	| "100"
net_amount|	剩余金额	|String(10)|	Y	|实收金额减退款金额| "0"
finish_time	|上次操作在收钱吧的完成时间|String(13)|		Y|时间戳，本次动作在收钱吧的完成时间| "1449646835244"
channel\_finish_time	|上次操作在支付平台完成的时间|String(13)|	Y	|时间戳，本次动作在微信或支付宝的完成时间|"1449646835221"
subject	|商品概述	|String(32)|	Y	|交易时候的商品概述	| "wx"
operator|	操作员|	String(64)|	Y	|执行上次业务动作的操作员	| "Obama"


请参考返回码的状态请参考<font color="red">**附录**</font>

## 撤单返回示例

 1.撤单成功

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
2.撤单失败

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
    
##撤单接口接入常见问题

###1.手动撤单和自动撤单有什么区别？
手动撤单和自动撤单的区别只是撤单目的不同，实际执行的业务逻辑是完全一样的。

###2.撤单接口调用限制
撤单接口，一笔订单只能在当天进行一次撤单，撤单的时候是全额退款，包括支付手续费。进行过退款的订单不能撤单。

###3.手动撤单可以在订单支付完成后多久以内可以提交请求？
过了当天无法撤单。

###4.什么时候会用到自动撤单接口(cancel)
自动撤单接口是为了避免出现单边账而出现的。当一笔交易状态未知时，为了避免产生单边账，就需要调用自动撤单接口发起撤单，从而避免产生单边账
