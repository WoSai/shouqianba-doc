# 预下单

## 入口

        {api_domain}/upay/v2/precreate
## 签名验证
  请见[签名机制文档](https://doc.shouqianba.com/zh-cn/api/sign.html)
## 请求参数说明

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
terminal_sn | 收钱吧终端ID| String(32)| Y	 | 收钱吧终端ID | "23420593829"
client_sn | 商户系统订单号 | String(32)| Y | 必须在商户系统内唯一；且长度不超过32字节 | "18348290098298292838"
total_amount | 交易总金额 | String(10) | Y | 以分为单位,不超过10位纯数字字符串,超过1亿元的收款请使用银行转账 | "1000"
payway	|支付方式|	String|	Y	|内容为数字的字符串 |1:支付宝<br/>3:微信<br/>4:百度钱包<br/>5:京东钱包<br/>6:qq钱包
sub_payway	|二级支付方式|	String|N|内容为数字的字符串，<font color="red">如果要使用WAP支付，则必须传 "3", 使用小程序支付请传"4"</font>| "3"
payer\_uid|	付款人id|	String(64)|	N|消费者在支付通道的唯一id,**微信WAP支付必须传open_id,支付宝WAP支付必传用户授权的userId**| "okSzXt_KIZVhGZe538aOKIMswUiI"
subject|	交易简介|	String(64)|	Y|本次交易的概述| "pizza"
operator	|门店操作员|	String(32)|	Y	|发起本次交易的操作员|	"Obama"
description	|商品详情	|String(256)|N|对商品或本次交易的描述|
longitude|	经度	|String|	N	|经纬度必须同时出现|
latitude	|纬度	|String	|N|经纬度必须同时出现|
extended	|扩展参数集合	|String(256)|	N|	收钱吧与特定第三方单独约定的参数集合,json格式，最多支持24个字段，每个字段key长度不超过64字节，value长度不超过256字节 | { "goods_tag": "beijing"}
goods_details | 商品详情 | JSON |N |格式为json goods_details的值为数组，每一个元素包含五个字段，goods_id商品的编号，goods_name商品名称，quantity商品数量，price商品单价，单位为分，promotion_type优惠类型，0:没有优惠 1: 支付机构优惠，为1会把相关信息送到支付机构| "goods_details": [{"goods_id": "wx001","goods_name": "苹果笔记本电脑","quantity": 1,"price": 2,"promotion_type": 0},{"goods_id":"wx002","goods_name":"tesla","quantity": 1,"price": 2,"promotion_type": 1}]
reflect|	反射参数|	String(64)|	N|任何调用者希望原样返回的信息 | { "tips" : "100"}
notify_url|回调|String(128)|N| 支付回调的地址|例如：www.baidu.com 如果支付成功通知时间间隔为1s,5s,30s,600s

**商户系统订单号必须在商户系统内唯一，支付失败订单的二次预下单请求，请创建新的商户订单号**

## 请求参数中关于goods_details说明
字段名称 | 数值格式 | 长度 | 字段描述
--------- | ------ | ----- | -------
goods_id | String必填 | 32 | 商品的编号
goods_name | String必填 |32 | 商品名称，如ipad
quantity | Number必填 | 10 | 商品数量，如10
price | Number必填 | 9 | 商品单价，单位为分，如2000
promotion_type |Number必填 | 1 |优惠类型，0表示没有优惠，1表示支付机构优惠，为1会把相关信息送到支付机构

## 同步返回参数说明

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

## 预下单返回示例
 预下单成功

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


## 预下单接口接入常见问题
   
### 1.调用预下单接口成功后需要主动轮询获取订单状态
      precreate接口何时发起轮询：
      在得到预下单成功的结果后，即可向收钱吧服务器发起轮询请求。
	    预下单成功:biz_response.result_code="PRECREATE_SUCCESS" or biz_response.data.order_status="CREATED")
		  收钱吧目前所有预下单的订单有效支付时长约为4分钟，若超时仍未支付，收钱吧会自动取消该订单；因此请控制好轮询时间。
		  轮询的间隔建议为前30秒内2秒一次，之后5秒一次。
### 2.轮询如何发起？
      需要主动调用查询接口，按照问题1里的规则进行轮询。
      
### 3.有回调地址了为什么还有轮询？
     目前回调地址的通知间隔是1s, 5s, 30s, 600s，为了确保稳定，建议以主动轮询的结果为主，回调地址的结果为辅。
