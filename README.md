# kubernetes dns
Kubernetes networking and DNS demo project.

## Start
```
./run.sh
```

## Network Topology
```
================================HOST NETWORK================================
USER ~ GET https://nginx.example.org
PATH 1 - *DNS resolution*        PATH 2 - *traffic*
 |                                |
 |                                |
 |                                |
DNS forwarder .:53 UDP/TCP coredns|
 |                                |
================================KIND CLUSTER NETWORK=========================
 |                                |
 |                                |
DNS :53 pihole           LOADBALANCER metallb
                                  |
                                  |
                         INGRESS CONTROLLER nginx
                                   \
                                    \ nginx.default.svc.cluster.local
                                     \
                                      \ nginx app
```

## Troubleshooting
```
kubectl run debug -it --rm --image nicolaka/netshoot:latest
```
