+++
date = 2019-06-05T14:53:00-04:00
lastmod = 2021-04-08T14:53:00-04:00
title = "Kubernetes Services insights"
slug = "pod-services"
tags = ["kubernetes","docker"]
series = ["kubernetes","networking"]
+++
***

Services introduction
---

A Kubernetes service provides a static endpoint (IP) to access pods.
The IP is static and never changes while the service exists.
Services can have multiple pods in different nodes, in every request the service routes the traffic to a random backed pod even if the request comes from the same client.

Kubernetes Services
---

The *kube-proxy* manages everything related to services.

In summary, a service has the following characteristics

* Each service gets its own stable IP address and port.
* Clients and pods connect to the service ip address and port.
* The IP address is virtual
* The IP address in not assigned to any network interface and is not listed as source or destination IP address in a network packet when the packet leaves the node.
* You can't ping the service IP.


### kube-proxy and iptables

When a service is created, `kubectl create -f sevice.yaml`, the following happens:

* The virtual IP is created.
* The *API Server* notifies *kube-proxy* agents in each node that a new service has been created.
* *kube-proxy* creates iptables rules to route traffic from the virtual IP/port to the pods behind the service.


In the following figure, we can see a pod try to reach another pod backing up by a service.

1. The packet destination is initially set to the IP/port of the service (`172.30.0.1:80`)
2. The packet is handled by the *iptables* rules on the node.
3. The *iptables* rules check if there is any match.
4. One of the rules is: *if the packet destination equals to `172.30.0.1`* and equals to port `80`, replace the IP/port destination with the IP/port of a pod (the target pod specified in the Service spec).
5. From here,  it’s exactly as if the client pod had sent the packet
to pod B directly instead of through the service.


![k8-services-1]

[k8-services-1]: https://libert.xyz/images/k8-services-1.png
 "Services/iptables"


### Services discovery

How does a client or pod know what is the IP and port of a given service?


**Environment variables**

When a *pod* is first started Kubernetes creates a set of environment variables pointing to services that exist at the moment (if you create the service before the pods)


```bash
$ kubectl exec pod-example env
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
HOSTNAME=pod-example
KUBERNETES_SERVICE_HOST=10.12.100.1
KUBERNETES_SERVICE_PORT=443
...
EXAMPLE_SERVICE_HOST=10.12.100.16
EXAMPLE_SERVICE_PORT=80
```


**kube-dns**

Is a pod that runs a DNS server in the *kube-sytem* namespace. It configures a DNS entry (**/etc/resolv.conf**) on every pod launched in the cluster.

Each service gets an entry in the internal DNS server and the pods can access them by their Fully Qualified Domain Name (FQDN):

```
service-example.default.svc.cluster.local
```

### Services Endpoints


When a pod selector is defined in the service spec is not used when redirecting traffic from the service to the pods. Instead, the selector creates IPs and ports that are added to the *endpoint* resource.
When a client sends a request to the service, the service proxy selects one of the IPs and ports of the endpoint.


```yaml
$ kubectl describe svc example-service
Name:                example-service
Selector:            app=myApp
Type:                ClusterIP
IP:                  10.12.249.153
Port:                <unset> 80/TCP
Endpoints:           10.111.1.4:8080,10.111.2.5:8080,10.111.2.6:8080
```

Notice that if you create a service without a pod selector no endpoints will be added to the service.

***

*** References - [Kubernetes in Action](https://www.manning.com/books/kubernetes-in-action )