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


<!DOCTYPE html>
<html>
<head>
    <script type="module">
      import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid/dist/mermaid.esm.min.mjs';
      mermaid.initialize({startOnLoad:true});
    </script>
</head>
<body>
    <div class="mermaid">
      graph TD;
        A[Router] --> B(Switch);
        B --> C[PC1];
        B --> D[PC2];
        B --> E[PC3];
    </div>
</body>
</html>
