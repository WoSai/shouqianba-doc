# 支付类API Reference

## 接口响应

#### 返回字段列表

字段名 | 字段含义 | 取值 | 备注
--------- | ------ | ----- | -------
result_code | 通讯响应码 |200，400，500|200：通讯成功；400：客户端错误；500:服务端错误
error_code  | 通讯错误码 |见附录《公共错误码》 |通讯 **失败** 的时候才返回
error_message  |通讯错误信息描述 |见附录《公共错误码》 |通讯 **失败** 的时候才返回
biz_response  | 业务响应数据 |数组结构 |通讯 **成功** 的时候才返回
biz\_response.result_code  | 业务执行响应码 |见附录《业务数据响应码列表》|
biz\_response.error_code  | 业务执行结果返回码 |见附录《业执行错误码列表》 |
biz\_response.error_message  |业务执行错误信息 |见附录《业务执行错误码列表》|业务执行成功才返回
biz\_response.sn  |收钱吧系统订单号 |16位数字 |业务执行 **成功** 才返回
biz\_response.client_sn  | 客户系统订单号 | |业务执行 **成功** 才返回
biz\_response.status  | 最新流水状态 |见附录《流水状态列表》 |业务执行 **成功** 才返回
biz\_response.order_status  | 最新订单状态 |见附录《订单状态列表》 |业务执行 **成功** 才返回
biz\_response.payer_uid  | 付款人在支付服务商系统中的用户ID |字符串 |业务执行 **成功** 才返回
biz\_response.pay_login | 付款人在支付服务商系统中的登录账户 |字符串 |业务执行 **成功** 才返回
biz\_response.trade_no  | 第三方支付通道订单号|32-128位 |业务执行 **成功** 才返回
biz\_response.total_amount  | 有效交易总金额 |整数，以 <font color="red">分</font> 为单位 |业务执行 **成功** 才返回
biz\_response.net\_amount  | 如果没有退款，这个字段等于total_amount。否则等于total\_amount减去退款金额 |整数，以分为单位 |业务执行 **成功** 才返回
biz\_response.payway  | 支付方式 |见附录《支付方式列表》 |业务执行 **成功**才返回。包括支付宝，微信，京东，百度钱包等，未来会不断增加
biz\_response.sub_payway  | 二级支付方式 |见附录《二级支付方式列表》 |业务执行 **成功**才返回
biz\_response.finish_time  | 本次业务操作在收钱吧系统中执行完成的时间 |时间戳 |业务执行 **成功**才返回
biz\_response.channel\_finish_time  | 本次业务操作在第三方支付通道执行完成的时间 |时间戳|业务执行 **成功**才返回
biz\_response.terminal_sn  | 发起本次业务请求的终端ID |字符串| 业务执行 **成功**才返回
biz\_response.store_id  | 本次交易所属门店 |字符串 |业务执行 **成功**才返回
biz_response.subject | 本次交易概述 |字符串 |业务执行 **成功**才返回
biz_response.description | 本次交易详情 |字符串 |业务执行 **成功**才返回
biz_response.reflect | 商户透传参数 |字符串 |业务执行 **成功**才返回
biz_response.operator  | 本次业务执行的操作员 |字符串 |业务执行 **成功**才返回


#### 返回实例

