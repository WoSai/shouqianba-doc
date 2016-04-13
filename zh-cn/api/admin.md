# 业务类API Reference

### 激活
激活接口用于获取交易接口签名需要的参数（终端号和终端密钥）。激活接口需要使用服务商的密钥签名。签名方法参考支付接口的文档。

	请使用服务商序列号（vendor_sn）作为签名人序列号，服务商密钥（vendor_key）作为签名密钥。
#### 接口名
POST /terminal/activate
#### 请求类型
application/json
#### 请求参数
字段名 | 类型 | 是否必填 | 说明
------ | ----- | -----| -----
code | string | Y | 终端激活码
device_id | string | Y | 设备唯一身份ID
os_info | string | N | 当前系统信息，如: Android5.0
sdk_version | string | Y | SDK版本
type | string | N | 设备类型可以不提供。默认为"2"（SQB_SDK)

#### 响应
字段名 | 类型 | 是否必填 | 说明
------ | ----- | -----| -----
terminal_sn | string | Y | 终端号
terminal_key | string | Y | 终端密钥

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
签到接口用于获取每日最新的终端密钥（terminal_key）。如果使用过期的终端密钥（terminal_key）做签名，调用核心支付接口会收到签名错误的响应。签到接口的请求需要使用上一次有效的终端号（terminal_sn）和终端密钥（terminal_key）做签名，做法同支付接口一样。
	
	建议每自然天执行第一笔核心支付接口调用时，自动执行签到操作。
	SDK 会自动完成签到，不需要单独签到。

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
terminal_key | string | Y | 终端密钥

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
该接口用于上传SDK本地的日志数据到服务器，非必须。建议SDK每次签到完成后，上传历史日志文件，上传成功后删除已上传的日志文件。该接口需要使用终端号（terminal_sn）和终端密钥（terminal_key）做签名，方式同支付接口。

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
所有支付网关的请求，需要在HTTP头中放置签名首部，使用终端密钥（terminal_key）签名。签名方式详见支付网关文档V2.0.

### 终端激活
新的终端概念要求一个SDK实例独立使用一套终端号（terminal_sn）和终端密钥（terminal_key），终端号（terminal_sn）和终端密钥（terminal_key）的配置通过激活过程实现。SDK需要提供激活接口，供外部传入终端激活码（code），然后向收钱吧服务器获取对应的终端号（terminal_sn）和终端密钥（terminal_key），并由SDK负责存储终端号（terminal_sn）和终端密钥（terminal_key）。

### 终端KEY更新
SDK内部实现类似POS机的『签到』机制，用于每日更新终端密钥。可以实现为每自然天，发起第一笔向支付网关的请求前，自动执行签到操作，并更新本地存储的终端密钥。

