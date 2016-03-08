# 收钱吧支付网关2.0-windowsSDK开发接入文档
##1 UpaySDK简介

收钱吧 UpaySDK 是喔噻科技研发的为软件服务商提供收银服务及营销增值服务的开发工具包,支持windows、ios、android三大平台。
通过对接 UpaySDK,可以快速实现对主流支付服务平台的接入,帮助客户实现对智能化收款服务特别是移动支付收款的需求。
UpaySDK目前支持支付宝、微信、百付宝、京东钱包等主流的移动支付方式,银联钱包、QQ钱包也即将上线。

##2 文档说明
###2.1 文档内容

本文档主要描述 UpaySDK windows 版的接口定义、参数定义、错误处理等,同时也提供了多种开发语言的 demo 样例,以便开发者能够快速完成开发进行实施。
###2.2 阅读对象

具有开发能力来集成 UpaySDK 的商户的技术架构师,研发工程师,测试工程师,系统运维工程师等


###2.3 版本控制

版本号|完成日期|拟稿和修改人|发布日期|修订说明
---|---|---|---|---
V2.1.0|2016/01/25|王志鹏，刘毅|--|初稿
V2.1.0 Build.160128|2016/01/28|王志鹏|--|新增revoke接口说明，并修改了激活接口参数，<br>同时更新了本地错误类
V2.1.0 Build.160129|2016/01/29|王志鹏|--|文档增加了几个错误提示的说明，新增reflect和extended参数说明
V2.1.0 Build.160130|2016/01/31|王志鹏|--|修正文档中一个访问地址错误，增加了查询接口的返回参数描述
V2.1.0 Build.160202|2016/02/02|王志鹏|--|补充调用接口的参数规范说明
V2.1.0 Build.160222|2016/02/22|王志鹏|--|修正文档描述错误

##3 功能概述

UpaySDK 主要的业务功能有如下五个:

*  激活

  ```
  必须通过激活码激活后才可以正常使用 UpaySDK 的其它功能,
  	在商户完成入网时由收钱吧会分配对应的激活码
  ``` 
  
* 支付
		
	```
	B 扫 C 模式,商户通过扫码枪扫描消费者 APP 的付款码以完成收款动作
	```
* 预下单

	```
	C 扫 B 模式,商户生成收款的二维码,消费者通过 APP 扫描完成付款动作
	```
* 退款

	```
	消费者向商户提出退款请求,商户通过 UpaySDK 进行退款
	```
* 查询

	```
	商户通过 UpaySDK 查询某一笔订单的详细信息,若商户使用预下单无UI接口
	则需要通过此功能来确认订单的最终状态
	```
* 撤单

	```
	商户通过 UpaySDK 对特定的某一笔交易进行撤单操作,消费者支付金额会全额退回给消费者,并且对商户不会产生费率
	```


##4 接入指南

