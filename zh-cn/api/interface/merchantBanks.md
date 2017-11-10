# 开户银行接口（/merchant/banks）

## 请求参数

参数 | 参数名称 | 类型(长度) | 必传| 参数说明
--------- | ------ | ----- | -------|-------------------
bank_card | 银行卡号 |String(45)|Y|


## 请求示例

   
   ```json
    {
       "bank_card": "6228480402564890018"
    } 
   ```
   
## 响应示例

   
   ```json
    {
       "result_code": "200",
       "biz_response": {
           "result_code": "SUCCESS",
           "data": "中国农业银行"
       }
    }
   ```
