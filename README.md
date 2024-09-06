# kubernetes dns
Kubernetes networking and DNS demo project.

## Start
```
./run.sh
```

## Network Topology
```
=========================HOST NETWORK=====================================
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
DNS :53 pihole           LOADBALANCER metallb * exposes services on private network 192.168... 
* internal cluster DNS            |             as IP's (only accessible inside kind network)
* automatic records               |
* managed by external-dns         |
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
