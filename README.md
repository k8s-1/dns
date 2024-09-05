# kubernetes dns

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
