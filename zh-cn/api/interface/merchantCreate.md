# 商户入网接口（/v2/merchant/create）

## 请求参数

参数 | 参数名称 | 类型(长度) | 必传| 参数说明
--------- | ------ | ----- | -------|-------------------
商户名 | name |String(32)|Y|至少有一个汉字
联系人 |contact_name  | String(16)|Y |
联系电话 | contact_cellphone |String(32) |Y |
行业 | industry |String(36) |N |快递行业: 7a542419-312d-11e6-aebb-ecf4bbdee2f0
地区 | area |String(6) |Y |标准地区编码，参见附录
详细地址 | street_address |String(128) |Y | 
账户类型 | account_type |Integer |Y | 1 个人账户; 2 企业账户
银行卡号 | bank_card |String(45) |Y |
开户银行 | bank_name |String(45) |Y |
开户地区 | bank_area |String(6) |Y | 标准地区编码，参见附录
开户支行 | branch_name |String(45) |Y | 根据查询支行列表接口传支行名
开户姓名 | holder |String(45) |Y | 个人账户为开户人, 企业账户为开户公司名
预留手机号 | bank_cellphone |String(32) |N |
法人姓名 | legal_person_name |String(100) |N | 企业账户需要传
营业执照 | business_license_photo |String(255) |N | 企业账户需要传
工商注册号 | tax_payer_id |String(45) |N | 企业账户需要传
证件类型 | id_type |Integer |Y | 1 身份证; 2 护照; 3 台胞证; 4 港澳通行证;
身份证号 | identity |String(18) |Y |
身份证正面照 | holder_id_front_photo |String(255) |Y |
身份证反面照 | holder_id_back_photo |String(255) |Y |
门头照片 | brand_photo |String(255) |Y |
室内照片 | indoor_photo |String(255) |Y |
室外照片 | outdoor_photo |String(255) |Y |
其他照片 | other_photos |String(1024) |N |
备注 | remark |String(255) |N |
经度 | longitude |Double |N |
纬度 | latitude  |Double |N |
其他字段 | extra |BLOB |N |json格式存储的其他字段
服务商appid | vendor_app_id |String(36)) |Y |收钱吧提供的服务商appid
服务商sn | vendor_sn |String(32)) |Y |收钱吧提供的服务商sn
组织 | organization_id |String(36)) |N |收钱吧提供的商户所属组织id
推广者 | user_id |String(36) |N |收钱吧提供的商户推广人id
外部商户号 | client_sn |String(50) |N |外部商户号, 可以根据此商户号查询商户信息

## 请求示例

   
   ```json
    {
        "name": "XXX苏州园区⼆二部",
        "contact_name": "张三",
        "contact_cellphone": "15195951826",
        "industry": "7a542419-312d-11e6-aebb-ecf4bbdee2f0",
        "area": "320506",
        "street_address": "东⻓长路路88号",
        "bank_card": "6228480402564890018",
        "bank_name": "中国农业银⾏行行",
        "bank_area": "320506",
        "branch_name": "中国农业银⾏行行苏州⼯工业园区科技⽀支⾏行行",
        "holder": "张三",
        "bank_cellphone": "15195951826",
        "account_type": 1,
        "id_type": 1,
        "identity": "210102198403196241",
        "holder_id_front_photo": "http://www.shouqianba.com",
        "holder_id_back_photo": "http://www.shouqianba.com",
        "brand_photo": "http://www.shouqianba.com",
        "indoor_photo": "http://www.shouqianba.com",
        "outdoor_photo": "http://www.shouqianba.com",
        "other_photos": "http://www.shouqianba.com,http://www.wosai.cn",
        "remark": "备注123",
        "longitude": 120.776917,
        "latitude": 31.308309,
        "vendor_app_id": "2017110600000001",
        "vendor_sn": "91800129",
        "client_sn": "12345678"
    }   
   ```
    
## 响应示例

   
   ```json
    {
        "result_code": "200",
        "biz_response": {
            "result_code": "SUCCESS",
            "data": {
                "merchant_sn": "21680002793343",
                "store_sn": "21580000000523215",
                "terminal_sn": "2100000010002212097",
                "terminal_key": "cb40ff8679dfb8aa3d28741752973a31"
            }
        }
    }
   ```
   


