+++
date = 2019-04-13T15:25:21-04:00
title = "Service accounts & RBAC Authorization"
slug = "RBAC-Authorization"
tags = ["kubernetes"]
series = ["kubernetes","security"]
+++
***

When a request is received by the *API Server* (kubectl) it goes through a list of
authentication plugins.
The plugins examine the request and determine who is sending the request.

An authentication plugin returns the username and group of the authenticated
user. Kubernetes doesn’t store that information anywhere; it uses it to verify whether
the user is authorized to perform an action or not.

### Users

Kind of clients connecting the *API Server*:

* Humans (users)
* Pods (applications running in them)

### Groups

Human and *ServiceAccounts* can belong to multiple groups.


### ServiceAccounts

Every *POD* is associated with a *ServiceAccount* which represents the identity of the application running in the *POD*.

A *POD* authenticates with the *API Server* by sending the file `var/run/secrets/kubernetes.io/serviceaccount/token`, which is mounted in into each container file system through a secret volume.

*ServiceAccount* usernames are formatted like this:

`system:serviceaccount:<namespace>:<service account name>`


### ServiceAccount resource

*ServiceAccount* is yet another object in Kubernetes like Pods, ConfigMaps and so on, is also associated with namespaces.

Each pod is associated with a single ServiceAccount in the pod’s namespace.

![k8-p2-1]

[k8-p2-1]: https://libert.xyz/images/ser1.png
 "ServiceAcct"


### Create service ServiceAccounts

```bash
$ kubectl create serviceaccount foo
```

![k8-p2-2]

[k8-p2-2]: https://libert.xyz/images/ser2.png
 "create ServiceAcct"

 A custom token Secret has been created and associated with the
 ServiceAccount.
 The authentication tokens used in ServiceAccounts are JWT (JSON Web Tokens)


### RBAC Authorization plugin

RBAC determines if a user may perform an action or not.
The API server exposes a REST interface, users perform actions by sending HTTP
requests to the server. Users authenticate themselves by including credentials in the request (authentication token, username and password, or a client certificate).


|  HTTP Method 	|   Single Resource	|   Multiple Resources	|
|---	|---	|---	|
|   GET	|   get (watch)	|   list (and watch)	|
|   POST	|   create	|   n/a	|
|   PUT	|  update 	|   n/a	|
|   PATCH	|   patch	|  n/a 	|
|  DELETE 	|   delete	|  n/a 	|


### RBAC Resources

* Roles and ClusterRoles
* RoleBindings and ClusterRoleBindings

Roles define what can be done, while bindings define who can do it

![k8-p2-3]

[k8-p2-3]: https://libert.xyz/images/ser3.png
 "roles"

The difference between Role and a ClusterRole, or between a RoleBinding and a
ClusterRoleBinding, is that the Role and RoleBinding are namespaced resources,
whereas the ClusterRole and ClusterRoleBinding are cluster-level resources

![k8-p2-4]

[k8-p2-4]: https://libert.xyz/images/ser4.png
 "roles and cluster differences"



|  For accessing 	|   Role type to use	|   Binding type to use	|
|---	|---	|---	|
|  Cluster-level resources (Nodes, PersistentVolumes)	|   ClusterRole	| ClusterRoleBinding	|
|  Non-resource URLs (/api, /healthz)	|   ClusterRole 	|  ClusterRoleBinding	|
|  Namespaced resources in any namespace (and across all namespaces)	|  ClusterRole 	| ClusterRoleBinding	|
|  Namespaced resources in a specific namespace (reusing the same ClusterRole in multiple namespaces)	| ClusterRole	|  RoleBinding 	|
|  Namespaced resources in a specific namespace (Role must be defined in each namespace) 	|   Role	|  RoleBinding 	|

 Sources:

 https://www.manning.com/books/kubernetes-in-action


***
