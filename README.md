BustPushAss
----

BustPushAss is a MacOS app used to send push notification to devices. It's a front-end GUI tools that runs a `curl` command line internally.

e.g.
```bash
/usr/local/Cellar/curl/7.50.1/bin/curl -d '{"aps":{"alert":"Hi!","sound":"default"}}' \
--cert "pem_file_path:pem_password" -H "apns-topic: your.bundler.id" \
--http2 https://api.push.apple.com/3/device/your_device_token
```

<image width='240' src='./screenshot.png'>

Usage
----

1. Import the pem file from the APNS certificates for Push Notifications.
  e.g. 
  
  `openssl pkcs12 -in cert.p12 -out aps.pem`

2. Install the `curl` command line tool. Note: HTTP/2.0 support is needed.
  
  `brew install curl --with-nghttp2`

3. Input the path of `curl` and other information into the input-box.

4. Click the send button.


