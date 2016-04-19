##通讯响应码说明
200：通讯成功；400：客户端错误；500:服务端错误

error_code为本次通讯的错误码，error_message为对应的中文描述。当result_code不等于200的时候才会出现error_code和error_message。

result_code:400，客户端错误。客户端请求错误。INVALID_PARAMS/参数错误；INVALID_TERMINAL/终端错误；ILLEGAL_SIGN/签名错误。

result_code:500，服务端错误。收钱吧服务端异常。可提示“服务端异常，请联系收钱吧客服”。

##业务结果码（biz_response.result_code）说明
biz_response.result_code是业务响应码，biz_response.result_code返回SUCCESS表示业务执行成功，具体到业务场景会返回不同业务员结果码。

PAY_SUCCESS：支付操作成功。

PAY_FAIL：支付操作失败并且已冲正。`下一步操作：重新进行一笔交易。`

PAY_FAIL_ERROR：支付操作失败并且不确定第三方支付通道状态。`下一步操作：调用查询接口发起轮询，确定订单最终状态。`

CANCEL_SUCCESS：撤单操作成功。

CANCEL_ERROR：撤单操作失败并且不确定第三方支付通道状态。`下一步操作：调用查询接口发起轮询，确定订单最终状态。`

CANCEL_ABORT_ERROR：撤单操作试图终止进行中的支付流程，但是失败，不确定第三方支付通道的状态。`下一步操作：调用查询接口查询，确定订单最终状态。`

CANCEL_ABORT_SUCCESS：撤单操作试图终止进行中的支付流程并且成功。

REFUND_SUCCESS：退款操作成功。

REFUND_ERROR：退款操作失败并且不确定第三方支付通状态。`下一步操作：调用查询接口查询，确定订单最终状态。`

PRECREATE_SUCCESS：预下单操作成功。发起轮询

PRECREATE_FAIL：预下单操作失败。`下一步操作：重新进行一笔交易。`

SUCCESS：查询操作成功。**开发者根据返回的biz_response.data.order_status属性判断当前收钱吧订单的状态。**

FAIL：查询操作失败。

##订单状态（biz_response.data.order_status）说明
**开发者根据返回的biz_response.data.order_status属性判断当前收钱吧订单的状态。**

CREATED：订单已创建/支付中。

PAID：订单支付成功。

PAY_CANCELED：支付失败并且已经成功充正。

PAY_ERROR：支付失败，不确定是否已经成功充正。
REFUNDED：已成功全额退款。

PARTIAL_REFUNDED：已成功部分退款。

REFUND_ERROR：退款失败并且不确定第三方支付通道的最终退款状态。
CANCELED：客户端发起的撤单已成功。

CANCEL_ERROR：客户端发起的撤单失败并且不确定第三方支付通道的最终状态。

##哪些状态是订单最终状态
- PAID
- PAY_CANCELED
- REFUNDED
- PARTIAL_REFUNDED
- CANCELED