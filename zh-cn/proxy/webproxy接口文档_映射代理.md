# WebProxy接口文档 - 映射代理

## 目录

1. [约定](#convention)
    - [请求](#request)
    - [响应](#response)
2. [业务接口](#core-proxy)
    - [门店接口](#store-api)
        - [响应参数](#store-response)
        - [创建门店](#create-store)
        - [更新门店信息](#update-store)
        - [获取门店信息](#get-store)
    - [终端接口](#terminal-api)
        - [响应参数](#terminal-response)
        - [创建终端](#create-terminal)
        - [更新终端信息](#update-terminal)
        - [获取终端信息](#get-terminal)
3. [交易接口](#upay-proxy)
    - [支付](#upay-pay)
    - [退款](#upay-refund)
    - [撤单](#upay-revoke)
    - [查询](#upay-query)
    - [预下单](#upay-precreate)
4. [附录](#appendix)
    - [通讯错误码](#comm-error)
    - [业务结果码](#result-code)
    - [业务接口](#appendix-core)
        - [业务执行错误码](#core-biz-error)
        - [门店状态](#store-status)
        - [终端状态](#terminal-status)
        - [终端类型](#terminal-type)
    - [交易接口](#appendix-upay)
        - [业务执行错误码](#upay-biz-error)
        - [订单状态](#order-status)
        - [流水状态](#transaction-status)
        - [支付方式](#payway)
        - [二级支付方式](#sub-payway)

# 1. <a name="convention"></a>约定

欢迎使用收钱吧WebProxy（映射代理版）代理服务。该代理服务主要包含业务和交易两组接口，分别对应连接收钱吧的业务系统和支付系统。该代理主要完成了对接方门店和终端与收钱吧门店和终端的映射，并封装了请求的签名和复杂的请求时序，允许对接方直接以自己的门店和终端身份发起支付，极大减轻您的开发和维护成本。

**注**：为了正常使用WebProxy的映射代理服务，维持映射关系的有效性，若需要创建和维护门店和终端，请不要通过商户管理后台，而应使用WebProxy的业务接口。

### 1.1 <a name="request"></a>请求

- 接口协议：HTTP
- 请求格式：Content-Type: application/json
- 主体编码：UTF-8
- 所有参数字段的数据类型均为字符串
- 请求中所有涉及金额的地方都以 <font color="red">**分**</font> 为单位

### 1.2 <a name="response"></a>响应

- 响应格式：Content-Type: application/json
- 主体编码：UTF-8
- 所有参数字段的数据类型均为字符串
- 响应中所有涉及金额的字段都以 <font color="red">**分**</font> 为单位
- 响应中所有涉及时间的字段均为东八区UNIX时间戳，以毫秒为单位

#### 1.2.1 响应参数结构

WebProxy的响应参数与支付网关类似，大致结构如下：

    {
        "result_code": "400",
        "error_code": "TERMINAL_NOT_EXISTS",
        "error_message": "不存在这个终端",
        "biz_response": {
            "result_code": "PAY_FAIL",
            "error_code": "EXPIRED_BARCODE",
            "error_message": "过期的支付条码",
            "data": {
                "sn": "7894259244067344",
                "client_sn": "12345677767776",
                "status": "FAIL_CANCELED",
                "payway": "3",
                "sub_payway": "1",
                "order_status": "PAY_CANCELED",
                "total_amount": "1",
                "net_amount": "1",
                "finish_time": "1449569494595"
            }
        }
    }

**注**：以上样例只是为了说明每个可能出现的字段在整个响应中的位置，并非一个有效的响应的样例。

#### 1.2.2 响应参数说明

WebProxy响应参数具体说明如下：

字段名 | 字段含义 | 必填 | 取值 | 备注
--------- | ------ | ----- | ----- | -------
result_code | 通讯响应码 | Y | 200，400，500 | 200：通讯成功；400：客户端错误；500：服务端错误
error_code | 通讯错误码 | N | 见附录[通讯错误码](#comm-error) | 通讯 **失败** 的时候才返回
error_message | 通讯错误信息描述 | N | 见附录[通讯错误码](#comm-error) | 通讯 **失败** 的时候才返回
biz_response | 业务响应数据 | N | JSON对象 | 通讯 **成功** 的时候才返回
biz_response.result_code | 业务执行响应码 | N | 见附录[业务结果码](#result-code) | 通讯 **成功** 的时候才返回
biz_response.error_code | 业务执行结果返回码 | N | 见附录[业务执行错误码1](#core-biz-error)和[业务执行错误码2](#upay-biz-error) | 业务执行 **失败** 的时候才返回
biz_response.error_message | 业务执行错误信息 | N | 见附录[业务执行错误码1](#core-biz-error)和[业务执行错误码2](#upay-biz-error) | 业务执行 **失败** 的时候才返回
biz_response.data | 业务执行结果 | N | 对象结构，包含业务实体相关信息 | 业务执行 **成功** 的时候才返回

## 2. <a name="core-proxy"></a>业务接口

业务接口主要用于创建、更新和查询门店和终端信息，是直接对接收钱吧业务系统对外接口的客户端代理，封装了请求的签名和一定的请求时序，并在完成业务操作的同时，创建和维护对接方门店终端与收钱吧门店终端的映射关系。

### 2.1 <a name="store-api"></a>门店接口

#### 2.1.0 <a name="store-response"></a>响应参数

目前所有门店接口返回参数的结构和内容基本一致，仅有部分元数据字段（如`deleted`，`version`等）部分接口不会返回，因此在此统一列出，后续不再单独描述。

以下参数均指响应结果中`biz_response.data`节点下的字段：

属性名 | 属性含义 | 数据类型 | 描述 | 范例
----- | ----- | ----- | ----- | -----
name | 门店名称 | 字符 | 门店名称 | "苏州江湖客栈"
industry | 行业 | 字符 | 门店所属行业，参见附录（待完善） | "1"
status | 门店状态 | 字符 | 门店状态，参见附录[门店状态](#store-status) | "1"
rank | 信用等级 | 字符 | 门店的信用等级 | "2"
longitude | 经度 | 字符 | 门店地理位置的经度 | "120.311234"
latitude | 纬度 | 字符 | 门店地理位置的纬度 | "31.312345"
province | 省 | 字符 | 门店所在省份 | "江苏省"
city | 市 | 字符 | 门店所在城市 | "苏州市"
district | 区 | 字符 | 门店所在辖区 | "姑苏区"
street_address | 街道 | 字符 | 门店所在街道地址 | "平江路139号"
contact_name | 联系人姓名 | 字符 | 门店联系人姓名 | "张三"
contact_phone | 联系固定电话号码 | 字符 | 门店联系人的固定电话号码 | "0512-12345678"
contact_cellphone | 联系移动电话号码 | 字符 | 门店联系人的移动电话号码 | "13412345678"
contact_email | 联系邮箱 | 字符 | 门店联系人的邮箱 | "zhang@abc.com"
client_sn | 对接方内部门店号  | 字符 | 对接方系统内部对于该门店的唯一标识 | "1234567890"
merchant_sn | 商户序列号 | 字符 | 该门店对应的商户标识 | "09a81a57-9225-4d07-b78e-4f93ee8a366d"
solicitor_sn | 推广渠道序列号 | 字符 | 发展该门店入网的推广者标识 | "cefb7e58-a75d-afb7-8481-ced71ec96abc"
vendor_sn | 服务商序列号 | 字符 | 该门店对应的服务商标识 | "859d9f5f-af99-11e5-9ec3-00163e00625b"
extra | 扩展字段 | JSON对象 | 该门店相关的额外信息 | {"title":"标题"}
ctime | 创建时间 | 字符 | 门店在收钱吧业务系统中的创建时间 | "1449646835244"
mtime | 最后修改时间 | 字符 | 门店在收钱吧业务系统中的最后修改时间 | "1449647735268"
deleted | 删除标志 | 字符 | 门店在收钱吧业务系统中是否已被删除 | "false"
version | 版本 | 字符 | 门店信息的版本号，随门店信息的变更次数而递增 | "2"

#### 2.1.1 <a name="create-store"></a>创建门店

##### 接口说明

该接口用于创建门店，门店在收钱吧体系中是直接管理终端和利用终端收款的实体。

##### 接口路径

    {api_domain}/proxy/store/create

##### 请求参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
name | 门店名称 | 字符 | Y | 门店名称 | "苏州江湖客栈"
industry | 行业 | 字符 | N | 行业 | "1"
longitude | 经度 | 字符 | N | 经度 | "120.311234"
latitude | 纬度 | 字符 | N | 纬度 | "31.312345"
province | 省 | 字符 | Y | 省 | "江苏省"
city | 市 | 字符 | Y | 市 | "苏州市"
district | 区 | 字符 | Y | 区 | "姑苏区"
street_address | 街道 | 字符 | Y | 街道 | "平江路139号"
contact_name | 联系人姓名 | 字符 | Y | 联系人姓名 | "张三"
contact_phone | 联系固定电话号码 | 字符 | N | 联系固定电话号码 | "0512-12345678"
contact_cellphone | 联系移动电话号码 | 字符 | Y | 联系移动电话号码 | "13412345678"
contact_email | 联系邮箱 | 字符 | N | 联系邮箱 | "zhang@abc.com"
client_sn | 对接方内部门店号  | 字符 | Y | 对接方内部门店号  | "1234567890"
merchant_sn | 商户序列号 | 字符 | Y | 商户标识 | "09a81a57-9225-4d07-b78e-4f93ee8a366d"
extra | 扩展字段 | JSON对象 | N | 扩展字段 | {"title":"标题"}

##### 响应示例

- 创建成功

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "SUCCESS",
                "data": {
                    "id": "26a1270a-aa97-4854-a489-2344e33b0338",
                    "sn": "01234567890",
                    "name": "苏州江湖客栈",
                    "industry": "1",
                    "status": "1",
                    "rank": "2",
                    "longitude": "120.311234",
                    "latitude": "31.312345",
                    "province": "江苏省",
                    "city": "苏州市",
                    "district": "姑苏区",
                    "street_address": "平江路139号",
                    "contact_name": "张三",
                    "contact_phone": "0512-12345678",
                    "contact_cellphone": "13412345678",
                    "contact_email": "zhang@abc.com",
                    "client_sn": "1234567890",
                    "merchant_sn": "09a81a57-9225-4d07-b78e-4f93ee8a366d",
                    "solicitor_sn": "cefb7e58-a75d-afb7-8481-ced71ec96abc",
                    "vendor_sn": "859d9f5f-af99-11e5-9ec3-00163e00625b",
                    "extra": {"title":"标题"}
                }
            }
        }

#### 2.1.2 <a name="update-store"></a>更新门店信息

##### 接口说明

该接口用于更新某门店的基本信息。

##### 接口路径

    {api_domain}/proxy/store/update

##### 请求参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
client_sn | 对接方门店编号 | 字符 | Y | 对接方内部系统对该门店的唯一标识 | "26a1270a-aa97-4854-a489-2344e33b0338"
name | 门店名称 | 字符 | N | 门店名称 | "苏州江湖客栈"
industry | 行业 | 字符 | N | 行业 | "1"
longitude | 经度 | 字符 | N | 经度 | "120.311234"
latitude | 纬度 | 字符 | N | 纬度 | "31.312345"
province | 省 | 字符 | N | 省 | "江苏省"
city | 市 | 字符 | N | 市 | "苏州市"
district | 区 | 字符 | N | 区 | "姑苏区"
street_address | 街道 | 字符 | N | 街道 | "平江路139号"
contact_name | 联系人姓名 | 字符 | N | 联系人姓名 | "张三"
contact_phone | 联系固定电话号码 | 字符 | N | 联系固定电话号码 | "0512-12345678"
contact_cellphone | 联系移动电话号码 | 字符 | N | 联系移动电话号码 | "13412345678"
contact_email | 联系邮箱 | 字符 | N | 联系邮箱 | "zhang@abc.com"
extra | 扩展字段 | JSON对象 | N | 扩展字段 | {"title":"标题"}

##### 响应示例

- 更新成功

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "SUCCESS",
                "data": {
                    "id": "26a1270a-aa97-4854-a489-2344e33b0338",
                    "sn": "01234567890",
                    "name": "苏州江湖客栈",
                    "industry": "1",
                    "longitude": "120.311234",
                    "latitude": "31.312345",
                    "province": "江苏省",
                    "city": "苏州市",
                    "district": "姑苏区",
                    "street_address": "平江路139号",
                    "contact_name": "张三",
                    "contact_phone": "0512-12345678",
                    "contact_cellphone": "13412345678",
                    "contact_email": "zhang@abc.com",
                    "client_sn": "1234567890",
                    "extra": {"title":"标题"}
                }
            }
        }

#### 2.1.3 <a name="get-store"></a>获取门店信息

##### 接口说明

该接口用于获取某门店的基本信息。

##### 接口路径

    {api_domain}/proxy/store/get

##### 请求参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
client_sn | 对接方门店编号 | 字符 | Y | 对接方内部系统对该门店的唯一标识 | "26a1270a-aa97-4854-a489-2344e33b0338"

##### 响应示例

- 查询成功

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "SUCCESS",
                "data": {
                    "id": "26a1270a-aa97-4854-a489-2344e33b0338",
                    "sn": "01234567890",
                    "name": "苏州江湖客栈",
                    "industry": "1",
                    "status": "1",
                    "rank": "2",
                    "longitude": "120.311234",
                    "latitude": "31.312345",
                    "province": "江苏省",
                    "city": "苏州市",
                    "district": "姑苏区",
                    "street_address": "平江路139号",
                    "contact_name": "张三",
                    "contact_phone": "0512-12345678",
                    "contact_cellphone": "13412345678",
                    "contact_email": "zhang@abc.com",
                    "client_sn": "1234567890",
                    "merchant_sn": "09a81a57-9225-4d07-b78e-4f93ee8a366d",
                    "solicitor_sn": "cefb7e58-a75d-afb7-8481-ced71ec96abc",
                    "vendor_sn": "859d9f5f-af99-11e5-9ec3-00163e00625b",
                    "extra": {"title":"标题"},
                    "ctime": "1458404655938",
                    "mtime": "1458405255955",
                    "deleted": "false",
                    "version": "1"
                }
            }
        }

### 2.2 <a name="terminal-api"></a>终端接口

#### 2.2.0 <a name="terminal-response"></a>响应参数

目前所有终端接口返回参数的结构和内容基本一致，仅有部分元数据字段（如`deleted`，`version`等）部分接口不会返回，因此在此统一列出，后续不再单独描述。

以下参数均指响应结果中`biz_response.data`节点下的字段：

属性名 | 属性含义 | 数据类型 | 描述 | 范例
----- | ----- | ----- | ----- | -----
id | UUID | 字符 | 终端ID | "400fb2ed-c68b-f8a7-1af2-b3761f36d579"
sn | 用户可见终端编号 | 字符 | 用于用户识别的终端编号 | "0123456789012"
device_fingerprint | 设备指纹 | 字符 | 如设备IMEI码等 | "31499CCE184873CCA5A7CD45EFFA315C"
name | 终端名 | 字符 | 终端名 | "终端001号"
type | 类型 | 字符 | 终端类型，参见附录[终端类型](#terminal-type) | "10"
status | 状态 | 字符 | 终端状态，参见附录[终端状态](#terminal-status) | "0"
last_signon_time | 最近登录时间 | 字符 | 时间戳，以毫秒为单位 | "1458404855938"
sdk_version | SDK版本 | 字符 | 如该终端使用SDK接入，则返回SDK的版本 | "2.1.0"
os_version | 操作系统版本 | 字符 | 该终端使用的操作系统版本 | "Android-5.0.2"
current_secret | 当前密钥 | 字符 | 该终端当前用于交易的密钥 | "ce364589c8f70522760a4ba726cc2c8e"
last_secret | 次最新密钥 | 字符 | 该终端之前用于交易的密钥 | "195d69648341d65abcf802f4d4ab408a"
longitude | 经度 | 字符 | 该终端的装机地理位置的经度 | "120.311234"
latitude | 纬度 | 字符 | 该终端的装机地理位置的纬度 | "31.312345"
client_sn | 对接方内部终端号 | 字符 | 对接方系统内部对于该终端的唯一标识 | "1234567890"
client_store_sn | 对接方内部门店编号 | 字符 | 对接方系统内部对于该终端所属门店的唯一标识 | "1234567890"
extra | 扩展字段 | JSON对象 | 该终端相关的额外信息 | {"title":"标题"}
target | 回调通知设置 | 字符 | 该终端发起异步交易（如预下单）后，收钱吧回调的通知目标地址 | "https://shop.abc.com/callback"
target_type | 回调通知方式 | 字符 | 收钱吧回调通知的方式 | "1"
store_sn | 门店序列号 | 字符 | 终端所属收钱吧门店的标识 | "26a1270a-aa97-4854-a489-2344e33b0338"
merchant_sn | 商户序列号 | 字符 | 终端所属收钱吧商户的标识 | "09a81a57-9225-4d07-b78e-4f93ee8a366d"
solicitor_sn | 推广渠道序列号 | 字符 | 终端所属收钱吧推广者的标识 | "cefb7e58-a75d-afb7-8481-ced71ec96abc"
vendor_sn | 服务商序列号 | 字符 | 终端所属收钱吧服务商的标识 | "859d9f5f-af99-11e5-9ec3-00163e00625b"
vendor_app_id | 服务商应用ID | 字符 | 终端所安装的服务商的应用ID | "bdf9b7f1-e01d-11e5-9ec3-00163e00625b"
ctime | 创建时间 | 字符 | 终端在收钱吧业务系统中的创建时间 | "1458404655938"
mtime | 最后修改时间 | 字符 | 终端在收钱吧业务系统中的最后修改时间 | "1458405255955"
deleted | 删除标志 | 字符 | 终端在收钱吧业务系统中是否已被删除 | "false"
version | 版本 | 字符 | 终端信息的版本号，随终端信息的变更次数而递增 | "15"

#### 2.2.1 <a name="create-terminal"></a>创建终端

##### 接口说明

该接口用于创建终端，终端在收钱吧业务体系中是直接进行交易操作的实体。终端不能够独立存在，每一台终端都必须对应一个所属门店。

##### 接口路径

    {api_domain}/proxy/terminal/create

##### 请求参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
device_fingerprint | 设备指纹 | 字符 | N | 设备指纹 | "31499CCE184873CCA5A7CD45EFFA315C"
name | 终端名 | 字符 | Y | 终端名 | "终端001号"
type | 终端类型 | 字符 | Y | "10"
sdk_version | SDK版本 | 字符 | N | SDK版本 | "2.1.0"
os_version | 操作系统版本 | 字符 | N | 操作系统版本 | "Android-5.0.2"
longitude | 经度 | 字符 | N | 经度 | "120.311234"
latitude | 纬度 | 字符 | N | 纬度 | "31.312345"
client_sn | 对接方内部终端号  | 字符 | Y | 对接方内部终端号  | "1234567890"
extra | 扩展字段 | JSON对象 | N | 扩展字段 | {"title":"标题"}
target | 回调通知设置 | 字符 | N | 回调通知设置 | "https://shop.abc.com/callback"
target_type | 回调通知方式 | 字符 | N | 回调通知方式 | "1"
client_store_sn | 对接方内部门店编号 | 字符 | Y | 对接方系统内部对于该终端所属门店的唯一标识 | "1234567890"
vendor_app_id | 服务商应用ID | 字符 | N | 服务商应用ID | "bdf9b7f1-e01d-11e5-9ec3-00163e00625b"

##### 响应示例

- 创建成功

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "SUCCESS",
                "data": {
                    "id": "400fb2ed-c68b-f8a7-1af2-b3761f36d579",
                    "sn": "0123456789012",
                    "device_fingerprint": "31499CCE184873CCA5A7CD45EFFA315C",
                    "name": "终端001号",
                    "type": "2",
                    "status": "1",
                    "sdk_version": "2.1.0",
                    "os_version": "Android-5.0.2",
                    "current_secret": "ce364589c8f70522760a4ba726cc2c8e",
                    "last_secret": "195d69648341d65abcf802f4d4ab408a",
                    "longitude": "120.311234",
                    "latitude": "31.312345",
                    "client_sn": "1234567890",
                    "client_store_sn": "1234567890",
                    "extra": {"title":"标题"},
                    "target": "https://shop.abc.com/callback",
                    "target_type": "1",
                    "store_sn": "26a1270a-aa97-4854-a489-2344e33b0338",
                    "merchant_sn": "09a81a57-9225-4d07-b78e-4f93ee8a366d",
                    "solicitor_sn": "cefb7e58-a75d-afb7-8481-ced71ec96abc",
                    "vendor_sn": "859d9f5f-af99-11e5-9ec3-00163e00625b",
                    "vendor_app_id": "bdf9b7f1-e01d-11e5-9ec3-00163e00625b"
                }
            }
        }

#### 2.2.2 <a name="update-terminal"></a>更新终端信息

##### 接口说明

该接口用于更新某终端的基本信息。

##### 接口路径

    {api_domain}/proxy/terminal/update

##### 请求参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
client_sn | 对接方内部终端号 | 字符 | Y | 对接方系统内部对于该终端的唯一标识 | "1234567890"
device_fingerprint | 设备指纹 | 字符 | N | 设备指纹 | "31499CCE184873CCA5A7CD45EFFA315C"
name | 终端名 | 字符 | Y | 终端名 | "终端001号"
type | 终端类型 | 字符 | Y | "10"
sdk_version | SDK版本 | 字符 | N | SDK版本 | "2.1.0"
os_version | 操作系统版本 | 字符 | N | 操作系统版本 | "Android-5.0.2"
longitude | 经度 | 字符 | N | 经度 | "120.311234"
latitude | 纬度 | 字符 | N | 纬度 | "31.312345"
client_store_sn | 对接方内部门店编号 | 字符 | N | 如请求带有门店编号，则将终端移机至该门店 | "1234567890"
extra | 扩展字段 | JSON对象 | N | 扩展字段 | {"title":"标题"}
target | 回调通知设置 | 字符 | N | 回调通知设置 | "https://shop.abc.com/callback"
target_type | 回调通知方式 | 字符 | N | 回调通知方式 | "1"
vendor_app_id | 服务商应用ID | 字符 | N | 服务商应用ID | "bdf9b7f1-e01d-11e5-9ec3-00163e00625b"

##### 响应示例

- 更新成功

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "SUCCESS",
                "data": {
                    "id": "400fb2ed-c68b-f8a7-1af2-b3761f36d579",
                    "sn": "0123456789012",
                    "device_fingerprint": "31499CCE184873CCA5A7CD45EFFA315C",
                    "name": "终端001号",
                    "type": "2",
                    "status": "1",
                    "last_signon_time": "1458405375123",
                    "sdk_version": "2.1.0",
                    "os_version": "Android-5.0.2",
                    "current_secret": "ce364589c8f70522760a4ba726cc2c8e",
                    "last_secret": "195d69648341d65abcf802f4d4ab408a",
                    "longitude": "120.311234",
                    "latitude": "31.312345",
                    "client_sn": "1234567890",
                    "client_store_sn": "1234567890",
                    "extra": {"title":"标题"},
                    "target": "1",
                    "target_type": "https://shop.abc.com/callback",
                    "store_sn": "26a1270a-aa97-4854-a489-2344e33b0338",
                    "merchant_sn": "09a81a57-9225-4d07-b78e-4f93ee8a366d",
                    "solicitor_sn": "cefb7e58-a75d-afb7-8481-ced71ec96abc",
                    "vendor_sn": "859d9f5f-af99-11e5-9ec3-00163e00625b",
                    "vendor_app_id": "bdf9b7f1-e01d-11e5-9ec3-00163e00625b",
                    "ctime": "1458404655938",
                    "mtime": "1458405255955",
                    "deleted": "false",
                    "version": "1"
                }
            }
        }

#### 2.2.3 <a name="get-terminal"></a>获取终端信息

##### 接口说明

该接口用于获取某终端的基本信息。

##### 接口路径

    {api_domain}/proxy/terminal/get

##### 请求参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
client_sn | 对接方内部终端号 | 字符 | Y | 对接方系统内部对于该终端的唯一标识 | "1234567890"

##### 响应示例

- 查询成功

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "SUCCESS",
                "data": {
                    "id": "400fb2ed-c68b-f8a7-1af2-b3761f36d579",
                    "sn": "0123456789012",
                    "device_fingerprint": "31499CCE184873CCA5A7CD45EFFA315C",
                    "name": "终端001号",
                    "type": "2",
                    "status": "1",
                    "last_signon_time": "1458405375123",
                    "sdk_version": "2.1.0",
                    "os_version": "Android-5.0.2",
                    "current_secret": "ce364589c8f70522760a4ba726cc2c8e",
                    "last_secret": "195d69648341d65abcf802f4d4ab408a",
                    "longitude": "120.311234",
                    "latitude": "31.312345",
                    "client_sn": "1234567890",
                    "client_store_sn": "1234567890",
                    "extra": {"title":"标题"},
                    "target": "1",
                    "target_type": "https://shop.abc.com/callback",
                    "store_sn": "26a1270a-aa97-4854-a489-2344e33b0338",
                    "merchant_sn": "09a81a57-9225-4d07-b78e-4f93ee8a366d",
                    "solicitor_sn": "cefb7e58-a75d-afb7-8481-ced71ec96abc",
                    "vendor_sn": "859d9f5f-af99-11e5-9ec3-00163e00625b",
                    "vendor_app_id": "bdf9b7f1-e01d-11e5-9ec3-00163e00625b",
                    "ctime": "1458404655938",
                    "mtime": "1458405255955",
                    "deleted": "false",
                    "version": "1"
                }
            }
        }

## 3. <a name="upay-proxy"></a>交易接口

交易接口主要帮助对接方发起支付、退款、撤单、查询和预下单等交易请求。在发起交易请求之前，WebProxy会检查对接方传入的门店和终端信息，若在本地映射记录中未找到相应记录，会进行自动创建，具体逻辑如下表。WebProxy交易接口是直接对接收钱吧支付系统对外接口的客户端代理，封装了门店和终端映射关系、请求的签名和一定的请求时序。

**注**：upay-proxy接口的请求和响应中所有涉及金额的地方都以 <font color="red">**分**</font> 为单位。

client_terminal_sn | client_store_sn | 终端所属门店 | 映射处理逻辑
------------ | ------------- | ------------ | ------------
存在 | 存在  | 未变化 | 映射至收钱吧终端后发起交易
存在 | 存在  | 变化 | 更新终端信息，移机至新门店，映射至收钱吧终端后发起交易
存在 | 不存在  | N/A | 创建门店，移机至新门店，映射至收钱吧终端后发起交易
不存在 | 存在  | N/A | 在该门店下创建终端，映射至收钱吧终端后发起交易
不存在 | 不存在  | N/A | 创建门店，在该门店下创建终端，映射至收钱吧终端后发起交易

### 3.0 <a name="upay-meta"></a>交易请求中的终端及门店

所有WebProxy的交易接口均需要传入对接方的终端和门店参数，若在本地映射记录中按编号未找到相应记录，则会进行自动创建。终端及门店参数相应字段如下：

- 终端参数

以下参数均需要放在请求中的`client_terminal`节点下。

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
client_sn | 对接方内部终端号  | 字符 | Y | 对接方系统内部对于该终端的唯一标识 | "1234567890"
device_fingerprint | 设备指纹 | 字符 | N | 设备指纹 | "31499CCE184873CCA5A7CD45EFFA315C"
name | 终端名 | 字符 | N | 终端名 | "终端001号"
type | 终端类型 | 字符 | N | "10"
sdk_version | SDK版本 | 字符 | N | SDK版本 | "2.1.0"
os_version | 操作系统版本 | 字符 | N | 操作系统版本 | "Android-5.0.2"
longitude | 经度 | 字符 | N | 经度 | "120.311234"
latitude | 纬度 | 字符 | N | 纬度 | "31.312345"
extra | 扩展字段 | JSON对象 | N | 扩展字段 | {"title":"标题"}
target | 回调通知设置 | 字符 | N | 回调通知设置 | "https://shop.abc.com/callback"
target_type | 回调通知方式 | 字符 | N | 回调通知方式 | "1"
vendor_app_id | 服务商应用ID | 字符 | N | 服务商应用ID | "bdf9b7f1-e01d-11e5-9ec3-00163e00625b"

- 门店参数

以下参数均需要放在请求中的`client_store`节点下。

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
client_sn | 对接方内部门店号  | 字符 | Y | 对接方系统内部对于该门店的唯一标识 | "1234567890"
name | 门店名称 | 字符 | N | 门店名称 | "苏州江湖客栈"
industry | 行业 | 字符 | N | 行业 | "1"
longitude | 经度 | 字符 | N | 经度 | "120.311234"
latitude | 纬度 | 字符 | N | 纬度 | "31.312345"
province | 省 | 字符 | N | 省 | "江苏省"
city | 市 | 字符 | N | 市 | "苏州市"
district | 区 | 字符 | N | 区 | "姑苏区"
street_address | 街道 | 字符 | N | 街道 | "平江路139号"
contact_name | 联系人姓名 | 字符 | N | 联系人姓名 | "张三"
contact_phone | 联系固定电话号码 | 字符 | N | 联系固定电话号码 | "0512-12345678"
contact_cellphone | 联系移动电话号码 | 字符 | N | 联系移动电话号码 | "13412345678"
contact_email | 联系邮箱 | 字符 | N | 联系邮箱 | "zhang@abc.com"
extra | 扩展字段 | JSON对象 | N | 扩展字段 | {"title":"标题"}

### 3.1 <a name="upay-pay"></a>支付

#### 接口说明

操作员利用收银终端扫描顾客手机上的收款码完成收银时需要调用的接口，接口会保持连接直至最终结果返回或请求超时，超时时间约为45秒。

**注**：同一client_sn的订单WebProxy允许多次尝试支付；但一旦支付成功，则不再允许对同一client_sn的订单进行再次支付。

#### 接口路径

    {api_domain}/proxy/pay

#### 请求参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
client_terminal | 对接方终端信息 | JSON对象 | Y | 包含对接方终端编号，名称等信息，若WebProxy按编号查找不存在，则自动按所填写的信息创建终端，具体见[交易请求中的终端及门店](#upay-meta) | 
client_store | 对接方门店信息 | JSON对象 | Y | 包含对接方门店编号，名称等信息，若WebProxy按编号查找不存在，则自动按所填写的信息创建门店，具体见[交易请求中的终端及门店](#upay-meta) | 
client_sn | 商户系统订单号 | String(32) | Y | 必须在商户系统内唯一；且长度不超过32字节 | "18348290098298292838"
total_amount | 交易总金额 | String(10) | Y | 以分为单位，不超过10位纯数字字符串，超过1亿元的收款请使用银行转账 | "1000"
payway | 支付方式 | String(2) | N | 内容为数字的字符串。一旦设置，则根据支付码判断支付通道的逻辑失效 | "1"
dynamic_id | 条码内容 | String(32) | Y | 终端扫描得到的条形码值，不超过32字符 | "130818341921441147"
subject | 交易简介 | String(64) | Y | 本次交易的简要介绍 | "Pizza"
operator | 门店操作员  | String(32) | Y | 发起本次交易的操作员 | "Obama"
description | 商品详情 | String(256) | N | 对商品或本次交易的描述 | "Extra cheese"
longitude | 交易位置经度 | String(16) | N | 经纬度必须成对填写 | "121.615459404"
latitude | 交易位置维度 | String(16) | N | 经纬度必须成对填写 | "31.4056441552"
device_id | 设备标示 | String(32) | N | 如设备IMEI码等 |
extended | 扩展参数集合 | JSON对象 | N | 收钱吧与特定第三方单独约定的参数集合，json格式，最多支持24个字段，每个字段key长度不超过64字节，value长度不超过256字节 | { "goods_tag": "beijing"}
reflect | 反射参数 | String(64) | N | 任何调用者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容 | "{ \"tips\": \"200\" }"

#### 响应参数

以下参数均指响应结果中`biz_response.data`节点下的字段：

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
sn | 收钱吧唯一订单号 | String(16) | Y | 收钱吧系统内部唯一订单号 | "7892259488292938"
client_sn | 商户订单号 | String(32) | Y | 商户系统订单号 | "7654321132"
trade_no | 支付通道订单号 | String(64) | Y | 支付通道交易凭证号 | "2013112011001004330000121536"
status | 流水状态 | String(32) | Y | 本次操作产生的流水的状态 | "SUCCESS"
order_status | 订单状态 | String(32) | Y | 当前订单状态 | "PAID"
payway | 支付方式 | String(2) | Y | 一级支付方式，取值见附录[支付方式](#payway) | "1"
sub_payway | 二级支付方式 | String(2) | Y | 二级支付方式，取值见附录[二级支付方式](#sub-payway) | "1"
payer_uid | 付款人ID | String(64) | N | 支付平台（微信，支付宝）上的付款人ID | "2801003920293239230239"
payer_login | 付款人账号 | String(128) | N | 支付平台上(微信，支付宝)的付款人账号 | "134****3920"
total_amount | 交易总额 | String(10) | Y | 本次交易总金额 | "10000"
net_amount | 实收金额 | String(10) | Y | 如果没有退款，这个字段等于total_amount。否则等于total_amount减去退款金额 | "0"
subject | 交易概述 | String(64) | Y | 本次交易概述 | "Pizza"
finish_time | 付款动作在收钱吧的完成时间 | String(13) | Y | UNIX时间戳，以毫秒为单位 | "1449646835244"
channel_finish_time | 付款动作在支付通道的完成时间 | String(13) | Y | UNIX时间戳，以毫秒为单位 | "1449646835244"
operator |操作员 | String(32) | Y | 门店操作员 | "张三丰"
reflect	 | 反射参数 | String(64) | N | 透传参数 | "{ \"tips\": \"200\" }"

#### 响应示例

- 支付成功

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "PAY_SUCCESS",
                "data": {
                    "sn": "7894259244067349",
                    "client_sn": "12345677767776",
                    "status": "SUCCESS",
                    "payway": "3",
                    "sub_payway": "1",
                    "order_status": "PAID",
                    "payer_uid": "okSzXt3uY4-W8fKBH7B4z8seMzBU",
                    "trade_no": "1006101016201512081965934048",
                    "total_amount": "1",
                    "net_amount": "1",
                    "finish_time": "1449569460430",
                    "channel_finish_time": "1449569460000",
                    "store_sn": "00293001928483902",
                    "subject": "Domino's Pizza",
                    "operator": "Kan"
                }
            }
        }

- 支付通讯失败

        {
            "result_code": "400",
            "error_code": "TERMINAL_NOT_EXISTS",
            "error_message": "不存在这个终端"
        }

- 支付业务失败

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "PAY_FAIL",
                "error_code": "EXPIRED_BARCODE",
                "error_message": "过期的支付条码",
                "data": {
                    "sn": "7894259244067344",
                    "client_sn": "12345677767776",
                    "status": "FAIL_CANCELED",
                    "payway": "3",
                    "sub_payway": "1",
                    "order_status": "PAY_CANCELED",
                    "total_amount": "1",
                    "net_amount": "1",
                    "finish_time": "1449569494595"
                }
            }
        }

### 3.2 <a name="upay-refund"></a>退款

#### 接口说明

操作员利用收银终端扫描顾客手机上的订单条形码或手动输入订单号，对该订单进行退款时需要调用的接口，接口会返回退款结果（成功或退款中）或错误信息。

同一笔订单允许多次退款。

#### 接口路径

    {api_domain}/proxy/refund

#### 请求参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
client_terminal | 对接方终端信息 | JSON对象 | Y | 包含对接方终端编号，名称等信息，若WebProxy按编号查找不存在，则自动按所填写的信息创建终端，具体见[交易请求中的终端及门店](#upay-meta) | 
client_store | 对接方门店信息 | JSON对象 | Y | 包含对接方门店编号，名称等信息，若WebProxy按编号查找不存在，则自动按所填写的信息创建门店，具体见[交易请求中的终端及门店](#upay-meta) | 
sn | 收钱吧唯一订单号 | String(16) | N | 收钱吧系统内部唯一订单号 | "7892259488292938"
client_sn | 商户订单号 | String(32) | N | 商户系统订单号 | "7654321132"
refund_request_no | 退款序列号 | String(20) | Y | 商户退款所需序列号，为防止重复退款 | "23030349"
operator | 操作员 | String(64) | Y | 执行本次退款的操作员 | "Obama"
refund_amount | 退款金额 | String(10) | Y | 退款金额 | "100"

**注**：sn与client_sn不能同时为空，支付系统会优先按照sn查找订单进行退款；如果没有sn，支付系统则按照client_sn查找订单进行退款。

#### 响应参数

以下参数均指响应结果中`biz_response.data`节点下的字段：

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
sn | 收钱吧唯一订单号 | String(16) | Y | 收钱吧系统内部唯一订单号 | "7894259244061958"
client_sn | 商户订单号 | String(64) | Y | 商户系统订单号 | "22345677767776"
status | 退款流水状态 | String(32) | Y | 本次退款对应的流水的状态 | "SUCCESS"
order_status | 订单状态 | String(32) | Y | 当前订单状态 | "REFUNDED"
trade_no | 支付通道的订单凭证号 | String(64) | Y | 支付宝或微信的订单号 | "2006101016201512090096528672"
total_amount | 交易总金额 | String(10) | Y | 原始交易实收金额 | "100"
net_amount | 剩余金额 | String(10) | Y | 实收金额减退款金额 | "0"
finish_time | 退款动作在收钱吧的完成时间 | String(13) | Y | 时间戳，本次退款动作在收钱吧的完成时间 | "1449646835244"
channel_finish_time | 退款动作在支付平台完成的时间 | String(13) | Y | 时间戳，本次退款动作在微信或支付宝的完成时间 | "1449646835221"
subject | 商品概述 | String(32) | Y | 交易时候的商品概述 | "wx"
operator | 操作员 | String(32) | Y | 执行本次退款的操作员 | "Obama"

#### 响应示例

- 退款成功

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "REFUND_SUCCESS",
                "data": {
                    "sn": "7894259244067218",
                    "client_sn": "12345677767776",
                    "status": "SUCCESS",
                    "payway": "3",
                    "sub_payway": "1",
                    "order_status": "REFUNDED",
                    "trade_no": "2006101016201512080095793262",
                    "total_amount": "1",
                    "net_amount": "0",
                    "finish_time": "1449563206776",
                    "channel_finish_time": "1449563206632"
                }
            }
        }

- 退款通讯失败
    
        {
            "result_code": "400",
            "error_code": "INVALID_PARAMS",
            "error_message": "refund_amount金额为整数，长度不超过10位，以分为单位"
        }

- 退款业务失败

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "FAIL",
                "error_code": "UPAY_REFUND_INVALID_ORDER_STATE",
                "error_message": "订单已全额退款,可退金额不足"
            }
        }

### 3.3 <a name="upay-revoke"></a>撤单

#### 接口说明

如果一笔订单已经支付成功，在系统规定的时间范围内，可以调用这个接口完成全额退款，并且不会触发任何手续费。

#### 接口路径

    {api_domain}/proxy/revoke

#### 请求参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
client_terminal | 对接方终端信息 | JSON对象 | Y | 包含对接方终端编号，名称等信息，若WebProxy按编号查找不存在，则自动按所填写的信息创建终端，具体见[交易请求中的终端及门店](#upay-meta) | 
client_store | 对接方门店信息 | JSON对象 | Y | 包含对接方门店编号，名称等信息，若WebProxy按编号查找不存在，则自动按所填写的信息创建门店，具体见[交易请求中的终端及门店](#upay-meta) | 
sn | 收钱吧系统订单号 | String(16) | N | 收钱吧系统唯一订单号 | "7894259244061958"
client_sn | 商户自己的订单号 | String(64) | N | 商户自己订号 | "2324545839"

**注**：sn与client_sn不能同时为空，支付系统会优先按照sn查找订单进行撤单；如果没有sn，支付系统则按照client_sn查找订单进行撤单。

#### 响应参数

以下参数均指响应结果中`biz_response.data`节点下的字段：

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
sn | 收钱吧唯一订单号 | String(16) | Y | 收钱吧系统内部唯一订单号 | "7894259244061958"
client_sn | 商户订单号 | String(64) | Y | 商户系统订单号 | "22345677767776"
status | 流水状态 | String(32) | Y | 本次操作对应的流水的状态 | "SUCCESS"
order_status | 订单状态 | String(32) | Y | 当前订单状态 | "CANCELED"
trade_no | 支付通道的订单凭证号 | String(64) | Y | 支付宝或微信的订单号 | "2006101016201512090096528672"
total_amount | 交易总金额 | String(10) | Y | 原始交易实收金额 | "100"
net_amount | 剩余金额 | String(10) | Y | 实收金额减退款金额 | "0"
finish_time | 上次操作在收钱吧的完成时间 | String(13) | Y | 时间戳，本次动作在收钱吧的完成时间 | "1449646835244"
channel_finish_time | 上次操作在支付平台完成的时间 | String(13) | Y | 时间戳，本次动作在微信或支付宝的完成时间 | "1449646835221"
subject | 商品概述 | String(32) | Y | 交易时候的商品概述 | "wx"
operator | 操作员 | String(64) | Y | 执行上次业务动作的操作员 | "Obama"

#### 响应示例

- 撤单成功

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "CANCEL_SUCCESS",
                "data": {
                    "sn": "7894259244064831",
                    "client_sn": "22345677767776",
                    "status": "SUCCESS",
                    "payway": "3",
                    "sub_payway": "1",
                    "order_status": "CANCELED",
                    "total_amount": "1",
                    "net_amount": "0",
                    "finish_time": "1450090828489",
                    "subject": "wx",
                    "store_sn": "49"
                }
            }
        }

- 撤单通讯失败

        {
            "result_code": "500",
            "error_code": "UNKNOWN_SYSTEM_ERROR",
            "error_message": "未知的系统错误"
        }

- 撤单业务失败

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "CANCEL_ERROR",
                "error_code": "UPAY_TCP_ORDER_NOT_REFUNDABLE",
                "error_message": "订单7894259244061958参与了活动并且无法撤销"
            }
        }

### 3.4 <a name="upay-query"></a>查询

#### 接口说明

操作员利用收银终端扫描顾客手机上的收款码完成收银时需要调用的接口，接口会保持连接直至最终结果返回或请求超时，超时时间约为45秒。

#### 接口路径

    {api_domain}/proxy/query

#### 请求参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
client_terminal | 对接方终端信息 | JSON对象 | Y | 包含对接方终端编号，名称等信息，若WebProxy按编号查找不存在，则自动按所填写的信息创建终端，具体见[交易请求中的终端及门店](#upay-meta) | 
client_store | 对接方门店信息 | JSON对象 | Y | 包含对接方门店编号，名称等信息，若WebProxy按编号查找不存在，则自动按所填写的信息创建门店，具体见[交易请求中的终端及门店](#upay-meta) | 
sn | 收钱吧系统订单号 | String(16) | N | 收钱吧系统唯一订单号 | "7894259244061958"
client_sn | 商户自己的订单号 | String(64) | N | 商户自己订号 | "2324545839"

**注**：sn与client_sn不能同时为空，支付系统会优先按照sn查询订单；如果没有sn，支付系统则按照client_sn查询订单。

#### 响应参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
sn | 收钱吧唯一订单号 | String(16) | Y | 收钱吧系统内部唯一订单号 | "7894259244061958"
client_sn | 商户订单号 | String(64) | Y | 商户系统订单号 | "22345677767776"
status | 流水状态 | String(32) | Y | 本次操作对应的流水的状态 | "SUCCESS"
order_status | 订单状态 | String(32) | Y | 当前订单状态 | "REFUNDED"
trade_no | 支付通道的订单凭证号 | String(64) | Y | 支付宝或微信的订单号 | "2006101016201512090096528672"
total_amount | 交易总金额 | String(10) | Y | 原始交易实收金额 | "100"
net_amount | 剩余金额 | String(10) | Y | 实收金额减退款金额 | "0"
finish_time | 上次操作在收钱吧的完成时间 | String(13) | Y | 时间戳，本次动作在收钱吧的完成时间 | "1449646835244"
channel_finish_time | 上次操作再支付通道完成的时间 | String(13) | Y | 时间戳，本次动作在微信或支付宝的完成时间 | "1449646835221"
subject | 商品概述 | String(32) | Y | 交易时候的商品概述 | "wx"
operator | 操作员 | String(64) | Y | 执行上次业务动作的操作员 | "Obama"

#### 响应示例

- 查询成功

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "SUCCESS",
                "data": {
                        "sn": "7894259244096963",
                        "client_sn": "1234567",
                        "ctime": "1449036464229",
                        "status": "SUCCESS",
                        "order_status": "CANCELED",
                        "total_amount": "1",
                        "net_amount": "0",
                        "finish_time": "1449563206776",
                        "channel_finish_time": "1449563206632",
                        "payway": "3",
                        "sub_payway": "1"
                }
            }
        }

- 查询通讯失败

        {
            "result_code": "500",
            "error_code": "MAINTENANCE_INPROGRESS",
            "error_message": "服务端正在升级维护，稍候5分钟"
        }

- 查询业务失败

        {
            "result_code": "200",
            "biz_response": {
                "error_code": "UPAY_ORDER_NOT_EXISTS",
                "error_message": "订单不存在",
                "result_code": "FAIL"
            }
        }


### 3.5 <a name="upay-precreate"></a>预下单

#### 接口说明

预下单接口对应以下两种支付场景：

- 操作员预先生成需要支付的订单信息，系统调用预下单接口获取预下单结果和支付二维码，顾客利用支付应用客户端（如微信、支付宝等）扫描二维码进行支付；
- 对接商户希望在自己的前端页面上利用微信JS-SDK唤起微信支付控件进行WAP支付，需要先调用WebProxy的预下单接口获取前端支付参数。

#### 接口路径

    {api_domain}/proxy/preCreate

#### 请求参数

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
client_terminal | 对接方终端信息 | JSON对象 | Y | 包含对接方终端编号，名称等信息，若WebProxy按编号查找不存在，则自动按所填写的信息创建终端，具体见[交易请求中的终端及门店](#upay-meta) | 
client_store | 对接方门店信息 | JSON对象 | Y | 包含对接方门店编号，名称等信息，若WebProxy按编号查找不存在，则自动按所填写的信息创建门店，具体见[交易请求中的终端及门店](#upay-meta) | 
client_sn | 商户系统订单号 | String(32) | Y | 必须在商户系统内唯一；且长度不超过32字节 | "18348290098298292838"
total_amount | 交易总金额 | String(10) | Y | 以分为单位，不超过10位纯数字字符串，超过1亿元的收款请使用银行转账 | "1000"
payway | 支付方式 | String(2) | Y | 内容为数字的字符串 | "1"
sub_payway | 二级支付方式 | String(2) | N | 内容为数字的字符串，<span style="color: red;">如果要使用WAP支付，则必须传 "3"</span> | "3"
payer_uid | 付款人id | String(64) | N | 消费者在支付通道的唯一id，**微信WAP支付必须传open_id** | "okSzXt_KIZVhGZe538aOKIMswUiI"
subject | 交易简介 | String(64) | Y | 本次交易的概述 | "pizza"
operator | 门店操作员 | String(32) | Y | 发起本次交易的操作员 | "Obama"
description | 商品详情 | String(256) | N | 对商品或本次交易的描述 |
longitude | 经度 | String(16) | N | 经纬度必须成对出现 |
latitude | 纬度 | String(16) | N | 经纬度必须成对出现 |
extended | 扩展参数集合 | String(256) | N | 收钱吧与特定第三方单独约定的参数集合，json格式，最多支持24个字段，每个字段key长度不超过64字节，value长度不超过256字节 | { "goods_tag": "beijing"}
reflect | 反射参数 | String(64) | N | 任何调用者希望原样返回的信息 | "{ \"tips\" : \"100\""}

#### 响应参数

以下参数均指响应结果中`biz_response.data`节点下的字段：

参数 | 参数名称 | 类型 | 必填 | 描述 | 范例
--------- | ------ | ----- | ------- | --- | ----
sn | 收钱吧唯一订单号 | String(16) | Y | 收钱吧系统内部唯一订单号 | "7892259488292938"
client_sn | 商户订单号 | String(64) | Y | 商户系统订单号 | "7654321132"
trade_no | 支付服务商订单号 | String(64) | Y | 支付通道交易凭证号 | "2013112011001004330000121536"
status | 流水状态 | String(32) | Y | 本次操作产生的流水的状态 | "CREATED"
order_status | 订单状态 | String(32) | Y | 当前订单状态 | "CREATED"
payway | 支付方式 | String(2) | Y | 一级支付方式，取值见附录[支付方式](#payway) | "1"
sub_payway | 二级支付方式 | String(2) | Y | 二级支付方式，取值见附录[二级支付方式](#sub-payway) | "3"
qr_code | 二维码内容 | String(128) | 预下单成功后生成的二维码 | "https://qr.alipay.com/bax00069h45nvvfc3tu9803a"
total_amount | 交易总额 | String(10) | Y | 本次交易总金额 | "10000"
net_amount | 实收金额 | String(10) | Y | 如果没有退款，这个字段等于total_amount。否则等于total_amount减去退款金额 | "0"
subject | 交易概述 | String(64) | Y | 本次交易概述 | "Pizza"
operator | 操作员 | String(32) | Y | 门店操作员 | "张三丰"
reflect | 反射参数 | String(64) | N | 任何调用者希望原样返回的信息 | "{ \"tips\" : \"100\""}
wap_pay_request | 支付通道返回的调用WAP支付需要传递的信息 | String(1024) | N | WAP支付一定会返回

#### 响应示例

- 预下单成功

        {
            "result_code": "200",
            "biz_response": {
                "result_code": "PRECREATE_SUCCESS",
                "data": {
                    "sn": "7894259244096169",
                    "client_sn": "765432112",
                    "status": "IN_PROG",
                    "order_status": "CREATED",
                    "total_amount": "1",
                    "net_amount": "1",
                    "operator ": "张三丰",
                    "subject ": "coca cola",
                    "qr_code": "https://qr.alipay.com/bax8z75ihyoqpgkv5f"
                }
            }
        }

- 预下单通讯失败

        {
            "result_code": "400",
            "error_code": "TERMINAL_NOT_EXISTS",
            "error_message": "不存在这个终端"
        }

- 预下单业务失败

        {
    	    "result_code": "200",
    	    "biz_response": {
    		    "result_code": "FAIL",
    		    "error_code": "CLIENT_SN_CONFLICT",
    		    "error_message": "client_sn 128309123034 在系统中已经存在"
    	    }
        }

## 4. <a name="appendix"></a>附录

### 4.1 <a name="comm-error"></a>通讯错误码

error_code为本次通讯的错误码；error_message为对应的中文描述。

error_code和error_message当result_code不等于200的时候才会出现。

result_code | error_code | error_message 
--------- | ------ | -----  
**400** | INVALID_PARAMS | 参数错误
**400** | INVALID_TERMINAL | 终端错误
**400** | ILLEGAL_SIGN | 签名错误
**500** | UNKNOWN_SYSTEM_ERROR | 系统错误

### 4.2 <a name="result-code"></a>业务结果码

biz_response.result_code状态分为`SUCCESS`、`FAIL`、`INPROGRESS`和`ERROR`四类：

- SUCCESS: 本次业务执行成功
- FAIL: 本次业务执行失败
- INPROGRESS: 本次业务进行中
- ERROR: 本次业务执行结果未知

具体到业务场景，分别有下列状态：

取值 |含义 | 下一步动作 
--------- | ------ | -----  
<font color="red">PAY_SUCCESS</font> | 支付操作成功 | 银货两讫
<font color="red">PAY_FAIL</font> | 支付操作失败并且已冲正 | 重新进行一笔交易
<font color="red">PAY_FAIL_ERROR</font> | 支付操作失败并且不确定第三方支付通道状态 | 联系客服
<font color="green">CANCEL_SUCCESS</font> | 撤单操作成功 | 
<font color="green">CANCEL_ERROR</font> | 撤单操作失败并且不确定第三方支付通道状态 | 联系客服
<font color="green">CANCEL_ABORT_ERROR</font> | 撤单操作试图终止进行中的支付流程，但是失败，不确定第三方支付通道的状态 | 联系客服
<font color="green">CANCEL_ABORT_SUCCESS</font> | 撤单操作试图终止进行中的支付流程并且成功	 | 
<font color="pink">REFUND_SUCCESS</font> | 退款操作成功 | 
<font color="pink">REFUND_ERROR</font> | 退款操作失败并且不确定第三方支付通状态 | 联系客服
<font color="blue">PRECREATE_SUCCESS</font> | 预下单操作成功 | 
<font color="blue">PRECREATE_FAIL</font> | 预下单操作失败 | 
<font color="red">SUCCESS</font> | 操作成功 | 
<font color="red">FAIL</font> | 操作失败（不会触发流程） |

### 4.3 <a name="appendix-core"></a>业务接口

#### 4.3.1 <a name="core-biz-error"></a>业务执行错误码

biz_response.error_code为业务执行结果返回码，biz_response.error_message为对应的中文描述，当业务执行失败(即biz_response.result不为success)的时候，会返回如下内容：

error_code | error_message
-------- | --------
UPAY_MERCHANT_NOT_EXISTS | 商户不存在
CLIENT_SN_CONFLICT | client_sn在系统中已存在

#### 4.3.2 <a name="store-status"></a>门店状态

store.status的可能取值如下：

状态 | 定义
-------- | --------
0 | 暂停营业
1 | 正常营业

#### 4.3.3 <a name="terminal-status"></a>终端状态

terminal.status的可能取值如下：

状态 | 定义
-------- | --------
0 | 未激活
1 | 正常
2 | 禁用

#### 4.3.4 <a name="terminal-type"></a>终端类型

terminal.type的可能取值如下：

类型 | 定义
-------- | --------
11 | iOS应用
10 | Android应用
20 | Windows桌面应用
30 | 专用设备
40 | WAP支付
50 | 服务

### 4.4 <a name="appendix-upay"></a>交易接口

#### 4.4.1 <a name="upay-biz-error"></a>业务执行错误码

biz_response.error_code为业务执行结果返回码；biz_response.error_message为对应的中文描述。

当业务执行失败（即biz_response.result_code不为`SUCCESS`）的时候，会返回如下内容：

error_code |error_message
--------- | ------
INVALID_BARCODE | 条码错误
INSUFFICIENT_FUND | 账户金额不足
EXPIRED_BARCODE | 过期的支付条码
BUYER_OVER_DAILY_LIMIT | 付款人当日付款金额超过上限
BUYER_OVER_TRANSACTION_LIMIT | 付款人单笔付款金额超过上限
SELLER_OVER_DAILY_LIMIT | 收款账户当日收款金额超过上限
TRADE_NOT_EXIST | 交易不存在
TRADE_HAS_SUCCESS | 交易已被支付
SELLER_BALANCE_NOT_ENOUGH | 卖家余额不足
REFUND_AMT_NOT_EQUAL_TOTAL | 退款金额无效
TRADE_FAILED | 交易失败
UNEXPECTED_PROVIDER_ERROR | 不认识的支付通道
TRADE_TIMEOUT | 交易超时自动撤单
ACCOUNT_BALANCE_NOT_ENOUGH | 商户余额不足
CLIENT_SN_CONFLICT | client_sn在系统中已存在
UPAY_ORDER_NOT_EXIST | 订单不存在
REFUNDABLE_AMOUNT_NOT_ENOUGH | 订单可退金额不足
UPAY_TERMINAL_NOT_EXISTS | 终端号在交易系统中不存在
UPAY_TERMINAL_STATUS_ABNORMAL | 终端未激活
UPAY_CANCEL_ORDER_NOOP | 无效操作，订单已经是撤单状态了
UPAY_CANCEL_INVALID_ORDER_STATE | 当前订单状态不可撤销
UPAY_REFUND_ORDER_NOOP | 无效操作，本次退款退款已经完成了
UPAY_REFUND_INVALID_ORDER_STATE | 当前订单状态不可退款
UPAY_STORE_OVER_DAILY_LIMIT | 商户日收款额超过上限
UPAY_TCP_ORDER_NOT_REFUNDABLE | 订单参与了活动并且无法撤销

#### 4.4.2 <a name="order-status"></a>订单状态

biz_response.data.order_status的可能取值如下：
	
取值 |含义  
--------- | ------
<font color="green">CREATED</font> | <font color="red">订单已创建/支付中</font>
<font color="green">PAID</font> | <font color="red">订单支付成功</font>
<font color="green">PAY_CANCELED</font> | <font color="red">支付失败并且已经成功充正</font>
<font color="green">PAY_ERROR</font> | <font color="red">支付失败，不确定是否已经成功充正</font>
<font color="green">REFUNDED</font> | <font color="red">已成功全额退款</font>
<font color="green">PARTIAL_REFUNDED</font> | <font color="red">已成功部分退款</font>
<font color="green">REFUND_ERROR</font> | <font color="red">退款失败并且不确定第三方支付通道的最终退款状态</font>
<font color="green">CANCELED</font> | <font color="red">客户端发起的撤单已成功</font>
<font color="green">CANCEL_ERROR</font> | <font color="red">客户端发起的撤单失败并且不确定第三方支付通道的最终状态</font>

#### 4.4.3 <a name="transaction-status"></a>流水状态

取值 |含义 | 处理逻辑 
--------- | ------ | -----  
SUCCESS	 | 业务执行确认成功（即收钱吧后台和消费者端均成功） | 银货两讫（无论是交货还是退货）
FAIL_CANCELED | 确认失败（即收钱吧后台和消费者端均失败） | 银货两讫，（不交货或是不退货）
FAIL\_PROTOCOL_1 | 协议错误 | 小概率事件，失败但不确认消费者端状态<br>（即收钱吧后台强制认为是失败，但不确认消费者端是否同步失败）<br>（如果是收款，则不交货，但立即联系收钱吧客服，<br>（即算是消费者显示成功付款；<br>（如果是退货，则马上把货品回收，<br>（同时立即联系收钱吧客服，由收钱吧客服负责将钱款退回。
FAIL\_IO_1 | IO错误 | 同上
FAIL\_PROTOCOL_2 | 协议错误 | 同上	
FAIL\_IO_2 | IO错误 | 同上
FAIL\_PROTOCOL_3 | 协议错误 | 同上
FAIL_ERROR | 支付流程失败后进行自动撤单操作，和支付通道通信成功，但是返回结果为撤单失败。 | 同上
CANCEL_ERROR | 撤单流程调用支付通道的撤单接口通信成功，但是返回结果为撤单失败。 | 同上
REFUND_ERROR | 退款流程调用支付通道的退款接口通信成功，但是返回的结果为退款失败。 | 同上

**注**：当系统返回状态为 失败但不确认消费者端状态的时候，一定要明确这笔订单是失败的，收钱吧会最终负责将这笔交易撤销。不能交货或者退货，请立即进行人工介入，联系客服人员，以防遭受损失。

#### 4.4.4 <a name="payway"></a>支付方式

biz_response.data.payway的可能取值如下：

取值 |含义  
--------- | ------
0 | 不指定
1 | 支付宝
3 | 微信
4 | 百付宝
5 | 京东

#### 4.4.4 <a name="sub-payway"></a>二级支付方式

biz_response.data.sub_payway的可能取值如下：

取值 |含义  
--------- | ------
1 | 条码支付
2 | 二维码支付
3 | WAP支付
