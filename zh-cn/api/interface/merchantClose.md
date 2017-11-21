# 商户禁用接口（/merchant/close）

## 请求参数

参数 | 参数名称 | 类型(长度) | 必传| 参数说明
--------- | ------ | ----- | -------|-------------------
vendor_sn | 服务商号 |String(32)|Y|
merchant_sn | 商户号 |String(32)|Y|


## 请求示例

   
   ```json
    {
      "vendor_sn": "91800129",
      "merchant_sn": "21680002793234"
    }
   ```
   
## 响应示例

   
   ```json
    {
       "result_code": "200",
       "biz_response": {
           "result_code": "SUCCESS"
    }
    }
   ```
