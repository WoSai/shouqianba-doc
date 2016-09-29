# 签到
签到接口用于获取每日最新的终端密钥（terminal_key）。如果使用过期的终端密钥（terminal_key）做签名，调用核心支付接口会收到签名错误的响应。签到接口的请求需要使用上一次有效的终端号（terminal_sn）和终端密钥（terminal_key）做签名，签名做法同激活接口一样。
	
	建议每自然天执行第一笔核心支付接口调用时，自动执行签到操作。
	SDK 会自动完成签到，不需要单独签到。

## 接口名
{api_domain}/terminal/checkin
### 请求类型
application/json
## 请求参数
字段名 | 类型 | 是否必填 | 说明
------ | ----- | -----| -----
terminal_sn | string | Y | 终端号
device_id | string | Y | 设备唯一身份ID
os_info | string | N | 当前系统信息，如: Android5.0
sdk_version | string | N | SDK版本

## 响应
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

##签到接口接入常见问题
###1.签到接口的作用
一个密钥每个自然日会过期。签到的作用是更新终端密钥，获取每日最新密钥。开发者需要把最新的terminal_key保存下来。

	SDK 会自动完成签到，不需要单独签到。
	Web API 建议每自然天执行第一笔核心支付接口调用时，自动执行签到操作。
	
###2.签到失败问题?
 如果签到失败，一般都是更换设备导致。解决方法：重新申请新的激活码。
