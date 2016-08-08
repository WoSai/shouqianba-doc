##Windows SDK 部署
一般情况下,开发者只需要将 dll 和配置文件拷贝到需要集成的第三方应用执行文件同级目录下,即完成了部署。

配置文件放在exe执行目录下，日志就输出在exe执行目录下

调试过程中请确保配置文件**KeyParams**中
		
		AppURL:RTM
		EnableLog:1
		
如果需要配置文件路径，建议用环境变量修改
##网络限制

**环境:**终端不能直接与外网通信

###**解决方案(Windows SDK):**
###端口转发

###代理服务器
增加代理设置就是在KeyParams文件中增加如下两行：

	Proxy:http-proxy-sha.corporate.ge.com

	ProxyPort:80
	
参考[收钱吧支付网关2.0-windowsSDK开发接入文档](https://github.com/WoSai/shouqianba-doc/blob/master/zh-cn/sdk/windows.md)“4.5.1 KeyParams” 

注释掉则不生效

##如果在日后的维护过程中客户电脑损坏重装以后，怎么能够快速激活？有没有好的解决方案？
如果设备损坏了，但是设备硬盘还是可以使用的，那么原来的激活的程序可以拷贝出来继续使用。只有当激活文件被损坏了或者与终端不匹配了才需要重新激活码。



##是否能用SDK2.0直接覆盖SDK1.0使用？
不能！SDK1.0与SDK2.0是完全不同的对接模式。SDK1.0是从商户维度接入，SDK2.0是从终端维度接入，从1.0升级到2.0，需要重新编写程序。

**注意：**

1.新SDK升级以后，授权机制有变动，之前的ID和KEY不能通用；

2.Windows SDK2.0调用支付类接口不需要类似pay等前缀。

##Windows SDK如何判断此机是否曾经激活过？
Windows SDK有个获取终端号接口terminalSN()，如果未激活的话设备编号是空的，可以通过这个接口判断是否已激活。

##Windows SDK，不同的订单，第一张订单还没被扫的情况下能不能继续生成第二张订单的二维码？
preCreateUI不可以，preCreateUI需要得到第一张订单支付结果之后才能继续生成第二张订单。
preCreate可以。

##Windows SDK业务的请求地址（接入域名）是写死在dll里的吗？可以换成内网IP吗？
业务请求地址不是写死的。可以通过KeyParams文件配置 SDK 的基本参数。AppURL:后面跟需要的地址，以/结束。参考[收钱吧支付网关2.0-windowsSDK开发接入文档](https://github.com/WoSai/shouqianba-doc/blob/master/zh-cn/sdk/windows.md)“4.5.1 KeyParams” 

##关于Window SDK时序
Windows SDK对于业务时序都是封装好的，不需要用户自己查询和撤单，SDK自动完成。SDK调用的结果只有成功和失败。（preCreate除外）

##Windows SDK特殊字符
所有的参数,不能含有特殊字符，除 extended 参数外的所有参数中包含”字符的,需要使用\”转义代替。

##Windows SDK调用接口返回值是乱码？
Windows SDK统一采用 UTF-8 字符编码

设置自动编码autoCodec(1),只需调用一次

先调用version接口,获取SDK版本测试字符串返回接收的代码是否正确

##Windows SDK保存二维码图片可以自定义名称吗？
可以的。

Windows SDK接入二维码名称后面会跟一个qrcode。

##Windows SDK最低支持的系统版本
Windows SDK 最低支持 XP

##使用PB接入SDK常见问题:
### FUNCTION string activate(string params) LIBRARY "CashBarV2.dll"报错找不到函数？
在后边加上alias for "_activate@4"

所有函数都是stdcall标准，所以都需要按照stdcall的格式增加别名  有参数就加4 没参数就是0
