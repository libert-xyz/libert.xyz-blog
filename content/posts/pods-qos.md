+++
date = 2019-08-27T18:47:59-04:00
title = "PODS QoS"
slug = "pods-qos"
tags = ["kubernetes","docker"]
series = ["kubernetes","QoS"]
+++
***

There is no option or field to assign Quality of service to a pod but a combination between **Requests** and **Limits**
give us the ability to define Quality of service.


### QoS Classes


* *BestEffort* class (no request and limits set)
* *Guaranteed* class (requests are equal to limits)
* *Burstable* class (one container has limit set but another don't)


![k8-p2-1]

[k8-p2-1]: https://libert.xyz/images/qos1.png
 "Classes"

Looking at QoS at the POD level is confusing because a POD can have one or multiple containers.

### QoS class of a single container POD


|   CPU requests / limits	|  Memory requests / limits 	|   Container QoS class	|
|:-:	|:-:	|:-:	|
|   None set	|   None set	|   BestEffort	|
|   None set	|   Requests < Limits	|  Burstable 	|
|   None set	|   Requests = Limits	|  Burstable 	|
|   Requests < Limits	|   None set	|  Burstable 	|
|   Requests < Limits	|   Requests < Limits	|  Burstable 	|
|   Requests < Limits	|   Requests = Limits	|  Burstable 	|
|   Requests = Limits	|   Requests = Limits	|  Guaranteed 	|



*If only requests are set, but not limits, refer to the table rows where
requests are less than the limits. If only limits are set, requests default to the
limits, so refer to the rows where requests equal limits.*


### QoS class of a POD with multiple containers


For multi-container pods, if all the containers have the same QoS class, that’s also the pod’s QoS class.
If at least one container has a different class, the pod’s QoS class is *Burstable*.


|   Container 1 QoS class	|  Container 2 QoS class 	|   POD's QoS class	|
|:-:	|:-:	|:-:	|
|   BestEffort	|   BestEffort	|   BestEffort	|
|   BestEffort	|   Burstable	|  Burstable 	|
|   BestEffort	|  Guaranteed |  Burstable 	|
|   Burstable	|   Burstable	|  Burstable 	|
|   Burstable	|   Guaranteed	|  Burstable 	|
|   Guaranteed	|   Guaranteed	|  Guaranteed 	|



### Which process gets killed when memory is low?


The QoS classes determine which container gets killed first.
Killing order by QoS class:

1. *BestEffort*
2. *Burstable*
3. *Guaranteed*

When the node’s memory is already maxed out and one of the processes on the node tries to allocate more memory, the system will need to kill one of the processes.


![k8-p2-2]

[k8-p2-2]: https://libert.xyz/images/qos2.png
 "Killing Order"



Sources:

https://www.manning.com/books/kubernetes-in-action

***
