+++
date = 2019-06-15T17:17:33-04:00
title = "Kubernetes Internals Deep Dive Summary Pt2"
slug = "kubernetes-internals-p2"
tags = ["kubernetes","docker","k8"]
+++




##### If you haven't yet, check the first part [here](https://libert.xyz/posts/kubernetes-internals/)


K8 Architecture Summary Pt2
---


### What happens when we submit a pod manifest to the API server?


Before any event, the *Controler Manager*, *Scheduler* and the *Kubelet* are in "watching mode" waiting for a new event for their respective resources types in the *API Server*


![k8-p2-1]

[k8-p2-1]: https://libert.xyz/images/k8-p2-1.png
 "Watching Mode"


### Deployment manifest created


Now you executed the command `kubectl create -f deployment.yaml`

This happens next:

1. The *API Server* verifies the Deployment specifications
2. Stores it in *etcd*
3. Returns a response to `kubectl`


After the following chain of events takes place


![k8-p2-2]

[k8-p2-2]: https://libert.xyz/images/k8-p2-2.png
 "Events"


### What a running pod is?

When we run `kubectl run nginx --image=nginx` a few interesting things happens:

1. Nginx container Running
2. Pod Infrastructure Container (*pause container*) running

![k8-p2-3]

[k8-p2-3]: https://libert.xyz/images/k8-p2-3.png
 "Pause Container"



#### *The Pause Container*


The *pause container* is the container that holds all containers in the pod together.
All containers in the pod share the same network and Linux namespaces, the *Pod Infrastructure Container* holds all these namespaces.


![k8-p2-4]

[k8-p2-4]: https://libert.xyz/images/k8-p2-4.png
 "Pod Infrastructure Container"
