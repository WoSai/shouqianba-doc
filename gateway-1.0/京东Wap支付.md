#京东 WAP 支付接口


###1 下单

**url**

    API_DOMAIN/JdGateway/wap
    
**METHOD**

POST


**参数**

   参数名 | 参数解释 | 是否必须
------------ | ------------- | ------------
 wosai_store_id | 喔噻商户ID  |  Y
wosai_appid | 喔噻分配的appid  | Y
channel_id|代理商ID| Y
sign|签名字符串|Y
total_fee_cent|金额，单位分|Y
flag|交易来源标记，APP/SDK/POS/QRCODE|N
subject|商品描述，UTF-8编码，128汉字|Y
operator|操作员| N
store_owner_order_id| 商户自己系统中的唯一订单号| N
detail | 商品名称明细列表 | N
notify_url|接受服务器异步通知的地址|N
customer_store_id|商户门店ID|N
terminal_id|终端Id|N


**返回结果**

```
{
  "data": {
    "id": "f665f0d7-a209-249a-6867-f4f0740b1693",
    "order_sn": "0000259247304920",
    "operator": "商户操作员",
    "wosai_store_id": "9990530011001100100012202",
    "status": 0,
    "ctime": "2015-12-23 11:39:29",
    "last_modified": "2015-12-23 11:39:29",
    "order_pay_detail": "",
    "order_refund_detail": "",
    "order_detail": "0000259247304920",
    "remark": "",
    "pay_way": "JD",
    "sub_pay_way": "WAPPAY",
    "total_fee": "0.01",
    "origin_fee": "0.01",
    "store_owner_order_sn": "0000259247304920",
    "notify_url": "",
    "is_liquidation_next_day": "1",
    "product_remark": "",
    "order_pay_time": "2015-12-23 11:39:29",
    "flag": "QRCODE",
    "position": "",
    "trade_fee_rate": "0.60",
    "version": "1",
    "deleted": "0",
    "subject": "默认商品",
    "terminal_id": "123",
    "device_info": null,
    "customer_store_id": "",
    "trade_no": "",
    "pay_account": null,
    "pay_id": null,
    "buyer_pay_amount": "0",
    "receipt_amount": "0",
    "invoice_amount": "0",
    "mdiscount_amount": "0",
    "weixin_sub_mch_id": null,
    "operatorCopy": "",
    "discountAmount": "0",
    "getDiscount": "0"
  },
  "code": "10000",
  "msg": "succ"
}
```

###2. 退款
  
 **url**
  
    API_DOMAIN/JdGateway/refund
    
**METHOD**

	POST
 
 **参数**
 
   参数名 | 参数解释 | 是否必须
------------ | ------------- | ------------
 wosai_store_id | 喔噻商户ID  |  Y
wosai_appid | 喔噻分配的appid  | Y
channel_id|代理商ID| Y
 sign|签名字符串|Y
order_sn | 收钱吧生成的订单号  | Y
refund_fee_cent|退款金额，以分为单位，不得大于总金额|Y


###3. 微信支付-订单查询

**url**

    api_domain/Upay/queryOrder

    
**METHOD**

	GET   

**参数**

   参数名 | 参数解释 | 是否必须
------------ | ------------- | ------------
 wosai_store_id | 喔噻商户ID  |  Y
wosai_app_id | 喔噻分配的appid  | Y
channel_id|代理商ID| Y
 sign|签名字符串|Y
wosai_order_sn | 收钱吧生成的订单号  | Y

**返回值**

```
{
  "data": {
    "id": "f665f0d7-a209-249a-6867-f4f0740b1693",
    "order_sn": "0000259247304920",
    "operator": "商户操作员",
    "wosai_store_id": "9990530011001100100012202",
    "status": "0",
    "ctime": "2015-12-23 11:39:29",
    "last_modified": "2015-12-23 11:39:29",
    "order_pay_detail": "",
    "order_refund_detail": "",
    "order_detail": "0000259247304920",
    "remark": "",
    "pay_way": "JD",
    "sub_pay_way": "WAPPAY",
    "total_fee": 1,
    "origin_fee": 1,
    "store_owner_order_sn": "0000259247304920",
    "notify_url": "",
    "is_liquidation_next_day": "1",
    "product_remark": "",
    "flag": "QRCODE",
    "position": "",
    "trade_fee_rate": "0.60",
    "version": "1",
    "deleted": "0",
    "subject": "默认商品",
    "terminal_id": "123",
    "device_info": "",
    "customer_store_id": "",
    "trade_no": "",
    "pay_account": "",
    "pay_id": "",
    "buyer_pay_amount": "0",
    "receipt_amount": "0",
    "invoice_amount": "0",
    "mdiscount_amount": "0",
    "weixin_sub_mch_id": "",
    "operatorCopy": "",
    "discountAmount": "0",
    "getDiscount": "0"
  },
  "code": "10000",
  "msg": "succ"
}
```

