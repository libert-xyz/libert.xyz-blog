+++
date = 2019-08-26T13:15:19-04:00
title = "PODS Requests & Limits"
slug = "pods-requests-limits"
tags = ["kubernetes","docker"]
series = ["kubernetes","QoS"]
+++
***

When creating a pod we can specify the amount of CPU and memory that a container needs.
If a POD has more than one container requests and limits are specified individually for each container.

**E.g.**

![k8-p2-1]

[k8-p2-1]: https://libert.xyz/images/1req.png
 "Requests"


If you don't specify a CPU request the Kubernetes Scheduler will take the decisions of resource allocations for you.
In the worst-case scenario, the container may not get any CPU at all.


### Understanding CPU Units

The CPU resource is measured in CPU units. One CPU unit in Kubernetes is equivalent to:

* 1 AWS vCPU
* 1 GCP Core
* 1 Azure vCore

You can use the suffix m that means **millicores**.

**E.g.**

100m CPU = 0.1 CPU
500m CPU = 0.5 CPU



### Requests and Scheduling

The request resource specifies the **minimum amount** of resources that the pod needs. The *Scheduler* uses this information when scheduling the pod to a node.
When scheduling a pod, the *Scheduler* will only consider nodes with enough unallocated resources to meet the request resource.


### How does the Scheduler decide if a POD fits in a Node?

Here is when it gets a bit confusing because the *Scheduler* doesn't look how much resources are being used at the time of scheduling but the **sum** of resources requested by existing pods deployed in the node.
In summary, the Scheduler only cares about requests, not actual usage.

**E.g.**

![k8-p2-2]

[k8-p2-2]: https://libert.xyz/images/2req.png
 "Requests"


### Resource Limits


* **Requests** ensure that the container gets the **minimum** amount of resources it needs.

* **Limits** ensure the **maximum** amount of resources the container will be allowed to consume.


CPU is a compressible resource, which means the amount used by a container can
be throttled without affecting the process running in the container.
On the other hand, Memory is incompressible. Once a process is given a chunk of
memory, that memory can’t be taken away from it until it’s released by the process
itself.
That’s why we need to limit the maximum amount of memory a container can
be given.

Without limiting memory, a container/pod running on a worker node may
eat up all the available memory and affect all other pods on the node and any new
pods scheduled to the node. A single malfunction-
ing or malicious pod can practically make the whole node unusable.

**E.g.**

![k8-p2-3]

[k8-p2-3]: https://libert.xyz/images/3req.png
 "Limits"


In the example above you can see that we haven't specified Requests, in that case, request is set to the same values as limits.

### Reaching the limit

Unlike *requests*, the **sum** of all the limits are **allowed** to exceed 100% of the node capacity. The consequence of this is when 100% of the node's resources are used some containers will need to be killed.

**E.g.**

![k8-p2-4]

[k8-p2-4]: https://libert.xyz/images/4req.png
 "Limits2"

### OOMKilled/Out of Memory

CPU use is **throttled** when reaching the limits. Is not the same case with memory, the process is killed when tries to allocate memory out of the limit (OOMKilled).

### Containers always see the node's memory and CPU, not the container's

Even if we set the limit on how much memory is available to a container, the container is not aware of this limit.
This has a negative effect on any application that looks up the amount of memory available on the system and uses that information to decide how much memory to use.


Sources:

https://www.manning.com/books/kubernetes-in-action

***
