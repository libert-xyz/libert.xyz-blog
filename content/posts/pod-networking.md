+++
date = 2019-06-02T15:37:05-04:00
title = "Diving deeper into pod networking"
slug = "pod-networking"
tags = ["kubernetes","docker","networking"]
series = ["kubernetes","networking"]
+++
***

Inter-pod networking
---

Networking is one of the most complex pieces in Kubernetes, let's try to summarize pod networking and apply the divide and conquer paradigm.


1. Each pod gets its own unique IP address.
2. Each pod can communicate with all other pods through a flat, NATless network.


### How Kubernetes does it?


The networking is set up by the System Administrator or by a *Container Network Interace (CNI)* plugin.

Anyone can develop their own *CNI* plugin, the only conditions are the ones listed above.


### No NAT

![k8-net-1]

[k8-net-1]: https://libert.xyz/images/k8-net-1.png
 "No Nat"


In the image above *pod A* sends a network package to *pod B*, the package sent by *pod A* must reach *pod B* with source and destination address unchanged.

By doing this, applications running in *pods* think that they are connected in the same plain network connected to the same network switch.

The only case when the *pod* source ip is changed is when it communicates with services on the internet, in this case, the source IP is changed to the host worker node IP address.


### Even deeper into networking

#### 1. Communication between containers in the same node


The network namespace is set up by the *Infrastructure Container (pause container)* .

Pods on a node are connected to the same bridge through virtual Ethernet interfaces.
If you run `ifconfig` in a node you will see a `vethxxx` listed.
The interface in the container namespace is renamed to `eth0`

![k8-net-2]

[k8-net-2]: https://libert.xyz/images/k8-net-2.png
 "Virtual Ethernet"


1. The interface in the host's network namespace is attached to a networking bridge.
2. the *eth0* interface in the container is assigned an IP from the bridge IP range.
3. All containers in a node are connected to the same bridge.



#### 2. Communication between containers in different nodes


To enable communication between containers in different nodes, the birdges on those nodes need to be connected.

The node physical network needs to be connected with the virtual bridge as well.

Routing tables on node A need to be added to all packets destined for `10.1.2.0/24` are routed to node B, and node B routing tables need to be added so packets sent to `10.1.1.0/24` are routed to node A.


![k8-net-3]

[k8-net-3]: https://libert.xyz/images/k8-net-3.png
 "Different nodes pods"



***
