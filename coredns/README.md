DNS needs to be forwarded from docker host into the Kubernetes cluster, because
adding a node:port as nameserver in /etc/resolve.conf will not work.
The standard port for any DNS is implicitly 53.
