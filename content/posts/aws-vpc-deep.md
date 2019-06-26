+++
date = 2016-10-10T14:43:55-04:00
title = "AWS/Amazon Global Network - Re:Invent 2016"
slug = "aws-vpc-deep"
tags = ["aws"]
series = ["aws"]
+++
***


AWS rarely gives us insights about how they manage their data centers, there is no too much information about what kind of hardware they use and how they can scale quickly.

This is because I found the  talk **AWS re:Invent 2016** called [**Amazon Global Network Overview**](https://youtu.be/uj7Ting6Ckk) really enjoyable.

**James Hamilton** (Vice President and Distinguished Engineer) gives us an amazing overview of how the magic happens behind AWS datacenters.


With 14 regions across the world.


### Trans-Oceanic cables to interconnect AWS Regions

![vpc-1]

[vpc-1]: https://libert.xyz/images/vpc-1.png
 "Region Links"

AWS owns and manages all the fiber connections between regions and as **James Hamilton** mentions in the talks they don't trust and depend of any third party provider.


### AWS regions

![vpc-2]

[vpc-2]: https://libert.xyz/images/vpc-2.png
 "Regions"

Each region is composed of at least two availability zones but all new Amazon regions are built with at least three AZs and some have as many as five.



#### Transit Centers

Transit centers provide connectivity to the region to the rest of the world.
Every Region has two transit centers.



#### Metro Fiber

AWS Regions and AZs are connected with Metro Fiber.

Within an AZ there are intra-AZ fiber connections within the data centers, inter-AZ fiber connections between data centers that make up the AZ and fiber connections between each of the data centers and one of two transit stations each AZ has that connect to the outside world.

![vpc-3]

[vpc-3]: https://libert.xyz/images/vpc-3.png
 "Metro Fiber"


#### AZs

Each AZ has at least one data center, although some have as many as eight.

Also is misconception to think that AZs are servers hosted in the same datacenter as other AZs but in different racks, actually AZs are independent building separated miles away within a Region.
Several AZ's over 300k servers


 ![vpc-7]

 [vpc-7]: https://libert.xyz/images/vpc-7.png
  "AZs"


Miles away from a distance perspective, close from a latency perspective (1 millisecond)


#### Datacenters

Inside the data center, AWS runs its own custom-built hardware, including network routers.

AWS runs around 50k to 80k bare metal servers in each datacenter.

 If data centers are any larger, then there are only modest gains in efficiency related to its scale. On the other hand, there are negative consequences to building larger data centers: If one fails, it will bring down more capacity compared to if a smaller facility goes down. Keeping data centers in relatively modest sizes costs a little bit more.



 ![vpc-8]

 [vpc-8]: https://libert.xyz/images/vpc-8.png
  "Datacenters-2"



#### AWS Custom Routers


AWS builds its network routers.

Hamilton showed one from Broadcom - that has 78 transistors and can support up to 128 ports of 25Gb Ethernet each.

AWS runs mostly 25GbE inside its data centers, despite most industry standards running 40 Gigabit Ethernet.
25G Ethernet, creating a 50G Ethernet connection, is less expensive and high bandwidth than a single 40G Ethernet.


![vpc-5]

[vpc-5]: https://libert.xyz/images/vpc-5.png
 "Routers"



#### Software Defined Networking


AWS started relying on the custom hardware NIC (network interface controller) in 2012.
This change reduced the overall Latency and offloaded the servers virtualization.

Sending a package to a neighbor server using Virtualization takes milliseconds.
The package has to go from the

Latency:
application --> GuestOS > Hypervisor >  NIC = Milliseconds
NIC to NIC -> Microseconds
Packet crossing the fiber = Nanoseconds


![vpc-9]

[vpc-9]: https://libert.xyz/images/vpc-9.png
 "Servers"


***