1. 交易成功

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "PAY_SUCCESS",
            "data": {
                "sn": "7894259244067349",
                "client_sn": "12345677767776",
                "status": "SUCCESS",
                "payway": "3",
                "sub_payway": "1",
                "order_status": "PAID",
                "payer_uid": "okSzXt3uY4-W8fKBH7B4z8seMzBU",
                "trade_no": "1006101016201512081965934048",
                "total_amount": "1",
                "net_amount": "1",
                "finish_time": "1449569460430",
                "channel_finish_time": "1449569460000",
                "terminal_sn": "1122234-dewls02s2",
                "store_id": "00293001928483902",
                "subject": "Domino's Pizza",
                "operator": "Kan",
            }
        }
    }
    ```

2. 交易进行中

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

3. 交易失败

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

4. 客户端错误

    ```json
    {
        "result_code": "400",
        "error_code": "TERMINAL_NOT_EXISTS",
        "error_message": "不存在这个终端",
    }
    ```

5. 客户端错误

    ```json
    {
        "result_code": "400",
        "error_code": "INVALID_PARAMETER",
        "error_message": "client_sn不可以为空；total_amount不可以为负数",
    }
    ```

6. 服务端错误

    ```json
    {
        "result_code": "500",
        "error_code": "UNKNOWN_SYSTEM_ERROR",
        "error_message": "未知的系统错误",
    }
    ```

7. 服务端系统错误

    ```json
    {
        "result_code": "500",
        "error_code": "MAINTENANCE_INPROGRESS",
        "error_message": "服务端正在升级维护，稍候5分钟",
    }
    ```

8. 退款成功

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "REFUND_SUCCESS",
            "data": {
                "sn": "7894259244067218",
                "client_sn": "12345677767776",
                "status": "SUCCESS",
                "payway": "3",
                "sub_payway": "1",
                "order_status": "REFUNDED",
                "trade_no": "2006101016201512080095793262",
                "total_amount": "1",
                "net_amount": "0",
                "finish_time": "1449563206776",
                "channel_finish_time": "1449563206632"
            }
        }
    }
    ```

9. 查单成功

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

10. 预下单成功

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

11. 撤单成功

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


## 接口列表

#### 约定

* 所有返回参数都为 <font color="red">**JSON**</font> 格式，请务必在HTTP请求头中加入Content-Type: application/json。
* 所有请求的body都需采用UTF-8编码，所有响应也会采用相同编码。
* 所有返回数据的类型都是 <font color="red">**字符串**</font>。
* 接口中所有涉及金额的地方都以 <font color="red">**分**</font> 为单位。
* api_domain：https://api.shouqianba.com


#### 付款

* 入口

	    {api_domain}/upay/v2/pay

* 请求参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
terminal_sn | 收钱吧终端ID |String(32)|Y|收钱吧终端ID，不超过32位的纯数字|"00101010029201012912"
client_sn |商户系统订单号  | String(32)|Y | 必须在商户系统内唯一；且长度不超过32字节|"18348290098298292838"
total_amount | 交易总金额 |String(10) |Y |以分为单位,不超过10位纯数字字符串,超过1亿元的收款请使用银行转账 |"1000"
payway | 支付方式 |String |N |内容为数字的字符串。一旦设置，则根据支付码判断支付通道的逻辑失效 |"1"
dynamic_id | 条码内容 |String(32) |Y | 不超过32字节|"130818341921441147"
subject |交易简介  |String(64) |Y |本次交易的简要介绍 |"Pizza"
operator |门店操作员  |String(32) |Y|发起本次交易的操作员 | Obama
description | 商品详情 |String(256) |N |对商品或本次交易的描述 |
longitude | 经度 | String| N|经纬度必须同时出现 | "121.615459404"
latitude | 维度 | String|N |经纬度必须同时出现 | "31.4056441552"
device_id | 设备标示 |String(32) | | |
extended | 扩展参数集合 | JSON map | N | 收钱吧与特定第三方单独约定的参数集合,json格式，最多支持24个字段，每个字段key长度不超过64字节，value长度不超过256字节 | { "goods_tag": "beijing"}
reflect | 反射参数 | String(64) | N | 任何调用者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容 | { "tips": "200" }

**商户系统订单号必须在商户系统内唯一，支付失败订单的二次支付请求，请创建新的商户订单号**

