# Security and Identity Certification

## HTTPS Protocol
- The communication between equipment and cloud using HTTPS protocol.It is for secure communication over a computer network, the communication protocol is encrypted by Transport Layer Security (TLS 1.2).
- HTTPS connections were primarily used for payment transactions on the internet for sensitive transactions in corporate information systems.
<!--## OCSP Stapling
- OCSP stapling, formally known as the TLS Certificate Status Request extension, is an alternative approach to the Online Certificate Status Protocol (OCSP) for checking the revocation status of X.509 digital certificates.[1] It allows the presenter of a certificate to bear the resource cost involved in providing OCSP responses by appending ("stapling") a time-stamped OCSP response signed by the CA to the initial TLS handshake, eliminating the need for clients to contact the CA.
- OCSP stapling is designed to reduce the cost of an OCSP validation, both for the client and the OCSP responder, especially for those big traffic scenario.-->

## Multiple Access Points
| Location      | Access Entrypoint          | Domain        | IP            |
| ------------- | -------------              | ------------- | ------------- |
| Hongkong  | Hongkong without OCSP Stapling       |hk-api.shouqianba.com | 47.90.17.0  |
| Hangzhou  | China mainland without OCSP Stapling|api.shouqianba.com | 120.55.199.154|

## Dual Identity Certification
### Service Provider Certificate,
- For the mobile payment prerequisites, clients needs valid SHOUQIANBA terminal and Terminal Certificate，SHOUQIANBA will issue the service provider certificate for those clients who passed the business certification, it is designed for all of the terminal class interface signature check.
- A valid certificate including serial number (VENDOR_SN) and a service provider key (Vendor_key).
- Service provider who has the certificate as well as a activation-code can have the right to activate the terminal, and get the Terminal Certificate.

### Terminal Certificate,
- With Service Provider Certificate, clients can have valid terminal and terminal certificate which including terminal number (TERMINAL_SN) and the Terminal key (Terminal_key).
The terminal certificate is issued by the SHOUQIANBA, it is designed for all fund class interfaces signature check.
- In order to securely transmit data based on the data channel, the Service Provider and equipment has the responsibility to ensure the security of their service provider certificate and equipment certificate;

## MD5 Signature Algorithm,
- This is mainly for data integrity check purpose.
- It is based on the service provider certificate or equipment certificate and the request content of the byte stream to generate information digest as a signature.
