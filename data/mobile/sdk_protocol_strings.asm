; ASCII commands and headers sent by the Mobile Adapter SDK.
MobileSMTPHeloCommand:
	db "HELO ", 0
MobileSMTPMailFromCommand:
	db "MAIL FROM:<", 0
MobileSMTPRecipientCommand:
	db "RCPT TO:<", 0
MobileSMTPDataCommand:
	db "DATA\r\n", 0
MobileMailQuitCommand:
	db "QUIT\r\n", 0
MobilePOP3UserCommand:
	db "USER ", 0
MobilePOP3PasswordCommand:
	db "PASS ", 0
MobilePOP3StatCommand:
	db "STAT\r\n", 0
MobilePOP3ListCommand:
	db "LIST 00000\r\n", 0
MobilePOP3RetrCommand:
	db "RETR 00000\r\n", 0
MobilePOP3DeleCommand:
	db "DELE 00000\r\n", 0
MobilePOP3HeadCommand:
	db "TOP 00000 0\r\n", 0
MobileHTTPGetCommand:
	db "GET ", 0
MobileHTTPVersion:
	db " HTTP/1.0\r\n", 0
MobileHTTPUserAgent:
	db "User-Agent: CGB-", 0
MobileHTTPHeaderEnd:
	db "\r\n\r\n", 0
MobileHTTPPostCommand:
	db "POST ", 0
MobileHTTPContentLength:
	db "Content-Length: ", 0
