# iOS SDK开发接入

*当前文档版本：0.1.3*

# 目录

2. [开发接入指南](#deploy)
3. [开发者文档](#documentation)
4. [开发指引及示例](#tutorial)
5. [附录](#Appendix)
6. [常见问题](#FAQs)
7. [联系我们](#Contact)
8. [版本记录](#ChangeLog)

## 1. <a name="deploy"></a> 开发接入指南

该部分文档主要介绍如何在您的开发项目中引入SDK，首次接入SDK的开发人员可以通过该章节快速掌握SDK的部署流程。

### 1.1 获取最新版SDK

[下载最新版的SDK](http://shouqianba-sdk.oss-cn-hangzhou.aliyuncs.com/upay_sdk_ios_3.0.0.zip)。为保证您的财产和数据安全，请勿使用从其他非收钱吧渠道获取的SDK。对由于使用了非官方SDK而导致的任何物质或非物质损失，收钱吧概不负责。

### 1.2 集成SDK

#### 1.2.1 iOS支持

目前iOS SDK支持的iOS版本为 **iOS 7.0+** 。

#### 1.2.2 向项目中添加SDK

只需解压您下载的SDK文件，其中应包含WSUpayKit.framework和WSUpayKit.bundle两个文件。WSUpayKit.framework中包含了SDK的全部代码，WSUpayKit.bundle中包含了SDK所用到的所有视图、多语言支持和多媒体等资源。请将这两个文件拖拽至您的iOS开发项目中，并确保`Copy items if needed`和您的目标是被勾选的，如下图所示。

![](http://images.wosaimg.com/53/c80f7d9e65afe2aecd1f742ab8868d15e79bea.png "向项目中添加SDK")

#### 1.2.3 向目标中添加依赖

SDK需要的依赖如下：

- Security.framework
- CoreLocation.framework
- libz.dylib

请选择`您的目标 -> Build Phases -> Link Binary With Libraries`，单击`+`按钮。如下图所示：

![](http://images.wosaimg.com/aa/ffd81f9fa49e3fb46912ac230f7618801c659e.png "添加目标依赖")

在弹出的窗口中搜索Security.framework和CoreLocation.framework，然后确认添加。

添加libz.dylib依赖时，请在弹出的窗口中点击`Add Other...`，会弹出资源管理器窗口，此时按下`Cmd + Shift + G`，在输入框中输入`/usr/lib`，然后进入该文件夹。选中libz.dylib，点击确定后，即完成该步骤。

#### 1.2.4 更新项目设置

在您的项目中，选择`您的目标 -> Info -> Custom iOS Target Properties`，在其中加入以下属性：

- `Supported interface orientations (iPhone)`（可选）
- `App Transport Security Settings -> Allow Arbitrary Loads`
- `Privacy - Location Usage Description`
- `NSLocationWhenInUseUsageDescription`

如需要使用标准界面模式，请将`Supported interface orientations (iPhone)`设置为`Portrait`方向，因为SDK的标准界面在iPhone设备上仅支持Portrait方向。

自iOS 9起，苹果对安全性提出更高要求，因此请将`App Transport Security Settings`中`Allow Arbitrary Loads`的值设为`YES`，以便开发模式时使用HTTP连接。在发布正式版本时，可根据实际需要将该设置取消。

此外，为了保证交易安全，SDK需要获取用户的当前的地理位置位置，因此需要在`Privacy - Location Usage Description`和`NSLocationWhenInUseUsageDescription`中设置提醒文字，<b style="color: red;">否则SDK将无法正常工作</b>。

具体配置如下图所示：

![](http://images.wosaimg.com/c5/ce312919c78e238579eca8b748a7cf53ed63b0.png "更新项目设置")

#### 1.2.4 在代码中引用SDK

    #import <WSUpayKit/WSUpayKit.h>

仅需该一行代码，您就可以在代码中轻松使用SDK了。

<br />

## 2. <a name="documentation"></a> 开发者文档

本章节详尽全面地介绍了SDK中所有开发者可以使用的类，类成员，NS_ENUM及其他常量。

### 2.1 <a name="WSUpayOrder"></a> WSUpayOrder

SDK订单类，代表所需操作的订单对象。

#### 2.1.1 属性成员

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>成员</td>
            <td>类型</td>
            <td>修饰</td>
            <td>说明</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>sn</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>收钱吧系统内部唯一订单号，由数字组成，不超过16字符</td>
        </tr>
        <tr>
            <td>client_sn</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>商户系统订单号，必须在商户系统内唯一，不超过64字符</td>
        </tr>
        <tr>
            <td>total_amount</td>
            <td>NSInteger</td>
            <td>assign, nonatomic</td>
            <td>交易总金额，以分为单位，不超过10位，超过1亿元的收款请使用银行转账</td>
        </tr>
        <tr>
            <td>payway</td>
            <td><a href="#WSUpayPayway">WSUpayPayway</a></td>
            <td>assign, nonatomic</td>
            <td>支付渠道，如微信、支付宝、京东钱包、百度钱包和QQ钱包等</td>
        </tr>
        <tr>
            <td>dynamic_id</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>支付条码内容，不超过32字符</td>
        </tr>
        <tr>
            <td>subject</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>本次交易的简要介绍，不超过64字符</td>
        </tr>
        <tr>
            <td>order_description</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>对商品或本次交易的描述，不超过256字符</td>
        </tr>
        <tr>
            <td>order_operator</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>发起本次交易的操作员，不超过32字符</td>
        </tr>
        <tr>
            <td>extended</td>
            <td>NSDictionary</td>
            <td>strong, nonatomic</td>
            <td>收钱吧与特定第三方单独约定的参数字典，最多支持24个字段，每个字段key长度不超过64字符，value长度不超过256字符，总长度不超过64字符</td>
        </tr>
        <tr>
            <td>reflect</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>反射参数，任何调用者希望原样返回的信息，不超过64字符</td>
        </tr>
        <tr>
            <td>refund_request_no</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>商户退款所需序列号，防止重复退款，不超过32字符</td>
        </tr>
        <tr>
            <td>refund_amount</td>
            <td>NSInteger</td>
            <td>assign, nonatomic</td>
            <td>退款金额，以分为单位，不超过10位</td>
        </tr>
    </tbody>
</table>

#### 2.1.2 该类无方法成员

### 2.2 <a name="WSUpayTask"></a> WSUpayTask

SDK任务。配置好任务后，调用相关方法，可对收钱吧的订单进行一系列操作。

#### 2.2.1 <a name="WSUpayTaskProperties"></a> 属性成员

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>成员</td>
            <td>类型</td>
            <td>修饰</td>
            <td>说明</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>upayOrder</td>
            <td>WSUpayOrder</td>
            <td>readonly, strong, nonatomic</td>
            <td>本次任务需要执行的订单</td>
        </tr>
        <tr>
            <td>finishBlock</td>
            <td>WSUpayTaskFinishBlock</td>
            <td>copy</td>
            <td>处理任务结果或错误信息的block</td>
        </tr>
        <tr>
            <td>preCreateBlock</td>
            <td>WSUpayTaskFinishBlock</td>
            <td>copy</td>
            <td>处理预下单的订单信息（其中包含收款二维码）或错误信息的block</td>
        </tr>
        <tr>
            <td>devMode</td>
            <td>BOOL</td>
            <td>assign, nonatomic</td>
            <td>是否使用开发模式。有关开发模式，请参见<a href="#devMode">附录</a></td>
        </tr>
        <tr>
            <td>needsUserInterface</td>
            <td>BOOL</td>
            <td>assign, nonatomic</td>
            <td>是否需要使用SDK的<a href="#withUI">标准界面模式</a></td>
        </tr>
        <tr>
            <td>baseViewController</td>
            <td>UIViewController</td>
            <td>weak, nonatomic</td>
            <td>如需使用标准界面模式，请将其设置为当前的ViewController</td>
        </tr>
        <tr>
            <td>refundByClientSn</td>
            <td>BOOL</td>
            <td>assign, nonatomic</td>
            <td>使用SDK标准界面模式进行退款时，是否将用户输入的交易单号作为商户订单号
     （若为YES，退款时SDK将把用户输入的交易单号当作商户订单号；否则当作收钱吧订单号）</td>
        </tr>
        <tr>
            <td>revokeByClientSn</td>
            <td>BOOL</td>
            <td>assign, nonatomic</td>
            <td>使用SDK标准界面模式进行撤单时，是否将用户输入的交易单号作为商户订单号
     （若为YES，撤单时SDK将把用户输入的交易单号当作商户订单号；否则当作收钱吧订单号）</td>
        </tr>
    </tbody>
</table>

#### 2.2.2 初始化方法成员

    - (instancetype)initWithUpayOrder:(WSUpayOrder *)upayOrder;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;按传入的WSUpayOrder，初始化并返回WSUpayTask实例。

###### 参数

<table style="width: 100%;">
    <tr>
        <td><i>upayOrder</i></td>
        <td>需要进行操作的WSUpayOrder对象</td>
    </tr>
</table>

###### 返回值

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;一个包含*upayOrder*的WSUpayTask对象。

###### 适用性

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SDK 3.0.0

    - (instancetype)initWithUpayOrder:(WSUpayOrder *)upayOrder
                             onFinish:(WSUpayTaskFinishBlock)finish;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;按传入的WSUpayOrder和交易完成后的处理逻辑，初始化并返回WSUpayTask实例。

###### 参数

<table style="width: 100%;">
    <tr>
        <td><i>upayOrder</i></td>
        <td>需要进行操作的WSUpayOrder对象</td>
    </tr>
    <tr>
        <td><i>finish</i></td>
        <td>交易结果返回的处理block</td>
    </tr>
</table>

###### 返回值

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;一个包含*upayOrder*的WSUpayTask对象。当任何交易操作完成后，该对象会回调*finish*。

###### 适用性

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SDK 3.0.0

    - (instancetype)initWithUpayOrder:(WSUpayOrder *)upayOrder
                          onPreCreate:(WSUpayTaskFinishBlock)preCreate
                             onFinish:(WSUpayTaskFinishBlock)finish;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;按传入的WSUpayOrder、预下单返回处理逻辑和交易完成后的处理逻辑，初始化并返回WSUpayTask实例。

###### 参数

<table style="width: 100%;">
    <tr>
        <td><i>upayOrder</i></td>
        <td>需要进行操作的WSUpayOrder对象</td>
    </tr>
    <tr>
        <td><i>preCreate</i></td>
        <td>预下单结果返回的处理block</td>
    </tr>
    <tr>
        <td><i>finish</i></td>
        <td>交易结果返回的处理block</td>
    </tr>
</table>

###### 返回值

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;一个包含*upayOrder*的WSUpayTask对象。当预下单结果返回后，该对象会回调*preCreate*，当任何交易操作完成后，该对象会回调*finish*。

###### 适用性

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SDK 3.0.0

#### 2.2.3 实例方法成员

    - (void)activateTerminal:(NSString *)code
                    vendorId:(NSString *)vendorId
                   vendorKey:(NSString *)vendorKey
                      finish:(void (^)(NSError *error))finish;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;激活该设备。在该设备首次被用于SDK付款时调用，否则该设备将无法进行正常交易。

###### 参数

<table style="width: 100%;">
    <tr>
        <td><i>code</i></td>
        <td>由收钱吧提供的设备激活码，用于激活该设备作为收钱吧服务的终端</td>
    </tr>
    <tr>
        <td><i>vendorId</i></td>
        <td>收钱吧服务商ID，验证服务商身份的重要凭证，由开发者和服务商管理，请在应用内确保其安全性</td>
    </tr>
    <tr>
        <td><i>vendorKey</i></td>
        <td>收钱吧服务商KEY，验证服务商身份的重要凭证，由开发者和服务商管理，请在应用内确保其安全性</td>
    </tr>
    <tr>
        <td><i>finish</i></td>
        <td>激活结果处理的block，成功激活后返回的NSError为<code>nil</code>，激活失败时返回NSError实例</td>
    </tr>
</table>

###### 返回值

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N/A

###### 适用性

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SDK 3.0.0

    - (void)pay;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;向收钱吧服务器发起支付请求。若超时未收到响应，则发起查询。若规定时间内查询未果则自动冲正（撤单）。

###### 参数

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N/A

###### 返回值

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N/A

###### 适用性

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SDK 3.0.0

    - (void)refund;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;向收钱吧服务器发起退款请求。若超时未收到响应，则发起查询并返回查询结果。

###### 参数

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N/A

###### 返回值

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N/A

###### 适用性

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SDK 3.0.0

    - (void)query;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;向收钱吧服务器发起查询订单请求

###### 参数

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N/A

###### 返回值

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N/A

###### 适用性

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SDK 3.0.0

    - (void)preCreate;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;向收钱吧支付网关发送预下单请求。首次回调返回二维码，二次回调返回支付结果。

###### 参数

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N/A

###### 返回值

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N/A

###### 适用性

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SDK 3.0.0

    - (void)revoke;

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;向收钱吧支付网关发送撤单请求。若超时未收到响应，则发起查询并返回查询结果。

###### 参数

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N/A

###### 返回值

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;N/A

###### 适用性

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SDK 3.0.0

### 2.3 <a name="WSUpayResult"></a> WSUpayResult

SDK交易结果类，包含操作完成后返回的订单信息和交易结果。

#### 2.3.1 属性成员

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>成员</td>
            <td>类型</td>
            <td>修饰</td>
            <td>说明</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>sn</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>收钱吧系统内部唯一订单号，由数字组成，不超过16字符</td>
        </tr>
        <tr>
            <td>client_sn</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>商户系统订单号，必须在商户系统内唯一，不超过64字符</td>
        </tr>
        <tr>
            <td>order_status</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>订单状态，当前订单状态，不超过32字符</td>
        </tr>
        <tr>
            <td>total_amount</td>
            <td>NSInteger</td>
            <td>assign, nonatomic</td>
            <td>交易总金额，以分为单位，不超过10位</td>
        </tr>
        <tr>
            <td>net_amount</td>
            <td>NSInteger</td>
            <td>assign, nonatomic</td>
            <td>剩余金额，实收金额减已退款金额，以分为单位，不超过10位</td>
        </tr>
        <tr>
            <td>payway</td>
            <td><a href="#WSUpayPayway">WSUpayPayway</a></td>
            <td>assign, nonatomic</td>
            <td>支付渠道，如微信、支付宝、京东钱包、百度钱包和QQ钱包等</td>
        </tr>
        <tr>
            <td>sub_payway</td>
            <td><a href="#WSUpaySubPayway">WSUpaySubPayway</a></td>
            <td>assign, nonatomic</td>
            <td>支付方式，扫描条形码支付或预下单二维码收款</td>
        </tr>
        <tr>
            <td>payer_uid</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>付款人ID，支付渠道（微信，支付宝等）中的付款人ID，不超过64字符</td>
        </tr>
        <tr>
            <td>payer_login</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>付款人账号，支付渠道（微信，支付宝等）中的付款人账号，不超过128字符</td>
        </tr>
        <tr>
            <td>trade_no</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>支付渠道（微信，支付宝等）的交易流水号</td>
        </tr>
        <tr>
            <td>finish_time</td>
            <td>double</td>
            <td>assign, nonatomic</td>
            <td>上次操作在收钱吧服务器的完成时间，Unix时间戳，精确到毫秒</td>
        </tr>
        <tr>
            <td>channel_finish_time</td>
            <td>double</td>
            <td>assign, nonatomic</td>
            <td>上次操作在支付渠道（微信，支付宝等）完成的时间，Unix时间戳，精确到毫秒</td>
        </tr>
        <tr>
            <td>qr_code</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>收款二维码信息，预下单时在订单信息中返回，不超过128字符</td>
        </tr>
        <tr>
            <td>subject</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>本次交易的简要介绍，不超过64字符</td>
        </tr>
        <tr>
            <td>order_description</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>对商品或本次交易的描述，不超过256字符</td>
        </tr>
        <tr>
            <td>order_operator</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>发起本次交易的操作员，不超过32字符</td>
        </tr>
        <tr>
            <td>reflect</td>
            <td>NSString</td>
            <td>strong, nonatomic</td>
            <td>反射参数，任何调用者希望原样返回的信息，不超过64字符</td>
        </tr>
    </tbody>
</table>

#### 2.3.2 该类无方法成员

### 2.4 <a name="WSUpayTaskFinishBlock"></a> WSUpayTaskFinishBlock

SDK定义的处理任务结果或错误信息的block类型，WSUpayTask的`finishBlock`和`preCreateBlock`属性的类型均为该类型。该类型声明如下：

    typedef void (^WSUpayTaskFinishBlock)(WSUpayResult *upayResult, NSError *error);

- 当任意操作正常完成时，WSUpayTask回调时传入正常的WSUpayResult实例以及`nil`的NSError；
- 当操作失败时，传入包含错误信息的NSError实例，并根据情况，尽可能返回WSUpayResult实例。

### 2.5 <a name="WSUpayPayway"></a> WSUpayPayway

SDK定义了名为WSUpayPayway的NS_ENUM，常量类型为NSInteger，方便开发者指定和判断订单的支付渠道。

<table>
    <thead style="font-weight: bold;">   
        <tr>
            <td>支付渠道</td>
            <td>实际值</td>
            <td>说明</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>WSUpayPaywayUnknown</td>
            <td>0</td>
            <td>未知支付渠道</td>
        </tr>
        <tr>
            <td>WSUpayPaywayAlipay</td>
            <td>1</td>
            <td>支付宝</td>
        </tr>
        <tr>
            <td>WSUpayPaywayWechat</td>
            <td>3</td>
            <td>微信支付</td>
        </tr>
        <tr>
            <td>WSUpayPaywayBaidu</td>
            <td>4</td>
            <td>百度钱包</td>
        </tr>
        <tr>
            <td>WSUpayPaywayJD</td>
            <td>5</td>
            <td>京东钱包</td>
        </tr>
    </tbody>
</table>

### 2.6 <a name="WSUpaySubPayway"></a> WSUpaySubPayway

SDK定义了名为WSUpaySubPayway的NS_ENUM，常量类型为NSInteger，方便开发者指定和判断订单的支付方式。

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>支付方式</td>
            <td>实际值</td>
            <td>说明</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>WSUpaySubPaywayBarcode</td>
            <td>1</td>
            <td>付款条形码支付方式</td>
        </tr>
        <tr>
            <td>WSUpaySubPaywayQrcode</td>
            <td>2</td>
            <td>收款二维码支付方式</td>
        </tr>
    </tbody>
</table>

### 2.7 <a name="WSUpayGeneralErrorCode"></a> WSUpayGeneralErrorCode

SDK定义了名为WSUpaySubPayway的NS_ENUM，常量类型为NSInteger，方便开发者根据SDK返回的NSError中的`code`属性判断错误原因。

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>错误代码</td>
            <td>实际值</td>
            <td>说明</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>WSUpayGeneralErrorCodeExternalError</td>
            <td>-10200</td>
            <td>支付渠道返回了处理异常时的错误代码</td>
        </tr>
        <tr>
            <td>WSUpayGeneralErrorCodeResponseError</td>
            <td>-10300</td>
            <td>SDK无法处理收钱吧服务返回参数时的错误代码</td>
        </tr>
        <tr>
            <td>WSUpayGeneralErrorCodeClientError</td>
            <td>-10400</td>
            <td>客户端请求无效的错误代码</td>
        </tr>
        <tr>
            <td>WSUpayGeneralErrorCodeServerError</td>
            <td>-10500</td>
            <td>收钱吧服务器端处理出现异常的错误代码</td>
        </tr>
        <tr>
            <td>WSUpayGeneralErrorCodeTerminalError</td>
            <td>-10600</td>
            <td>终端设备错误代码</td>
        </tr>
    </tbody>
</table>

### 2.8 <a name="OtherConstants"></a> 其他常量

#### 2.8.1 <a name="WSUpayErrorDomains"></a> SDK自定义Error Domain

SDK定义了一组类型为NSString的Error Domains，方便开发者根据SDK返回的NSError中的`domain`属性判断错误原因。

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>Error Domain</td>
            <td>实际值</td>
            <td>说明</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>WSUpayRequestErrorDomain</td>
            <td>WSUpayRequestErrorDomain</td>
            <td>请求参数错误</td>
        </tr>
        <tr>
            <td>WSUpayTerminalErrorDomain</td>
            <td>WSUpayTerminalErrorDomain</td>
            <td>终端错误</td>
        </tr>
        <tr>
            <td>WSUpayNetworkErrorDomain</td>
            <td>WSUpayNetworkErrorDomain</td>
            <td>网络错误</td>
        </tr>
        <tr>
            <td>WSUpayServerErrorDomain</td>
            <td>WSUpayServerErrorDomain</td>
            <td>服务器错误</td>
        </tr>
        <tr>
            <td>WSUpayTransactionErrorDomain</td>
            <td>WSUpayTransactionErrorDomain</td>
            <td>业务流程错误</td>
        </tr>
        <tr>
            <td>WSUpayUnknownErrorDomain</td>
            <td>WSUpayUnknownErrorDomain</td>
            <td>收钱吧SDK未知错误</td>
        </tr>
    </tbody>
</table>

#### 2.8.2 <a name="WSOrderStatus"></a> 收钱吧订单状态

SDK定义了一组类型为NSString的订单状态常量，方便开发者根据SDK返回的WSUpayResult中的`order_status`属性判断当前收钱吧订单的状态。

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>订单状态</td>
            <td>实际值</td>
            <td>说明</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>WSUpayOrderCreated</td>
            <td>CREATED</td>
            <td>订单已创建</td>
        </tr>
        <tr>
            <td>WSUpayOrderPaid</td>
            <td>PAID</td>
            <td>订单已成功支付</td>
        </tr>
        <tr>
            <td>WSUpayOrderPayCanceled</td>
            <td>PAY_CANCELED</td>
            <td>订单未支付，已被撤消</td>
        </tr>
        <tr>
            <td>WSUpayOrderPayError</td>
            <td>PAY_ERROR</td>
            <td>订单支付失败，付款结果未知</td>
        </tr>
        <tr>
            <td>WSUpayOrderRefunded</td>
            <td>REFUNDED</td>
            <td>订单已被全额退款</td>
        </tr>
        <tr>
            <td>WSUpayOrderPartialRefunded</td>
            <td>PARTIAL_REFUNDED</td>
            <td>订单已部分退款</td>
        </tr>
        <tr>
            <td>WSUpayOrderRefundError</td>
            <td>REFUND_ERROR</td>
            <td>订单退款失败，退款结果未知</td>
        </tr>
        <tr>
            <td>WSUpayOrderCanceled</td>
            <td>CANCELED</td>
            <td>订单支付失败，已冲正</td>
        </tr>
        <tr>
            <td>WSUpayOrderCancelError</td>
            <td>CANCEL_ERROR</td>
            <td>订单冲正失败，状态未知</td>
        </tr>
        <tr>
            <td>WSUpayOrderRevoked</td>
            <td>CANCELED</td>
            <td>订单已撤单</td>
        </tr>
        <tr>
            <td>WSUpayOrderRevokeError</td>
            <td>CANCEL_ERROR</td>
            <td>订单撤单失败，状态未知</td>
        </tr>
    </tbody>
</table>

<br />

## 4. <a name="tutorial"></a> 开发指引及示例

### 4.1 激活

激活操作提供了无界面和标准界面两种开发模式。当指定`needsUserInterface`为`YES`且`baseViewController`为当前的ViewController时，则启用标准界面模式；否则启用无界面模式。

WSUpayTask实例的`activateTerminal`方法的`code`参数是由收钱吧提供的设备激活码，用于激活该设备作为收钱吧服务的终端。而`vendorId`和`vendorKey`是验证服务商身份的重要凭证，由开发者和服务商管理，请在应用内确保其安全性。`finish`参数是处理激活结果的block。当激活成功时，SDK会回调block并传入`nil`；激活失败时，SDK会回调block并传入包含错误信息的NSError实例。

- 无界面模式下，激活方法的所有参数均为必选，若缺少`code`，`vendorId`或`vendorKey`，方法会回调并返回参数错误；若缺少`finish`，则不进行任何操作。
- 标准界面模式下，激活方法忽略`code`参数，由输入控件的输入值作为激活码；`vendorId`或`vendorKey`为必填，否则进行激活时会回调并返回参数错误；若缺少`finish`，则不进行任何操作。

#### 示例代码

    #import "ViewController.h"
    #import <WSUpayKit/WSUpayKit.h>
    
    @interface ViewController
    
    @property (strong, nonatomic) WSUpayTask *upayTask;

    @end

    @implementation ViewController
    
    /**
     @brief 利用SDK激活该设备，以便进行交易
     */
    - (void)activateTerminal {
        _upayTask = [[WSUpayTask alloc] init];
        _upayTask.needsUserInterface = YES; // 启用标准界面模式
        _upayTask.baseViewController = self;
        _upayTask.devMode = YES; // 使用开发模式
        [_upayTask activateTerminal:@"123456"
                           vendorId:@"someid"
                          vendorKey:@"somekey"
                             finish:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    // 激活失败，展示激活失败结果
                } else {
                    // 激活成功，展示激活成功结果
                }
            });
        }];
    }
    
    @end

### 4.2 支付

支付操作提供了无界面和标准界面两种开发模式。当指定`needsUserInterface`为`YES`且`baseViewController`为当前的ViewController时，则启用标准界面模式；否则启用无界面模式。

在准备支付请求时，对于WSUpayOrder实例的支付渠道（`payway`）属性，开发者可以选择不指定或赋值为`WSUpayPaywayUnknown`，收钱吧服务器会根据WSUpayOrder实例的`dynamic_id`属性自动判断支付渠道。

若开发者使用无界面开发模式，则由开发者负责开发扫描条码页面，并指定WSUpayOrder实例的支付条码（`dynamic_id`）属性，否则支付请求会直接返回参数错误。若开发者使用标准界面开发模式，则由SDK负责展示扫描条码页面并收集扫描到的条码值。

#### 支付参数

WSUpayOrder的属性中有关支付操作的属性如下：

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>属性</td>
            <td>无界面模式</td>
            <td>标准界面模式</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>client_sn</td>
            <td><b>必填</b></td>
            <td><b>必填</b></td>
        </tr>
        <tr>
            <td>total_amount</td>
            <td><b>必填</b></td>
            <td><b>必填</b></td>
        </tr>
        <tr>
            <td>payway</td>
            <td>选填</td>
            <td>选填</td>
        </tr>
        <tr>
            <td>dynamic_id</td>
            <td><b>必填</b></td>
            <td>选填</td>
        </tr>
        <tr>
            <td>subject</td>
            <td><b>必填</b></td>
            <td><b>必填</b></td>
        </tr>
        <tr>
            <td>order_description</td>
            <td>选填</td>
            <td>选填</td>
        </tr>
        <tr>
            <td>order_operator</td>
            <td><b>必填</b></td>
            <td><b>必填</b></td>
        </tr>
        <tr>
            <td>extended</td>
            <td>选填</td>
            <td>选填</td>
        </tr>
        <tr>
            <td>reflect</td>
            <td>选填</td>
            <td>选填</td>
        </tr>
    </tbody>
</table>

#### 示例代码

    #import "ViewController.h"
    #import <WSUpayKit/WSUpayKit.h>
    
    @interface ViewController
    
    @property (strong, nonatomic) WSUpayTask *upayTask;

    @end

    @implementation ViewController
    
    /**
     @brief 利用SDK进行扫码支付交易
     */
    - (void)payOrder {
        WSUpayOrder *order = [[WSUpayOrder alloc] init];
        order.client_sn = @"8128258306";
        order.total_amount = 100; // 1元，单位为分
        order.payway = WSUpayPaywayWechat; // 支付渠道，详见附录
        order.subject = @"Dinner Order";
        order.order_operator = @"John Doe";
        order.order_description = @"Pumpkin Pie";
        order.extended = @{@"open_id": @"wx2b5bkt7enklc"};
        order.reflect = @"Send me back";
    
        _upayTask = [[WSUpayTask alloc] initWithUpayOrder:order
                      onFinish:^(WSUpayResult *upayResult, NSError *error) {
            if (error) {
                // 交易失败，处理错误信息
                if (upayResult) {
                    // 处理交易失败的订单
                }
            } else {
                // 交易完成，处理交易结果
                // 可根据upayResult.order_status判断当前的订单状态
            }
        }];
        _upayTask.needsUserInterface = YES; // 启用标准界面模式
        _upayTask.baseViewController = self;
        _upayTask.devMode = YES; // 使用开发模式
    
        [_upayTask pay];
    }
    
    @end

### 4.3 退款

退款操作提供了无界面和标准界面两种开发模式。当指定`needsUserInterface`为`YES`且`baseViewController`为当前的ViewController时，则启用标准界面模式；否则启用无界面模式。

在退款时，对WSUpayOrder实例的收钱吧订单号（`sn`）和商户订单号（`client_sn`）属性处理方式如下：

- 当开发者同时指定了两者时，退款以收钱吧订单号为准；
- 当仅指定两者任意其一时，按照指定的订单号为准；
- 若都未指定，则在无界面模式下，退款操作直接返回参数校验错误，在标准界面模式下，SDK会展示输入订单号的控件。

在最后一种情形时，WSUpayTask的`refundByClientSn`属性是用来让开发者选择在标准界面模式下，用户输入的订单号是否作为商户订单号。

此外，若使用标准界面模式，开发者也可以选择不指定WSUpayOrder实例的退款金额（`refund_amount`），此时SDK会展示输入退款金额控件。

#### 退款参数

WSUpayOrder的属性中有关退款操作的属性如下：

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>属性</td>
            <td>无界面模式</td>
            <td>标准界面模式</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>sn</td>
            <td>选填</td>
            <td>选填，<b>与client_sn必填其一</b></td>
        </tr>
        <tr>
            <td>client_sn</td>
            <td>选填</td>
            <td>选填，<b>与sn必填其一</b></td>
        </tr>
        <tr>
            <td>refund_request_no</td>
            <td><b>必填</b></td>
            <td><b>必填</b></td>
        </tr>
        <tr>
            <td>refund_amount</td>
            <td><b>必填</b></td>
            <td>选填</td>
        </tr>
        <tr>
            <td>order_operator</td>
            <td>选填</td>
            <td>选填</td>
        </tr>
        <tr>
            <td>reflect</td>
            <td>选填</td>
            <td>选填</td>
        </tr>
    </tbody>
</table>

#### 示例代码

    #import "ViewController.h"
    #import <WSUpayKit/WSUpayKit.h>
    
    @interface ViewController
    
    @property (strong, nonatomic) WSUpayTask *upayTask;

    @end

    @implementation ViewController
    
    /**
     @brief 利用SDK进行退款操作
     */
    - (void)refundOrder {
        WSUpayOrder *order = [[WSUpayOrder alloc] init];
        order.sn = @"7892249408175";
        order.client_sn = @"8128258306";
        order.refund_request_no = @"1234567890";
        order.refund_amount = 100; // 1元，单位为分
        order.order_operator = @"John Doe";
        order.reflect = @"Send me back";
    
        _upayTask = [[WSUpayTask alloc] initWithUpayOrder:order
                      onFinish:^(WSUpayResult *upayResult, NSError *error) {
            if (error) {
                // 退款失败，处理错误信息
                if (upayResult) {
                    // 处理退款失败的订单
                }
            } else {
                // 退款完成，处理退款结果
                // 可根据upayResult.order_status判断当前的订单状态
            }
        }];
        _upayTask.needsUserInterface = YES; // 启用标准界面模式
        _upayTask.baseViewController = self;
        _upayTask.devMode = YES; // 使用开发模式
        _upayTask.refundByClientSn = NO;
    
        [_upayTask refund];
    }
    
    @end

### 4.4 预下单

预下单操作提供了无界面和标准界面两种开发模式。当指定`needsUserInterface`为`YES`且`baseViewController`为当前的ViewController时，则启用标准界面模式；否则启用无界面模式。

在准备预下单请求时，对于WSUpayOrder实例的支付渠道（`payway`）属性，开发者必须指定，且值不可为`WSUpayPaywayUnknown`。否则SDK会直接回调*preCreate*并传入参数错误。

若开发者使用无界面开发模式，则由开发者负责开发展示收款二维码页面。若开发者使用标准界面开发模式，则由SDK负责展示收款二维码页面。

目前收钱吧预下单订单的有效期大约为 **100** 秒，若超时仍未支付，则收款二维码失效。

#### 预下单参数

WSUpayOrder的属性中有关预下单操作的属性如下：

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>属性</td>
            <td>无界面模式</td>
            <td>标准界面模式</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>client_sn</td>
            <td><b>必填</b></td>
            <td><b>必填</b></td>
        </tr>
        <tr>
            <td>total_amount</td>
            <td><b>必填</b></td>
            <td><b>必填</b></td>
        </tr>
        <tr>
            <td>payway</td>
            <td><b>必填</b></td>
            <td><b>必填</b></td>
        </tr>
        <tr>
            <td>subject</td>
            <td><b>必填</b></td>
            <td><b>必填</b></td>
        </tr>
        <tr>
            <td>order_description</td>
            <td>选填</td>
            <td>选填</td>
        </tr>
        <tr>
            <td>order_operator</td>
            <td><b>必填</b></td>
            <td><b>必填</b></td>
        </tr>
        <tr>
            <td>extended</td>
            <td>选填</td>
            <td>选填</td>
        </tr>
        <tr>
            <td>reflect</td>
            <td>选填</td>
            <td>选填</td>
        </tr>
    </tbody>
</table>

#### 示例代码

    #import "ViewController.h"
    #import <WSUpayKit/WSUpayKit.h>
    
    @interface ViewController
    
    @property (strong, nonatomic) WSUpayTask *upayTask;

    @end

    @implementation ViewController
    
    /**
     @brief 利用SDK进行预下单交易
     */
    - (void)preCreateOrder {
        WSUpayOrder *order = [[WSUpayOrder alloc] init];
        order.client_sn = @"8128258306";
        order.total_amount = 100; // 1元，单位为分
        order.payway = WSUpayPaywayAlipay; // 支付渠道，详见附录
        order.subject = @"Grocery Order";
        order.order_operator = @"Sam White";
        order.order_description = @"Paper Towel";
        order.extended = @{@"return_url": @"http://www.somewebsite.com/"};
        order.reflect = @"Send me back";
    
        _upayTask = [[WSUpayTask alloc] initWithUpayOrder:order
                      onPreCreate:^(WSUpayResult *upayResult, NSError *error) {
            if (error) {
                // 预下单失败，处理错误信息
                if (upayResult) {
                    // 处理预下单失败的订单
                }
            } else {
                // 预下单完成，处理预下单结果
                // 若使用无界面模式，展示收款二维码
            }
        }
                      onFinish:^(WSUpayResult *upayResult, NSError *error) {
            if (error) {
                // 交易失败，处理错误信息
                if (upayResult) {
                    // 处理交易失败的订单
                }
            } else {
                // 交易完成，处理交易结果
                // 可根据upayResult.order_status判断当前的订单状态
            }
        }];
        _upayTask.needsUserInterface = YES; // 启用标准界面模式
        _upayTask.baseViewController = self;
        _upayTask.devMode = YES; // 使用开发模式
    
        [_upayTask preCreate];
    }
    
    @end

### 4.5 查询

查询操作仅支持无界面开发模式。开发者仅需传入WSUpayOrder实例，并指定其收钱吧订单号（`sn`）或商户订单号（`client_sn`）属性。若都未指定，则SDK直接返回参数错误。

#### 查询参数

WSUpayOrder的属性中有关查询操作的属性如下：

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>属性</td>
            <td>无界面模式</td>
            <td>标准界面模式</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>sn</td>
            <td>选填</td>
            <td>选填，<b>与client_sn必填其一</b></td>
        </tr>
        <tr>
            <td>client_sn</td>
            <td>选填</td>
            <td>选填，<b>与sn必填其一</b></td>
        </tr>
    </tbody>
</table>

#### 示例代码

    #import "ViewController.h"
    #import <WSUpayKit/WSUpayKit.h>
    
    @interface ViewController
    
    @property (strong, nonatomic) WSUpayTask *upayTask;

    @end

    @implementation ViewController
    
    /**
     @brief 利用SDK进行查询操作
     */
    - (void)queryOrder {
        WSUpayOrder *order = [[WSUpayOrder alloc] init];
        order.sn = @"7892249408175";
        order.client_sn = @"8128258306";
    
        _upayTask = [[WSUpayTask alloc] initWithUpayOrder:order
                      onFinish:^(WSUpayResult *upayResult, NSError *error) {
            if (error) {
                // 查询失败，处理错误信息
            } else {
                // 查询完成，处理查询结果
            }
        }];
        _upayTask.devMode = YES; // 使用开发模式
    
        [_upayTask query];
    }
    
    @end

<br />

### 4.6 撤单

撤单操作提供了无界面和标准界面两种开发模式。当指定`needsUserInterface`为`YES`且`baseViewController`为当前的ViewController时，则启用标准界面模式；否则启用无界面模式。

在撤单时，对WSUpayOrder实例的收钱吧订单号（`sn`）和商户订单号（`client_sn`）属性处理方式如下：

- 当开发者同时指定了两者时，撤单以收钱吧订单号为准；
- 当仅指定两者任意其一时，按照指定的订单号为准；
- 若都未指定，则在无界面模式下，撤单操作直接返回参数校验错误，在标准界面模式下，SDK会展示输入订单号的控件。

在最后一种情形时，WSUpayTask的`revokeByClientSn`属性是用来让开发者选择在标准界面模式下，用户输入的订单号是否作为商户订单号。

#### 撤单参数

WSUpayOrder的属性中有关撤单操作的属性如下：

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>属性</td>
            <td>无界面模式</td>
            <td>标准界面模式</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>sn</td>
            <td>选填</td>
            <td>选填，<b>与client_sn必填其一</b></td>
        </tr>
        <tr>
            <td>client_sn</td>
            <td>选填</td>
            <td>选填，<b>与sn必填其一</b></td>
        </tr>
        <tr>
            <td>reflect</td>
            <td>选填</td>
            <td>选填</td>
        </tr>
    </tbody>
</table>

#### 示例代码

    #import "ViewController.h"
    #import <WSUpayKit/WSUpayKit.h>
    
    @interface ViewController
    
    @property (strong, nonatomic) WSUpayTask *upayTask;

    @end

    @implementation ViewController
    
    /**
     @brief 利用SDK进行撤单操作
     */
    - (void)revokeOrder {
        WSUpayOrder *order = [[WSUpayOrder alloc] init];
        order.sn = @"7892249408175";
        order.client_sn = @"8128258306";
    
        _upayTask = [[WSUpayTask alloc] initWithUpayOrder:order
                      onFinish:^(WSUpayResult *upayResult, NSError *error) {
            if (error) {
                // 撤单失败，处理错误信息
                if (upayResult) {
                    // 处理撤单失败的订单
                }
            } else {
                // 撤单完成，处理撤单结果
                // 可根据upayResult.order_status判断当前的订单状态
            }
        }];
        _upayTask.needsUserInterface = YES; // 启用标准界面模式
        _upayTask.baseViewController = self;
        _upayTask.devMode = YES; // 使用开发模式
        _upayTask.revokeByClientSn = NO;
    
        [_upayTask revoke];
    }
    
    @end

## 5 <a name="Appendix"></a> 附录

### 5.1 <a name="devMode"></a> 开发模式

为了方便开发者进行调试，SDK提供了 **开发模式** 。开发模式下，设备端和服务器端都采用开发环境的数据和参数。这样可以避免开发者因开发调试而影响到正式环境的商户交易数据。因此，收钱吧建议开发者在开发调试和发布测试版本时，采用开发模式；在发布正式版本时，则采用非开发模式。

SDK在[WSUpayTask](#WSUpayTask)中提供了`devMode`属性。该属性决定当前操作是否使用开发模式。若在执行操作前，设置WSUpayTask的`devMode`属性为`YES`，则：

- SDK将调用收钱吧开发环境服务器，所有交易数据保存在开发环境，与正式环境隔离；
- SDK将使用开发环境的终端配置。这意味着如果开发者在开发模式下成功激活某台设备后，切换到非开发模式下，该设备仍处于未激活状态。

### 5.2 <a name="noUI"></a> 无界面模式

如果开发者产品设计和开发能力较强，且希望最大程度自定义用户界面和交互流程，可以选择无界面开发模式。该模式下，所有操作均不会展示SDK自带的用户界面，而仅通过回调与集成SDK的应用沟通。有关如何开启或关闭无界面模式，请参考[开发指引及示例](#tutorial)。

### 5.3 <a name="withUI"></a> 标准界面模式

如果开发者不希望投入过多成本，且希望使用标准化用户界面和交互流程，可以选择标准界面开发模式。该模式下，除查询操作以外，均会展示SDK自带的用户界面。该模式可以极大降低开发和维护成本，同时保证用户使用SDK的体验。有关如何开启或关闭标准界面模式，请参考[开发指引及示例](#tutorial)。

### 5.6 SDK返回错误处理

SDK在操作过程中遇到任何异常时，会将错误信息通过回调方式传递NSError实例给开发者处理。SDK同时定义了一系列[错误代码](#WSUpayGeneralErrorCode)及[Error Domain](#WSUpayErrorDomains)分别作为NSError实例的`code`和`domain`的值，以便开发者判断错误的原因。

此外，SDK还会设置NSError实例中的`userInfo`属性，传入包含`NSLocalizedDescriptionKey`和`NSLocalizedFailureReasonErrorKey`键值对的NSDictionary实例，其中带有当前错误的详细描述和错误原因描述，方便开发者在调试时获取更详细的错误信息。

下表用于说明各种常见错误信息的处理方法：

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>domain</td>
            <td>code</td>
            <td>处理方法</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>WSUpayTransactionErrorDomain</td>
            <td>-10200</td>
            <td>收钱吧服务器成功处理，但支付渠道业务处理异常，请检查您的交易请求是否合法以及交易双方账户的有效性。</a></td>
        </tr>
        <tr>
            <td>WSUpayTerminalErrorDomain</td>
            <td>-10400<br />-10600</td>
            <td>服务器认为该终端设备不合法或设备激活失败。若为激活操作，请确认您的激活码有效；若为其他操作，请确认设备已被正常激活。</td>
        </tr>
        <tr>
            <td>WSUpayRequestErrorDomain</td>
            <td>-10400</td>
            <td>无效的请求。请确认您的请求参数是否合法，具体请参考<a href="tutorial">开发指引及示例</a></td>
        </tr>
        <tr>
            <td>WSUpayServerErrorDomain</td>
            <td>-10300<br />-105xx</td>
            <td>收钱吧服务器返回结果异常或服务器端处理异常。出现该错误时，操作最终结果未知。当收款或退款时遇到该错误，建议开发者提示用户联系收钱吧客服。</td>
        </tr>
        <tr>
            <td>WSUpayUnknownErrorDomain</td>
            <td>-10500<br />或其他</td>
            <td>未知错误。出现该错误时，操作最终结果未知。当收款或退款时遇到该错误，建议开发者提示用户联系收钱吧客服。调试时可检查<code>userInfo</code>属性确认错误原因。</td>
        </tr>
    </tbody>
</table>

除以上错误信息以外，在遇到网络通信错误、JSON解析错误和Keychain错误等异常时，SDK还会返回`domain`为`NSURLErrorDomain`、`NSCocoaErrorDomain`和`com.samsoffes.sskeychain`的NSError实例。

## 6. <a name="FAQs"></a> 常见问题

#### 1. 在支付、预下单或退款时，为何未收到任何回调？

**解决方案：**

首先请确保您的项目添加了正确的依赖并完成了以下设置（具体步骤请参考[开发接入指南](#deploy)）：

- `Privacy - Location Usage Description`
- `NSLocationWhenInUseUsageDescription`

其次，检查代码，确保WSUpayTask的`finishBlock`传入了正确的处理逻辑（预下单时需要检查`preCreateBlock`）。

最后，请确保WSUpayTask的实例在操作过程中没有被ARC（[Objective-C](https://developer.apple.com/library/ios/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html) / [Swift](https://developer.apple.com/library/ios/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html)）机制回收（例如可以将WSUpayTask的实例作为当前ViewController的一个strong的属性）。

**注：如果您在开发时遇到任何问题需要咨询，请 [联系我们](#Contact)**

## 7. <a name="Contact"></a> 联系我们

如果您在使用SDK进行开发时遇到任何问题，请及时联系收钱吧。联系方式为：

**技术支持：**<sdk@wosai-inc.com>

**收钱吧运营&客服：**<shou@wosai-inc.com>

## 8. <a name="ChangeLog"></a> 版本记录

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>版本</td>
            <td style="width:100px">日期</td>
            <td>说明</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>0.1.0</td>
            <td>2016年1月27日</td>
            <td>提交审阅</td>
        </tr>
        <tr>
            <td>0.1.1</td>
            <td>2016年1月29日</td>
            <td>更新项目依赖；更新激活接口；增加撤单操作的开发文档、流程说明和开发指引；完善常见问题部分</td>
        </tr>
        <tr>
            <td>0.1.2</td>
            <td>2016年1月31日</td>
            <td>WSUpayOrder的operator属性在支付与预下单操作时改为必填字段；WSUpayOrder的extended属性类型改为NSDictionary；更新相应开发指引</td>
        </tr>
        <tr>
            <td>0.1.3</td>
            <td>2016年2月1日</td>
            <td>更新SDK版本为3.0.0，更新联系方式，正式发布</td>
        </tr>
    </tbody>
</table>