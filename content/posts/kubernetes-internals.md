---
title: "Kubernetes Internals Deep Dive"
date: 2019-05-12T13:34:45-04:00
draft: false
---


Learning Kubernetes (k8 for short) is already complex, to make it even funnier I decided to go one level below and learn (or try) how this container orchestrator works behind scenes.

Most of the references comes from blogs like [Julia Evans](https://jvns.ca/blog/2017/06/04/learning-about-kubernetes/),  Kubernetes Documentation and this awesome book called [Kubernetes in Action](https://www.manning.com/books/kubernetes-in-action )



K8 Architecture
----------------

In a nutshell k8 has two components

**1. Control Plane (master node)**

 * API Server
 * Scheduler
 * Controll Manager
 * etcd (key-value storage)


 **2. The (worker) Nodes**

* Kubelet
* Kube Proxy
* Container Runtime (docke or others)


![1k8]

[1k8]: https://libert.xyz/images/1k8.png
 "k8 architecture"




** How these components comunicate? **


To summarize:

* All components communicate with the *API server*.
* They don't talk to each other directly.
* Only the API server communicates with etcd.
* Communication between the API server and the other components are initiated by the components, except when we run `kubectl` to get logs , `kubectl attach`  to connect to a running container. In those cases the API Server connects to the kubelet.


** How components are run **

The *kubelet* is one of the most interesting component of the system because is the only one that **allways** runs as a regular system process.
All the other components in the Control plane and Worker nodes can run as pods or system process.
The *kubelet* is also deployed to the Master node to run the Control Plane components as pods.

** etcd knows everything about your cluster **

All objects configurations are stored in **etcd**.
For instance all the operations for retreaving information about the cluster such as `kubectl get nodes` , `kubectl get pods` , etc. starts with a call to the *API Server* and then the *API Server* reads the information from *etcd*.

The same happens when we make a change in the cluster like adding a new pod `kubectl create -f new-pod.yaml`. The *API Server* is called and this interacts with *etcd* to write the new state of the cluster.


** The API Server talks with everyone **

Is basically a *CRUD* system (create, read, update, delete) with a RESTful API endpoint and his database is the *etcd* service.

It also validates the objects before storing to *etcd*. It uses *Optimistic Locking* to ensure that two clients don't update an objects at the same time.

The API Server use *Authentication plugins* to authenticate the user, after the plugin identifies the user, extracts the userid and group, this data is used by the *Authorization Plugin* to identify if the user can perform the action on the requested resource. After the plugin says that the user can perform the action a request is send to the *Admision Control Plugin*.
In Summary:

*Authentication Plugin* --> *Authorization Plugin* --> *Adminision Control Plugin*

After all this process the *API Server* validates the object and stores the state in *etcd* and returns a response to the client.


** The Scheduler is always watching the API Server**

The Scheduler has a watch mechanism and waits for newly created pods through the *API Server*, then assign the new pod to a node.
The Scheduler does not communicate with the node server or *kubelet*, all the *Scheduler* does is upadte the pod definition  through the *API Server*.

So far seems like a simple task if the Scheduler just pick a random node to schedule the *pod* but actually the Scheduler uses algorithms to pick the best node.

Algorithm flow:

* Filter nodes to obtain the acceptable nodes.
* Chose the best one based on highest score, if all have the same score, round-robin is used.

Acceptable Nodes Questions:

* Does the Node can fulfill the pod request for Hardware resources?
* If the pod request to run in a particular node, is this the node?
* If the pod request to mount a volume, can this volume be mounted in this node?
* Does the pod tolerate the taints of the node?