###4.1 资源说明
#### 4.1.1 下载
[下载最新版的SDK](http://shouqianba-sdk.oss-cn-hangzhou.aliyuncs.com/SQB-Windows-SDK-2.1.0_build20160307.zip)。为保证您的财产和数据安全，请勿使用从其他非收钱吧渠道获取的SDK。对由于使用了非官方SDK而导致的任何物质或非物质损失，收钱吧概不负责。

####4.1.2 内容
SDK 包含一个“CashBarV2.dll”动态库文件和两个配置文件,如下图:
![GitHub set up](http://ww2.sinaimg.cn/mw690/839dbc19gw1f180uytbjvj21hw09gjt2.jpg)

####4.1.3 部署

一般情况下,开发者只需要将 dll 和配置文件拷贝到需要集成的第三方应用执行文件同级目录下,即完成了部署。 

若部署环境对目录有其它要求也可以通过以下方式进行部署:

```
1. Dll 放在目标环境下任意可读取的目录下,以下方式选其一即可

	a)在加载 dll 时指定其所在目录完整路径
	b)在环境变量”Path“的变量值里增加 dll 所在目录完整路径
	
2. 配置文件放在目标环境下任意可读取的目录下,以下方式选其一即可
	
	a)通过”4.4.2.2 设置配置文件路径”接口
	b)新增环境变量“WosaiSDKPath“,并将其变量值赋值为配置文件所在目录
完整路径
```

####4.1.3 环境

UpaySDK 默认是指向测试环境,如要部署到正式环境请参考 “4.5.1 KeyParams” 更改配置即可。

####4.1.4 使用
UpaySDK 的使用步骤,一般包括:

```
1. 初始化:   加载 SDK(只需一次)
2. 业务请求: 发送业务请求;(根据业务需求可多次调用) 
3. 业务处理: 处理业务结果;(与业务请求一一对应)
4. 销毁:    销毁 SDK(只需一次)
```

业务请求处理完毕后,SDK 会返回业务结果,应用端需要按照业务结果进行处理。具体过程如下图：

![GitHub set up](http://ww4.sinaimg.cn/large/61df8f13gw1f12g9gkuw5j20n309o75o.jpg)

####4.1.5 更新

第三方主动到“收钱吧”官方指定更新路径下下载最新的 UpaySDK 包内容(包括动态库文件),下载完成后,替换原来已经存在的 UpaySDK 包内容,即可完成更新。
通常情况下 UpaySDK 会向下进行版本兼容,开发者更新无需重新开发,如有需要更改 的情况,收钱吧会在官网更新时做出明显提醒。

###4.2 协议规则
	
协议|规则
---|---
输入参数|按顺序以&符号连接，<br>例: 参数 1&参数 2&...&参数 n 
输出参数|**业务接口**:返回状态.返回信息(&符号连接) 或者 返回状 态:返回信息(json 格式)<br>例：<br>Pay Success.参数 1&参数 2&...&参数 n<br>Query Result:{param1=”1”, param1=”2”}<br>**扩展接口**:单一返回值
字符编码|统一采用 UTF-8 字符编码
参数特殊字符及转义|所有的参数,不能含有&字符,除 extended 参数外的所有 参数中包含”字符的,需要使用\”转义代替
输入参数必要性|M-必填,<br>C-满足条件则必填,<br>O-选填,<br>P-必须占位可传空值
输出参数必要性|M-固定返回,<br>C-满足条件返回
	
	
###4.3 参数规定
####4.3.1 通讯响应码

响应码|响应描述
---|---
200|通讯成功
400|通讯失败，客户端错误
500|通讯失败，服务端错误

####4.3.2 通讯错误码

错误码|错误描述
---|---
INVALID_PARAMS|参数错误
INVALID_TERMINAL|终端错误
ILLEGAL_SIGN|签名错误
INVALID_BARCODE|支付条码错误
UNKNOWN_SYSTEM_ERROR|系统错误
UNKNOWN_SYSTEM_ERROR|不识别的支付通道

####4.3.3 业务响应码

响应码|响应描述
---|---
PAY_SUCCESS|支付操作成功
 PAY_FAIL|支付操作失败并且已冲正
PAY_FAIL_ERROR|支付操作失败并且不确定第三方支付通道状态
 CANCEL_SUCCESS|撤单操作成功
CANCEL_ERROR|撤单操作失败并且不确定第三方支付通道状态
CANCEL_ABORT_ERROR|撤单操作试图终止进行中的支付流程,但是失 败,不确定第三方支付通道的状态
CANCEL_ABORT_SUCCESS|撤单操作试图终止进行中的支付流程并且成功
REFUND_SUCCESS|退款操作成功
REFUND_ERROR|退款操作失败并且不确定第三方支付通状态
PRECREATE_SUCCESS|预下单操作成功
SUCCESS|操作成功
PRECREATE_FAIL|预下单操作失败

####4.3.4 业务错误码

错误码|错误描述
---|---
AUTHCODE_EXPIRE|二维码过期
INVALID_BARCODE|条码错误
INSUFFICIENT_FUND|账户金额不足
EXPIRED_BARCODE|过期的支付条码
BUYER_OVER_DAILY_LIMIT|付款人当日付款金额超过上限
BUYER_OVER_TRANSACTION_LIMIT|付款人单笔付款金额超过上限
SELLER_OVER_DAILY_LIMIT|收款账户当日收款金额超过上限 
TRADE_NOT_EXIST|交易不存在
TRADE_HAS_SUCCESS|交易已被支付
SELLER_BALANCE_NOT_ENOUGH|卖家余额不足
REFUND_AMT_NOT_EQUAL_TOTAL|退款金额无效
TRADE_FAILED|交易失败
CLIENT_SN_CONFLICT|client_sn在系统中已存在
UPAY_ORDER_NOT_EXIST|订单不存在
REFUND_REQUEST_CONFLICT|重复的退款请求
UNEXPECTED_PROVIDER_ERROR|不认识的支付通道


####4.3.5 支付方式

取值|含义
---|---
1|支付宝
3|微信
4|百付宝
5|京东钱包

####4.3.6 二级支付方式

取值|含义
---|---
1|条码支付（B扫C）
2|二维码支付（C扫B）

####4.3.7 订单状态

参数名称|参数含义
---|---
CREATED|订单已创建/支付中
PAID|订单支付成功
PAY_CANCELED|支付失败并且已经成功充正
PAY_ERROR|支付失败,不确定是否已经成功充正
REFUNDED|已成功全额退款
PARTIAL_REFUNDED|已成功部分退款
REFUND_ERROR|退款失败并且不确定第三方支付通道的最终退款状态
CANCELED|用户发起的撤单已成功
CANCEL_ERROR|用户发起的撤单失败并且不确定第三方支付通道的最终状态


####4.3.8 返回状态

参数名称|参数含义
---|---
Activate Success|激活成功
Activate Failure|激活失败
Pay Success|支付成功
Pay Failure|支付失败
Refund Success|退款成功
Refund Failure|退款失败
Query Result|查询结果
Query Failure|查询失败
PreCreate Success|预下单成功
PreCreate Failure|预下单失败
Revoke Success|撤单成功
Revoke Failure|撤单失败


###4.4 接口列表
####4.4.1 业务接口
**4.4.1.1激活**

该接口负责向收钱吧发送激活请求,激活成功后方可正常使用 SDK

* 4.4.1.1.1  函数原型

函数原型|有无UI|返回状态
---|---|---
const char* __stdcall activateUI (const char* param)|有|Activate Success、Activate Failure
const char* __stdcall activate(const char* params)|无|Activate Success、Activate Failure

* 4.4.1.1.2 输入参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
供应商|String|M|由收钱吧分配的供应商ID|--
授权码|String|M|由收钱吧分配的供应商Key|--
激活码|String(12)|C|由收钱吧分配的激活码，activate必传|411451574136


* 4.4.1.1.3 输出参数
 
名称|类型|必要性|参数说明|示例
---|---|---|---|---
返回状态|String|M|标识本次请求成功还是失败<br>Activate Success、Activate Failure|Activate Success
错误码|String|C|返回状态 Failure 时存在,详细参见错误列表|ACTIVATE_FAIL
错误码描述|String|C|返回状态 Failure 时存在,详细参见错误列表|激活失败


* 4.4.1.1.4 使用示意

![GitHub set up](http://ww1.sinaimg.cn/large/61df8f13gw1f12h44z0mej20g00n976d.jpg)

**4.4.1.2 支付**

* 4.4.1.2.1 函数原型

函数原型|有无UI|返回状态
---|---|---
const char* __stdcall payUI (const char* params)|有|Pay Success、Pay Failure
const char* __stdcall pay(const char* params)|无|Pay Success、Pay Failure

* 4.4.1.2.2 输入参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
商户订单号|String(32)|M|商户系统内部的唯一订单标识|201660121175530001
商品名称|String(32)|M|本次交易的简要介绍|测试商品
操作员|String(32)|M|发起本次交易的操作员|00
商品描述|String(256)|P|对商品或本次交易的详细描述|雪碧 300ml
支付方式|String(1)|P|见参数规定,若传空值,接口会自动根 据付款码识别|1
交易金额|String(10)|M|以分为单位,不超过 10 位纯数字字符串|1000
付款码|String(32)|P|消费者用于付款的条码或二维码内容, 使用 UI 时可以传空值|130818341921441147
反射参数|String|P|商户系统希望收钱吧接口服务原样返回的字符内容|--
扩展参数|String|P|商户系统与收钱吧系统约定的参数格式|--

* 4.4.1.2.3 输出参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
返回状态|String|M|标识本次请求成功还是失败定|Pay Success
收钱吧订单号|String(32)|M|收钱吧生成的当前订单的唯一标识,返 回状态为 Failure 时可能为空值|7894259244017207
商户订单号|String(32)|M|商户系统内部的唯一订单标识|20160122111520
支付方式|String(1)|M|见参数规定,返回状态为 Failure 时可能 为空值|1
支付平台交易凭证|String(64)|C|返回状态 Success 时存在|10054810162016012 22834933179
错误码|String|C|返回状态 Failure 时存在,详细参见错误 列表|CLIENT_SN_CONFLICT
错误码描述|String|C|返回状态 Failure 时存在,详细参见错误 列表|client_sn 20160122111519 在系统中已经存在
反射参数|String|P|商户系统上报的字符内容|--

* 4.4.1.2.4 使用示意

![GitHub set up](http://ww4.sinaimg.cn/large/61df8f13gw1f12hit1wq6j20c80mlta3.jpg)


**4.4.1.3 预下单**

该接口负责向收钱吧发送生成商户收款二维码的请求并返回请求结果

* 4.4.1.3.1 函数原型

函数原型|有无UI|返回状态
---|---|---
const char* __stdcall preCreateUI (const char* params)|有|Pay Success、Pay Failure、 PreCreate Failure
const char* __stdcall preCreate (const char* params)|无|PreCreate Success、 PreCreate Failure

* 4.4.1.3.2输入参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
商户订单号|String(32)|M|商户系统内部的唯一订单标识201660121175530001
商品名称|String(32)|M|本次交易的简要介绍测试商品
操作员|String(32)|M|发起本次交易的操作员|00
商品描述|String(256)|P|对商品或本次交易的详细描述|雪碧 300ml
支付方式|String(1)|M|本次交易使用的支付通道,见参数规定|1
交易金额|String(10)|M|以分为单位,不超过 10 位纯数字字符串|1000
保存路径|String(32)|C|用于保存二维码图片,preCreate时必传|C:\prcode\
反射参数|String|P|商户系统希望收钱吧接口服务原样返回的字符内容|--
扩展参数|String|P|商户系统与收钱吧系统约定的参数格式|--


* 4.4.1.3.3输出参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
返回状态|String|M|标识本次请求成功还是失败,见参数规定|PreCreate Failure
收钱吧订单号|String(32)|M|收钱吧生成的当前订单的唯一标识,返 回状态为 PreCreate Failure 时可能为 空值|7894259244017207
商户订单号|String(32)|M|商户系统内部的唯一订单标识|20160122111520
支付方式|String(1)|C|见参数规定,返回状态为 Pay Success 或 Pay Failure 时存在|1
二维码路径|String|C|生成的二维码在客户端的完整路径,返 回状态为 PreCreate Success 时存在|C:\Users\andy\Desktop\qrcode.bmp
支付平台交易凭证|String(64)|C|支付平台的唯一交易流水标识,返回状 态为 Pay Success 时存在|1005481016201601222834933179
错误码|String|C|见错误列表,返回状态为 PreCreate Failure 或 Pay Failure 时存在|CLIENT_SN_CONFLICT
错误码描述|String|C|见错误列表,返回状态为 PreCreate Failure 或 Pay Failure 时存在|client_sn 20160122111519 在系统中已经存在
反射参数|String|P|商户系统上报的字符内容|--


* 4.4.1.3.4使用示意

![GitHub set up](http://ww2.sinaimg.cn/large/61df8f13gw1f12hxdatgyj20hk0l840a.jpg)



**4.4.1.4退款**

* 4.4.1.4.1 函数原型

函数原型|有无UI|返回状态
---|---|---
const char* __stdcall refundUIWithSN (const char* params)|有|Refund Success、Refund Failure
const char* __stdcall refundUIWithClientSN (const char* params)|有|Refund Success、Refund Failure
const char* __stdcall refund(const char* params)|无|Refund Success、 Refund Failure


* 4.4.1.4.2 输入参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
收钱吧订单号|String(32)|C|收钱吧系统内的唯一订单标识;<br>refundUIWithSN 时必须;<br>refund 时必要性为 P,与商户订单号必须有一项不为空,<br>若同时不为空,则收钱吧订单号优先级高|7894259244017207
商户订单号|String(32)|C|商户系统内的唯一订单标识;<br>refundUIWithClientSN 时必须;<br>refund时必要性为P,与收钱吧订单号必须有一项不为空,<br>若同时不为空,则收钱吧订单号优先级高|20160122111520
退款序列号|String(32)|M|商户系统退款的唯一标识|20160122111521
操作员|String(32)|M|发起本次退款的操作员|00
退款金额|String(10)|M|以分为单位,不超过 10 位纯数字字符串|1000
反射参数|String|P|商户系统希望收钱吧接口服务原样返回的字符内容|--

* 4.4.1.4.3 输出参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
返回状态|String|M|标识本次请求成功还是失败,见参数规定|Refund Success
收钱吧订单号|String(32)|M|收钱吧产生当前订单的唯一标识,若未 传入则返回空值|7894259244017207
商户订单号|String(32)|M|商户系统内部的唯一订单标识,若未传 入则返回空值|20160122111520
支付通道交易凭证|String(64)|C|返回状态 Success 时存在|10054810162016012 22834933179
错误码|String|C|返回状态 Failure 时存在,详细参见错误列表|REFUNDABLE_AMOU NT_NOT_ENOUGH
错误码描述|String|C|返回状态 Failure 时存在,详细参见错误列表|退款金额错误,可退金额不足
反射参数|String|P|商户系统上报的字符内容|--

* 4.4.1.4.4 使用示意

![GitHub set up](http://ww4.sinaimg.cn/large/61df8f13gw1f12iabudjuj20iw0m6mz4.jpg)

**4.4.1.5 查询**

该接口负责向收钱吧发起查询一笔订单的请求并返回查询结果

* 4.4.1.5.1 函数原型

函数原型|有无UI|返回状态
---|---|---
const char* __stdcall query (const char* params)|无|Query Result、Query Failure

* 4.4.1.5.2 输入参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
收钱吧订单号|String(32)|P|收钱吧系统内的唯一订单标识;<br>与商户订单号不可以同时为空,<br>若同时存在,则收钱吧订单号优先级高|7894259244017207
商户订单号|String(32)|P|商户系统内的唯一订单标识;<br>与收钱吧订单号不可以同时为空,<br>若同时存在,则收钱吧订单号优先级高|20160122111520

* 4.4.1.5.3 输出参数


名称|类型|必要性|参数说明|示例
---|---|---|---|---
返回状态|String|M|标识本次请求成功还是失败,见参数规定|Query Result
**<font color="red">当返回状态为 Query Failure 时会以&连接形式返回以下参数</font>**|-|-|-|-
收钱吧订单号|String(32)|M|收钱吧产生当前订单的唯一标识,若未传入则返回空值|7894259244017207
商户订单号String(32)||M|商户系统内部的唯一订单标识,若未传入则返回空值|20160122111520
错误码|String|M|详细参见错误列表|x0001
错误码描述|String|M|详细参见错误列表|加载服务失败
**<font color="red">当返回状态为 Query Result 时会以 json 格式返回以下参数</font>**||||
result_code|String|M|通讯响应码,见参数规定|200
error_code|String|C|通讯错误码(通讯失败时返回),见参数规定|UNKNOWN_SYSTEM_ERROR
error_message|String|C|通讯错误描述(通讯失败时返回),见参数规定|未知的系统错误
biz_response|String|C|业务响应数据(通讯成功时返回)|--
**<font color="red">业务响应数据 biz_response 包括以下字段</font>**||||
result_code|String|M|业务响应码，见参数规定|200
**<font color="red">当 biz_response.result_code 返回 FAIL 时会包括以下参数</font>**||||
error_code|String|C|业务错误码，见参数规定|UPAY_ORDER_NOT_EXISTS
error_message|String|C|业务错误描述,见参数规定|订单不存在
**<font color="red">当 biz_response.result_code 返回 SUCCESS 时会包括以下参数</font>**||||
sn|String(32)|C|收钱吧系统内的唯一订单标识|7894259244017207
client_sn|String(32)|C|商户系统内的唯一订单标识|20160122111520
ctime|String(13)|C|订单在收钱吧系统创建的时间|1453442456161
status|String(32)|C|本次操作的流水状态,见参数规定|SUCCESS
payway|String(1)|C|支付方式,见参数规定|1
sub_payway|String(1)|C|二级支付方式,见参数规定|1
order_status|String(32)|C|订单状态,见参数规定|REFUNDED
trade_no|String(64)|C|支付平台交易凭证|200610101620151209 0096528672
description|String|C|商户系统随订单提交的商品描述|--
total_amount|String(10)|C|交易金额|100
net_amount|String(10)|C|剩余金额(实收金额减退款金额)|0
finish_time|String(13)|C|交易在收钱吧完成的时间|1453442456161
channel_finish_time|String(13)|C|交易在支付平台(支付宝、微信等)完成的时间|1453442456161
subject|String(32)|C|本次交易的简要介绍|测试商品
operator|String(64)|C|操作员|00
reflect|String|C|商户系统随订单提交的反射参数|--

* 4.4.1.5.4 使用示意

![GitHub set up](http://ww2.sinaimg.cn/large/61df8f13gw1f12j4c31jtj207h0h4js4.jpg)

**4.4.1.6撤单**

该接口负责向收钱吧发送撤单请求并返回撤单结果,一笔订单进行撤单操作后,已支付金额 会全部退回给消费者

* 4.4.1.6.1函数原型

函数原型|有无UI|返回状态
---|---|---
const char* __stdcall revokeUIWithSN (const char* params)|有|Revoke Success、 Revoke Failure
const char* __stdcall revokeUIWithClientSN (const char* params)|有|Revoke Success、 Revoke Failure
const char* __stdcall revoke(const char* params)|无|Revoke Success、 Revoke Failure

* 4.4.1.6.2输入参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
收钱吧订单号|String(32)|C|收钱吧系统内的唯一订单标识; <br>revokeUIWithSN 时必须;<br>revoke 时与商户订单号必须有一项不 为空,<br>若同时存在,则收钱吧订单号优先级高|7894259244017207
商户订单号|String(32)|C|商户系统内的唯一订单标识; <br>revokeUIWithClientSN 时必须;<br>revoke 时与收钱吧订单号必须有一项不为空,<br>若同时存在,则收钱吧订单号优先级高|20160122111520
反射参数|String|P|商户系统希望收钱吧接口服务原样返回的字符内容|--



* 4.4.1.6.3输出参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
返回状态|String|M|标识本次请求成功还是失败,见参数规定|Revoke Success
收钱吧订单号|String(32)|M|收钱吧产生当前订单的唯一标识,若未 传入则返回空值|7894259244017207
商户订单号|String(32)|M|商户系统内部的唯一订单标识,若未传 入则返回空值|20160122111520
支付通道交易凭证|String(64)|C|返回状态 Success 时存在|10054810162016012 22834933179
错误码|String|C|返回状态 Failure 时存在,详细参见错误列表|--
错误码描述|String|C|返回状态 Failure 时存在,详细参见错误列表|--
反射参数|String|P|商户系统上报的字符内容|--


* 4.4.1.5.4 使用示意

![GitHub set up](http://ww3.sinaimg.cn/large/61df8f13gw1f12p1g8oaxj20g80je3zw.jpg)

####4.4.2 扩展接口
**4.4.2.1获取二维码内容**

该接口负责返回二维码的实际内容,方便调用者进行自己的业务处理,
需在调用 3.4.6 预下单接口后使用

* 4.4.2.1.1函数原型

函数原型|有无UI|返回状态
---|---|---
const char* __stdcall qrcode()|无|NA

* 4.4.2.1.2输入参数

NA

* 4.4.2.1.3输出参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
二维码内容|String|M|支付宝、微信等平台生成的<br>二维码地址或者内容|https://qr.alipay.com/bax0500684qda1dwwepd00bd


**4.4.2.2设置配置文件路径**

该接口负责设置设置文件在客户端的位置,以便动态库获取配置信息

* 4.4.2.2.1函数原型

函数原型|有无UI|返回状态
---|---|---
const int __stdcall setSDKPath(const char* params)|无|NA

* 4.4.2.2.2输入参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
文件路径|String|M|配置文件所在目录完整路径|C:\config\

* 4.4.2.2.3输出参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
应答码|Int|M|返回 0 代表成功|0

**4.4.2.3自动编码**

该接口负责将其他接口传入的字符串参数和返回的字符串自动进行转码,
无需调用者对字符串进行另外的处理

* 4.4.2.3.1函数原型

函数原型|有无UI|返回状态
---|---|---
const int __stdcall autoCodec(int params)|无|NA

* 4.4.2.3.2输入参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
转码标识|Int|M|是否自动进行转码,<br>当参数不为 0 时 sdk 会自动进行转码|1

* 4.4.2.3.3输出参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
应答码|Int|M|返回 0 代表成功|0

**4.4.2.4 获取SDK版本**

该接口负责将返回当前 SDK 的详细版本信息

* 4.4.2.4.1函数原型

函数原型|有无UI|返回状态
---|---|---
const char* __stdcall version()|无|NA

* 4.4.2.4.2输入参数

NA

* 4.4.2.4.3输出参数

名称|类型|必要性|参数说明|示例
---|---|---|---|---
版本信息|String|M|当前SDK版本号|2.1.0 Build.160120d

**4.4.2.5 获取终端号**

该接口负责将返回 SDK 所使用的终端号,激活后才可以获得

* 4.4.2.5.1函数原型

函数原型|有无UI|返回状态
---|---|---
const char* __stdcall terminalSN()|无|NA

* 4.4.2.5.2输入参数

NA

* 4.4.2.5.3输出参数


名称|类型|必要性|参数说明|示例
---|---|---|---|---
终端号|Stirng|M|当前SDK所使用的终端号|18878019483


###4.5 配置文件

####4.5.1 KeyParams

配置 SDK 的基本参数,文件名为 KeyParams,若没有请自行创建

参数名|参数解释|参数值|示例
---|---|---|---
APPURL|业务的请求地址,默认测试环境|测试环境:RC;<br>正式环境:RTM;<br>自定义:http://xxxxxxx/|AppURL:RC
EnableLog|是否开启SDK日志，默认不开启|开启:1,不开启:0|EnableLog:1


####4.5.2 KeySettings

配置 SDK 的快捷键,文件名为 KeySettings,若没有请自行创建

参数名|参数解释|参数值|示例
---|---|---|---
ESC|取消键|16 进制键值|ESC:0x0D
ENTER|确认键|16 进制键值|ENTER:0x0A



###4.6 错误列表

错误码|错误描述|处理建议
----|----|----
Illegal Request|非法的请求|一般不会出现此错误,如若出现请联系收钱吧客服
Illegal Params|参数不正确|检查参数是否符合文档规定
Illegal Amount|金额不正确|检查金额是不是整数型字符串
Illegal Operator|操作员不正确|检查操作员信息是不是没有传递或传递了空值
Illegal SN|收钱吧订单号不正确|检查收钱吧订单号是不是没有传递或传递了空值
Illegal Client SN|商户订单号不正确|检查商户订单号是不是没有传递或传递了空值
Illegal Client SN and SN|商户订单号或收钱吧订单号不正确|检查商户订单号、收钱吧订单号是不是都没有传递或都传递了空值
Illegal Dynamic ID|付款码不正确|检查付款码是不是没有传递或传递了空值
Illegal Subject|商品名称不正确|检查商品名称是不是没有传递 或传递了空值
Illegal Terminal SN|终端号不正确|检查 SDK 同级目录下是否有 AutoKeyParams 文件,若有请联系收钱吧客服
Illegal Secret|密钥不正确|一般不会出现此错误,如若出现请联系收钱吧客服
Illegal Refund Request No|退款序列号不正确|检查退款序列号是不是没有传 递或传递了空值
Illegal Save Path|保存路径不正确|检查保存路径是不是没有传递 或传递了空值
x0000|发生未知错误|请联系收钱吧客服
x0001|加载服务失败|先检查网络是否正常,若正常请 联系收钱吧客服
x0002|服务异常|请联系收钱吧客服
x0003|请求超时|先检查网络是否正常,是否可以 访问 https://api.shouqianba.com, 若都正常请联系收钱吧客服
x1001|保存二维码失败,请检 查路径|检查二维码保存的路径是否存在,是否有读写权限
x1002|无法保存激活数据|检查 SDK 所在文件夹是否拥有读写权限,若有请联系收钱吧客服
x1003|写入激活数据失败|检查 SDK 所在文件夹是否拥有读写权限,若有请联系收钱吧客服
x1004|无法保存签到数据|检查 SDK 所在文件夹是否拥有读写权限,若有请联系收钱吧客服
x1005|写入签到数据失败|检查 SDK 所在文件夹是否拥有 读写权限,若有请联系收钱吧客服
x2001|签到获得的授权内容无 效|请联系收钱吧客服
x2002|自动冲正失败|冲正未成功,请联系收钱吧客服确认订单状态
x2003|支付失败|支付未成功,支付金额已经退回给消费者,请重新发起交易
x3001|激活签名错误|联系软件开发商以确认供应商信息是否正确
x3002|支付签名错误|一般不会出现此错误,如若出现请联系收钱吧客服
x3003|退款签名错误|一般不会出现此错误,如若出现请联系收钱吧客服
x3004|预下单签名错误|一般不会出现此错误,如若出现请联系收钱吧客服
x3005|查询签名错误|一般不会出现此错误,如若出现请联系收钱吧客服
x3006|撤单签名错误|一般不会出现此错误,如若出现请联系收钱吧客服
x4001|支付清算失败|支付失败,请联系收钱吧客服确认订单状态
x4002|退款清算失败|退款失败,请联系收钱吧客服确认退款状态
x4003|撤单清算失败|撤单失败,请联系收钱吧客服确认撤单状态
x5001|调用收钱吧界面错误|联系软件开发商
UNKNOWN_SYSTEM_ERROR|系统错误|一般不会出现此错误,如若出现请联系收钱吧客服
ACTIVATE_FAIL|激活失败|联系收钱吧客服
AUTHCODE_EXPIRE|二维码过期|让消费者刷新付款码重新支付
INVALID_BARCODE|条码错误|确认所扫的付款码是否是收钱吧当前支持的支付方式
INSUFFICIENT_FUND|账户金额不足|消费者的账户余额或者银行卡余额不足,让消费者更换银行卡进行支付
EXPIRED_BARCODE|过期的支付条码|让消费者刷新付款码重新支付
BUYER_OVER_DAILY_LIMIT|付款人当日付款金额超过上限|让消费者更换银行卡重新进行支付
BUYER_OVER_TRANSACTION_LIMIT|付款人单笔付款金额超 过上限|让消费者更换银行卡重新进行支付
SELLER_OVER_DAILY_LIMIT|收款账户当日收款金额超过上限|商户收款超过收钱吧设置的额 度上限,请联系收钱吧客服进行提额
TRADE_NOT_EXIST|交易不存在|找不到订单信息,需要确认订单号是否正确
TRADE_HAS_SUCCESS|交易已被支付|订单已经支付成功,不能重复支付
SELLER_BALANCE_NOT_ENOUGH|卖家余额不足|需要收款商户确认账户余额是否足够
REFUND_AMT_NOT_EQUAL_TOTAL|退款金额无效|检查退款金额是否正确,且不能大于订单的可退款金额
TRADE_FAILED|交易失败|请重新发起交易请求
CLIENT_SN_CONFLICT|client_sn 在系统中已存在|一个商户订单号只能发起一次支付请求
UPAY_ORDER_NOT_EXIST|订单不存在|确认订单号是否正确,若确认
REFUND_REQUEST_CONFLICT|重复的退款请求|检查退款序列号是否重复
UNEXPECTED_PROVIDER_ERROR|不认识的支付通道|收钱吧不支持的支付方式,需开发者确认支付方式传值是否正确,若正确请联系收钱吧客服



###4.7 示例代码
 
开发语言|下载地址
----|----
C++| （https://github.com/WoSai/shouqianba-winsdk2.0-demo)



