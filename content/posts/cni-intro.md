+++
date = 2019-06-05T14:53:00-04:00
title = "Kubernetes Services insights"
slug = "pod-services"
tags = ["kubernetes","docker"]
series = ["kubernetes","networking"]
+++
***


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


***
