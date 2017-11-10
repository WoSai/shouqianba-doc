# 商户信息接口（/merchant/info）

## 请求参数

参数 | 参数名称 | 类型(长度) | 必传| 参数说明
--------- | ------ | ----- | -------|-------------------
merchant_sn | 商户号 |String(32)|Y|


## 请求示例

   
   ```json
    {
       "merchant_sn": "1680000379076"
    } 
   ```
   
## 响应示例

   
   ```json
    {
       "result_code": "200",
       "biz_response": {
           "result_code": "SUCCESS",
           "data": {
               "merchant_sn": "21680002791056",
               "client_sn": null,
               "merchant_name": "XXX苏州园区⼆二部2",
               "contact_name": "张三",
               "contact_cellphone": "15195951826",
               "area": "320506",
               "street_address": "东⻓长路路88号",
               "bank_card": "6228480402564890018",
               "bank_name": "中国农业银⾏行行",
               "bank_area": null,
               "branch_name": null,
               "holder": "张三",
               "bank_cellphone": "15195951826",
               "unified_status": 0
        }
    }
    }
   ```
