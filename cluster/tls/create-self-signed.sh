#!/bin/sh

# create self-signed tls certificate

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=my-demo-app.local"
