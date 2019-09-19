# 商户入网接口（/v2/merchant/create）

## 请求参数

参数 | 参数名称 | 类型(长度) | 必传| 参数说明
--------- | ------ | ----- | -------|-------------------
商户名 | name |String(40)|Y| 7至40个字符，支持中英文、数字、全角半角（）、《》、-，至少包含1个中文、不支持其他特殊符号、emoji
商户经营名称 | business_name |String(32)|N|2至20个字符，支持英文、数字，至少包含一个中文字符，不支持特殊符号、emoji，商家实际在经营场所使用的名称，默认和商户名一样
联系人 |contact_name  | String(16)|Y |2至10个字，支持中文，不支持英文、数字、特殊符号、emoji
联系电话 | contact_cellphone |String(32) |Y |11位数字
行业 | industry |String(36) |N |快递行业: 7a542419-312d-11e6-aebb-ecf4bbdee2f0
地区 | area |String(6) |Y |标准地区编码，参见附录
详细地址 | street_address |String(128) |Y | 5至128字符，支持中英文、数字，支持符号（），。-；不支持特殊符号，emoji
账户类型 | account_type |Integer |Y | 1 个人账户; 2 企业账户
银行卡号 | bank_card |String(45) |Y |
银行卡照片 | bank_card_image |String(255) |Y |必须传真实的银行卡照片，需要跟银行卡号匹配
银行卡有效期 | card_validity | Long |N |时间戳 , 毫秒级
开户银行 | bank_name |String(45) |Y |
开户地区 | bank_area |String(6) |Y | 标准地区编码，参见附录
开户支行 | branch_name |String(45) |Y | 根据查询支行列表接口传支行名
开户姓名 | holder |String(45) |Y | 个人账户为开户人，企业账户为开户公司名
证件类型 | id_type |Integer |Y |  1 身份证; 2 非中国护照; 3 台胞证; 4 港澳通行证; 5 中国护照
身份证号 | identity |String(18) |Y |
身份证正面照 | holder_id_front_photo |String(255) |Y |必须传真实的身份证照片，且身份证信息需要和开户姓名和身份证号匹配
身份证反面照 | holder_id_back_photo |String(255) |Y |必须传真实的身份证照片，且身份证有效期限不能过期
证件有效期 | id_validity | Long |N | 时间戳 , 毫秒级，证件类型为身份证时会自动识别
预留手机号 | bank_cellphone |String(32) |N |
法人姓名 | legal_person_name |String(100) |N | 企业账户需要传
法人证件类型 | legal_person_id_type |Integer |N | 1 身份证; 2 非中国护照; 3 台胞证; 4 港澳通行证; 5 中国护照
法人证件号码 | legal_person_id_number |String(18) |N |
法人证件正面照 | legal_person_id_card_front_photo|String(255) |N |必须传真实的身份证照片，且身份证信息需要和法人姓名和身份证号匹配
法人证件反面照 | legal_person_id_card_back_photo|String(255) |N |必须传真实的身份证照片，且身份证有效期限不能过期
法人证件有效期 | legal_id_validity | Long | N |时间戳 , 毫秒级，证件类型为身份证时会自动识别
法人证件类型 | license_type | Integer | N | 0、无营业执照、1、个体工商户营业执照 2、企业营业执照 3、事业单位法人证书 4、民办非企业单位登记证书 5、社会团体法人登记证书 6、基金会法人登记证书 7、律师事务所执业许可证
营业执照 | business_license_photo |String(255) |N | license_type不为0时必传
营业执照名称 | license_name |String(100) |N | 企业账户需要传,license_type为2代表证照名称
营业执照注册地址 | license_address | String(255) | N | license_type不为0时必传
营业执照有效期 | license_validity | String(128) | N | license_type不为0时必传
工商注册号 | tax_payer_id |String(45) |N | 企业账户需要传,license_type为2代表证照注册号
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
外部商户号 | client_sn |String(50) |N |外部商户号，可以根据此商户号查询商户信息
是否创建商户账号 |create_account |Boolean |N |默认(true)创建商户账号，传false则不创建账号
微信客服电话 |customer_phone |String(32 |N |为空则取联系电话contact_cellphone

## 请求示例

   
   ```json
    {
        "name": "XXX苏州园区⼆二部",
        "business_name": "XXX园区分店",
        "contact_name": "张三",
        "contact_cellphone": "15195951826",
        "industry": "7a542419-312d-11e6-aebb-ecf4bbdee2f0",
        "area": "320506",
        "street_address": "东⻓长路路88号",
        "bank_card": "6228480402564890018",
        "bank_card_image": "http://www.shouqianba.com",
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
        "client_sn": "12345678",
        "customer_phone": "13900000000",
        "license_type" : 1,
        "business_license_photo" : "http://www.shouqianba.com",
        "license_address" : "苏州市苏州工业园区苏州工业园区直属镇工业园区东长路88号2-5产业园g1栋18楼",
        "license_validity" : "20190919-99991231"
        
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
   
## 常见异常编码
 
 异常码 | 异常原因 | 举例
 --------- | ------ | ----- |
 400 | 参数不符 | 商户经营名称格式错误, 支持中英文和数字, 至少包含一个中文
 403 | 证件信息不符 | 身份证正面照姓名与开户人不一致
 409 | 参数冲突 | 银行卡号与开户行不匹配
 413 | 参数字段超长 | 图片大小不能超过1M
 500 | 系统异常 | 系统繁忙:XXX



