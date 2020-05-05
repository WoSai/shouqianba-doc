# 收钱吧 轻POS  API

## <span id="1">1.**公共定义**</span>

### <span id="1_1">1.1.**请求通用定义**</span>

本平台所有请求格式均采用JSON格式，请求字符集采用UTF-8编码。

所有请求均按照以下通用格式定义：

| **参数** | 出现 | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| request | 1 | String | JSON格式的string字符串 | 标志一次接口请求的请求体 |
| request.head | 1 | String | JSON格式的string字符串 | 标志本次请求的公共参数 |
| request.body | 1 | String | JSON格式的string字符串 | 标志本次请求的业务对象 |
| signature | 1 | String | 签名，RSA加密 | 本次请求的请求体的加密签名，用于接口安全性校验。签名规则见本文档目录[1.3.签名](README.md#1_3) |

| **参数** | 出现 | **类型** | **约束 ** | **描述** |
| --- | --- | --- | --- | --- |
| request.head.appid | 1 | String | 数字，最大32位 | 轻POS应用编号，商户入网后由收钱吧技术支持提供 |
| request.head.sign\_type | 1 | String | 签名算法 | 支持的签名算法：            <br />1. SHA1&#39;:SHA1withRSA;   <br />2. SHA256&#39;:SHA256withRSA |
| request.head.request\_time | 1 | String | 字符串，最大64位 | 发起请求时间，格式详见 [1.5时间数据元素定义](README.md#1_5) |
| request.head.reserve | 0-1 | String | 字符串，长度不限 |  |
| request.head.version | 1 | String | 字符串，最大10位 | 收钱吧应用版本号，当前版本1.0.0 |

请求体样例：

{

&quot;request&quot;:{

&quot;head&quot;:{

&quot;version&quot;:&quot;1.0.0&quot;,

&quot;sign\_type&quot;:&quot;SHA1&quot;,

&quot;appid&quot;:&quot;28lp61847655&quot;,

&quot;request\_time&quot;:&quot;2001-07-04T12:08:56+05:30&quot;,

&quot;reserve&quot;:&quot;{}&quot;

},

&quot;body&quot;:{

&quot;subject&quot;:&quot;this is request business body&quot;

}

},

&quot;signature&quot;:&quot;blmSaxUF6/N2XOcz7UWRRVQ5XsVCEz1BpZl6R9Rc6TA3+IfWhJtmCsUZjtw72w1QQ8rEV6+uMh3GWbyzH02Y9dJQCW&quot;

}

### <span id="1_2">1.2.**响应通用定义**</span>

本平台所有响应返回均采用JSON格式，body均采用UTF-8编码。

所有响应均按照以下通用格式定义：

| **参数** | 出现 | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| response | 1 | String | JSON格式的string字符串 | 标志本次业务返回结果体 |
| response.head | 1 | String | JSON格式的string字符串 | 标志本次业务返回结果体头部数据 |
| response.body | 1 | String | JSON格式的string字符串 | 标志本次业务返回结果体的业务返回对象 |
| signature | 1 | String | 签名，RSA加密 | 本次请求的返回体的加密签名，用于接口安全性校验。签名规则见本文档目录[1.3.签名](README.md#1_3) |

| **字段名** | **字段含义** | **取值** | **备注** |
| --- | --- | --- | --- |
| response.body.result\_code | 通讯响应码 | 200，400，500 | 200：通讯成功；400：客户端错误；500:服务端错误 |
| response.body.error\_code | 通讯错误码 | 见通信错误码表 | 通讯  **失败**  的时候才返回 |
| response.body.error\_message | 通讯错误信息描述 | 见 通信错误码表 | 通讯  **失败**  的时候才返回 |
| response.body.biz\_response | 业务响应数据 | JSON结构 | 通讯  **成功**  的时候才返回 |
| response.body.biz_response.result_code | 业务执行响应码 | 见 业务响应定义 |  |
| response.body.biz_response.error_code | 业务执行结果返回码 | 见 业务响应定义 | 业务处理失败时返回 |
| response.body.biz_response.error_message | 业务执行错误信息 | 见 业务响应定义 | 业务处理失败时返回 |
| response.body.biz_response.data | 业务执行返回参数 | 见各具体接口的返回参数定义 |  |
返回体样例：

{

&quot;response&quot;: {

&quot;head&quot;: {

&quot;version&quot;: &quot;1.0.0&quot;,

&quot;sign\_type&quot;:&quot;SHA1&quot;,

&quot;appid&quot;: &quot;28lp61847655&quot;,

&quot;response\_time&quot;: &quot;2001-07-04T12:08:56+05:30&quot;,

&quot;reserve&quot;: &quot;{}&quot;

},

&quot;body&quot;: {

&quot;result\_code&quot;: &quot;200&quot;

&quot;biz\_response&quot;: {

&quot;result\_code&quot;: &quot;200&quot;

&quot;data&quot;: {

&quot;check\_sn&quot;: &quot;76526166340&quot;,

&quot;order\_sn&quot;: &quot;1b7efc395f754c60b5c28b96dd402174&quot;

}

}

}

},

&quot;signature&quot;: &quot;blmSaxUF6/N2XOcz7UWRRVQ5XsVCEz1BpZl6R9Rc6TA3+IfWhJtmCsUZjtw72w1QQ8rEV6+uMh3GWbyzH02Y9dJQCW&quot;

}

通讯错误码表：

error\_code为本次通讯的错误码

error\_message为对应的中文描述

当result\_code不等于200的时候才会出现

| 编号 | result\_code | error\_code | error\_message |
| --- | --- | --- | --- |
| 1 | 400 | INVALID\_PARAMS | 参数错误 |
| 2 | 400 | ILLEGAL\_SIGN | 签名错误 |
| 3 | 500 | UNKNOWN\_SYSTEM\_ERROR | 系统错误 |

### <span id="1_3">1.3. **签名**</span>

##### 请求参数签名：

•第一步：商户生成一份RSA公钥私钥，将公钥交付于收钱吧，收钱吧会使用该公钥验证签名，RSA密钥使用2048位

•第二步：将完整的请求内容（不包含&quot;request&quot;字段，仅包括request的值）使用RSA私钥签名，并转换为BASE64编码

•第三步：将生成的签名填充到请求体中的signature当中

##### 返回结果验签：

•第一步：收钱吧生成一份RSA公钥私钥，将公钥交付于商户，商户需要使用该公钥验证返回结果，RSA密钥使用2048位

•第二步：使用正则表达式将请求字符串和签名字符串从完整的请求字符串中分离出来

•第三步：使用收钱吧的公钥对于返回体签名进行验签

##### 签名示例：

签名私钥（仅用于商户调试签名使用）：

MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCkNGOzVWVpLAE9yMN0iqONAGniYp8JrzwdDO7lONzVyR0AC+9XRkrJohfYyF6LeZOMXZorzF+1m28I/lNKNvd0EqK30N/7vXt09cAj0D2oHTwwPIZFvTeWS2fKjfo1lcWvOIpSZmXDuo1KhitHlSo6blNf3kXjnpmshwt3skE2WKw4m0PLo2UJbmnbYi9WCSBHhYkAVxXPCATWymkZfOW9cUYGugg6dLzKH2Z0arNVtUbdmSJOPTuB7wpyAmk4IupXYdw+mYPD5wpHCQrGTxO6OW0U+PdrfkUIJKI4xaOGD9WSCeeRs8nNlpsDLnZcP1jyWcTuAGgkFNtu8VHI7gk5AgMBAAECggEAdCdXC2lx9gaZzjGxCUR00u4i+HAY3gnmNQqMBvvFQzkjWYAXyx2/E4ik48VBE9ppZBZmU2sbnOSZk7wMAOiG/MWd8vc/Kd1sclzQkMTiiIQ9qkV2GejyZE9s2Ry7jKIol30gY49plx3kin4EKXu7xl96fMtHlu7+98sDcqVWefD3efWRaCynLr0YmMGODQEvJ5mLeLn5aJS/zUMxWRmHtFL46LxPEDO0fpXZw/U2ZKtey/SiuxoMJNh18Nthtj/qmZmndjE0fPW25yb9u/5S8UJDfnCs1lzXG36QpW8RQjAZ1ip/DVNkP7FqP1MmDA1EtV73GLBM4K6x2g9z74mxgQKBgQDVsiy/AlbMzQe9ISj2MLOajDHhsMcw6vUIbh7Otj+Cqgga1rxSQ1XKTjp6n1JGFudMH58w0Z/htYn9D9mHCKbd7IjC4w3IX2X+kw8stx9kgrcidHSRhHXjiiF47wEUrZEnm32zUxjWw8+RXQdVojBawZrJQtytslKaJR5PQj/0EQKBgQDEtg9MeorZXgBrdO/Hs6paMlBGDFVUzf7wRWwzQqvGeYy8Qr4ztlTEeNgXZcDFrV6sSwUcW0BQDtg3oDtpolSFoW7MQjN9gsOh2D70jniIWVNFovwQ/+ljWfGT/JCKk19aN/jP2+DbMt/+E3uuNTu2XyfeHx5Ufrz3qGOOkplKqQKBgDjxBDlVbzmdPH2p81c+fO0mhDgmOb2QLgC0DyN3ro6rrgMwyveEl7yTgcOg5nRkr/c5ydphUR/8lqtG6OixZn1mBL8hb0/AE9Z06ys4FHZc2l2k+Fa6HAuoh+jIjtoqsa4DIciB0PGRNaL/TfAEiqv0QMF2PoVOKfKHB3+JIK9xAoGBAJTaD4mX0Sna8AZgXnGHiwjlucjH3Gpn1tqKLe48LS/rGov7FWKcPljN+Pb7kHwFTPajbiKfCnOKSCMPpOWyaLMWDXmTPtNi+BaoRDta8+p5bYHsa0GR5VHA5gVNwTKbgjQK1sSzZdt5C/Z/V7/jmGPQbaKveYwGu4fMbEmetVDBAoGALsgsyoJe19BQuqqYAp6zokDHF0w3W3YQNnrisF3qF/hFXY4n4azg/FMtykTYD2nOBEQ/JpACOHbpUULbucqnm/9fLTjSLfVNWRv2oY0hCsRRug+NH7OEXR2Da1vM7VnLrJwgkUubhqYD398qzyk8Uh3DPoYg7xnqRhgS+29tPw0=

验签公钥（仅用于商户调试签名使用）：

MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApDRjs1VlaSwBPcjDdIqjjQBp4mKfCa88HQzu5Tjc1ckdAAvvV0ZKyaIX2Mhei3mTjF2aK8xftZtvCP5TSjb3dBKit9Df+717dPXAI9A9qB08MDyGRb03lktnyo36NZXFrziKUmZlw7qNSoYrR5UqOm5TX95F456ZrIcLd7JBNlisOJtDy6NlCW5p22IvVgkgR4WJAFcVzwgE1sppGXzlvXFGBroIOnS8yh9mdGqzVbVG3ZkiTj07ge8KcgJpOCLqV2HcPpmDw+cKRwkKxk8TujltFPj3a35FCCSiOMWjhg/VkgnnkbPJzZabAy52XD9Y8lnE7gBoJBTbbvFRyO4JOQIDAQAB

第一步：封装请求参数

{

&quot;head&quot;: {

&quot;sign\_type&quot;: &quot;SHA1&quot;,

&quot;appid&quot;: &quot;test\_appid&quot;,

&quot;request\_time&quot;: &quot;2019-09-26T19:57:29+08:00&quot;,

&quot;version&quot;: &quot;1.0.0&quot;

},

&quot;body&quot;: {

&quot;store\_sn&quot;: &quot;SH1&quot;,

&quot;brand\_code&quot;: &quot;000000&quot;,

&quot;check\_sn&quot;: &quot;000000001&quot;,

&quot;workstation\_sn&quot;: &quot;0&quot;

}

}

第二步：生成签名体，

{&quot;head&quot;:{&quot;sign\_type&quot;:&quot;SHA1&quot;,&quot;appid&quot;:&quot;test\_appid&quot;,&quot;request\_time&quot;:&quot;2019-09-26T19:57:29+08:00&quot;,&quot;version&quot;:&quot;1.0.0&quot;},&quot;body&quot;:{&quot;store\_sn&quot;:&quot;SH1&quot;,&quot;brand\_code&quot;:&quot;000000&quot;,&quot;check\_sn&quot;:&quot;000000001&quot;,&quot;workstation\_sn&quot;:&quot;0&quot;}}

第三步：使用私钥并根据head.sign\_type指定的签名算法对签名体进行签名

&quot;luyVxzfRoiy27uepgEireRWAFFsGQNX/wgJKn8ALzgknq9oh0OJTi23T3HhVUJyG9lien/8vGm/LQ4UY14wxDIh9AAYsjQSNZwFqzI5yHorBzZ1wZo3lfmS26i4zkMxwJcEYyryboTBYt/tFS/QhciHmBoDY9d/bdUgZ2R+fnNsBsKgPQUR/SEoz0bEg8LRIUmQHlc4X4ma5qqN2dV2paNa8fdIipCKJHyLAR8mjVeX3w4gG6Bsz478406NkSp8uQECxzSPRBUc/fd1f+RHoDWh+x3e6vk58kQJQyRu5mPTjFk2EUCgdyXtAm+FVMOyMYeR3Vx3i1W2WyRNmLITTxg==&quot;

第四步：封装HTTP请求体

{&quot;request&quot;:{&quot;head&quot;:{&quot;sign\_type&quot;:&quot;SHA1&quot;,&quot;appid&quot;:&quot;test\_appid&quot;,&quot;request\_time&quot;:&quot;2019-09-26T19:57:29+08:00&quot;,&quot;version&quot;:&quot;1.0.0&quot;},&quot;body&quot;:{&quot;store\_sn&quot;:&quot;SH1&quot;,&quot;brand\_code&quot;:&quot;000000&quot;,&quot;check\_sn&quot;:&quot;000000001&quot;,&quot;workstation\_sn&quot;:&quot;0&quot;}},&quot;signature&quot;:&quot;luyVxzfRoiy27uepgEireRWAFFsGQNX/wgJKn8ALzgknq9oh0OJTi23T3HhVUJyG9lien/8vGm/LQ4UY14wxDIh9AAYsjQSNZwFqzI5yHorBzZ1wZo3lfmS26i4zkMxwJcEYyryboTBYt/tFS/QhciHmBoDY9d/bdUgZ2R+fnNsBsKgPQUR/SEoz0bEg8LRIUmQHlc4X4ma5qqN2dV2paNa8fdIipCKJHyLAR8mjVeX3w4gG6Bsz478406NkSp8uQECxzSPRBUc/fd1f+RHoDWh+x3e6vk58kQJQyRu5mPTjFk2EUCgdyXtAm+FVMOyMYeR3Vx3i1W2WyRNmLITTxg==&quot;}

### <span id="1_4">1.4.**参数数量定义**</span>

|      | 描述                                    |
| ---- | --------------------------------------- |
| 1    | 元素必须出现，且是一个。                |
| 0-1  | 该元素是一个可选项，最少0个，最多1个。  |
| 0-n  | 该元素是一个可选项，最少0个，最大不限。 |
| 1-n  | 该元素是一个必须项，最少1个，最大不限。 |

### <span id="1_5">1.5.**时间数据元素定义**</span>

采用ISO 8601 Format. YYYY-MM-DDThh:mm:ssTZD

Example:

2015-12-05T15:28:36+08:00

2015-12-05T15:28:36+0800



## <span id="2">2.**销售类操作**</span>

### <span id="2_1">2.1.**购买**</span>

API endpoint: {api\_domain}/api/lite-pos/v1/sales/purchase

Verb: POST

Signature ：需要签名，参考统一签名说明

请求参数：

| **参数** | 出现 | **类型** | **约束** | 描述 |
| --- | --- | --- | --- | --- |
| request\_id | 1 | String | 字符串，最大64位 | 请求编号，每次请求必须唯一；表示每一次请求时不同的业务，如果第一次请求业务失败了，再次请求，可以用于区分是哪次请求的业务。 |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供 |
| store\_sn | 1 | String | 字符串，最大36位 | 商户内部使用的门店编号 |
| store\_name | 0-1 | String | 字符串，最大255位 | 商户门店名称 |
| workstation\_sn | 1 | String | 字符串，最大36位 | 门店收银机编号，如果没有请传入&quot;0&quot; |
| check\_sn | 1 | String | 字符串，最大32位 | 商户订单号，在商户系统中唯一 |
| scene | 1 | String | 数字，1位 | 场景值：1-智能终端，2-H5，4-PC |
| sales\_time | 1 | String | 字符串，20- 25位 | 商户订单创建时间, 格式详见 [1.5时间数据元素定义](README.md#1_5) |
| amount | 1 | String | 数字，最大12位 | 订单价格，精确到分 |
| currency | 1 | String | 字符串，3位 | 币种，ISO numeric currency code 如：&quot;156&quot;for CNY |
| subject | 1 | String | 字符串，最大64位 | 订单简短描述，建议传8个字内 |
| description | 0-1 | String | 字符串，最大255位 | 订单描述 |
| operator | 1 | String | 字符串，最大32位 | 操作员，可以传入收款的收银员或导购员。例如"张三" |
| customer | 1 | String | 字符串，最大32位 | 客户信息，可以是客户姓名或会员号 |
| extension\_1 | 0-1 | String | 字符串，最大32位 | 拓展字段1，可以用于做自定义标识，如座号，房间号 |
| extension\_2 | 0-1 | String | 字符串，最大32位 | 拓展字段2，可以用于做自定义标识，如座号，房间号 |
| industry\_code | 1 | String | 数字，1位 | 行业代码, 0=零售;1:酒店; 2:餐饮; 3:文娱; 4:教育; |
| pos\_info | 1 | String | 字符串，最大64位 | 传入商户系统的产品名称、系统编号等信息，便于帮助商户调查问题 |
| notify\_url | 0-1 | String | 字符串，最大255位 | 通知接收地址。总共回调7次，回调时间间隔：4m,10m,10m,1h,2h,6h,15h |
| return\_url | 0-1 | String | 字符串，最大支持255位 | 支付结果页，H5场景支付结果页 |
| extended | 0-1 | JSON ||扩展对象，用于传入本接口所定义字段之外的参数，JSON格式。|
| reflect | 0-1 | String | 字符串，最大64位 | 反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。 |
| items | 0-n | [Item] | item数组 | 订单货物清单，定义如下表 |
| tenders | 0-n | [tender] | tender数组 | 指定订单的各支付方式，定义如下表，不指定支付方式时该数组为空由操作员在POS上选择支付方式，指定支付方式时下发各支付方式设置，预授权完成必须下发该项目并指定授权时的流水号 |

items：

| **参数** | **出现  ** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| item\_code | 1 | String | 字符串，最大32位 | 商户系统中的商品编号 |
| item\_desc | 1 | String | 字符串，最大64位 | 商品描述信息，例&quot;白色短袖&quot; |
| category | 0-1 | String | 字符串，最大32位 | 商品所属大类，例&quot;短袖&quot; |
| unit | 0-1 | String | 字符串，最大32位 | 商品单位，例&quot;件&quot; |
| item\_qty | 1 | String | 数字，最大8位 | 商品数量，例&quot;2&quot;；当退货时数量为负数，例：&quot;-2&quot; |
| item\_price | 1 | String | 数字，最大12位 | 商品单价，精确到分 |
| sales\_price | 1 | String | 数字，最大12位 | 商品成交价格,一般为数量\*单价，如有折扣再进行扣减，精确到分；当退货时成交价为负数；目前不校验"数量\*单价"结果是否与此字段值相等 |
| type | 1 | String | 数字，1位 | 0-销售，1-退货 |
| return\_store\_sn | 0-1 | String | 字符串，最大36位 | 原商品销售门店号，退货时必填 |
| return\_workstation\_sn | 0-1 | String | 字符串，最大36位 | 原商品销售收音机号，退货时必填 |
| return\_check\_sn | 0-1 | String | 字符串，最大32位 | 原商品销售订单号，退货时必填 |

tenders：

| **参数** | 出现 | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| tender\_type | 1 | String | 数字，1位 | 支付方式类型：0-其他，1-预授权完成，2-银行卡，3-QRCode，4-分期，99-外部 |
| sub\_tender\_type | 0-1 | String | 数字 | 二级支付方式类型（开发者不需要传入具体值）：<br />001-现金，如需在轻POS录入其他支付方式，在对接时与收钱吧沟通配置；<br />101-银行卡预授权完成，<br />102-微信预授权完成，103-支付宝预授权完成；<br />201-银行卡；<br />301-微信，302-支付宝；<br />401-银行卡分期；402-花呗分期 |
| sub\_tender\_desc | 0-1 | String | 字符串 | 当tender\_type为99时，必填，且传入参数值为收银系统自定义的支付方式 |
| dynamic\_id| 0-1 | String | 字符串 | 付款码内容 |
| amount | 1 | String | 数字，最大12位 | 支付金额，精确到分； |
| transaction\_sn | 1 | String | 字符串，最大32位 | 商户系统流水号，在商户系统中唯一 |
| installment\_number| 0-1 | String | 数字 | 分期数，不传则终端选择 |
| installment\_fee\_merchant\_percent| 0-1 | String | 数字 | 商家贴息比例0~100的整数，跟期数同时出现，指定期数时必传。花呗分期只能传0或者100 |
| original\_tender\_sn | 0-1 | String | 字符串，最大32位 | tender\_type 为1时必填，内容为预授权订单操作成功后，轻POS返回给商户的预授权流水号 |
| pay\_status | 0-1 | String | 数字，最大12位 | 标记该tender是否已经支付完成，<br />0：待操作，<br />1：已完成tender\_type为99时，为1：已完成，其他的tender\_tpye必须为0：待操作 |
| create\_time | 0-1 | String | 字符串，最大32位 | tender创建时间，当pay\_status为1时必填, 格式详见 [1.5时间数据元素定义](README.md#1_5) |

返回参数：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供，返回调用方传入的值 |
| store\_sn | 1 | String | 字符串，最大36位 | 商户内部使用的门店编号，返回调用方传入的值 |
| workstation\_sn | 1 | String | 字符串，最大36位 | 门店收银机编号，返回调用方传入的值 |
| check\_sn | 1 | String | 字符串，最大32位 | 商户订单号，返回调用方传入的值 |
| order\_sn | 1 | String | 字符串，最大32位 | 本系统为该订单生成的订单序列号 |
| cashier\_url | 0-1 | String | 字符串，最大255位 | 轻POS收银台地址，H5场景下会返回该字段， |
| reflect | 0-1 | String | 字符串，最大64位 | 反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。 |

### <span id="2_2">2.2.**退款**</span>

API endpoint: {api\_domain}/api/lite-pos/v1/sales/refund

Verb: POST

Signature ：需要签名，参考统一签名说明

请求参数：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| request\_id | 1 | String | 字符串，最大64位 | 请求编号，每次请求必须唯一；表示每一次请求时不同的业务，如果第一次请求业务失败了，再次请求，可以用于区分是哪次请求的业务。 |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供 |
| store\_sn | 1 | String | 字符串，最大36位 | 商户内部使用的门店编号 |
| store\_name | 0-1 | String | 字符串，最大255位 | 商户门店名称 |
| workstation\_sn | 1 | String | 字符串，最大36位 | 门店收银机编号，如果没有请传入&quot;0&quot; |
| check\_sn | 1 | String | 字符串，最大32位 | 商户订单号 |
| sales\_time | 1 | String | 字符串，20- 25位 | 商户订单创建时间, 格式详见 [1.5时间数据元素定义](README.md#1_5) |
| amount | 1 | String | 数字，最大12位 | 订单价格，精确到分，金额应为负数。 |
| currency | 1 | String | 字符串，3位 | 币种，ISO numeric currency code 如：&quot;156&quot;for CNY |
| subject | 1 | String | 字符串，最大64位 | 订单简短描述，建议传8个字内 |
| description | 0-1 | String | 字符串，最大255位 | 订单描述 |
| operator | 1 | String | 字符串，最大32位 | 操作员，可以传入收款的收银员或导购员。例如"张三" |
| customer | 1 | String | 字符串，最大32位 | 客户信息，可以是客户姓名或会员号 |
| extension\_1 | 0-1 | String | 字符串，最大32位 | 拓展字段1，可以用于做自定义标识，如座号，房间号 |
| extension\_2 | 0-1 | String | 字符串，最大32位 | 拓展字段2，可以用于做自定义标识，如座号，房间号 |
| industry\_code | 1 | String | 数字，1位 | 行业代码, 0=零售1:酒店; 2:餐饮; 3:文娱; 4:教育; |
| pos\_info | 1 | String | 字符串，最大64位 | 传入商户系统的产品名称、系统编号等信息，便于帮助商户调查问题 |
| notify\_url | 0-1 | String | 字符创，最大255位 | 通知接收地址。总共回调7次，回调时间间隔：4m,10m,10m,1h,2h,6h,15h。 |
| extended | 0-1 | JSON ||扩展对象，用于传入本接口所定义字段之外的参数，JSON格式。|
| reflect | 0-1 | String | 字符串，最大64位 |反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。|
| items | 0-n | [Item] | item数组 | 订单货物清单，定义如下表 |
| tenders | 1-n | [tender] | tender数组 | 订单指定的各退款方式，定义如下表， |

items：

| **参数** | **出现  ** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| item\_code | 1 | String | 字符串，最大32位 | 商户系统中的商品编号 |
| item\_desc | 1 | String | 字符串，最大64位 | 商品描述信息，例&quot;白色短袖&quot; |
| category | 0-1 | String | 字符串，最大32位 | 商品所属大类，例&quot;短袖&quot; |
| unit | 0-1 | String | 字符串，最大32位 | 商品单位，例&quot;件&quot; |
| item\_qty | 1 | String | 数字，最大8位 | 商品数量，例&quot;2&quot;；当退货时数量为负数，例：&quot;-2&quot; |
| item\_price | 1 | String | 数字，最大12位 | 商品单价，精确到分 |
| sales\_price | 1 | String | 数字，最大12位 | 商品成交价格,一般为数量*单价，如有折扣再进行扣减，精确到分；当退货时成交价为负数；目前不校验"数量*单价"结果是否与此字段值相等 |
| type | 1 | String | 数字，1位 | 0-销售，1-退货 |
| return\_store\_sn | 0-1 | String | 字符串，最大36位 | 原商品销售门店号，退货时必填 |
| return\_workstation\_sn | 0-1 | String | 字符串，最大36位 | 原商品销售收音机号，退货时必填 |
| return\_check\_sn | 0-1 | String | 字符串，最大32位 | 原商品销售订单号，退货时必填 |

tenders：

| **参数** | 出现 | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| transaction\_sn | 1 | String | 字符串，最大32位 | 商户系统流水号，在商户系统中唯一 |
| amount | 1 | String | 数字，最大12位 | 退款金额，精确到分，退款为负 |
| pay\_status | 1 | String | 数字，1位 | 标记该tender是否已经支付完成，0：待操作，1：已完成原tender\_type为99-外部时必需为1其他tender\_tpye必需为0 |
| create\_time | 0-1 | String | 字符串，最大32位 | tender创建时间，当pay\_status为1时必填，格式详见 [1.5时间数据元素定义](README.md#1_5) |
| original\_tender\_sn | 1 | String | 字符串，最大32位 | 原购货订单完成后本系统返回的支付流水号 |

返回参数：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供，返回调用方传入的值 |
| store\_sn | 1 | String | 字符串，最大36位 | 商户内部使用的门店编号，返回调用方传入的值 |
| workstation\_sn | 1 | String | 字符串，最大36位 | 门店收银机编号，返回调用方传入的值 |
| check\_sn | 1 | String | 字符串，最大32位 | 商户订单号，返回调用方传入的值 |
| order\_sn | 1 | String | 字符串，最大32位 | 本系统为该订单生成的订单序列号 |
| reflect | 0-1 | String | 字符串，最大64位 | 反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。可以在订单结果通知中返回 |

## <span id="3">3.**授权类操作**</span>

### <span id="3_1">3.1.**预授权**</span>

API endpoint: {api\_domain}/api/lite-pos/v1/authorization/initial

Verb: POST

Signature ：需要签名，参考统一签名说明
请求参数：

| **参数**        | 出现 | **类型** | **约束**          | **描述**                                                     |
| --------------- | ---- | -------- | ----------------- | ------------------------------------------------------------ |
| request\_id     | 1    | String   | 字符串，最大64位  | 请求编号，每次请求必须唯一；表示每一次请求时不同的业务，如果第一次请求业务失败了，再次请求，可以用于区分是哪次请求的业务。 |
| brand\_code     | 1    | String   | 数字，最大32位    | 品牌编号，系统对接前由&quot;收钱吧"分配并提供                |
| store\_sn       | 1    | String   | 字符串，最大36位  | 商户内部使用的门店编号                                       |
| store\_name     | 0-1  | String   | 字符串，最大255位 | 商户门店名称                                                 |
| workstation\_sn | 1    | String   | 字符串，最大36位  | 门店收银机编号，如果没有请传入&quot;0&quot;                  |
| check\_sn       | 1    | String   | 字符串，最大32位  | 商户订单号                                                   |
| sales\_time     | 1    | String   | 字符串，20- 25位  | 商户订单创建时间, 格式详见 [1.5时间数据元素定义](README.md#1_5) |
| channel\_fixed  | 0-1  | String   | 数字，1位         | 是否指定预授权渠道，0，不指定；1，指定。默认为0              |
| auth\_channel   | 0-1  | String   | 数字，1位         | 预授权渠道，1:银行卡，2：微信，3：支付宝。指定预授权渠道后必传。 |
| amount          | 1    | String   | 数字，最大12位    | 预授权金额，精确到分                                         |
| currency        | 1    | String   | 字符串，3位       | 币种，ISO numeric currency code 如：&quot;156&quot;for CNY   |
| subject         | 1    | String   | 字符串，最大64位  | 订单简短描述，建议传8个字内                                  |
| description     | 0-1  | String   | 字符串，最大255位 | 订单描述                                                     |
| operator        | 1    | String   | 字符串，最大32位  | 操作员，可以传入收款的收银员或导购员。例如&quot;张三&quot;   |
| customer        | 1    | String   | 字符串，最大32位  | 客户信息，可以是客户姓名或会员号                             |
| extension\_1    | 0-1  | String   | 字符串，最大32位  | 拓展字段1，可以用于做自定义标识，如座号，房间号              |
| extension\_2    | 0-1  | String   | 字符串，最大32位  | 拓展字段2，可以用于做自定义标识，如座号，房间号              |
| industry\_code  | 1    | String   | 数字，1位         | 行业代码, 0=零售;1:酒店; 2:餐饮; 3:文娱; 4:教育;             |
| pos\_info       | 1    | String   | 字符串，最大64位  | 传入商户系统的产品名称、系统编号等信息，便于帮助商户调查问题 |
| notify\_url     | 0-1  | String   | 字符串，最大255位 | 通知接收地址。总共回调7次，回调时间间隔：4m,10m,10m,1h,2h,6h,15h。 |
| extended        | 0-1  | JSON     |                   | 扩展对象，用于传入本接口所定义字段之外的参数，JSON格式。     |
| reflect         | 0-1  | String   | 字符串，最大64位  | 反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。 |

返回参数：

| **参数**        | **出现** | **类型** | **约束**         | **描述**                                                     |
| --------------- | -------- | -------- | ---------------- | ------------------------------------------------------------ |
| brand\_code     | 1        | String   | 数字，最大32位   | 品牌编号，系统对接前由"收钱吧"分配并提供，返回调用方传入的值 |
| store\_sn       | 1        | String   | 字符串，最大36位 | 商户内部使用的门店编号，返回调用方传入的值                   |
| workstation\_sn | 1        | String   | 字符串，最大36位 | 门店收银机编号，返回调用方传入的值                           |
| check\_sn       | 1        | String   | 字符串，最大32位 | 商户订单号，返回调用方传入的值                               |
| order\_sn       | 1        | String   | 字符串，最大32位 | 本系统为该订单生成的订单序列号                               |
| reflect         | 0-1      | String   | 字符串，最大64位 | 反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。可以在订单结果通知中返回 |

### <span id="3_2">3.2.**预授权撤销**</span>

API endpoint: {api\_domain}/api/lite-pos/v1/authorization/release

Verb: POST

Signature ：需要签名，参考统一签名说明

请求参数：

| **参数**                  | 出现 | **类型** | **约束**          | **描述**                                                     |
| ------------------------- | ---- | -------- | ----------------- | ------------------------------------------------------------ |
| request\_id               | 1    | String   | 字符串，最大64位  | 请求编号，每次请求必须唯一；表示每一次请求时不同的业务，如果第一次请求业务失败了，再次请求，可以用于区分是哪次请求的业务。 |
| brand\_code               | 1    | String   | 数字，最大32位    | 品牌编号，系统对接前由"收钱吧"分配并提供                     |
| store\_sn                 | 1    | String   | 字符串，最大36位  | 商户内部使用的门店编号                                       |
| store\_name               | 0-1  | String   | 字符串，最大255位 | 商户门店名称                                                 |
| workstation\_sn           | 1    | String   | 字符串，最大36位  | 门店收银机编号，如果没有请传入&quot;0&quot;                  |
| check\_sn                 | 1    | String   | 字符串，最大32位  | 商户订单号，在商户系统中唯一                                 |
| original\_store\_sn       | 0-1  | String   | 字符串，最大36位  | 原始商户门店编号                                             |
| original\_workstation\_sn | 0-1  | String   | 字符串，最大36位  | 原始门店收银机编号，如果没有请传入&quot;0&quot;              |
| original\_check\_sn       | 0-1  | String   | 字符串，最大32位  | 原始商户订单号                                               |
| original\_order\_sn       | 0-1  | String   | 字符串，最大32位  | 本系统为该笔预授权撤销对应的原始预授权订单生成的订单序列号   |
| sales\_time               | 1    | String   | 字符串，20- 25位  | 订单创建时间, 格式详见[1.5时间数据元素定义](README.md#1_5)   |
| amount                    | 1    | String   | 数字，最大12位    | 预授权撤销金额，等于原始预授权订单金额，精确到分             |
| currency                  | 1    | String   | 字符串，3位       | 币种，ISO numeric currency code 如：&quot;156&quot;for CNY   |
| subject                   | 1    | String   | 字符串，最大64位  | 订单简短描述，建议传8个字内                                  |
| description               | 0-1  | String   | 字符串，最大255位 | 订单描述                                                     |
| operator                  | 1    | String   | 字符串，最大32位  | 操作员，可以传入收款的收银员或导购员。例如"张三"             |
| customer                  | 1    | String   | 字符串，最大32位  | 客户信息，可以是客户姓名或会员号                             |
| extension\_1              | 0-1  | String   | 字符串，最大32位  | 拓展字段1，可以用于做自定义标识，如座号，房间号              |
| extension\_2              | 0-1  | String   | 字符串，最大32位  | 拓展字段2，可以用于做自定义标识，如座号，房间号              |
| industry\_code            | 1    | String   | 数字，1位         | 行业代码, 0=零售;1:酒店; 2:餐饮; 3:文娱; 4:教育;             |
| pos\_info                 | 1    | String   | 字符串，最大64位  | 传入商户系统的产品名称、系统编号等信息，便于帮助商户调查问题 |
| notify\_url               | 0-1  | String   | 字符创，最大255位 | 通知接收地址。总共回调7次，回调时间间隔：4m,10m,10m,1h,2h,6h,15h |
| extended                  | 0-1  | JSON     |                   | 扩展对象，用于传入本接口所定义字段之外的参数，JSON格式。     |
| reflect                   | 0-1  | String   | 字符串，最大64位  | 反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。 |

original\_store\_sn、original\_workstation\_sn、original\_check\_sn和original\_order\_sn不能同时为空，优先按original\_order\_sn查询，如果没有再按original\_check\_sn查询。

返回参数：

| **参数**        | **出现** | **类型** | **约束**         | **描述**                                                     |
| --------------- | -------- | -------- | ---------------- | ------------------------------------------------------------ |
| brand\_code     | 1        | String   | 数字，最大32位   | 品牌编号，系统对接前由"收钱吧"分配并提供，返回调用方传入的值 |
| store\_sn       | 1        | String   | 字符串，最大36位 | 商户内部使用的门店编号，返回调用方传入的值                   |
| workstation\_sn | 1        | String   | 字符串，最大36位 | 门店收银机编号，返回调用方传入的值                           |
| check\_sn       | 1        | String   | 字符串，最大32位 | 商户订单号，返回调用方传入的值                               |
| order\_sn       | 1        | String   | 字符串，最大32位 | 本系统为该订单生成的订单序列号                               |
| reflect         | 0-1      | String   | 字符串，最大64位 | 反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。可以在订单结果通知中返回 |

## 

## <span id="4">4.**取消订单操作**</span>

API endpoint: {api\_domain}/api/lite-pos/v1/sales/void

Verb: POST

Signature ：需要签名，参考统一签名说明

请求参数：

| **参数** | **出现** | 类型 | 约束 | 描述 |
| --- | --- | --- | --- | --- |
| request\_id | 1 | String | 字符串，最大64位 | 请求编号，每次请求必须唯一；表示每一次请求时不同的业务，如果第一次请求业务失败了，再次请求，可以用于区分是哪次请求的业务。 |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供 |
| original\_store\_sn | 0-1 | String | 字符串，最大36位 | 商户内部使用的门店编号 |
| original\_workstation\_sn | 0-1 | String | 字符串，最大36位 | 原始门店收银机编号，如果没有请传入&quot;0&quot; |
| original\_check\_sn | 0-1 | String | 字符串，最大32位 | 原始商户订单号 |
| original\_order\_sn | 0-1 | String | 字符串，最大32位 | 本系统为该订单生成的订单序列号 |
| reflect | 0-1 | String | 字符串，最大64位 | 反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。 |

original\_store\_sn+original\_workstation\_sn+original\_check\_sn和original\_order\_sn不能同时为空，优先按original\_order\_sn查询，如果没有再按original\_store\_sn+original\_workstation\_sn+original\_check\_sn查询。

注：只有待操作的订单可以取消。

返回参数：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供，返回调用方传入的值 |
| store\_sn | 1 | String | 字符串，最大36位 | 商户内部使用的门店编号，返回调用方传入的值 |
| workstation\_sn | 1 | String | 字符串，最大36位 | 门店收银机编号，返回调用方传入的值 |
| check\_sn | 1 | String | 字符串，最大32位 | 商户订单号，返回调用方传入的值 |
| original\_order\_sn | 1 | String | 字符串，最大32位 | 本系统为该订单生成的订单序列号 |
| reflect | 0-1 | String | 字符串，最大64位 | 反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。可以在订单结果通知中返回 |

## <span id="5">5.**通知**</span>

### <span id="5_1">5.1.**授权结果通知**</span>

API endpoint: 由商户提供，收钱吧配置

Verb: POST

Signature ：请求参数中包含签名，商家需要对签名进行验签，参考统一签名说明

请求参数：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| notification\_sn | 1 | String | 字符串，最大32位 | 通知编号 |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供，返回调用方传入的值 |
| store\_sn | 1 | String | 字符串，最大36位 | 商户内部使用的门店编号，返回调用方传入的值 |
| workstation\_sn | 1 | String | 字符串，最大36位 | 门店收银机编号，返回调用方传入的值 |
| check\_sn | 1 | String | 字符串，最大32位 | 商户订单号，返回调用方传入的值 |
| order\_sn | 1 | String | 字符串，最大32位 | 订单序列号 |
| order\_status | 1 | String | 数字，1位 | 订单状态0：已取消，1：待操作，3：等待结果中，4：操作完成 |
| sales\_time | 1 | String | 字符串，20- 25位 | 订单创建时间, 格式详见 [1.5时间数据元素定义](README.md#1_5) |
| auth\_channel | 1 | String | 数字，1位 | 预授权渠道，1:银行卡，2.微信，3.支付宝 |
| amount | 1 | String | 数字，最大12位 | 预授权金额，精确到分 |
| currency | 1 | String | 字符串，3位 | 币种，ISO numeric currency code 如：&quot;156&quot;for CNY |
| subject | 1 | String | 字符串，最大64位 | 订单简短描述 |
| description | 0-1 | String | 字符串，最大255位 | 订单描述 |
| operator | 1 | String | 字符串，最大32位 | 操作员，可以传入收款的收银员或导购员。例如"张三" |
| customer | 1 | String | 字符串，最大32位 | 客户信息，可以是客户姓名或会员号 |
| extension\_1 | 0-1 | String | 字符串，最大32位 | 拓展字段1，可以用于做自定义标识，如座号，房间号 |
| extension\_2 | 0-1 | String | 字符串，最大32位 | 拓展字段2，可以用于做自定义标识，如座号，房间号 |
| industry\_code | 1 | String | 数字，1位 | 行业代码, 0=零售;1:酒店; 2:餐饮; 3:文娱; 4:教育; |
| pos\_info | 1 | String | 字符串，最大64位 | 传入商户系统的产品名称、系统编号等信息，便于帮助商户调查问题 |
| notify\_url | 0-1 | String | 字符创，最大255位 | 通知接收地址，总共回调7次，回调时间间隔：4m,10m,10m,1h,2h,6h,15h。 |
| extended | 0-1 | JSON ||扩展对象，用于传入本接口所定义字段之外的参数，JSON格式。|
| reflect | 0-1 | String | 字符串，最大64位 | 反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。可以在订单结果通知中返回 |
| tenders | 0-n | [tender] | tender数组 | 预授权/预授权撤销 操作结果信息，定义如下表， |

tenders：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| amount | 1 | String | 数字，最大12位 | 预授权/预授权撤销金额，精确到分 |
| tender\_sn | 0-1 | String | 字符串，最大32位 | 预授权/预授权撤销操作成功后本系统返回的流水号 |
| pay\_time | 0-1 | String | 字符串，20- 25位 | 操作成功时间, 格式详见 [1.5时间数据元素定义](README.md#1_5) |
| pay\_status | 1 | Int | 数字，1位 | 预授权/预授权撤销状态, 1:成功;2:失败; |

商户收到通知后的响应，收钱吧判断通知成功的标志，参考响应通用定义。示例：

{

&quot;response&quot;: {

&quot;head&quot;: {

&quot;version&quot;: &quot;1.0.0&quot;,

&quot;sign\_type&quot;: &quot;SHA1&quot;,

&quot;appid&quot;: &quot;28lp61847655&quot;,

&quot;response\_time&quot;: &quot;2019-08-01T12:00:00+08:00&quot;

},

&quot;body&quot;: {

&quot;result\_code&quot;: &quot;200&quot;,

&quot;biz\_response&quot;: {

&quot;result\_code&quot;: &quot;200&quot;

}

}

},

&quot;signature&quot;: &quot;&quot;

}

### <span id="5_2">5.2. **销售结果通知**</span>

API endpoint: 由商户提供，收钱吧配置

Verb: POST

Signature ：请求参数中包含签名，商家需要对签名进行验签，参考统一签名说明

请求参数：

| **参数** | **出现 ** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| notification\_sn | 1 | String | 字符串，最大32位 | 通知编号 |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供，返回调用方传入的值 |
| store\_sn | 1 | String | 字符串，最大36位 | 商户内部使用的门店编号，返回调用方传入的值 |
| workstation\_sn | 1 | String | 字符串，最大36位 | 门店收银机编号，返回调用方传入的值 |
| check\_sn | 1 | String | 字符串，最大32位 | 商户订单号，返回调用方传入的值 |
| order\_sn | 1 | String | 字符串，最大32位 | 订单序列号 |
| order\_status | 1 | String | 数字，1位 | 订单状态0：已取消，1：待操作，2：操作中，3：等待结果中，4：操作完成，5：部分完成，6：操作失败 |
| scene | 1 | String | 数字，1位 | 场景：1：智能终端，2：H5，4=PC |
| sales\_time | 1 | String | 字符串，20- 25位 | 订单创建时间,格式详见 [1.5时间数据元素定义](README.md#1_5) |
| amount | 1 | String | 数字，最大12位 | 订单价格，精确到分 |
| currency | 1 | String | 字符串，3位 | 币种，ISO numeric currency code 如：&quot;156&quot;for CNY |
| subject | 1 | String | 字符串，最大64位 | 订单简短描述 |
| description | 0-1 | String | 字符串，最大255位 | 订单描述 |
| operator | 1 | String | 字符串，最大32位 | 操作员，可以传入收款的收银员或导购员。例如"张三" |
| customer | 1 | String | 字符串，最大32位 | 客户信息，可以是客户姓名或会员号 |
| extension\_1 | 0-1 | String | 字符串，最大32位 | 拓展字段1，可以用于做自定义标识，如座号，房间号 |
| extension\_2 | 0-1 | String | 字符串，最大32位 | 拓展字段2，可以用于做自定义标识，如座号，房间号 |
| industry\_code | 1 | String | 数字，1位 | 行业代码, 0=零售;1:酒店; 2:餐饮; 3:文娱; 4:教育; |
| pos\_info | 1 | String | 字符串，最大64位 | 商户系统的产品名称、系统编号等信息，便于帮助商户调查问题 |
| notify\_url | 0-1 | String | 字符创，最大255位 | 通知接收地址。总共回调7次，回调时间间隔：4m,10m,10m,1h,2h,6h,15h。 |
| extended | 0-1 | JSON ||扩展对象，用于传入本接口所定义字段之外的参数，JSON格式。|
| reflect | 0-1 | String | 字符串，最大64位 | 反射参数; 任何开发者希望原样返回的信息，可以用于关联商户ERP系统的订单或记录附加订单内容。可以在订单结果通知中返回 |
| items | 0-n | [Item] | item数组 | 订单货物清单，定义如下表 |
| tenders | 0-n | [tender] | tender数组 | 指定订单的各退款方式，定义如下表， |

items：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| item\_code | 1 | String | 字符串，最大32位 | 商户系统中的商品编号 |
| item\_desc | 1 | String | 字符串，最大64位 | 商品描述信息，例&quot;白色短袖&quot; |
| category | 0-1 | String | 字符串，最大32位 | 商品所属大类，例&quot;短袖&quot; |
| unit | 0-1 | String | 字符串，最大32位 | 商品单位，例&quot;件&quot; |
| item\_qty | 1 | String | 数字，最大8位 | 商品数量，例&quot;2&quot; |
| item\_price | 1 | String | 数字，最大12位 | 商品单价，精确到分 |
| sales\_price | 1 | String | 数字，最大12位 | 商品成交价格,一般为数量*单价，如有折扣再进行扣减，精确到分；当退货时成交价为负数；目前不校验"数量*单价"结果是否与此字段值相等 |
| type | 1 | String | 数字，1位 | 0-销售，1-退货 |
| return\_store\_sn | 0-1 | String | 字符串，最大36位 | 原商品销售门店号，退货时必填 |
| return\_workstation\_sn | 0-1 | String | 字符串，最大36位 | 原商品销售收银机号，退货时必填 |
| return\_check\_sn | 0-1 | String | 字符串，最大32位 | 原商品销售订单号，退货时必填 |

tenders：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| original\_transaction\_sn | 0-1 | String | 字符串，最大32位 | 支付/退款指定中商户系统流水号，在商户系统中唯一 |
| original\_tender\_sn | 0-1 | String | 字符串，最大32位 | 退款对应的原购货订单完成后本系统返回的支付流水号 |
| tender\_sn | 1 | String | 数字，最大32位 | 支付/退款成功后，轻POS生成的唯一流水号 |
| amount | 1 | String | 数字，最大12位 | 支付/退款金额，精确到分 |
| collected\_amount | 1 | String | 数字，最大12位 | 商家实收/实退金额，精确到分 |
| paid\_amount | 1 | String | 数字，最大12位 | 消费者实付/实退金额，精确到分 |
| pay\_time | 1 | String | 字符串，20- 25位 | tender支付/退款时间, 格式详见 [1.5时间数据元素定义](README.md#1_5) |
| pay\_status | 1 | String | 数字，1位 | 支付状态, 1:待操作; 2:支付中; 3:支付成功; 4:退款中; 5:退款成功;6:退款失败;7:支付失败;8:未知状态; |
| tender\_type | 1 | String | 数字，1位 | 支付方式类型：0-其他，1-预授权完成，2-银行卡，3-QRCode，4-分期，99-外部 |
| sub\_tender\_type | 0-1 | String | 数字 | 二级支付方式类型：<br />001-现金，如需在轻POS录入其他支付方式，在对接时与收钱吧沟通配置；<br />101-银行卡预授权完成，102-微信预授权完成，103-支付宝预授权完成；<br />201-银行卡；<br />301-微信，302-支付宝；<br />401-银行卡分期，402-花呗分期 |
| sub\_tender\_desc | 0-1 | String | 字符串 | 二级支付方式描述。如：微信支付 |

商户收到通知后的响应，收钱吧判断通知成功的标志，参考响应通用定义。示例：

{

&quot;response&quot;: {

&quot;head&quot;: {

&quot;version&quot;: &quot;1.0.0&quot;,

&quot;sign\_type&quot;: &quot;SHA1&quot;,

&quot;appid&quot;: &quot;28lp61847655&quot;,

&quot;response\_time&quot;: &quot;2019-08-01T12:00:00+08:00&quot;

},

&quot;body&quot;: {

&quot;result\_code&quot;: &quot;200&quot;,

&quot;biz\_response&quot;: {

&quot;result\_code&quot;: &quot;200&quot;

}

}

},

&quot;signature&quot;: &quot;&quot;

}

## <span id="6">6.**查询**</span>

### <span id="6_1">6.1.**授权结果查询**</span>

API endpoint: {api\_domain}/api/lite-pos/v1/authorization/query

Verb: POST

Signature ：需要签名，参考统一签名说明

请求参数：

| **参数** | **出现 ** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供 |
| store\_sn | 1 | String | 字符串，最大36位 | 商户内部使用的门店编号 |
| workstation\_sn | 1 | String | 字符串，最大36位 | 门店收银机编号，如果没有请传入&quot;0&quot; |
| check\_sn | 1 | String | 字符串，最大32位 | 商户订单号，在商户系统中唯一 |
| order\_sn | 0-1 | String | 字符串，最大32位 | 预授权订单下发时收钱吧返回的订单号（可选，优先使用order\_sn作查询） |

返回参数：

| **参数** | **出现 ** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供 |
| store\_sn | 1 | String | 字符串，最大36位 | 商户内部使用的门店编号，返回调用方传入的值 |
| workstation\_sn | 1 | String | 字符串，最大36位 | 门店收银机编号，返回调用方传入的值 |
| check\_sn | 1 | String | 字符串，最大32位 | 商户订单号，返回调用方传入的值 |
| order\_sn | 1 | String | 字符串，最大32位 | 订单序列号 |
| order\_status | 1 | String | 数字，1位 | 订单状态0：已取消，1：待操作，3：等待结果中，4：操作完成 |
| sales\_time | 1 | String | 字符串，20- 25位 | 订单创建时间, 格式详见 [1.5时间数据元素定义](README.md#1_5) |
| amount | 1 | String | 数字，最大12位 | 订单价格，精确到分 |
|  | 0-1 | String | 数字，1位 |是否指定预授权渠道，0，不指定，1，指定，默认为0|
| auth\_channel | 1 | String | 数字，1位 | 预授权渠道，1:银行卡，2：微信，3：支付宝 |
| currency | 1 | String | 字符串，3位 | 币种，ISO numeric currency code 如：&quot;156&quot;for CNY |
| subject | 1 | String | 字符串，最大64位 | 订单简短描述 |
| description | 0-1 | String | 字符串，最大255位 | 订单描述 |
| operator | 1 | String | 字符串，最大32位 | 操作员，可以传入收款的收银员或导购员。例如"张三" |
| customer | 1 | String | 字符串，最大32位 | 客户信息，可以是客户姓名或会员号 |
| extension\_1 | 0-1 | String | 字符串，最大32位 | 拓展字段1，可以用于做自定义标识，如座号，房间号 |
| extension\_2 | 0-1 | String | 字符串，最大32位 | 拓展字段2，可以用于做自定义标识，如座号，房间号 |
| industry\_code | 1 | String | 数字，1位 | 行业代码, 0=零售;1:酒店; 2:餐饮; 3:文娱; 4:教育; |
| pos\_info | 1 | String | 字符串，最大64位 | 传入商户系统的产品名称、系统编号等信息，便于帮助商户调查问题 |
| notify\_url | 0-1 | String | 字符创，最大255位 | 通知接收地址。总共回调7次，回调时间间隔：4m,10m,10m,1h,2h,6h,15h |
| extended | 0-1 | JSON ||扩展对象，用于传入本接口所定义字段之外的参数，JSON格式|
| tenders | 0-n | [tender] | tender数组 | 指定订单的各退款方式，定义如下表， |

tenders：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| amount | 1 | String | 数字，最大12位 | 预授权/预授权撤销金额，精确到分 |
| tender\_sn | 0-1 | String | 字符串，最大32位 | 预授权/预授权撤销操作成功后本系统返回的流水号 |
| pay\_time | 0-1 | String | 字符串，20- 25位 | 操作成功时间, 格式详见 [1.5时间数据元素定义](README.md#1_5) |
| pay\_status | 1 | Int | 数字，1位 | 预授权/预授权撤销状态, 1:成功;2:失败; |

### <span id="6_2">6.2**销售结果查询**</span>

API endpoint: {api\_domain}/api/lite-pos/v1/sales/query

Verb: POST

Signature ：需要签名，参考统一签名说明

请求参数：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供 |
| store\_sn | 1 | String | 字符串，最大36位 | 商户内部使用的门店编号 |
| workstation\_sn | 1 | String | 字符串，最大36位 | 门店收银机编号，如果没有请传入&quot;0&quot; |
| check\_sn | 1 | String | 字符串，最大32位 | 商户订单号，在商户系统中唯一 |
| order\_sn | 0-1 | String | 字符串，最大32位 | 销售类订单下发时收钱吧返回的订单号（可选，优先使用order\_sn作查询） |

返回参数：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| brand\_code | 1 | String | 数字，最大32位 | 品牌编号，系统对接前由"收钱吧"分配并提供，返回调用方传入的值 |
| store\_sn | 1 | String | 字符串，最大36位 | 商户内部使用的门店编号，返回调用方传入的值 |
| workstation\_sn | 1 | String | 字符串，最大36位 | 门店收银机编号，返回调用方传入的值 |
| check\_sn | 1 | String | 字符串，最大32位 | 商户订单号，返回调用方传入的值 |
| order\_sn | 1 | String | 字符串，最大32位 | 订单序列号 |
| scene | 1 | String | 数字，1位 | 场景值：1-智能终端，2-H5，4-PC |
| order\_status | 1 | String | 数字，1位 | 订单状态0：已取消，1：待操作，2：操作中，3：等待结果中，4：操作完成，5：部分完成，6：操作失败 |
| sales\_time | 1 | String | 字符串，20- 25位 | 订单创建时间, 格式详见 [1.5时间数据元素定义](README.md#1_5) |
| amount | 1 | String | 数字，最大12位 | 订单价格，精确到分 |
| currency | 1 | String | 字符串，3位 | 币种，ISO numeric currency code 如：&quot;156&quot;for CNY |
| subject | 1 | String | 字符串，最大64位 | 订单简短描述 |
| description | 0-1 | String | 字符串，最大255位 | 订单描述 |
| operator | 1 | String | 字符串，最大32位 | 操作员，可以传入收款的收银员或导购员。例如"张三&quot; |
| customer | 1 | String | 字符串，最大32位 | 客户信息，可以是客户姓名或会员号 |
| extension\_1 | 0-1 | String | 字符串，最大32位 | 拓展字段1，可以用于做自定义标识，如座号，房间号 |
| extension\_2 | 0-1 | String | 字符串，最大32位 | 拓展字段2，可以用于做自定义标识，如座号，房间号 |
| industry\_code | 1 | String | 数字，1位 | 行业代码, 0=零售;1:酒店; 2:餐饮; 3:文娱; 4:教育; |
| pos\_info | 1 | String | 字符串，最大64位 | 传入商户系统的产品名称、系统编号等信息，便于帮助商户调查问题 |
| notify\_url | 0-1 | String | 字符创，最大255位 | 通知接收地址。总共回调7次，回调时间间隔：4m,10m,10m,1h,2h,6h,15h |
| extended | 0-1 | JSON ||扩展对象，用于传入本接口所定义字段之外的参数，JSON格式|
| items | 0-n | [Item] | item数组 | 订单货物清单，定义如下表 |
| tenders | 0-n | [tender] | tender数组 | 指定订单的各退款方式，定义如下表， |

items：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| item\_code | 1 | String | 字符串，最大32位 | 商户系统中的商品编号 |
| item\_desc | 1 | String | 字符串，最大64位 | 商品描述信息，例&quot;白色短袖&quot; |
| category | 0-1 | String | 字符串，最大32位 | 商品所属大类，例&quot;短袖&quot; |
| unit | 0-1 | String | 字符串，最大32位 | 商品单位，例&quot;件&quot; |
| item\_qty | 1 | String | 数字，最大8位 | 商品数量，例&quot;2&quot; |
| item\_price | 1 | String | 数字，最大12位 | 商品单价，精确到分 |
| sales\_price | 1 | String | 数字，最大12位 | 商品成交价格,一般为数量*单价，如有折扣再进行扣减，精确到分；当退货时成交价为负数；目前不校验"数量*单价"结果是否与此字段值相等 |
| type | 1 | String | 数字，1位 | 0-销售，1-退货 |
| return\_store\_sn | 0-1 | String | 字符串，最大36位 | 原商品销售门店号，退货时必填 |
| return\_workstation\_sn | 0-1 | String | 字符串，最大36位 | 原商品销售收银机号，退货时必填 |
| return\_check\_sn | 0-1 | String | 字符串，最大32位 | 原商品销售订单号，退货时必填 |

tenders：

| **参数** | **出现** | **类型** | **约束** | **描述** |
| --- | --- | --- | --- | --- |
| original\_transaction\_sn | 0-1 | String | 字符串，最大32位 | 支付/退款指定中商户系统流水号，在商户系统中唯一 |
| original\_tender\_sn | 0-1 | String | 字符串，最大32位 | 退款对应的原购货订单完成后本系统返回的支付流水号 |
| tender\_sn | 1 | String | 数字，最大32位 | 支付/退款成功后，轻POS生成的唯一流水号 |
| amount | 1 | String | 数字，最大12位 | 支付/退款金额，精确到分 |
| collected\_amount | 1 | String | 数字，最大12位 | 商家实收/实退金额，精确到分 |
| paid\_amount | 1 | String | 数字，最大12位 | 消费者实付/实退金额，精确到分 |
| pay\_time | 0-1 | String | 字符串，20- 25位 | tender支付/退款时间, 格式详见 [1.5时间数据元素定义](README.md#1_5) |
| pay\_status | 1 | String | 数字，1位 | 支付状态, 1:待操作; 2:支付中; 3:支付成功; 4:退款中; 5:退款成功;6:退款失败;7:支付失败;8:未知状态; |
| tender\_type | 1 | String | 数字，1位 | 支付方式类型：0-其他，1-预授权完成，2-银行卡，3-QRCode，4-分期，99-外部 |
| sub\_tender\_type | 0-1 | String | 数字 | 二级支付方式类型：<br />001-现金，如需在轻POS录入其他支付方式，在对接时与收钱吧沟通配置；<br />101-银行卡预授权完成，102-微信预授权完成，103-支付宝预授权完成；<br />201-银行卡；<br />301-微信，302-支付宝；<br />401-银行卡分期，402-花呗分期 |
| sub\_tender\_desc | 0-1 | String | 字符串 | 二级支付方式描述。如：微信支付 |