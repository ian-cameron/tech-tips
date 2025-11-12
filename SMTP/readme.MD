# Testing SMTP from CLI
Using telnet you can test SMTP with

````
telnet <hostname> 25
HELO example.com
MAIL FROM: sender@example.com
RCPT TO: test@example.com
DATA
Subject: Hello from here
Test 123
.
````

For authenticated SMTP its a couple more steps.
Base64 encode your username and password:

````
printf %s 'username' | base64
printf %s 'password' | base64
````
save these for the next steps

````
telnet hostname 25
HELO (or EHLO sometimes) 
AUTH LOGIN <username64>
<password64>
(continue as usual)
````