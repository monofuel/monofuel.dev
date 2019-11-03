---
title: "InfluxDB Raspberry Pi Monitoring Cluster"
author: "monofuel"
date: 2018-08-01T15:01:02.197Z
lastmod: 2019-11-03T04:30:07Z

description: ""

subtitle: "It’s been a while since I last got to work with a Linux cluster, so I decided to build an affordable cluster of raspberry Pi computers. It…"

image: "/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/1.jpeg" 
images:
 - "/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/1.jpeg" 
 - "/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/2.jpeg" 
 - "/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/3.jpeg" 
 - "/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/4.jpeg" 
 - "/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/5.png" 
 - "/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/6.jpeg" 


aliases:
    - "/influxdb-raspberry-pi-monitoring-cluster-23b76621d5b0"
---

It’s been a while since I last got to work with a Linux cluster, so I decided to build an affordable cluster of raspberry Pi computers. It took an entire afternoon to build! The cluster had 16 cores, 4gb of ram, 128gb of storage, a whopping 16 usb ports and only cost about $200. How many clusters do you know with 16 usb ports?




![image](/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/1.jpeg)



I decided to set up my cluster for monitoring my computers using Telegraf to report statistics like CPU and Memory usage. Some more awesome stuff you could do with your very own high performance cluster:

*   run Nagios and Nagios Log Server to actively monitor the network and pull syslogs
*   serve a Plex media server along with any other services you might have for organizing your movies and shows
*   have many Gitlab CI runners to self-host your own CI/CD stack. Bonus points if you test your code on a small pi cluster before you deploy to a big cluster.
*   Manage an economical Blender rendering cluster
*   You could run several cryptocurrency nodes by adding an external hard drive to the cluster.
*   connect each node to a monitor for a sweet video display wall
*   make cool animations by blinking the LEDs on each pi
*   add RGB lighting to the cluster for better performance (maybe color the lights based on temperature?)

Getting the hardware done was easy, the tricky part was automating all the software. I experimented with a few configuration management tools, and found that Ansible works pretty great on the Raspberry Pi. It’s easy to setup and uses very little memory, unlike other tools that would want to pull an entire JRE and use at least 512mb of ram (whyyyy). Another advantage for ansible is it does not require an agent to run on each node, as it works entirely over SSH.

Of course, for a scalable cluster, you don’t want to care about what node work is getting assigned to. Who wants to spend their time figuring out memory requirements and scheduling jobs on different nodes? I wanted to run Grafana and InfluxDB on the cluster, and to not worry about what node has what programs and libraries installed. Docker containers make this easy by packaging up an entire service into a single container that can be assigned to any node. Docker Swarm can orchestrate running your containers across a cluster. Sharing files between nodes is also tricky, so I set up GlusterFS to share storage across the entire cluster.

If you want to follow along and build one yourself, this guide assumes you are familiar with Linux and using a Raspberry Pi.

### Step 1: Parts List

I happened to have the tools to make ethernet cables already, so I crimped custom length cables for the project. 3D printed parts were printed in Blue ABS on my Makerfarm Prusa i3.

Investing in some Ethernet crimping tools and learning how to cut your own cables is worth it, having perfect length cables and being able to replace broken connectors (like if the tab on the top breaks) is very handy.

