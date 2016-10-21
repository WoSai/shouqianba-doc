# 上传日志（非必须）
该接口用于上传终端本地的日志数据到服务器，非必须。建议终端每次签到完成后，上传历史日志文件，上传成功后删除已上传的日志文件。该接口需要使用终端号（terminal_sn）和终端密钥（terminal_key）做签名，方式同支付接口。

## 接口名
{api_domain}/terminal/uploadLog

## 请求参数
Body内容即为日志，请使用zip格式压缩。

## 响应
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
