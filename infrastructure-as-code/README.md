- [client](../client/)
    * if hosted locally on kind, expose instance via NodePort, allowing to access the service from outside the cluster at &lt;NodeIP&gt;:&lt;NodePort&gt;
    * if K8S cluster is hosted on a cloud provider, expose instance via LoadBalancer using a cloud provider's load balancer.

```sh
kubectl get pod

kubectl exec --stdin --tty client-... /bin/sh
kubectl exec --stdin --tty api-... -- /bin/bash
```
