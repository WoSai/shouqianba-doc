# 商户禁用接口（/v2/merchant/upload）

## 请求参数

参数 | 参数名称 | 类型(长度) | 必传| 参数说明
--------- | ------ | ----- | -------|-------------------
file | 图片base64编码 ||Y|


## 请求示例

   
   ```json
    {
      "file": "{base64}"
    }
   ```
   
## 响应示例

   
   ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "SUCCESS",
            "data": "http://images.wosaimg.com/9c/a5acf81c00eda3e2e7029b2da32918d439ffa9.jpg"
        }
    }
   ```
