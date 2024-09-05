# kubernetes dns
Kubernetes networking and DNS demo project.

## Start
```
./run.sh
```

## Network diagram
```
localhost 
    ---> request example.domain.com
    ---> DNS forwarder listens on local port 53 TCP/UDP for resolution requests
    ---> nodePort address (i.e. loadbalancer)
    ---> cluster DNS
    ---> app
```

## Troubleshooting
```
kubectl run debug -it --rm --image nicolaka/netshoot:latest
```
