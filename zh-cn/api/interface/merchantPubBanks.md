# 开户银行接口（/v2/merchant/pub_banks）

## 请求参数

参数 | 参数名称 | 类型(长度) | 必传| 参数说明
--------- | ------ | ----- | -------|-------------------
bank_name | 银行名称 |String(45)|N| 模糊搜索支持银行名


## 请求示例

   
   ```json
    {
       "bank_name": "招商"
    } 
   ```
   
## 响应示例

   
   ```json
    {
       "result_code": "200",
       "biz_response": {
           "result_code": "SUCCESS",
           "data": [
               "招商银行"
           ]
       }
    }
   ```
