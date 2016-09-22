# 微信公众号支付 wap 收银台

##网关地址
https://m.wosai.cn/qr/gateway

##请求方式
GET

#### 请求参数
参数 | 参数名称 | 类型 | 是否必填 | 描述 |范例
------ | ----- | ----- | ----- |----- | -----
terminal_sn | 收钱吧终端ID | String(32) |	Y |收钱吧终端ID | "23420593829"
client_sn | 商户系统订单号 | String(32) |	Y |必须在商户系统内唯一；且长度不超过32字节 | "18348290098298292838"
total_amount | 交易总金额 | String(10) |	Y |以分为单位,不超过10位纯数字字符串,超过1亿元的收款请使用银行转账 | "1000"
subject | 交易概述 | String(64) |	Y |本次交易的概述 | "pizza"
payway | 支付方式 | String | N |支付方式，目前支持的支付方式参照附录 《支付方式》。不传默认为微信 |3
operator | 	门店操作员 | String(32) |	Y |发起本次交易的操作员 | "Obama"
description | 商品详情 | String(256) | N |对商品或本次交易的描述 | 
longitude | 经度 | 	String | N |经纬度必须同时出现 | 
latitude | 	纬度 | String |	N |经纬度必须同时出现 | 
extended | 	扩展参数集合 | String(256) |	N |收钱吧与特定第三方单独约定的参数集合,json格式，最多支持24个字段，每个字段key长度不超过64字节，value长度不超过256字节 | { "goods_tag": "beijing"}
reflect | 反射参数 | String(64) |	N |任何调用者希望原样返回的信息 | { "tips" : "100"}
notify_url | 服务器异步回调 url | String(128) | N |支付回调的地址 |例如：www.shouqianba.com 如果支付成功通知时间间隔为1s,5s,30s,600s
return_url | 页面跳转同步通知页面路径 | String(128) |	Y |处理完请求后，当前页面自动跳转到商户网站里指定页面的http路径 | "https://www.shouqianba.com"
sign | 签名 | String(32) |	Y |签名，规则请参考附录 《签名规则》 | 


#### 页面同步跳转参数说明
商户的请求数据处理完成后，会将处理的结果数据通过系统程序控制客户端页面自动跳转的方式通知给商户网站。这些处理结果数据就是页面跳转同步通知参数。

参数 | 参数名称 | 类型 | 必填 |描述 |范例
------ | ----- | -----| ----- | ----- | -----
is_success | 成功标识 | String(1) | Y | 表示接口调用是否成功，并不表明业务处理结果。 | T
error_code | 错误码 | String | N | 仅 is_success 为 F 时出现 | 见附录 《错误码》
error_message | 错误描述 | String | N | 仅 is_success 为 F 时出现 | 见附录 《错误码》
terminal_sn | 收钱吧终端ID | String(32) | Y | 收钱吧终端ID | "23420593829"
sn | 收钱吧唯一订单号 | String(16) | Y | 收钱吧系统内部唯一订单号 | 7892259488292938
trade_no | 支付服务商订单号 | String(64)| Y | 支付通道交易凭证号 | 2013112011001004330000121536
client_sn | 商户系统订单号 | String(32) | Y | 必须在商户系统内唯一；且长度不超过32字节 | "18348290098298292838"
status | 支付状态 | String | N | 标志支付是否成功 | "SUCCESS"
result_code | 业务错误码 | String(64)| N | status 为 FAIL 时出现 | 见附录 《错误码》
result_message | 业务错误描述 | String | N | status 为 FAIL 时出现 | 见附录 《错误码》
total_amount | 交易总金额 | String(10) | Y | 以分为单位,不超过10位纯数字字符串,超过1亿元的收款请使用银行转账 | "1000"
subject | 交易概述 | String(64) | Y | 本次交易的概述 | "pizza"
operator | 门店操作员 | String(32) | Y | s发起本次交易的操作员 | "Obama"
reflect | 反射参数 | String(64) | N | 任何调用者希望原样返回的信息 | { "tips" : "100"}
sign | 签名 | String(32) | Y | 签名，规则请参考附录 《签名规则》 | 

注意:
商户务必以查单或服务器异步通知的订单结果为准并作出正确的处理。查单 API 请参考 支付类 API 说明

#附录

##支付方式

取值 | 含义
----- | -----
3 | 微信


##错误码 

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

result_code | result_message | 说明
----- | ----- | -----
get_brand_wcpay_request:ok |get_brand_wcpay_request:ok |支付成功
get_brand_wcpay_request:fail | get_brand_wcpay_request:fail |支付失败
get_brand_wcpay_request:cancel |get_brand_wcpay_request:cancel |用户取消支付
说明：一般除 get_brand_wcpay_request:ok 外皆认为支付失败，无需细分处理。

##签名规则
1. 筛选 获取所有请求参数，不包括字节类型参数，如文件、字节流，剔除sign与sign_type参数。
2. 排序 将筛选的参数按照第一个字符的键值ASCII码递增排序（字母升序排序），如果遇到相同字符则按照第二个字符的键值ASCII码递增排序，以此类推。
3. 拼接 将排序后的参数与其对应值，组合成“参数=参数值”的格式，并且把这些参数用&字符连接起来，此时生成的字符串为待签名字符串。将key的值拼接在字符串后面，调用MD5算法生成sign。将sign转换成大写。

例：
传入参数如下
terminal_sn: "123"
client_sn:"123"
total_amount:"1"
 
拼接参数字符串
stringA="client_sn=123&terminal_sn=123&total_amount=1"
拼接密钥
stringSignTemp = "stringA&key=19b820737ace6937a7808c"
md5生成sign
sign = md5(stringSignTemp).toUpperCase()

##注：
  需要使用微信浏览器，使用302跳转的方式访问https://m.wosai.cn/qr/gateway
  示例：
  <?php

$paramsStr = "client_sn=***&operator=TEST&return_url=***&subject=TEST&terminal_sn=***&total_amount=*";
$sign = strtoupper(md5($paramsStr.'&key=**********'));
$paramsStr = $paramsStr."&sign=".$sign;

header("Location:https://m.wosai.cn/qr/gateway?".$paramsStr);
