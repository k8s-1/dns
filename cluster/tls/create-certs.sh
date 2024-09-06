#!/bin/sh

# # create self-signed tls certificate -> key + crt, without a CA this results in insecure https!
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=my-demo-app.local"
# kubectl create secret tls my-demo-app-tls --key tls.key --cert tls.crt --dry-run=client -oyaml > tls-secret.yaml

# instead use a CA to validate identity of public crt, mkcert uses a locally hosted CA
mkcert -install
# mkcert -uninstall
mkcert nginx.example.org # create key + pem
openssl x509 -in nginx.example.org.pem -text -noout
kubectl create secret tls my-demo-app-tls --key nginx.example.org-key.pem --cert nginx.example.org.pem $dry > tls-secret.yaml
