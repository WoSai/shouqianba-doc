# Web Proxy接入指南

## 背景

随着移动支付的快速兴起，越来越多的大型商户急需在现有的收银系统中集成移动收款能力。然而大型商户在选择对接收钱吧移动支付系统时，却会面临种种困难，例如：

- 大型商户往往拥有自己的一套成熟的系统来管理门店和终端，然而系统维护和改造的成本巨大；
- 大型商户的收款终端多种多样，想要全面集成收钱吧SDK，需要耗费大量的人力物力财力；
- 大型商户的门店和收款终端对应关系复杂，基本的SDK对接在应对不断变化的门店终端关系时，会耗费一定的人力成本。

针对大型商户在对接收钱吧支付系统时面临的这些问题，我们推出了收钱吧Web Proxy，以便大型商户能够以最小的系统改造成本，快速完成与收钱吧的系统对接，轻松管理门店和收款终端，实现高效的移动收款能力。

## 概述

Web Proxy支持**映射代理**和**非映射代理**两种对接方式，涵盖了**门店管理**和**终端管理**两大核心业务功能，以及**支付**，**退款**，**查询**，**预下单**，**撤单**等核心支付功能。

Web Proxy作为一个代理的网络服务，可以直接部署在商户的内部服务器上，作为商户业务系统与收钱吧支付系统交互的桥梁。

## 模块设计

Web Proxy内部实现由三部分组成：**core-proxy**、**upay-proxy**和**auto-upay-proxy**。

- **core-proxy**主要功能是对接收钱吧的核心业务系统，提供服务商级别的门店和终端的管理功能服务代理；
- **upay-proxy**主要功能是对接收钱吧的核心支付系统，提供封装了支付接口的时序及请求签名的本地代理；
- **auto-upay-proxy**主要功能是在**core-proxy**和**upay-proxy**的基础上提供服务商的业务接口和交易接口，完成对接方门店、终端数据和收钱吧门店、终端数据的本地映射，使对接方直接使用自己的门店和终端编号即可完成门店、终端数据的管理和交易流程。

Web Proxy支持两种对接方式：

- **非映射代理**：对接方愿意维护自己门店终端与收钱吧门店终端的映射关系，Web Proxy仅做时序和签名的封装，角色类似于SDK（对接方调用**core-proxy**接口和**upay-proxy**接口）。

- **映射代理**：对接方不维护自己门店终端与收钱吧门店终端的映射关系，由Web Proxy全权代理业务数据的创建和维护，并支持对接方通过提供自己的门店序列号和终端序列号进行交易(对接方调用**auto-upay-proxy**接口)。该代理完成了对接方门店、终端与收钱吧门店、终端的映射，封装了请求的签名和复杂的请求时序，可直接发起支付交易，极大减轻了对接方的开发和维护成本。

### Web Proxy系统边界框架图

#### 非映射代理

![WebProxy系统边界框架图2][image-2]

#### 映射代理

![WebProxy系统边界框架图1][image-1]

## 接口列表

### 非映射代理（core-proxy & upay-proxy）

非映射代理提供的接口如下：
          
#### 业务代理接口

- 创建门店：`{api_domain}/store/create`
- 创建终端：`{api_domain}/terminal/create`
- 更新门店信息：`{api_domain}/store/update`
- 更新终端信息：`{api_domain}/terminal/update`
- 获取门店信息：`{api_domain}/store/get`
- 获取终端信息：`{api_domain}/terminal/get`

#### 交易代理接口

- 支付：`{api_domain}/pay`
- 退款：`{api_domain}/refund`
- 撤单：`{api_domain}/revoke`
- 查询：`{api_domain}/query`
- 二维码预下单：`{api_domain}/preCreate`

### 映射代理（auto-upay-proxy）

映射代理提供的接口如下：

#### 映射代理业务接口

- 创建门店：`{api_domain}/proxy/store/create`
- 创建终端：`{api_domain}/proxy/terminal/create`
- 更新门店信息：`{api_domain}/proxy/store/update`
- 更新终端信息：`{api_domain}/proxy/terminal/update`
- 获取门店信息：`{api_domain}/proxy/store/get`
- 获取终端信息：`{api_domain}/proxy/terminal/get`

#### 映射代理交易接口

- 支付：`{api_domain}/proxy/pay`
- 退款：`{api_domain}/proxy/refund`
- 撤单：`{api_domain}/proxy/revoke`
- 查询：`{api_domain}/proxy/query`
- 二维码预下单：`{api_domain}/proxy/preCreate`

[image-1]:	http://images.wosaimg.com/b0/490f0909a58ef7537d608ffe080e87d5643698.png
[image-2]:	http://images.wosaimg.com/bd/4630bf968fbc8801a0fab4e17860517fb36f34.png
