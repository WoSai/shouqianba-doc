# 接入流程

## Step 1 - 申请接入资格

请联系我们工作人员洽谈接入事宜：藏建强(18005736061), 陆斯维(13917862326)

## Step 2 - 提交资料

向申请接入资格的工作人员提供必要的资料，以获取您的vendorSn和vendorKey。

向工作人员提供商户资料，获取激活该商户终端的激活码。

至此，您已经可以开始使用收钱吧支付平台的API了。

## Step 3 - 开发应用

接入域名：https://api.shouqianba.com

支付平台所以的API仅支持JSON格式的请求调用，请务必在HTTP请求头中加入`Content-Type: application/json`

支付平台所有的API调用都需要签名验证。

### 签名算法

* 采用传输层签名机制。将HTTP请求body部分字节流视为被签名的内容，不关心主体的格式。
* 签名人sn和签名值放在HTTP请求头中，在接入服务中统一校验。
* 签名算法: sign = MD5( CONCAT( body + key ) )
* 签名首部: `Authorization: sn + " " + sign`

### 签名所用的sn和key

* 激活接口（/terminal/activate）的签名使用vendorSn和vendorKey
* 其他接口均使用激活接口成功返回的terminalSn和terminalKey

