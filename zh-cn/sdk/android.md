#Android SDK开发接入

##1.SDK简介

###1.1 前言
  收钱吧 Android SDK集成了各种支付方式,第三方通过调用本 SDK,可以轻松将支付宝,微 信,百度钱包,京东钱包支付等多种支付方式集成到自己的应用。


###1.2 主要功能

* 激活:  新的终端使用 SDK,需要先激活终端,才可以进行交易 
* 付款:  支持支付宝、微信、百度钱包、京东钱包支付 
* 退款:  对已经支付成功的订单进行退款操作 
* 查询:  对已经支付的订单查询
* 撤单:  直接取消某一笔交易 
* 预下单: 支持支付宝、微信、百度钱包、京东钱包支付


###1.3 框架设计

第三方用户通过集成收钱吧 SDK,面对前方商户提供多种可选的支付方式,同时喔噻可以将交易 路由至支付宝,微信等服务器。

###1.4 工作模式
####1.4.1、SDK 标准界面模式
SDK 默认的工作模式,激活、付款、退款、撤单、预下单集成了 UI 界面,不需要特别配置。 

####1.4.2、SDK 无界面标准模式

SDK 无界面的工作模式,在调用接口时,需要在 UpayOrder 订单参数中指定调用模式为
*<font color="red">setPayModel(UpayOrder.PayModel.NO_UI)。</font>*

