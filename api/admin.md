# 对接收钱吧API

## 关键业务流程
### B扫C交易
#### 时序
![B扫C](http://ww4.sinaimg.cn/large/48673013gw1ez7c45v2t4j20gq0rzdhm.jpg)


### C扫B交易
#### 时序
![C扫B](http://ww4.sinaimg.cn/large/48673013gw1ez7c4lpqb1j20g80flmy3.jpg)


### 退款
#### 时序
![退款](http://ww2.sinaimg.cn/large/48673013gw1ez7c4wsb9kj20gq0h3mxx.jpg)


## 终端管理接口
对接支付网关2.0 API时，除了[核心支付接口](api/core.md)所列接口外，还可能需要用到下列管理类接口

### 激活
激活接口用于根据激活码，获取终端sn和终端key，用于调用核心支付接口时的签名。激活接口的请求和响应需要使用服务商ID和secret做签名（验签），签名方法同核心支付接口。
#### 接口名
POST /terminal/activate
#### 请求类型
application/json
#### 请求参数
字段名 | 类型 | 是否必填 | 说明
------ | ----- | -----| -----
code | string | Y | 激活码内容
device_id | string | Y | 设备唯一身份ID
os_info | string | N | 当前系统信息，如: Android5.0
sdk_version | string | Y | SDK版本

#### 响应
字段名 | 类型 | 是否必填 | 说明
------ | ----- | -----| -----
terminal_sn | string | Y | 终端号
terminal_key | string | Y | 终端key

如：

```json
{
  "result_code": "200",
  "biz_response": {
    "terminal_sn": "10298371039",
    "terminal_key": "68d499beda5f72116592f5c527465656"
  }
}
```

### 签到
签到接口用于获取每日最新的终端key，否则使用过期的终端key做签名，调用核心支付接口会收到签名错误的响应。签到接口的请求需要使用上一次有效的终端sn和终端key做签名，做法同支付接口一样。建议每自然天执行第一笔核心支付接口调用时，自动执行签到操作。

#### 接口名
POST /terminal/checkin
#### 请求类型
application/json
#### 请求参数
字段名 | 类型 | 是否必填 | 说明
------ | ----- | -----| -----
terminal_sn | string | Y | 终端号
device_id | string | Y | 设备唯一身份ID
os_info | string | N | 当前系统信息，如: Android5.0
sdk_version | string | N | SDK版本

#### 响应
字段名 | 类型 | 是否必填 | 说明
------ | ----- | -----| -----
terminal_sn | string | Y | 终端号
terminal_key | string | Y | 终端key

如：

```json
{
  "result_code": "200",
  "biz_response": {
    "terminal_sn": "10298371039",
    "terminal_key": "68d499beda5f72116592f5c527465656"
  }
}
```

### 上传日志
该接口用于上传SDK本地的日志数据到服务器，非必须。建议SDK每次签到完成后，上传历史日志文件，上传成功后删除已上传的日志文件。该接口需要使用终端sn和终端key做签名，方式同支付接口。

#### 接口名
POST /terminal/uploadLog

#### 请求参数
Body内容即为日志，请使用zip格式压缩。

#### 响应
成功：

```json
{
  "result_code": "200",
  "error_code": "SUCCESS",
  "error_message": "ok"
}
```
失败则result_code不为200.

#### 错误码
待补充

## 安全
支付网关新接口采用了新的鉴权机制，以及引入了新的终端概念，SDK需要额外提供交易接口之外的接口。

### 接口签名
所有支付网关的请求，需要在HTTP头中放置签名首部，使用终端KEY签名。终端KEY默认由SDK存储。签名方式详见支付网关文档V2.0.

### 终端激活
新的终端概念要求一个SDK实例独立使用一套终端ID和终端KEY，终端ID和终端KEY的配置通过激活过程实现。SDK需要提供激活接口，供外部传入激活码，然后向收钱吧服务器获取对应的终端ID和终端KDY，并由SDK负责存储ID和KEY。

### 终端KEY更新
SDK内部实现类似POS机的『签到』机制，用于每日更新终端KEY。可以实现为每自然天，发起第一笔向支付网关的请求前，自动执行签到操作，并更新本地存储的终端KEY。

