# 支行列表接口（/v2/merchant/branches）

## 请求参数

参数 | 参数名称 | 类型(长度) | 必传| 参数说明
--------- | ------ | ----- | -------|-------------------
bank_name | 开户银行名 |String(45)|Y|
bank_area | 开户地区编号 |String(6)|Y|


## 请求示例

   
   ```json
    {
        "bank_name": "中国农业银行",
        "bank_area": "320506"
    } 
   ```
   
## 响应示例

   
   ```json
    {
      "result_code": "200",
      "biz_response": {
          "result_code": "SUCCESS",
          "data": [
              "中国农业银行苏州市镇湖分理处",
              "中国农业银行苏州城中支行",
              "中国农业银行苏州浒关支行",
              ...
          ]
       }
    }
   ```