* 同步返回参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
result\_code | 结果码 | String | Y | 结果码表示接口调用的业务逻辑是否成功 | "PAY_SUCCESS"
error\_code | 错误码 | String | N | 参考附录：业务执行错误码列表 |"INVALID_BARCODE"
error\_message | 错误消息 | String | N | 参考附录：业务执行错误码列表 |"不合法的支付条码"
terminal_sn	|终端号|	String(32)|Y|收钱吧终端ID|"01939202039923029"
sn|	收钱吧唯一订单号|	String(16)|Y|收钱吧系统内部唯一订单号|"7892259488292938"
client_sn|商户订单号|	String(32)|Y|商户系统订单号|"7654321132"
trade_no|支付服务商订单号|String(64)|Y|支付通道交易凭证号|"2013112011001004330000121536"
status|流水状态|String(32)|	Y|本次操作产生的流水的状态| "SUCCESS"
order_status	|订单状态	|String(32)|Y|当前订单状态|"PAID"
payway|	支付方式|	String(2)|Y|一级支付方式，取值见附录《支付方式列表》|"1"
sub_payway|二级支付方式|	String(2)|Y|二级支付方式，取值见附录《二级支付方式列表》|"1"
payer_uid|	付款人ID|	String(64)|N|支付平台（微信，支付宝）上的付款人ID|"2801003920293239230239"
payer_login|付款人账号|String(128)|N|支付平台上(微信，支付宝)的付款人账号|"134****3920"
total_amount|交易总额	|String(10)|Y|本次交易总金额|"10000"
net\_amount|实收金额|String(10)|Y|如果没有退款，这个字段等于total\_amount。否则等于 total_amount减去退款金额|"0"
subject|	交易概述|	String(64)|	Y|本次交易概述|"Pizza"
finish_time	|付款动作在收钱吧的完成时间|String(13)|Y|时间戳|"1449646835244"
channel\_finish_time|付款动作在支付服务商的完成时间|String(13)|Y|时间戳|"1449646835244"
operator	|操作员	|String(32)	|Y	|门店操作员	|"张三丰"
reflect	|反射参数|	String(64)	|N|	透传参数	| {"tips": "200"}

* 支付失败返回示例

    ```json
    {
        "result_code": "400",
        "error_code": "INVALID_PARAMS",
        "error_message": "total_amount金额为整数，长度不超过10位，以分为单位"
    }
    ```

* 客户端支付流程代码示例

    ```python
    Sub pay(request, timeout):
        Try:
        response = POST (pay_url, request)
        Except NetworkConnectError ex:
        raise (“网络不可用”, ex)
        Except NetworkIOError ex:
        return poll (request.client_sn, timeout)
        handle_response_error(response)
        biz_response = response.biz_response
        if biz_response.result_code == “PAY_SUCCESS”:
        return (“本次收款成功”, response)
        elif biz_response.result_code == “PAY_FAIL”:
        return (“本次收款失败并且支付金额已退还付款人”, response)
        elif biz_response.result_code == “PAY_FAIL_ERROR”:
        raise (“本次收款异常请联系收钱吧客服”, response)
        elif biz_response.result_code == “FAIL”:
        raise (“收款失败不涉及金额变更/提醒操作员错误内容”, response)
        else:
        return poll(request.client_sn, timeout)
    
    Sub poll(client_sn, remaining_time):
        if remaining_time < 0:
        Try:
            response = POST(cancel_url, client_sn)
        Except NetworkError ex:
            raise “本次收款超时撤单网络异常请联系收钱吧客服”, ex
        handle_response_error(response)
        result_code = response.biz_response.result_code
        error_code = response.biz_response.error_code
        if result_code == “CANCEL_SUCCESS” or 
            result_code == “CANCEL_ABORT_SUCCESS”:
            return (“本次收款超时并且已经成功撤单”, response)
        elif result_code == “FAIL” and error_code == “UPAY_ORDER_NOT_EXISTS”:
            return (“本次收款超时并且不需要撤单”, response)
        else:
            raise (“本次收款超时撤单异常请联系收钱吧客服”, response)
        else:
        stopwatch.start()
        Try
            response = POST(query_url, client_sn)
        Except NetworkError ex:
            sleep(5)
            return poll(client_sn, remaining_time – stopwatch.reading())
        handle_reponse_error(response)
        biz_response = response.biz_response
        if biz_response.result_code == “FAIL” and
            biz_response.error_code == “UPAY_ORDER_NOT_EXISTS”:
            return (“本次收款失败并且不需要撤单”, response)
        elif biz_response.result_code == “SUCCESS”:
            if biz_response.data.order_status == “CREATED”:
            sleep(5)
            return poll(client_sn, remaining_time – stopwatch.reading())
            elif biz_response.data.order_status == “PAID”:
            return (“本次收款成功”, response)
            elif biz_response.data.order_status == “PAY_CANCELED”:
            return (“本次收款失败并且支付金额已退还付款人”, response)
            elif biz_response.data.order_status == “PAY_ERROR”:
            return (“本次收款异常请联系收钱吧客服”, response)
    
    Sub handle_response_error(response):
        if response.result_code == “400”:
        raise (“联系终端开发商”, response.error_message)
        elif response.result_code == “500”:
        raise (“收钱吧支付网关故障，联系收钱吧客服”, response.error_message)
    ```


