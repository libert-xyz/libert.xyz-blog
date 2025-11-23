+++
date = 2015-09-01T11:59:37-04:00
title = "Easiest dockerfile"
slug = "easiest-dockerfile"
tags = ["docker","dockerfile"]
+++

We use a Dockerfile to build a Docker Images, we can write specific instructions such a install a package, update the system and define the ports that the container will be listen.

In the following example we write a Dockerfile in the /root directory

```bash
## Dockerfile that modifies centos:latest
 FROM centos:latest
 MAINTAINER User Name <username@domain.com>
## Update the server OS
 RUN yum -y upgrade
## Install Apache Web Server
 RUN yum -y install httpd
## Install OpenSSH-Server
 RUN yum -y install openssh-server
## Expose the SSH and Web Ports for attachment
 EXPOSE 22 80
 ```


Now we execute the build command

```bash
docker build -t mycustomimg/withservices:v1 /root
```

Once the image is build we verify that the image is in our list.

```bash
docker images
```