##2.开发指南
[下载最新版的SDK](http://shouqianba-sdk.oss-cn-hangzhou.aliyuncs.com/SQB-Android-SDK.zip)。为保证您的财产和数据安全，请勿使用从其他非收钱吧渠道获取的SDK。对由于使用了非官方SDK而导致的任何物质或非物质损失，收钱吧概不负责。

##3.集成步骤
###3.1 Eclipse下集成SDK
####3.1.1 解压 SDK,得到以下文件夹;
![GitHub set up](http://ww2.sinaimg.cn/large/61df8f13gw1f12bio2xqpj20dz02at8o.jpg)
####3.1.2 打开 eclipse 文件夹,将文件夹下面的 libs,与 res 文件夹 copy 到集成的项目中
![GitHub set up](http://ww2.sinaimg.cn/large/61df8f13gw1f12bj4t1onj20dl01owed.jpg)
####3.1.3 在 AndroidManifest.xml 中声明以下权限;

``` java

<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" /> 
<uses-permission android:name="android.permission.BLUETOOTH" /> 
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />  
<uses-permission android:name="android.permission.READ_PHONE_STATE" /> 
<uses-permission android:name="android.permission.INTERNET" /> 

<!--允许程序读取或写入系统设置 -->
<uses-permission android:name="android.permission.WRITE_SETTINGS" />
<!-- GPS 定位权限 -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" /> 
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" /> 
<uses-permission android:name="android.permission.ACCESS_WIFI_STATE" /> 
<uses-permission android:name="android.permission.CHANGE_WIFI_STATE" />

<!-- SD 卡读取权限,用户写入离线定位数据-->
<uses-permission android:name="android.permission.MOUNT_UNMOUNT_FILESYSTEMS"/> 
<uses-permission android:name="android.permission.WAKE_LOCK" /> 
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.FLASHLIGHT" /> 
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" /> 
<uses-permission android:name="android.permission.REORDER_TASKS" /> 
<uses-permission android:name="android.permission.VIBRATE" />

```
####3.1.4、在 AndroidManifest.xml 中声明以下 SDK 用到的 activity、service、receiver;

```java
<activity
	android:name="com.wosai.upay.ui.MainActivity" 
	android:theme="@style/AppBaseTheme"
	android:configChanges="keyboardHidden|orientation|screenSize" 
	android:windowSoftInputMode="stateHidden|adjustResize">
</activity>
<activity
	android:name="com.wosai.upay.zbar.activity.CaptureActivity"
	android:theme="@style/AppBaseTheme"
	android:windowSoftInputMode="adjustPan">
</activity>
<receiver
	android:name="com.wosai.upay.common.UpayTask$MyBroadcastReceiver"
 	android:exported="false">
	<intent-filter>
		<action android:name="com.wosai.upay" /> 
	</intent-filter>
</receiver>
<meta-data
	android:name="com.baidu.lbsapi.API_KEY"
	android:value="jb5QfTeGACZiPIUBx9ZwIC82" />
<service android:name="com.baidu.location.f" 
	android:enabled="true" android:process=":remote">
</service>
```
####3.1.5、初始化 SDK,在程序入口处初始化 SDK,如果初始化提示 AndroidManifest.xml 文件配置 有误,请检查配置文件;

```java

/**
* initUpay 初始化 UpayTask
* @param context 上下文对象
* @param isPlaySound 是否打开交易完成时,成功和失败的提示声音 
* @param urlType 服务器地址类型:DEV:开发环境,PRO:生产环境 
*/
DebugConfig.setDebug(true);//默认为非调试模式,如果需要调试,请设置为 true,打印和保存相关日志
UpayTask.getInstance().initUpay(context,isPlaySound,Env.UrlType.PRO);
```

###3.2 Android Studio下集成SDK
####3.2.1、解压 SDK,得到以下文件夹:
![GitHub set up](http://ww4.sinaimg.cn/large/61df8f13gw1f12c1s130yj20e4028mx4.jpg)
####3.2.2、打开 studio 文件夹,拷贝 SQB-Android-SDK-x.x.x.aar 结尾的压缩包到项目的 libs 下:
![GitHub set up](http://ww2.sinaimg.cn/large/61df8f13gw1f12c2odywdj20bs02laa0.jpg)
####3.2.3、在 build.gradle 文件中添加以下代码;

```java
repositories { 
	flatDir {
		dirs 'libs' 
	}
}
dependencies {
	compile(name: 'SQB-Android-SDK-2.1.0', ext: 'aar'))//name 后面紧跟的为引入的 aar 包名 
}
```
####3.2.4、初始化 SDK,在程序入口处初始化 SDK,如果初始化提示 AndroidManifest.xml 文件配置 有误,请检查配置文件;

```java
/**
* initUpay 初始化 UpayTask
* @param context 上下文对象
* @param isPlaySound 是否打开交易完成时,成功和失败的提示声音 
* @param urlType 服务器地址类型:DEV:开发环境,PRO:生产环境 
*/
DebugConfig.setDebug(true);//默认为非调试模式,如果需要调试,请设置为 true,打印和保存相关日志
UpayTask.getInstance().initUpay(context,isPlaySound,Env.UrlType.PRO);
```

####3.2.5、SDK 成功集成到项目

##4.重要参数说明

###4.1 UpayTask类

####4.1.1、UpayTask 对象获取
```java
UpayTask.getInstance()
```
####4.1.2 UpayTask方法说明
**激活**

```java
/**
* activate 激活
* @param code 激活码内容
* @param vendor_id 服务商 ID
* @param vendor_key 服务商 KEY 
* @param appId 服务商应用ID
* @param deviceSn 设备号
* @param deviceName 设备名称
* @param payModel 支付模式
* @param callBack 请求回调
*/
public void activate(String code, String vendor_id, String vendor_key,String appId,String deviceSn,String deviceName, UpayOrder.PayModel payModel, UpayCallBack callBack)

```
**检查终端是否激活**
```java
/**
 * 终端是否已经激活
 * @return true:终端已激活，false：终端未激活
 */
 public boolean isActivated()

```
**付款**

```java
/**
* pay 付款
* @param order 业务订单类 
* @param callBack 请求回调 
*/
public void pay(UpayOrder order, UpayCallBack callBack)
 
```
**退款**

```java
/**
* refund 退款
* @param order 业务订单类 
* @param callBack 请求回调 
*/
public void refund(UpayOrder order, UpayCallBack callBack)
```
**查询**

```java
/**
* query 查询
* @param order 业务订单类 
* @param callBack 请求回调 
*/
public void query(UpayOrder order, UpayCallBack callBack)
```
**撤单**

```java
/**
* revoke 撤单(退货)
* @param order 业务订单类 
* @param callBack 请求回调 
*/
public void revoke(UpayOrder order, UpayCallBack callBack)
```
**预下单**

```java
/**
* preCreate 预下单
* @param order 业务订单类 
* @param callBack 请求回调 
*/
public void preCreate(UpayOrder order, UpayCallBack callBack)
```

###4.2 UpayOrder类说明

属性 |属性名称 |类型 |描述 |付款 |退款 |预下单 |查询 |撤单  
--------- | ----| ----| ----| ----| ----| ----| ----| ----
sn | 收钱吧系统订单号| String| 收钱吧系统内部唯一订单号| ——| **无UI**(sn和client_sn<font color="red">不能同时为空</font>)<br>**有UI**(sn 和 client_sn 非必传)| ——| sn和client_sn不能同时为空|**无UI**(sn和client_sn<font color="red">不能同时为空</font>)<br>**有UI**(sn和client_sn非必传)
client_sn|商户系统订单号|String|必须在商户系统内唯一;且长度不超过32字节|必传|同上|必传|同上|同上
total_amount|交易总金额|Stirng|以分为单位,不超过10位纯数字字符串,超过1亿元的收款请 使用银行转账|必传|——|必传|——|——
payway|支付方式|String|纯数字字符串, 一旦设置,则根据支付码判断支付通道的逻辑失效。|非必传|——|必传|——|——
dynamic_id|付款码内容|String|不超过32字节|无UI必传|——|——|——|——
subject|交易简介|String|本次交易的简要介绍|必传|——|必传|——|——
operator|门店操作员|String|发起本次交易的操作员|必传|必传|必传|——|——
description|商品详情|String|对商品或本次交易的描述|非必传|——|非必传|——|——
extended|扩展那参数集合|String|收钱吧与特定第三方单独约定的参数集合, **json** 格式,最多支持24个字段,每个字段key长度不超过64字节,value长度不超过256字节|非必传|——|非必传|——|——
reflect|反射参数|String|任何调用者希望原样返回的信息|非必传|非必传|非必传|－－|非必传
refund_request_no|退款序列号|String|商户退款所需序列号，防止重复退款|——|必传|——|——|——
refund_amount|退款金额|String|退款金额|——|无UI必传|——|——|——
payModel|支付模式|PayModel(enum)|默认有界面模式|非必传|——|非必传|——|——
refundModel|退款模式|RefundModel(enum)|有界面退款模式，通过商户订单号或者收钱吧订单号|——|有UI必传|——|——|——
revokeModel|退款模式|RefundModel(enum)|有节目模式，通过商户订单号或者收钱吧订单号|——|——|——|——|有UI必传



###4.3 UpayResult类说明
属性|属性名称|描述
----|----|----
sn|收钱吧订单号|收钱吧系统内部唯一订单号
client_sn|商户订单号|商户系统订单号
trade_no|支付服务商订单号|支付通道交易凭证号
status|流水状态|本次操作产生的流水的状态
order_status|订单状态|当前订单状态
payway|支付方式|一级支付方式(支付宝、微信、百付宝、京东)
sub_payway|二级支付方式|二级支付方式(条码支付、二维码支付)
payer_uid|付款人ID|支付平台(微信,支付宝)上的付款人 ID
payer_login|付款人账号|支付平台上(微信,支付宝)的付款人账号
total_amount|交易总额|本次交易总金额
net_amount|实收金额|如果没有退款,这个字段等于 total_amount。否则等于 total_amount 减去退款金额
subject|交易概述|本次交易概述
finish_time|付款动作在收钱吧的完成时间|时间戳
channel_finish_time|付款动作在支付服务商的完成时间|时间戳
operator|操作员|门店操作员
description|商品详情|对商品或本次交易的描述
reflect|反射参数|透传参数
qr_code|二维码内容|预下单成功后生成的二维码
result_code|业务执行响应码
error_code|业务执行结果返回码
error_message|业务执行错误信息


**payway支付方式列表**

取值|含义
---|---
1|支付宝
3|微信
4|百付宝
5|京东
6|qq钱包

`未来会不断补充`

###4.4 UpayResult中result_code 状态码说明
取值|含义|下一步动作
---|---|---
200|通讯成功|
400|客户端错误|
500|服务端错误|
ACTIVATE_SUCCESS|激活操作成功|
PAY_SUCCESS|支付操作成功|
PAY_FAIL|支付操作失败并且已冲正|重新进行一笔交易
PAY_FAI_ERROR|支付失败并且不确定第三方支付通道状态|联系客服 400-668-5353
CANCEL_SUCCESS|撤单操作成功|
CANCEL_ERROR|撤单操作失败并且不确定第三方支付通道状态|联系客服400-668-5353
CANCEL_ABORT_ERROR|撤单操作师徒终止进行中的支付流程，但是失败，不确定第三方支付通道的状态|联系客服400-668-5353
CANCEL_ABORT_SUCCESS|撤单操作师徒终止进行中的支付流程并且成功|
REFUND_SUCCESS|退款操作成功|
REFUND_ERROR|退款操作失败并且不确定第三方支付通道状态|联系客服400-668-5353
PRECREATE_SUCCESS|预下单操作成功|
PRECREATE_FAIL|预下单操作失败|
SUCCESS|操作成功|
FAIL|操作失败（不会触发流程）|

**备注**

* 如果 **激活** 接口 result_code返回的不是 <font color="red">ACTIVATE_SUCCESS</font>，则认为激活失败
* 如果 **付款** 接口 result_code返回的不是 <font color="red">PAY_SUCCESS</font>，则认为付款失败
* 如果 **退款** 接口 result_code返回的不是 <font color="red">REFUND_SUCCESS</font>，则认为退款失败
* 如果 **撤单** 接口 result_code返回的不是 <font color="red">CANCEL_SUCCESS</font> 或者 <font color="red">CANCEL_ABORT_SUCCESS</font> 则认为撤单失败
* 如果 **预下单** 接口 result_code返回的不是 <font color="red">PRECREATE_SUCCESS</font>，则认为预下单失败
* 如果 **查询** 接口 result_code返回的不是 <font color="red">SUCCESS</font>，则认为查询失败
* 如果 **result_code** 返回值为  <font color="red">null </font> 或者<font color="red"> 0</font>，通过 error_code 和 error_message 信息处理。
* 如果 **result_code** 返回的是失败响应码,可先通过 error_code 和 error_message 信息处理,如果不存在 error_code 和 error_message,再根据 result_code 的含义及下一步处理。
 
##5.SDK有界面模式调用示例
###5.1 激活

```java
String vendorId = "10298371039";//服务商 ID
String vendorKey = "68d499beda5f72116592f5c527465656";//服务商 KEY
String appId="12313123223";  //服务商应用ID
String deviceSn="213213343323"; //商户设备号，在商户下要唯一，非必传
String deviceName="设备名"; //商户设备名，非必传
UpayTask.getInstance().activate("", vendorId, vendorKey, appId, deviceSn, deviceName
UpayOrder.PayModel.UI, new UpayCallBack() { 
	@Override
	public void onExecuteResult(UpayResult result) {
		//回调结果,请参考 UpayResult 类说明,根据回调结果添加自己的业务逻辑的处理
	} 
});
```

###5.2 支付

```java
UpayOrder order = new UpayOrder(); 
order.setClient_sn("client1241241");//商户订单号 
order.setTotal_amount("100");//交易总金额 order.setPayway("1");//支付方式 
order.setSubject("Android SDK");//交易简介 
order.setOperator("操作员 007");//门店操作员 
order.setDescription("餐饮");//商品详情 
order.setReflect("测试反射参数");//反射参数 

UpayTask.getInstance().pay(order, new UpayCallBack() {
	@Override
	public void onExecuteResult(UpayResult result) {
		//回调结果,请参考 UpayResult 类说明,根据回调结果添加自己的业务逻辑的处理
	} 
});
```


###5.3 退款

```java
UpayOrder order = new UpayOrder();
order.setSn("7894259244086017");//收钱吧订单号
order.setClient_sn("client1241241");//商户订单号 
order.setRefund_request_no("23524241");//退款序列号
order.setOperator("操作员 007");//操作员
order.setRefund_amount("100");//退款金额
order.setReflect("测试反射参数");//反射参数
order.setRefundModel(UpayOrder.RefundModel.CLIENT_SN);//指定退款模式为商户订单号退款 

UpayTask.getInstance().refund(order, new UpayCallBack() {
	@Override
	public void onExecuteResult(UpayResult result) {
		//回调结果,请参考 UpayResult 类说明,根据回调结果添加自己的业务逻辑的处理
	} 
});
```

###5.4 撤单

```java
UpayOrder order = new UpayOrder(); 
order.setSn("7894259244086017");//收钱吧订单号 
order.setClient_sn("client1241241");//商户订单号 
order.setReflect("测试反射参数");//反射参数
order.setRevokeModel(UpayOrder.RevokeModel.CLIENT_SN);//指定退款模式为商户订单号退款

UpayTask.getInstance().revoke(order, new UpayCallBack() { 
	@Override
	public void onExecuteResult(UpayResult result) {
		//回调结果,请参考 UpayResult 类说明,根据回调结果添加自己的业务逻辑的处理
	} 
});
```
###5.5 预下单

```java
UpayOrder order = new UpayOrder();
order.setClient_sn("client1241241");//商户订单号 
order.setTotal_amount("100");//交易总金额 
order.setPayway("1");//支付方式
order.setSubject("Android SDK");//交易简介
order.setOperator("操作员 007");//门店操作员
order.setDescription("餐饮");//商品详情
order.setReflect("测试反射参数");//反射参数 

UpayTask.getInstance().preCreate(order, new UpayCallBack() {
	@Override
	public void onExecuteResult(UpayResult result) {
	//回调结果,请参考 UpayResult 类说明,根据回调结果添加自己的业务逻辑的处理
	} 
});
```

##6.SDK无界面模式调用示例
###6.1 激活

```java
String code = "131451574136";//激活码
String vendorId = "10298371039";//服务商 ID
String vendorKey = "68d499beda5f72116592f5c527465656";//服务商 KEY
String appId="12313123223";  //服务商应用ID
String deviceSn="213213343323"; //商户设备号，在商户下要唯一，非必传
String deviceName="设备名"; //商户设备名，非必传

UpayTask.getInstance().activate(code, vendorId, vendorKey,appId,deviceSn, deviceName
UpayOrder.PayModel.NO_UI, new UpayCallBack() { 
	@Override
	public void onExecuteResult(UpayResult result) {
	//回调结果,请参考 UpayResult 类说明,根据回调结果添加自己的业务逻辑的处理
	} 
});
```

###6.2 支付

```java
UpayOrder order = new UpayOrder();
order.setClient_sn("client1241241");//商户订单号 
order.setTotal_amount("100");//交易总金额 order.setPayway("1");//支付方式 
order.setDynamic_id("285362899388441557");//付款码内容 
order.setSubject("Android SDK");//交易简介 
order.setOperator("操作员 007");//门店操作员 
order.setDescription("餐饮");//商品详情 
order.setReflect("测试反射参数");//反射参数
order.setPayModel(UpayOrder.PayModel.NO_UI );//指定 SDK 启动模式为无界面模式
     
UpayTask.getInstance().pay(order, new UpayCallBack() { 
	@Override
	public void onExecuteResult(UpayResult result) {
		//回调结果,请参考 UpayResult 类说明,根据回调结果添加自己的业务逻辑的处理
	} 
});
```
###6.3 退款

```java
UpayOrder order = new UpayOrder(); 
order.setSn("7894259244086017");//收钱吧订单号 
order.setClient_sn("client1241241");//商户订单号 
order.setRefund_request_no("23524241");//退款序列号 
order.setOperator("操作员 007");//操作员 
order.setRefund_amount("100");//退款金额 
order.setReflect("测试反射参数");//反射参数 
order.setPayModel(UpayOrder.PayModel.NO_UI);//指定 SDK 启动模式为无界面模式 

UpayTask.getInstance().refund(order, new UpayCallBack() {
	@Override
	public void onExecuteResult(UpayResult result) {
	//回调结果,请参考 UpayResult 类说明,根据回调结果添加自己的业务逻辑的处理
	}
});
```
###6.4 查询

```java
UpayOrder order = new UpayOrder(); 
order.setSn("7894259244086017");//收钱吧订单号 
order.setClient_sn("client1241241");//商户订单号 

UpayTask.getInstance().query(order, new UpayCallBack() {
	@Override
	public void onExecuteResult(UpayResult result) {
	//回调结果,请参考 UpayResult 类说明,根据回调结果添加自己的业务逻辑的处理
	} 
});
```
###6.5 撤单

```java
UpayOrder order = new UpayOrder(); 
order.setSn("7894259244086017");//收钱吧订单号 
order.setClient_sn("client1241241");//商户订单号 
order.setReflect("测试反射参数");//反射参数 
order.setPayModel(UpayOrder.PayModel.NO_UI);//指定 SDK 启动模式为无界面模式 

UpayTask.getInstance().revoke(order, new UpayCallBack() {
	@Override
	public void onExecuteResult(UpayResult result) {
		//回调结果,请参考 UpayResult 类说明,根据回调结果添加自己的业务逻辑的处理
	}
});
```
###6.6 预下单

```java
    
UpayOrder order = new UpayOrder(); 
order.setClient_sn("client1241241");//商户订单号 
order.setTotal_amount("100");//交易总金额
order.setPayway("1");//支付方式
order.setSubject("Android SDK");//交易简介
order.setOperator("操作员 007");//门店操作员 
order.setDescription("餐饮");//商品详情 
order.setReflect("测试反射参数");//反射参数 
order.setPayModel(UpayOrder.PayModel.NO_UI);//指定 SDK 启动模式为无界面模式 

UpayTask.getInstance().preCreate(order, new UpayCallBack() {
	@Override
	public void onExecuteResult(UpayResult result) {
		//回调结果,请参考 UpayResult 类说明,根据回调结果添加自己的业务逻辑的处理
	} 
});
```
##7.联系我们
如以上信息无法帮助你解决在开发中遇到的问题,请通过一下方式联系我们 邮箱:sdk@wosai-inc.com
我们的工程师会在第一时间回复您。