#### 退款

* 入口

		{api_domain}/upay/v2/refund

* 请求参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
terminal_sn	|收钱吧终端ID| String(32)|Y|收钱吧终端ID|"00101010029201012912"
sn|	收钱吧唯一订单号|	String(16)|N|收钱吧系统内部唯一订单号|"7892259488292938"
client_sn	|商户订单号	|String(32)|N|商户系统订单号。|"7654321132"
refund\_request_no|退款序列号|	String(20)|Y|商户退款所需序列号,防止重复退款|"23030349"
operator|操作员	|String(64)	|Y|执行本次退款的操作员|"Obama"
refund_amount|	退款金额	|String(10)|Y|退款金额|"100"

<p style="color:red; font-weight: bold;">sn与client_sn不能同时为空，优先按照sn查找订单，如果没有，再按照client_sn查询</p>

* 同步返回参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
result\_code | 结果码 | String | Y | 结果码表示接口调用的业务逻辑是否成功 | "REFUND_SUCCESS"
error\_code | 错误码 | String | N | 参考附录：业务执行错误码列表 | "ACCOUNT_BALANCE_NOT_ENOUGH"
error\_message | 错误消息 | String | N | 参考附录：业务执行错误码列表 | "商户余额不足"
terminal_sn	|收钱吧终端ID|	String(32)|	Y	|收钱吧终端ID，可使用英文字母和数字	| "103939292020"
sn	|收钱吧唯一订单号	|String(16)	|Y|	收钱吧系统内部唯一订单号| "7894259244061958"
client_sn	|商户订单号|	String(64)|	Y	|商户系统订单号。	| "22345677767776"
status|	退款流水状态	|String(32)|	Y	|本次退款对应的流水的状态| "SUCCESS"
order_status|	订单状态	|String(32)|	Y	|当前订单状态	| "REFUNDED"
trade_no	|支付平台的订单凭证号|	String(64)|	Y	|支付宝或微信的订单号| "2006101016201512090096528672"
total_amount	|交易总金额	|String(10)|	Y	|原始交易实收金额	| "100"
net_amount|	剩余金额	|String(10)|	Y	|实收金额减退款金额| "0"
finish_time	|退款动作在收钱吧的完成时间|	String(13)|	Y	|时间戳，本次退款动作在收钱吧的完成时间| "1449646835244"
channel\_finish_time	|退款动作在支付平台完成的时间|String(13)|	Y	|时间戳，本次退款动作在微信或支付宝的完成时间| "1449646835221"
subject|	商品概述	|String(32)	|Y|交易时候的商品概述| "wx"
operator|	操作员	|String(32)|Y|执行本次退款的操作员|"Obama"


