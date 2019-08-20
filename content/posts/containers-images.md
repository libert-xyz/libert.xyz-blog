+++
date = 2018-11-10T14:53:00-04:00
title = "Containers & Docker Images"
slug = "containers-docker"
tags = ["docker"]
series = ["docker"]
+++
***

Containers are getting more popular year by year and more companies are adopting containers as their default development environment.

One of the primary reasons for the rapid adoption are the flexibility to package the application code, share it and running anywhere regardless of the operating system host.  Another reason is the mass adoption of *Microservices Architectures*.

![docker-1]

[docker-1]: https://libert.xyz/images/docker-1.png
 "Containers"


### A Hello World container


The *busybox* images contain the basic *UNIX* tools like `echo`, `ls` and so on.

![docker-2]

[docker-2]: https://libert.xyz/images/docker-2.png
 "busybox"


#### Behind the scenes

* Docker checked if the *busybox:latest* image was present in your local computer.
* If not, docker pulled the image from the *Docker Hub* registry (docker.io).
* After the image was downloaded, *Docker* created a container from that image and ran the command `echo Hello World` inside it.
* The echo command sends the text to *STDOUT*, the process terminated and the container stopped.


![docker-3]

[docker-3]: https://libert.xyz/images/docker-3.png
 "Docker Hub"

#### Creating a python server


The following code creates a simple socket listening in the port 8000

```python
#!/usr/bin/python

import SimpleHTTPServer
import SocketServer

PORT = 8000

Handler = SimpleHTTPServer.SimpleHTTPRequestHandler

httpd = SocketServer.TCPServer(("", PORT), Handler)

print "serving at port", PORT
httpd.serve_forever()

```

Next, we need to dockerize the code using a Dockerfile

```
FROM python:2.7-alpine
ADD server.py /server.py
ENTRYPOINT ["python","server.py"]
```


#### Building the container image


![docker-4]

[docker-4]: https://libert.xyz/images/docker-4.png
 "docker build"


*Build Process*


![docker-5]

[docker-5]: https://libert.xyz/images/docker-5.png
 "docker build"



#### How  the image is built?


The build process is not performed by the *Docker* client, instead is performed by the `Docker daemon`


* The *client* and the *daemon* don't need to be in the same machine
* If you are running Docker in a non-Linux OS, the docker client runs in your host OS and the *docker daemon* runs in a *VM*.



#### Image layers


A docker image is composed of multiple layers.
When building an image, a new layer is created for each individual command in the *Dockerfile*

#### Running the container and accessing the app

Once the image is build, we can run the container

```bash
docker run -p 8000:8000 -d pyserv
```

To verify that the container is running `docker ps`

```
CONTAINER ID        IMAGE               COMMAND              CREATED             STATUS              PORTS                    NAMES
434339134cc8        pyserv              "python server.py"   30 seconds ago       Up 31 seconds        0.0.0.0:8000->8000/tcp   focused_benz

```

#### Shell inside the container

To get inside the container we can run `docker exec -it focused_benz sh`

The process `sh` process will have the same *Linux namespace* as the main container.

Now that we are inside the container we can explore the process running `ps aux`

```
/ # ps aux
PID   USER     TIME  COMMAND
    1 root      0:00 python server.py
   16 root      0:00 sh
   27 root      0:00 ps aux

```

If you feel curious and open another terminal in your host OS, you will see the process running in the container.


```
libert >>  ps -aux | grep server.py
root     21799  0.0  0.1  13908 12344 ?        Ss   19:47   0:00 python server.py

```

This proves that the process running in the container is also running in the host OS, but the process has a different *PID* . This is because the container is running in his own *Linux Namespace* and has his own *PID* tree.
The container filesystem is also isolated from the host OS.

***


*** References - [Kubernetes in Action](https://www.manning.com/books/kubernetes-in-action )
