# 接入流程

##申请接入资格

- 请联系我们工作人员洽谈接入事宜：陆斯维(13917862326), 藏建强(18005736061)

- 如果您需要英文服务洽谈接入事宜：Stanley Lu (+86 13917862326)

##提交资料

向申请接入资格的工作人员提供必要的资料，以获取您的服务商序列号（vendor_sn）和服务商密钥（vendor_key）和服务商平台,并在服务商平台生成服务商开发者的appid。

向工作人员提供商户资料，获取激活该商户终端的激活码。

至此，您已经可以开始使用收钱吧支付平台的API了。


##对接过程的业务流程

正常使用支付平台的交易功能，至少需要经历如下三个步骤：

1. 激活(一次)
2. 签到(可选)
3. 交易


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

* **支付**： B扫C支付模式，支付平台会自动根据支付码识别支付方式。
* **二维码预下单**： C扫B当面付模式，调用接口生成二维码，消费者扫码完成支付，接口返回的是二维码内容，开发者需要自己生成二维码图片。

* **退款**： 根据支付平台订单号完成退款，可支持同一笔订单分多次退款。

* **撤单**： 当天的订单可以通过这个接口撤销。和退款接口相比，调用撤单接口在实现全额退款的同时不会向商户加收手续费。

* **查询**： 获取订单的最新状态。




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

###注意细节
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


### 签名所用的sn和key

* 激活接口（/terminal/activate）的签名使用服务商序列号（vendor_sn）和（vendor_key）
* 其他接口均使用激活接口成功返回的终端号（terminal_sn）和终端密钥（terminal_key）

## Demo程序代码
* Python：[Demo的github项目链接=>] https://github.com/WoSai/shouqianba-webapi-pythondemo
* Java：[Demo的github项目链接=>] https://github.com/WoSai/shouqianba-webapi-javademo

##对接过程中的常见问题请参考API对接常见问题说明文档