* 退款失败返回示例

    ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "FAIL",
            "error_code": "UPAY_REFUND_INVALID_ORDER_STATE",
            "error_message": "订单已全额退款,可退金额不足"
        }
    }
    ```


#### 查询

* 入口

	    {api_domain}/upay/v2/query

* 请求参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
terminal_sn|	收钱吧终端ID	|String(32)|Y|收钱吧终端ID| "010382829292929"
sn	|收钱吧系统订单号|	String(16)|N|收钱吧系统唯一订单号| "7894259244061958"
client_sn|	商户自己的订单号	|String(64)|N|商户自己订号|"2324545839"

<p style="color:red; font-weight: bold;">sn与client_sn不能同时为空，优先按照sn查找订单，如果没有，再按照client_sn查询</p>

* 同步返回参数说明

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


#### 自动撤单

当终端的支付流程在进行过程中如果调用支付接口没有返回成功，为了避免交易纠纷，需要调用自动撤单接口完成冲正。

* 入口
	
	    {api_domain}/upay/v2/cancel

* 请求参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
terminal_sn|	收钱吧终端ID|	String(32)|	Y|	收钱吧终端ID |	"00101010029201012912"
sn|	收钱吧系统订单号	|String(16)|	N|	收钱吧系统唯一订单号|	"7894259244061958"
client_sn	|商户自己的订单号|	String(64)|	N	|商户自己订号| "2324545839"

<p style="color:red; font-weight: bold;">sn与client_sn不能同时为空，优先按照sn查找订单，如果没有，再按照client_sn查询</p>


* 同步返回参数

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
trade_no	|支付平台的订单凭证号|	String(64)|	Y	|支付宝或微信的订单号|	"2006101016201512090096528672"
total_amount	|交易总金额	|String(10)|	Y	|原始交易实收金额	| "100"
net_amount|	剩余金额	|String(10)|	Y	|实收金额减退款金额| "0"
finish_time	|上次操作在收钱吧的完成时间|String(13)|		Y|时间戳，本次动作在收钱吧的完成时间| "1449646835244"
channel\_finish_time	|上次操作在支付平台完成的时间|String(13)|	Y	|时间戳，本次动作在微信或支付宝的完成时间|"1449646835221"
subject	|商品概述	|String(32)|	Y	|交易时候的商品概述	| "wx"
operator|	操作员|	String(64)|	Y	|执行上次业务动作的操作员	| "Obama"


* 撤单失败返回示例**

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


#### 手动撤单

如果一笔订单已经支付成功，在系统规定的时间范围内，可以调用这个接口完成全额退款，并且不会触发任何手续费。手动撤单和自动撤单的区别只是撤单目的不同，实际执行的业务逻辑是完全一样的。

* 入口

	    {api_domain}/upay/v2/revoke

* 请求参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
terminal_sn|	收钱吧终端ID|	String(32)|	Y|	收钱吧终端ID |	"00101010029201012912"
sn|	收钱吧系统订单号	|String(16)|	N|	收钱吧系统唯一订单号|	"7894259244061958"
client_sn	|商户自己的订单号|	String(64)|	N	|商户自己订号|"2324545839"

<p style="color:red; font-weight: bold;">sn与client_sn不能同时为空，优先按照sn查找订单，如果没有，再按照client_sn查询</p>


* 同步返回参数

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
trade_no	|支付平台的订单凭证号|	String(64)|	Y	|支付宝或微信的订单号|	"2006101016201512090096528672"
total_amount	|交易总金额	|String(10)|	Y	|原始交易实收金额	| "100"
net_amount|	剩余金额	|String(10)|	Y	|实收金额减退款金额| "0"
finish_time	|上次操作在收钱吧的完成时间|String(13)|		Y|时间戳，本次动作在收钱吧的完成时间| "1449646835244"
channel\_finish_time	|上次操作在支付平台完成的时间|String(13)|	Y	|时间戳，本次动作在微信或支付宝的完成时间|"1449646835221"
subject	|商品概述	|String(32)|	Y	|交易时候的商品概述	| "wx"
operator|	操作员|	String(64)|	Y	|执行上次业务动作的操作员	| "Obama"


* 撤单失败返回示例**

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


#### 预下单

* 入口

        {api_domain}/upay/v2/precreate

* 请求参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
terminal_sn|	收钱吧终端ID|	String(32)|	Y	|收钱吧终端ID |	"23420593829"
client_sn|	商户系统订单号|	String(32)|	Y	|必须在商户系统内唯一；且长度不超过32字节|"18348290098298292838"
total_amount|	交易总金额	|String(10)|	Y	|以分为单位,不超过10位纯数字字符串,超过1亿元的收款请使用银行转账|"1000"
payway	|支付方式|	String|	Y	|内容为数字的字符串 |"1"
sub_payway	|二级支付方式|	String|N|内容为数字的字符串，<font color="red">如果要使用WAP支付，则必须传 "3" | "3"
payer\_uid|	付款人id|	String(64)|	N|消费者在支付通道的唯一id,**微信WAP支付必须传open_id**| "okSzXt_KIZVhGZe538aOKIMswUiI"
subject|	交易简介|	String(64)|	Y|本次交易的概述| "pizza"
operator	|门店操作员|	String(32)|	Y	|发起本次交易的操作员|	"Obama"
description	|商品详情	|String(256)|N|对商品或本次交易的描述|
longitude|	经度	|String|	N	|经纬度必须同时出现|
latitude	|纬度	|String	|N|经纬度必须同时出现|
extended	|扩展参数集合	|String(256)|	N|	收钱吧与特定第三方单独约定的参数集合,json格式，最多支持24个字段，每个字段key长度不超过64字节，value长度不超过256字节 | { "goods_tag": "beijing"}
reflect|	反射参数|	String(64)|	N|任何调用者希望原样返回的信息 | { "tips" : "100"}

**商户系统订单号必须在商户系统内唯一，支付失败订单的二次预下单请求，请创建新的商户订单号**

* 同步返回参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
sn|	收钱吧唯一订单号|	String(16)|	Y|	收钱吧系统内部唯一订单号	|7892259488292938
client_sn|	商户订单号|	String(64)|	Y	|商户系统订单号|	7654321132
trade_no	|支付服务商订单号|	String(64)|	Y	|支付通道交易凭证号|	2013112011001004330000121536
status	|流水状态	|String(32)|	Y	|本次操作产生的流水的状态|CREATED
order_status	|订单状态	|String(32)|	Y	|当前订单状态	|CREATED
payway	|支付方式	|String(2)|	Y	|一级支付方式，取值见附录《支付方式列表》|1
sub_payway|	二级支付方式|	String(2)|	Y|	二级支付方式，取值见附录《二级支付方式列表》|3
qr_code	|二维码内容	|String(128)|		 预下单成功后生成的二维码|	https://qr.alipay.com/bax00069h45nvvfc3tu9803a
total_amount	|交易总额	|String(10)|	Y|	本次交易总金额|	10000
net_amount|	实收金额	|String(10)|	Y	|如果没有退款，这个字段等于total_amount。否则等于total_amount减去退款金额|0
subject	|交易概述|	String(64)|	Y|本次交易概述|Pizza
operator|	操作员|	String(32)|Y|门店操作员|张三丰
reflect|	反射参数|	String(64)|	N|透传参数
wap_pay_request|支付通道返回的调用WAP支付需要传递的信息|String(1024)|N|WAP支付一定会返回；


## 附录	

#### 通讯错误码列表

error_code为本次通讯的错误码

error_message为对应的中文描述

当result_code不等于200的时候才会出现

result_code |error_code | error_message 
--------- | ------ | -----  
**400** |INVALID_PARAMS	|参数错误
**400**|INVALID_TERMINAL	|终端错误
**400**|ILLEGAL_SIGN	|签名错误
**500**|	UNKNOWN_SYSTEM_ERROR	|系统错误


#### 业务结果码列表

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


#### 订单状态列表

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


#### 流水状态列表

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


#### 业务执行错误码列表

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
UPAY\_ORDER\_NOT_EXIST	|订单不存在
REFUNDABLE\_AMOUNT\_NOT\_ENOUGH | 订单可退金额不足
UPAY\_TERMINAL\_NOT\_EXISTS | 终端号在交易系统中不存在
UPAY\_TERMINAL\_STATUS\_ABNORMAL | 终端未激活
UPAY\_CANCEL\_ORDER\_NOOP | 无效操作，订单已经是撤单状态了
UPAY\_CANCEL\_INVALID\_ORDER\_STATE | 当前订单状态不可撤销
UPAY\_REFUND\_ORDER\_NOOP | 无效操作，本次退款退款已经完成了
UPAY\_REFUND\_INVALID\_ORDER\_STATE | 当前订单状态不可退款
UPAY\_STORE\_OVER\_DAILY\_LIMIT | 商户日收款额超过上限
UPAY\_TCP\_ORDER\_NOT\_REFUNDABLE | 订单参与了活动并且无法撤销


#### 支付方式列表

	biz_response.data.payway

取值 |含义  
--------- | ------
1	|支付宝
3	|微信
4	|百付宝
5   |京东


#### 二级支付方式列表

	biz_response.data.sub_payway

取值 |含义  
--------- | ------
1   |条码支付
2   |二维码支付
3   |wap支付
