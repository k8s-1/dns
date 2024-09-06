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
*DNS resolution*                 *traffic*
 |                                |
 |                                |
================================KIND DOCKER NETWORK=========================
 |                                |
DNS forwarder .:53 UDP/TCP        |
 | (dockerized coredns)
 |                                |
 |                                |
 |                                |
DNS :53 pihole           LOADBALANCER metallb
(internal cluster DNS deploy)     |
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
