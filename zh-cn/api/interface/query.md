# 查询

## 入口

	    {api_domain}/upay/v2/query

## 签名验证

   请参考[签名机制文档](https://wosai.gitbooks.io/shouqianba-doc/content/zh-cn/api/sign.html)
   
## 请求参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
terminal_sn|	收钱吧终端ID	|String(32)|Y|收钱吧终端ID| "010382829292929"
sn	|收钱吧系统订单号|	String(16)|N|收钱吧系统唯一订单号| "7894259244061958"
client_sn|	商户自己的订单号	|String(64)|N|商户自己订号|"2324545839"

<p style="color:red; font-weight: bold;">sn与client_sn不能同时为空，优先按照sn查找订单，如果没有，再按照client_sn查询</p>

## 同步返回参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
result\_code | 结果码 | String | Y | 结果码表示接口调用的业务逻辑是否成功 | "SUCCESS"
error\_code | 错误码 | String | N | 参考附录：业务执行错误码列表 | "TRADE_TIMEOUT"
error\_message | 错误消息 | String | N | 参考附录：业务执行错误码列表 | "交易超时自动撤单"
terminal_sn|	收钱吧终端ID|	String(32)|	Y|	收钱吧终端ID， |	"01012010201201029"
sn	|收钱吧唯一订单号	|String(16)|	Y	|收钱吧系统内部唯一订单号|	"7894259244061958"
client_sn|	商户订单号|	String(64)|	Y	|商户系统订单号。|	"22345677767776"
status	|流水状态|	String(32)|	Y	|本次操作对应的流水的状态	|"SUCCESS"
order_status	|订单状态	|String(32)|	Y|	当前订单状态	|"REFUNDED"
trade_no|	支付平台的订单凭证号|String(64)|	Y	|支付宝或微信的订单号	|"2006101016201512090096528672"
total_amount	|交易总金额	|String(10)|	Y	|原始交易实收金额	|"100"
net_amount|	剩余金额	|String(10)|	Y|	实收金额减退款金额| "0"
finish_time	|上次操作在收钱吧的完成时间|String(13)|Y|时间戳，本次动作在收钱吧的完成时间|"1449646835244"
channel\_finish_time|上次操作再支付平台完成的时间|String(13)|	Y|	时间戳，本次动作在微信或支付宝的完成时间|"1449646835221"
subject|	商品概述	|String(32)|	Y	|交易时候的商品概述	| "wx"
operator	|操作员	|String(64)|	Y|	执行上次业务动作的操作员| "Obama"

返回的状态码请参考<font color="red">**附录**</font>


##查询接口返回示例
   查单成功

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
    
##查询接口接入过程常见问题

###1.何时调用查询接口
   1)调用预下单接口(precreate)预下单成功后，需要调用查询接口发起轮询
   
   2)调用支付接口(pay)支付后没有得到订单的最终状态，需要调用查询接口获取订单最终状态。
   
   3)调用退款接口(refund)发起退款后没有得到退款状态，需要调用查询接口获取退款状态。
   
   4)调用撤单接口(revoke/cancel)发起撤单或冲正之后没有得到撤单的最终状态，需要调用查询接口获取撤单的最终状态。
