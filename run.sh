#!/bin/bash

set -eux

workdir="$(pwd)"

# always start clean
./delete.sh

# start kind cluster with ingress settings and install ingress controller
cat <<EOF | kind create cluster --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
EOF
kubectl apply -f ingress-nginx.yaml

cd "$workdir"/cluster/tls && ./create-certs.sh && cd -

sleep 20

kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=180s

# metallb
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system
kustomize build ./infra/ | kubectl apply -f -
sleep 60


# cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.3/cert-manager.yaml
sleep 20
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    # The ACME server URL
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    # Email address used for ACME registration
    email: user@example.com
    # Name of a secret used to store the ACME account private key
    privateKeySecretRef:
      name: letsencrypt-staging
    # Enable the HTTP-01 challenge provider
    solvers:
      - http01:
          ingress:
            ingressClassName: traefik
EOF
sleep 5



# traefik ingress-controller
kustomize build ./traefik/ | kubectl apply -f -


# cert-manager + let's encrypt tls
kustomize build ./cert-manager/ | kubectl apply -f -


sleep 30

kustomize build ./cluster/ | kubectl apply -f -

sleep 10

cd coredns
# configure corefile to use variable nodeport
NODE_PORT=$(kubectl get svc pihole-nodeport -o jsonpath='{.spec.ports[0].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}')
sed \
  -e "s/NODE_PORT/$NODE_PORT/g" \
  -e "s/NODE_IP/$NODE_IP/g" \
  ./Corefile.template > ./Corefile
# run coredns
docker-compose up -d
cd ..

sleep 5

# query our server from a client in the same subnet or from the server directly
# docker by default uses bridge networking - a private virtual network @172.*.*.* on the docker host

TEST_FQDN=nginx.example.org
DNS_SERVER_IP=$(docker inspect coredns | jq -r '.[0].NetworkSettings.Networks.kind.IPAddress')
dig @"$DNS_SERVER_IP" "$TEST_FQDN"


# temporarily override local DNS /etc/resolve.conf
if [ -f /etc/resolv.conf.bkp ]; then
  echo "/etc/resolv.conf.bkp already exists!"
  exit 1
else
  sudo cp /etc/resolv.conf /etc/resolv.conf.bkp
  echo "nameserver $DNS_SERVER_IP" | sudo tee /etc/resolv.conf
fi


dig @"$NODE_IP" -p "$NODE_PORT" "$TEST_FQDN"


# kubectl run migrate -it --rm --restart=Never --image=nicolaka/netshoot -- /bin/sh -c 'dig @pihole.default.svc.cluster.local nginx.example.org'


sleep 50


nslookup nginx.example.org

dig nginx.example.org

curl -L nginx.example.org # mkcert local CA
curl -kL whoami.traefik.com # self-signed lets-encrypt
