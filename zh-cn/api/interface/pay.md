# 付款

## 入口

	    {api_domain}/upay/v2/pay
	    
## 签名验证

  请参考[签名机制文档](https://doc.shouqianba.com/zh-cn/api/sign.html)
  
## 请求参数说明

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
terminal_sn | 收钱吧终端ID |String(32)|Y|收钱吧终端ID，不超过32位的纯数字|"00101010029201012912"
client_sn |商户系统订单号  | String(32)|Y | 必须在商户系统内唯一；且长度不超过32字节|"18348290098298292838"
total_amount | 交易总金额 |String(10) |Y |以分为单位,不超过10位纯数字字符串,超过1亿元的收款请使用银行转账 |"1000"
payway | 支付方式 |String |N |非必传。内容为数字的字符串。一旦设置，则根据支付码判断支付通道的逻辑失效 |1:支付宝<br/>3:微信<br/>4:百度钱包<br/>5:京东钱包<br/>6:qq钱包
dynamic_id | 条码内容 |String(32) |Y | 不超过32字节|"130818341921441147"
subject |交易简介  |String(64) |Y |本次交易的简要介绍 |"Pizza"
operator |门店操作员  |String(32) |Y|发起本次交易的操作员 | Obama
description | 商品详情 |String(256) |N |对商品或本次交易的描述 |
longitude | 经度 | String| N|经纬度必须同时出现 | "121.615459404"
latitude | 维度 | String|N |经纬度必须同时出现 | "31.4056441552"
device_id|设备指纹|String|N|
extended | 扩展参数集合 | JSON map | N | 收钱吧与特定第三方单独约定的参数集合,json格式，最多支持24个字段，每个字段key长度不超过64字节，value长度不超过256字节 | { "goods_tag": "beijing"}
goods_details |商品详情 |JSON |N |格式为json goods_details的值为数组，每一个元素包含五个字段，goods_id商品的编号，goods_name商品名称，quantity商品数量，price商品单价，单位为分，promotion_type优惠类型，0:没有优惠 1: 支付机构优惠，为1会把相关信息送到支付机构 | "goods_details": [{"goods_id": "wx001","goods_name": "苹果笔记本电脑","quantity": 1,"price": 2,"promotion_type": 0},{"goods_id":"wx002","goods_name":"tesla","quantity": 1,"price": 2,"promotion_type": 1}]
reflect | 反射参数 | String(64) | N | 任何调用者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容 | { "tips": "200" }
notify_url|回调|String(128)|N| 支付回调的地址|例如：www.baidu.com 如果支付成功通知时间间隔为1s,5s,30s,600s 

**商户系统订单号必须在商户系统内唯一，支付失败订单的二次支付请求，请创建新的商户订单号**

## 请求参数中关于goods_details说明
字段名称 | 数值格式 | 长度 | 字段描述
--------- | ------ | ----- | -------
goods_id | String必填 | 32 | 商品的编号
goods_name | String必填 |32 | 商品名称，如ipad
quantity | Number必填 | 10 | 商品数量，如10
price | Number必填 | 9 | 商品单价，单位为分，如2000
promotion_type |Number必填 | 1 |优惠类型，0表示没有优惠，1表示支付机构优惠，为1会把相关信息送到支付机构

## 花呗分期交易请求参数
参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
hb_fq_num | 花呗分期数 |String|Y|目前支持3/6/12期，前置参数为extended.extend_params | "extended":{"extend_params": {"hb_fq_num": "12"}}
hb_fq_seller_percent |花呗分期卖家承担手续费比例  | String|Y | 商家承担手续费传入100，用户承担手续费传入0，前置参数为extended.extend_params| "extended": {"extend_params": {"hb_fq_seller_percent": "0"}}


## 同步返回参数说明

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
payway_name| 支付方式名称 | String(128) |Y| | 支付宝
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

## 支付成功回调地址参数说明：

参数 | 参数名称 | 类型 | 必填|描述 |范例
--------- | ------ | ----- | -------|---|----
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

收到成功的回调需要响应<font color="red">**success**给服务器端

返回的状态码请参考<font color="red">**附录**</font>

## 请求示例  

   ```json
    {
  	"total_amount": "1",
  	"subject": "收钱吧",
  	"dynamic_id": "281234305112341234",
  	"operator": "Roy",
  	"terminal_sn": "100003612347111234",
  	"client_sn": "8529061153479888",
  	"extended": 
	{
    		"extend_params": 
		{
      		"hb_fq_seller_percent": "0",
      		"hb_fq_num": "12"
    		}
  	}
     }
    ```
    
## 返回示例

1. 交易成功

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
4.支付失败

    ```json
    {
        "result_code": "400",
        "error_code": "INVALID_PARAMS",
        "error_message": "total_amount金额为整数，长度不超过10位，以分为单位"
    }
    ```
    
## 支付接口接入常见问题

### 1.出现支付签名错误
 如果使用的激活码是只能在一个终端上激活的，但是却在多个终端上使用，就会出现支付签名错误。一个激活码可以激活多个终端的则不会出现这个问题
### 2.client_sn是什么？支付失败后重新进行支付可以延用之前的client_sn吗？
 **client_sn:**商户系统订单号，必须在商户系统内唯一。
支付失败后重新进行支付**不**可以延用之前的client_sn。
一笔交易中，前台订单号是唯一的，例如0001，提交支付失败后，再次提交支付请求，订单号就不能是0001了。
### 3.使用pay接口支付(b扫c)40s左右没输入密码支付会提示超时,需要重新调用支付接口去重新支付。

### 4.如果支付成功后没有拿到订单的最终状态（order_status里不是最终状态）,就需要调用查询接口获取最终状态。
 哪些状态是订单最终状态<a name="status"></a>
- PAID
- PAY_CANCELED
- REFUNDED
- PARTIAL_REFUNDED
- CANCELED

### 5.建议对接方加入一个手动查询的按钮去处理可能出现的单边账：

   为了预防出现单边账，建议对接方手动加一个查询按钮，当支付完成后，如果消费者支付成功，但是终端显示支付失败或者状态不明确，这个时候可以给收银员一个手动查询订单状态的操作，如果查询得到的状态依旧不是成功，就需要联系收钱吧客服人工接入了。

### 6.支付成功后支付宝、微信显示信息分别是什么？

支付时需要传入商品名称，这个一方面是保留业务信息，另一方面是会展示在消费者的付款终端上。
支付成功后，微信APP上，商品信息显示的是商品名称。


