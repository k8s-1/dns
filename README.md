# kubernetes dns

## Start
```
./run.sh
```

## Network diagram
```
localhost 
    ---> request example.domain.com
    ---> DNS proxy listens on local DNS port 53 TCP/UDP for resolution requests
    ---> nodePort address (i.e. loadbalancer)
    ---> cluster DNS
    ---> app
```
