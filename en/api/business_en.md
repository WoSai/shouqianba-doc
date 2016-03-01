# Developer Guide

To make sure your services or client application works properly with Upay Web API, the following types of business processes need to be implemented:

1. Terminal activation
2. Terminal checkin
3. Transactions


## Terminal Activation

Every Upay terminal needs to be activated before any transaction takes place. Terminal will get `terminal_sn` and `terminal_key` in successful activation response. The terminal is responsible for saving and managing the `terminal_sn` and `terminal_key` which will be used for signature of every transaction request.

Every terminal only needs to be activated once.

![](../img/activate_sd.png?raw=true) 

## Terminal Checkin

`terminal_sn` and `terminal_key` are like username and password to your terminal. To keep your terminals and transactions safe, `terminal_key`s should be updated on daily basis. Developers may pick any time during the day to perfrom the checkin. But keep in mind that a `terminal_key` is only valid for at most 48 hours, and after each checkin, only current and last `terminal_key`s are valid.

![](../img/checkin_sd.png?raw=true) 

## Transactions

Upay Web API supports the following transactions: 

* **Pay**: When a cashier uses Upay terminal to scan a customer's payment barcode; Upay will automatically figure out the payment service provider from the barcode.

* **Refund**: Issue an order refund based on order serial number; Upay supports multiple refunds of a single order.

* **Revoke**: Orders can be revoked within the day it is created; compared to refund, revoke an order will issue a full refund without incurring any service fee.

* **Query**: Get the latest order information by either your or Upay's order serial number.

* **Pre-create**: Cashier pre-creates the order with Upay terminal and show customer the QR code; customer scans the QR code with payment app to finish the transaction. Note: Upay Web API only returns the QR code value; your service or client app is responsible for generating the QR code picture from the value.


### Transaction Sequence Diagrams

#### Pay

![](../img/pay_normal_sd.png?raw=true) 

![](../img/pay_exception_sd.png?raw=true)

#### Pre-create

![](../img/precreate_sd.png?raw=true)

#### Refund

![](../img/refund_normal_sd.png?raw=true)

![](../img/refund_exception_sd.png?raw=true)
