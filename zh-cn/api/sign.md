# 签名机制

## 请求域名

   收钱吧接入域名(api_domain)：`https://vsi-api.shouqianba.com`
   
   <font color="red">**注：收钱吧的Web API接口是https协议，当发起请求时，会要求检查证书，在发起请求时规避ssl的证书检查或者
  携带证书请求**</font>
    
## 需要参与签名的接口及参数

需要使用服务商序列号(vendor_sn)和服务商密钥(vendor_key)进行签名的接口：
   
   * 1.激活接口(/terminal/activate)
     
需要使用激活得到的终端号(terminal_sn)和终端密钥(terminal_key)进行签名的接口:
   
   * 1.签到(/terminal/checkin)
   * 2.支付(/upay/v2/pay)
   * 3.预下单(/upay/v2/precreate)
   * 4.退款(/upay/v2/refund)
   * 5.主动撤单(/upay/v2/revoke)
   * 6.冲正(/upay/v2/cancel)
   * 7.查询(/upay/v2/query)
   * 8.上传日志(/terminal/uploadLog)
   
    <font color="red">**注：如果使用了签到接口，请以签到返回的terminal_sn和terminal_key作为其他接口的签名参数**</font>

     
## 签名方法
   如果要正常使用各接口，需要按照以下方式去进行签名验证:
   
   * 支付平台所有的API仅支持JSON格式的请求调用，请务必在HTTP请求头中加入`Content-Type: application/json`。
   * 所有请求的body都需采用`UTF-8`编码，所有响应也会采用相同编码。
   * 支付平台所有的API调用都需要签名验证。
   * 采用应用层签名机制。将HTTP请求body部分的`UTF-8`编码字节流视为被签名的内容，不关心主体的格式。
   * 签名序列号(sn)和签名值(sign)放在HTTP请求头中，在接入服务中统一校验。
   * 签名算法: sign = MD5( CONCAT( body + key ) )
   * 签名首部: `Authorization: sn + " " + sign`
   * 所有返回参数都为 <font color="red">**JSON**</font> 格式，请务必在HTTP请求头中加入Content-Type: application/json。
   * 所有请求的body都需采用UTF-8编码，所有响应也会采用相同编码。
   * 所有返回数据的类型都是 <font color="red">**字符串**</font>。
   * 接口中所有涉及金额的地方都以 <font color="red">**分**</font> 为单位。
### 签名案例
```
curl --request POST
  --url https://vsi-api.shouqianba.com/upay/v2/pay
  --header 'Authorization: sn+" "+sign' 
  --header 'content-type: application/json'
  --data '{"params": "test"}'
```
   
## Demo程序代码
   * Python：[Demo的github项目链接=>] https://github.com/WoSai/shouqianba-webapi-pythondemo
   * Java：[Demo的github项目链接=>] https://github.com/WoSai/shouqianba-webapi-javademo
   * C#:[Demo的github项目链接=>]  https://github.com/WoSai/Shouqianba-Mobile-Payment-API-CSharp-demo
   * PHP:[Demo项目链接=>] https://github.com/WoSai/Shouqianba-mobile-payment-API-demo-PHP
