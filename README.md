# kubernetes dns

## Start
```
./run.sh
```

## Network diagram
```
localhost 
    ---> request example.domain.com
    ---> DNS proxy
    ---> nodePort address (i.e. loadbalancer)
    ---> cluster DNS
    ---> app
```
