# 查询

## 入口

	    {api_domain}/upay/v2/query

## 签名验证

   请参考[签名机制文档](https://doc.shouqianba.com/zh-cn/api/sign.html)
   
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
payment_list |活动优惠 |JSON |N |格式为json payment_list的值为数组，每一个元素包含两个字段，一个是type支付名称，一个amount_total支付金额 |"payment_list": [{"type": "BANKCARD_DEBIT","amount_total": "1"},{"type": "DISCOUNT_CHANNEL_MCH","amount_total": "100"}]

## payment_list参数说明
type |描述
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

返回的状态码请参考<font color="red">**附录**</font>


## 查询接口返回示例
   查单成功

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
    
## 查询接口接入过程常见问题

### 1.何时调用查询接口
   1)调用预下单接口(precreate)预下单成功后，需要调用查询接口发起轮询。
   
   2)调用支付接口(pay)支付后没有得到订单的最终状态，需要调用查询接口获取订单最终状态。
   
   3)调用退款接口(refund)发起退款后没有得到退款状态，需要调用查询接口获取退款状态。
   
   4)调用撤单接口(revoke/cancel)发起撤单或冲正之后没有得到撤单的最终状态，需要调用查询接口获取撤单的最终状态。

   5)为了预防出现单边账，建议对接方手动加一个查询按钮，当支付完成后，如果消费者支付成功，但是终端显示支付失败或者状态不明确，这个时候可以给收银员一个手动查询订单状态的操作，如果查询得到的状态依旧不是成功，就需要联系收钱吧客服人工接入了。
