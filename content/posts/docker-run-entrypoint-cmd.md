+++
date = 2019-06-12T15:12:45-04:00
title = "RUN or CMD or ENTRYPOINT"
slug = "run-cmd-entrypoint"
tags = ["docker"]
series = ["docker"]
+++
***

 ![targets](/images/docker.png)

One of the most confusing parts of a *Dockerfile* for me it has always been the part where
we execute or initiate the application.
 
### In Summary

* **RUN** executes command(s) in a new layer on top of the current image.
   Often used to install packages and dependencies.

* **CMD** sets default command and/or parameters, can be     overwritten from the command line when docker container runs.

* **ENTRYPOINT** Allows you to configure a container to run as an executable.



##### Difference between **RUN** and **CMD**

 Don't confuse **RUN** and **CMD**. **RUN** runs a command; **CMD** does not execute/run anything  at build time, only specifies the command for the image.


### SHELL and EXEC forms

All three instructions can be specified in *shell* or *exec* form.


#### SHELL form

`<instruction> <command>`

**Examples**

```bash
RUN apt-get install python3
CMD echo "Hello world"
ENTRYPOINT echo "Hello world"
```


When executed it runs as `/bin/sh -c <command>` as a normal shell command.
For example the following Dockerfile
```bash
ENV name Foo Bar
ENTRYPOINT echo "Hello, $name"
```

when container runs as `docker run -it <image>` will produce output

`Hello, Foo Bar`

#### EXEC form

Prefered for **CMD** and **ENTRYPOINT**

`<instruction> ["executable", "param1", "param2", ...]`

**Examples**

```bash
RUN ["apt-get", "install", "python3"]
CMD ["/bin/echo", "Hello world"]
ENTRYPOINT ["/bin/echo", "Hello world"]
```

When is executed in exec form it calls executable directly, and shell processing does not happen.
For example, the following Dockerfile

```bash
ENV name Foo Bar
ENTRYPOINT ["/bin/echo", "Hello, $name"]
```

when the container runs as `docker run -it <image>` will produce output


`Hello, $name`


If you need to run bash or sh, use *exec* form with `/bin/bash` as executable.

For example, the following Dockerfile

```
ENV name Foo Bar
ENTRYPOINT ["/bin/bash", "-c", "echo Hello, $name"]
```

when the container runs as `docker run -it <image>` will produce output

`Hello, Foo Bar`

### RUN
---

The preferred method to install packages and dependencies. Executes commands on top of the current layer and creates a new one.
It is usual to have more than one *RUN* instruction in a *Dockerifle*.

RUN has two forms:

* `RUN command` (shell form)
* `RUN ["executable","param1","param2"]` (exec form)

**Example**

```dockerfile
FROM alpine:3.10.1

RUN apk add --update /
    python3 /
    py-pip /
    curl
```

All the commands above run in a single layer

The default shell for the *shell form** is `/bin/sh -c`. If you need to use a different shell like `/bin/bash` use the *exec form* instead.

`RUN ["/bin/bash", "-c", "echo hello"]`

### CMD
---

It allows you to set a default command, which will be executed **only**  when you run a container without specifying a command.

 CMD has three forms:

 * `CMD ["executable","param1","param2"]` (exec form, preferred)
 * `CMD ["param1","param2"]` (sets additional default parameters for ENTRYPOINT)
 * `CMD command param1 param2` (shell form)

The second form sets default parameters that will be added after *ENTRYPOINT* parameters if container runs without command line arguments.


**Example**

```dockerfile
FROM alpine:3.10.1

RUN apk add --update \
    python3 \
    py-pip \
    curl

CMD ["python3","--version"]
```

Let's build and tag the Dockerfile

`docker build . -t alpine:ex3`

and run it

`docker run alpine:ex3`

the output is

`Python 3.7.3`

But if we run the container **with** a command:

`docker run alpine:ex3 cat /etc/issue`

the *CMD* is ignored and `cat /etc/issue` runs instead.
Output:

```
Welcome to Alpine Linux 3.10
Kernel \r on an \m (\l)
```


### ENTRYPOINT
---
Allows you to configure a container to run as a executable.
*ENTRYPOINT* commands **are not ignored** when Docker container runs with command line parameters.

ENTRYPOINT has two forms.

* `ENTRYPOINT ["executable", "param1", "param2"]` (exec form preferred)
* `ENTRYPOINT command param1 param2` (shell form)


**Example Exec Form**

Exec form of *ENTRYPOINT* allows us to set command and parameters and then use either form of *CMD* to set additional parameters.
*ENTRYPOINT* arguments are always used while *CMD* arguments can be overwritten by command line arguments.

```dockerfile
FROM alpine:3.10.1

RUN apk add --update /
    python3 /
    py-pip /
    curl

ENTRYPOINT ["echo"]
CMD ["from CMD"]
```

Let's build and tag the Dockerfile

`docker build . -t alpine:ex5`

and run it:

`docker run alpine:ex5`

output:

`from CMD`

Now let's run it adding a parameter

`docker run alpine:ex5 from here`

output:

`from here`


**Shell form**

Shell form of ENTRYPOINT **ignores** any CMD or docker run command line arguments.



### CMD and ENTRYPOINT interaction table

The table below shows what command is executed for different ENTRYPOINT / CMD combinations



|   |  **No ENTRYPOINT** | ENTRYPOINT `exec_entry` `p1_entry`  | ENTRYPOINT `["exec_entry" "p1_entry"]` |
|:-:|:-:|:-:|:-:|
|  **No CMD** | -  | `/bin/sh -c exec_entry p1_entry`  | `exec_entry p1_entry` |
|  **CMD** `[“exec_cmd”, “p1_cmd”]` |  `exec_cmd p1_cmd	` |  `/bin/sh -c exec_entry p1_entry` |  `exec_entry p1_entry exec_cmd p1_cmd` |
| **CMD** `[“p1_cmd”, “p2_cmd”]`  | `p1_cmd p2_cmd	`  | `/bin/sh -c exec_entry p1_entry	`   |  `exec_entry p1_entry p1_cmd p2_cmd` |
|  **CMD** `exec_cmd p1_cmd` | `/bin/sh -c exec_cmd p1_cmd	`  |  `/bin/sh -c exec_entry p1_entry	` | `exec_entry p1_entry /bin/sh -c exec_cmd p1_cmd`  |


Sources:

https://docs.docker.com/engine/reference/builder/#run

https://goinbigdata.com/docker-run-vs-cmd-vs-entrypoint/

***
