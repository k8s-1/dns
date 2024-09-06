# kubernetes dns
Kubernetes networking and DNS demo project.

## Start
```
./run.sh
```

## Network Topology
```
=========================DOCKER HOST NETWORK==============================
USER ~ GET https://nginx.example.org
*DNS resolution*                 *traffic*
 |                                |
 |                                |
=========================KIND DOCKER NETWORK==============================
 |                                |
DNS forwarder .:53 UDP/TCP        |
 | * dockerized coredns           |
 | * available to docker host     |
 |                                |
 |                                |
 |                                |
DNS :53 pihole                    |
* internal cluster DNS            |
* automatic records               |
* managed by external-dns         |
                                  |
                        LOADBALANCER metallb * exposes services on private ip range
                                  |            192.168.200.X-192.168.200.X
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
