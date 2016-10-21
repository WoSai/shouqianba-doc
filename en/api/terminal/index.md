# Upay Web API Reference - Terminal

To keep the communication between Upay terminal and server safe, terminal's `terminal_sn` and request signature should be in the `Authorization` header of each Upay Web API request. Request signature makes sure the request is signed by the right entity and not modified by any third party.

Upay provides a set of APIs to help client application request and maintain its `terminal_sn` and `terminal_key`, along with a log upload API to help collecting debugging information.

### [Terminal Activation](activate.md)

Each Upay terminal needs to be activated before any transaction takes place. The terminal will get `terminal_sn` and `terminal_key` in successful activation response. The terminal is also responsible for saving and managing the `terminal_sn` and `terminal_key` which will be used for signature of every transaction request.

### [Terminal Check-in](checkin.md)

Similar to a POS terminal, a Upay terminal needs to check in everyday to get latest `terminal_key`. Updating the `terminal_key` everyday helps keep your terminal and transactions safe.

### [Terminal Log Upload](log_upload.md)

Client application may choose to use this API to upload terminal logs to Upay server. Upay does not use terminal log files for any purpose other than debugging and improving Upay Web API service.

