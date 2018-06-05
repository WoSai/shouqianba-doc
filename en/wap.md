## Upay WAP developer documentation

For clients interested in developing mobile shopping websites, Upay provides a special WAP API that can be intergrated to help them building mobile payment solutions within web browsers in apps such as Wechat and Alipay,so that the customers can use the mobile payment directly on the merchant's web page,thus expanding the online business channels of the merchants.

**Note:**

For WAP payment, currently only Wechat is supported. Alipay support is to be added in the future.

## 1. Payment Scenario

- A customer visits your mobile website with a built-in web browser in a mobile payment app, such as Wechat;
- The customer initiate a payment (such as by clicking a pay button on your website), and the mobile payment client app will pop up a confirmation to ask for payment authorization;
- The customer confirm the payment (a password may be required), and your website will display the payment result to the customer.

## 2. Business Process

![image](http://images.wosaimg.com/c2/ac6c6f981622118880ccd95ddfad1d2af260be.png "Upay WAP Pay Business Process")

### Process introduction

1. User visits the mobile terminal payment page of the merchant, triggering payment control (such as clicking the payment button).

2.The front logic of the payment page verifies the payment parameters and initiates the request to create an order.

3.After receiving the request, merchant's server revalidates request parameters and initiates a pre-order request to Shouqianba.

4.Once Shouqianba confirms that payment request is valid, it will initiate the transaction to the specific payment channel.

5.Payment channel returns the pre_order result synchronously.

6.Shouqianba returns the order information and the result to merchants.

7.Merchant's server responses to its own front-end page (which contains the payment parameter <span style="color:red; font-weight: bold;">biz_response.data.wap_pay_request</span> required to evoke payment clients to pay the controls).At the same time,  merchant begins polling the order status.<span style="color:red; font-weight: bold;">*</span>

8.The front page of the merchant calls the client by using payment parameter (<span style="color:red; font-weight: bold;">biz_response.data.wap_pay_request</span>) in the return result.

9.Consumers input the password and confirm the payment.

10.Front-end page of the merchant receives a callback from the client's front-end Javascript SDK and displays the payment processing pages. At the same time, front-end page initiates a query request to the merchant server (suggests using long connections) , waiting for the final payment result.

11.Merchant's server receives the query request from the front page, then maintains the connection until it receives the final payment result from Shouqianba.

12.Merchant's server returns the final payment result, and front page displays the successful payment and order information.

## 3. Before Integration

Before starting your integration process, please contact our sales representatives and technical support for implementation suggestions and provide your business information to apply for a set of vendor and merchant accounts for development and testing. The Wechat related information you provide must match those of your Wechat official account.

## <span style="color:red; font-weight: bold;">*</span>：wap_pay_request Parameters

|Name|Field|Required|Type|Example|Description
|:----|:----|:----|:----|:----|:----
|Public Account ID|appid|Yes|String(32)|wx8888888888888888|Public Account ID distributed by payment channnel
|Random string|noncestr|Yes|String(32)|5K8264ILTKCH16CQ2502SI8ZNMTM67VS|Random string, not longer than 32 bits. Recommended random number generation algorithm
|Order detail extension string|package|Yes|String(32)|WAP|Extended field,Fill in with WAP
|Pre payment transaction session identifier|prepayid|是|String(64)|wx201410272009395522657a690389285100|The pre payment reply identifier returned by WeChat unified interface is used for subsequent interface calls, which is valid for 2 hours.
|Signature|sign|Yes|String(32)	|C380BEC2BFD727A4B6845133519F3AD6|A detailed view of the signature generation algorithm
|time stamp|timestamp|Yes|String(32)|1414561699	|The current time, other details of the timestamp rules

See each payment channel WAP payment interface description

<span style="color:red; font-weight: bold;">**</span>：At present, Upay gateway can obtain the latest order status by asynchronous callback notification or merchant's backend server. It is suggested to use the combination of both to obtain the transaction status, and specifically refer to the web API to pre-create document.

<span style="color:red; font-weight: bold;">**</span>：Calling the front-end payment interface to arouse the payment channel modules in the front page, please ensure that you fully understand the related business processes and front-end development interfaces for each payment channel WAP before development.

## 3.Api description

### 3.1 Precreate

#### 3.1.1 Api address

    {api_domain}/upay/v2/precreate

#### 3.1.2 Request Parameters

Please refer to [Upay Web API Reference - Transaction](https://doc.shouqianba.com/zh-cn/api/interface/precreate.html)

#### 3.1.3 Special description

- for the WAP payment request, the value of the `sub_payway` in the request parameter must be ` "3" `, and the `payer_uid` is **mandatory** , which is valued as the open_id of the user under the merchant's public number;

- for the WAP payment request, the `wap_pay_request` in the return result contains the necessary parameters needed to evoke the payment channel controls in the front page of the merchant payment.

### 3.2 Query

#### 3.2.1 Api adress

    {api_domain}/upay/v2/query

#### 3.2.2 Request Parameters

Please refer to [Upay Web API Reference - Transaction](https://doc.shouqianba.com/zh-cn/api/interface/query.html)

#### 3.2.3 special description

- The merchant's back-end server can initiate a polling request to Upay server after receiving the success of the pre order.
- At present, all pre order orders are valid for about 90 seconds. If the time goes out and it is still not paid, the receipt will automatically cancel the order; therefore, the time of polling is controlled around **100-120** seconds.
- The interval between each query should be **once every 2 seconds in the first 30 seconds，and then once every 5 seconds**.

## 4.Glossary

**WAP payment:**

- **The public number WAP:** Public number payment is the user's H5 page that opens the merchant in WeChat or other payment channels. The merchant is paid by the WeChat payment module in the H5 page by calling the JSAPI interface provided by the payment channel.

-- the user enters the business public number in WeChat or other public accounts, opens a main page, and completes the payment.

-- users of friends in the friends circle, chat window and so on to share business page connection, users click on the link to open the merchant page, complete the payment.

-**Store code WAP:**

-- convert the merchant page into a QR code and stick it in a store. After the consumer has scanned the QR code and opening the page in a variety of wallet browsers, the amount is entered and the payment is completed.

## 5. Version record

<table>
    <thead style="font-weight: bold;">
        <tr>
            <td>Version</td>
            <td style="min-width:110px">Date</td>
            <td>Notes</td>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>0.1.0</td>
            <td>2016.03.08</td>
            <td>Submission for review</td>
        </tr>
        <tr>
            <td>1.0.0</td>
            <td>2016.03.09</td>
            <td>Official release</td>
        </tr>
    </tbody>
</table>

