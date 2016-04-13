# 接入流程

## Step 1 - 申请接入资格

- 请联系我们工作人员洽谈接入事宜：陆斯维(13917862326), 藏建强(18005736061)

- 如果您需要英文服务洽谈接入事宜：Stanley Lu (+86 13917862326)

## Step 2 - 提交资料

向申请接入资格的工作人员提供必要的资料，以获取您的服务商序列号（vendor_sn）和服务商密钥（vendor_key）。

向工作人员提供商户资料，获取激活该商户终端的激活码。

至此，您已经可以开始使用收钱吧支付平台的API了。

## Step 3 - 开发应用

接入域名(api_domain)：`https://api.shouqianba.com`

支付平台所有的API仅支持JSON格式的请求调用，请务必在HTTP请求头中加入`Content-Type: application/json`。

所有请求的body都需采用`UTF-8`编码，所有响应也会采用相同编码。

支付平台所有的API调用都需要签名验证。

### 签名算法

* 采用应用层签名机制。将HTTP请求body部分的`UTF-8`编码字节流视为被签名的内容，不关心主体的格式。
* 签名人序列号(sn)和签名值(sign)放在HTTP请求头中，在接入服务中统一校验。
* 签名算法: sign = MD5( CONCAT( body + key ) )
* 签名首部: `Authorization: sn + " " + sign`

### 签名所用的sn和key

* 激活接口（/terminal/activate）的签名使用服务商序列号（vendor_sn）和（vendor_key）
* 其他接口均使用激活接口成功返回的终端号（terminal_sn）和终端密钥（terminal_key）

## Demo程序代码
* Python：[Demo的github项目链接=>] https://github.com/WoSai/shouqianba-webapi-pythondemo
* Java：[Demo的github项目链接=>] https://github.com/WoSai/shouqianba-webapi-javademo
