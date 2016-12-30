# 通讯响应码说明
200：通讯成功；400：客户端错误；500:服务端错误

error_code为本次通讯的错误码，error_message为对应的中文描述。当result_code不等于200的时候才会出现error_code和error_message。

result_code:400，客户端错误。客户端请求错误。INVALID_PARAMS/参数错误；INVALID_TERMINAL/终端错误；ILLEGAL_SIGN/签名错误。

result_code:500，服务端错误。收钱吧服务端异常。可提示“服务端异常，请联系收钱吧客服”。

# 通讯错误码列表

error_code为本次通讯的错误码

error_message为对应的中文描述

当result_code不等于200的时候才会出现

result_code |error_code | error_message 
--------- | ------ | -----  
**400** |INVALID_PARAMS	|参数错误
**400**|INVALID_TERMINAL	|终端错误
**400**|ILLEGAL_SIGN	|签名错误
**500**|	UNKNOWN_SYSTEM_ERROR	|系统错误