If you don’t have a 3D printer, look to see if a nearby hackerspace or your local library has one that could print the cases for you. There are many stackable cases on [thingiverse](https://www.thingiverse.com/) you can choose from. Or you could just build a self replicating [reprap](https://reprap.org/wiki/RepRap_Machines), it’s not that hard and having your own printer is pretty awesome. You could print cool things like [Gameboys](https://twitter.com/monofuel34089/status/1011013405111533568), [Spaceships](https://twitter.com/monofuel34089/status/1024219492774162432), [a whole lot of spaceships](https://photos.app.goo.gl/vQRweJ5W9vSfoan99), [jesus that’s a lot of spaceships](https://twitter.com/monofuel34089/status/983137712403181568).

*   [5V switch](https://www.amazon.com/gp/product/B000FNFSPY/ref=as_li_qf_asin_il_tl?ie=UTF8&amp;tag=monomedium-20&amp;creative=9325&amp;linkCode=as2&amp;creativeASIN=B000FNFSPY&amp;linkId=dc2d3455193c0e1745783d03c7fbe7ca) (paid link)
*   [12A USB charger](https://www.amazon.com/gp/product/B00OQ19QYA/ref=as_li_qf_asin_il_tl?ie=UTF8&amp;tag=monomedium-20&amp;creative=9325&amp;linkCode=as2&amp;creativeASIN=B00OQ19QYA&amp;linkId=5064cb6d4aa2814b82c4c52df087e885) (paid link)
*   4x [Raspberry Pi 3](https://www.amazon.com/gp/product/B01LPLPBS8/ref=as_li_qf_asin_il_tl?ie=UTF8&amp;tag=monomedium-20&amp;creative=9325&amp;linkCode=as2&amp;creativeASIN=B01LPLPBS8&amp;linkId=78fc541808d3ee997b0ba679529b3ee3) (paid link) (or whatever version you can get your hands on, could even mix and match if you are up for the challenge)
*   4x [micro SD cards](https://www.amazon.com/gp/product/B07N34RP5L/ref=as_li_qf_asin_il_tl?ie=UTF8&amp;tag=monomedium-20&amp;creative=9325&amp;linkCode=as2&amp;creativeASIN=B07N34RP5L&amp;linkId=63507c901176a90077c5c1ccaf3676ca) (paid link). Size and speed will depend on how much you want to pay for. I went with 32gb
*   [short usb cable pack](https://www.amazon.com/gp/product/B00ZGVMNRQ/ref=as_li_qf_asin_il_tl?ie=UTF8&amp;tag=monomedium-20&amp;creative=9325&amp;linkCode=as2&amp;creativeASIN=B00ZGVMNRQ&amp;linkId=f19e893c67fe9dcaa969bef04313216c) (paid link)
*   4x raspberry pi stacking case: [https://www.thingiverse.com/thing:2187350](https://www.thingiverse.com/thing:2187350)
*   [sticky back velcro](https://www.amazon.com/gp/product/B000TGSPV6/ref=as_li_qf_asin_il_tl?ie=UTF8&amp;tag=monomedium-20&amp;creative=9325&amp;linkCode=as2&amp;creativeASIN=B000TGSPV6&amp;linkId=ee44e9af4aea569ae8e849cb121dcd6c) (paid link)
*   [velcro wrap](https://www.amazon.com/gp/product/B00A4FH34M/ref=as_li_qf_asin_il_tl?ie=UTF8&amp;tag=monomedium-20&amp;creative=9325&amp;linkCode=as2&amp;creativeASIN=B00A4FH34M&amp;linkId=7b04fd0f0236020fea0f52d90410fd27) (paid link)
*   optional: [usb hard drive](https://www.amazon.com/gp/product/B07CRG7BBH/ref=as_li_qf_asin_il_tl?ie=UTF8&amp;tag=monomedium-20&amp;creative=9325&amp;linkCode=as2&amp;creativeASIN=B07CRG7BBH&amp;linkId=af2cde006955f0933d906ddd0f225a47) (paid link)

### Assembling

I started by testing all the parts together. I crimped a couple of short 1 ft ethernet cables to connect each pi to the switch. Then I installed Raspbian on 4 sd cards and inserted them into each pi, and powered them all from the USB charger. I checked the status page on my OpenWRT router and verified that each pi got an IP and that I could log into each one as the pi user. Assuming nothing releases magic smoke, you are probably good. If magic smoke is released, you have done something wrong and should go back to step 1. If all the lights blink, you are most likely good. If you can SSH into each Pi, things are definitely working.

Once I knew all the hardware worked, I picked a random stackable pi case on thingiverse and started printing 4 of them. Printing cases can take a while, so you can start to tinker with the software during this time. I used blue plastic because that’s what I happened to have in the printer at the time, and was too lazy to change it.




![image](/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/2.jpeg)



I applied 2 rows of sticky velcro to the power supply and to the network switch. Optionally, you can put opposite velcro on each side of a hard drive, and sandwich it between the switch and the power supply. I would not recommend eating this sandwich though. Then I taped one of the stackable pi cases to the top of the switch. I had to borrow the hard drive from this project to store hundreds of gigs of 5k 360 photos and videos of Iceland, so I’m not currently using it. However if you do have an external drive, you could configure the head node as a NFS server to share the disk to the cluster instead of running glusterfs.




![image](/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/3.jpeg)



I wanted to use only one power cable for the entire cluster, so I chose a low power 5V switch that I could modify to run on USB. I cut the power cable for the switch along with one of the USB cables and spliced the ground and power lines together. Do not wire the data lines (they do not like power). If magic smoke is released when using the expertly crafted adapter, go back to step 1.




![image](/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/4.jpeg)



Once all the cases were printed, I installed a pi on each case and stacked them up. Using some velcro wrap to keep the cables organized (because we are classy and put some effort into cable organization), I connected everything together. I used the 1ft usb cables for the bottom 2 pi’s and 3ft cables for the top 2.

### Networking

There are a few options for networking. The Raspberry Pi 3 has both an ethernet port and wifi as options for connectivity. I connected the switch for my cluster directly to my main network with a crossover cable. Another way could be running the head node as a network gateway and having it connect to your main network with a usb ethernet adapter or through wifi. There are many fancy ways you could do networking, that’s left as an exercise to the reader (I guess if you enjoy debugging networks or something).

### Software

Prepare the micro SD cards with Raspbian stretch (I went with lite), and set up each pi one at a time. These are the very boring manual steps for getting everything ready to be automated by Ansible.

*   add an empty file named `ssh` to the boot partition on the sd card to enable ssh
*   check your router for the IP of each pi and ssh in as the pi user
*   change the default password with `passwd`
*   install any useful tools you like. You could install emacs instead of vim if you’re one of those people. `sudo apt install -y git vim tmux wget make curl`
*   set a good hostname with `sudo vim /etc/hostname` eg: redLeader, red1, red2, red3. I went with whitemage, blackmage, paladin and machinist. Try not to get sucked into spending 4 hours reading [RFC standards for hostnames](https://tools.ietf.org/html/rfc8117)
*   restart the pi after you changed the hostname
*   designate a head node (in my case I chose whitemage, as they keep the party alive) and setup an ssh key with `ssh-keygen`
*   copy the ssh public key from `~/.ssh/id-rsa.pub` to `~/.ssh/authorized_keys` on each node (including the head node)
*   test ssh’ing from the head node to itself (on the network interface, not localhost) and then ssh from the head node to each other node, accepting the host key for each node. This will make sure Ansible can connect automatically to each node.

If you got this far, it’s good to see you didn’t get trapped inside of vim when editing the hostname file. On the head node, you can pull down my git repo of ansible scripts to automate the rest of this setup

`git clone [https://github.com/monofuel/docker-pi-cluster](https://github.com/monofuel/docker-pi-cluster)`

edit hosts.yml with the hostname of the head node and worker nodes, along with any other computers you want to manage. I included my desktop (burtgang) so that the cluster could setup and configure telegraf on it.

depending on your network, you might want to define the IP for each host in `/etc/hosts` to make sure you can talk to each other node by hostname rather than IP.
`[cluster-head]  
whitemage``[cluster-workers]  
blackmage  
paladin  
machinist``[pi-cluster:children]  
cluster-head  
cluster-workers``[desktop]  
burtgang ansible_user=monofuel``[telegraf:children]  
pi-cluster  
desktop`

### Ansible

dirnmngr is required for adding the PPA key for the Ansible repo, you can install it with `apt install -y dirnmngr`. Then you can install the latest version of Ansible by following the debian instructions: [https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-apt-debian](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#latest-releases-via-apt-debian) From this step forward, all the hard bits are automated!

running `ansible-playbook all-playbooks/hosts.yml` will make sure that each node has the hostname for other nodes configured on the current network if your router doesn’t let you connect directly by hostname.

running `ansible-playbook cluster-playbooks/glusterfs.yml` will setup glusterfs across all nodes and mount it at `/mnt/gluster`. You can chown it to the pi user with `sudo chown pi.pi /mnt/gluster` to make it accessible.

running `ansible-playbook cluster-playbooks/docker.yml` will setup docker swarm across the entire cluster. To use docker, you will need to add the pi user to the docker group with `sudo gpasswd -a pi docker`. After adding pi to the group, you need log out and then log back in.

### Docker Swarm

The compose file defines a Grafana service and an Influxdb service. The containers expect folders to exist on the Glusterfs share, you can create them with `mkdir -p /mnt/gluster/home/grafana/{etc,var} &amp;&amp; mkdir -p /mnt/gluster/home/influxdb/`. I was having issues getting the Grafana to run as the pi user with Docker Swarm, so you also need to chown the grafana/var folder for the Grafana user with `sudo chown 472.472 /mnt/gluster/home/grafana/var`. You also need to copy a Grafana config to `grafana/etc/`.

Running `docker stack deploy -c ./docker-compose.yml pi-services` will deploy the containers defined in the compose file to the cluster swarm. Running `docker stack ps pi-services` will check the current status of the deployment. You can then access grafana by browsing to any cluster node on the port 3000. If you have issues, you can run the services locally with `docker-compose up` and looking at the log output.




![image](/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/5.png)



### Telegraf

If you would like to use the cluster to monitor devices on your network with Telegraf, you can run`ansible-playbook all-playbooks/telegraf.yml`. The playbook will install Telegraf on every machine in hosts.yml, and configure Telegraf to report back to the cluster. Additional hosts on your network that you want to control with Ansible will have to be added to hosts.yml and setup for ssh. Telegraf is defined by a role in `roles/telegraf`, and can be automatically installed on armhf or x86 hosts. There are telegraf ansible scripts on ansible galaxy, but I’m not sure if they support arm so I just made my own. Why use someone else’s code when you can invent everything yourself!

### What to Do Next

You can use your own armhf compatible docker compose file to deploy any services to the Raspberry Pi swarm. The compose file I setup has only 2 services, so half the cluster isn’t utilized yet.

### High Tech Cooling Solution

Additional cooling may be desired for true high performance computations. Setting it up with a usb powered fan helps, but I’m sure this could be better with some additional RGB lighting.




![image](/posts/2018-08-01_influxdb-raspberry-pi-monitoring-cluster/images/6.jpeg)



(As an Amazon Associate I earn from qualifying purchases.)
