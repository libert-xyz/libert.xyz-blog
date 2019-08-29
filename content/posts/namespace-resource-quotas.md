+++
date = 2019-08-28T16:06:55-04:00
title = "Namespaces resources quotas"
slug = "Namespaces-quotas"
tags = ["kubernetes"]
series = ["kubernetes","QoS"]
+++
***

The **Limits** and **Requests** are set for each container, what about
if we want to apply Limits to namespaces?


### *LimitRange* Object


The *LimitRange* resource. It allows you to specify (for each namespace) not only the minimum and maximum limit you can set on a container for each resource but also the default requests for containers that don’t specify requests.


![k8-p2-1]

[k8-p2-1]: https://libert.xyz/images/lim1.png
 "limitrange"



### *LimitRange* use case

A great use case for LimitRange is to prevent users from creating pods that are bigger than the node's resources in the cluster. Without LimitRange the *API Server* will accept the pod but never schedule it.


![k8-p2-2]

[k8-p2-2]: https://libert.xyz/images/lim2.png
 "object"


### Limiting total resources in a namespace

*LimitRange* only apply to individual pods, we can limit total resources by namespace with the object *ResourceQuota*.


![k8-p2-3]

[k8-p2-3]: https://libert.xyz/images/lim3.png
 "resource quota"


*ResourceQuota* sets the maximum amount of CPU pods in the namespace
can request to 400 millicores. The maximum total CPU limits in the namespace are
set to 600 millicores. For memory, the maximum total requests are set to 200 MiB,
whereas the limits are set to 500 MiB.

![k8-p2-4]

[k8-p2-4]: https://libert.xyz/images/lim4.png
 "resource quota and limitrange"


### Creating LimitRange along with ResourceQuota

As a best practice, you should create both objects.
When a quota for a specific resource (CPU or memory) is configured (request or
limit), pods need to have the request or limit (respectively) set for that same resource.


### Limiting the number of objects that can be created

*ResourceQuota* can also be configured to limit objects in a namespaces

![k8-p2-5]

[k8-p2-5]: https://libert.xyz/images/lim5.png
 "quota objects"

 The ResourceQuota in this listing allows users to create at most 10 Pods in the namespace, regardless if they’re created manually or by a ReplicationController, ReplicaSet or DaemonSet.


***
