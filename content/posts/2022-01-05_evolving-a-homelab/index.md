---
title: "Evolving a Homelab"
author: "monofuel"
date: 2022-01-05T22:21:07.559Z
lastmod: 2022-01-05T23:29:14Z

description: ""

subtitle: "Take ownership of your data and your security"
tags:
 - Homelab
 - Servers

image: "/posts/2022-01-05_evolving-a-homelab/images/1.jpeg" 
images:
 - "/posts/2022-01-05_evolving-a-homelab/images/1.jpeg"
 - "/posts/2022-01-05_evolving-a-homelab/images/2.jpeg"
 - "/posts/2022-01-05_evolving-a-homelab/images/3.jpeg"
 - "/posts/2022-01-05_evolving-a-homelab/images/4.jpeg"


aliases:
    - "/evolving-a-homelab-7bd7c20973b1"

---

![image](/posts/2022-01-05_evolving-a-homelab/images/1.jpeg#layoutTextWidth)
### Take ownership of your data and your security

I’ve been running a home server for several years, and wanted to document my experiences. This will hopefully help others who want to take better control of their own data. You don’t need a big fancy server to run a homelab, your start can be as humble as a Raspberry Pi!

Aside from making a [3D printed Buster Sword](https://medium.com/@monofuel34089/3d-printed-buster-sword-8e2ea1e6ed64), I’ve had a hobby of setting up services on my homelab. The setup has evolved over the years, and I’ve recently been working on refreshing my hardware. in 2021, I’ve now upgraded to VMware (hopefully writing blog posts will help fund future upgrades!). However this post will talk about the road to get there.

This blog is supported through Amazon Affiliate links. When you buy through product links, I may earn commissions to help fund future projects.

#### Why run a Home Server

It’s easy to want to run everything in the cloud these days. However costs can add up fast, (looking at you- [AWS egress pricing](https://blog.cloudflare.com/aws-egregious-egress/)!) and you don’t really control your own data. The main use I’ve had for my own server has been to store all of my photos, movies, TV shows, and games from the Steam and Epic stores. These libraries can easily be several terabytes (especially with a large Steam library) and can be too expensive to keep only on your desktop computer. A home server can provide a big shared storage space for all the devices on your network, like your laptop or phone.

All of your devices can send backups to the home server, and the home server itself can be backed up to the cloud (eg: Backblaze) or a remote location. You could even set up your own OpenVPN server to allow remote access to your home network when you are on the go. Home servers can also be used for hobby projects, such as running a full Bitcoin node to support the network.

#### The Pets

Initially I started out with 2 home servers that were built around 2013.

![image](/posts/2022-01-05_evolving-a-homelab/images/2.jpeg#layoutTextWidth)
Noctua fans in the ASUS RS100-X7



the first was an [Asus RS100-X7](https://amzn.to/32hQv9t) named ‘King’. I filled it up with 4 sticks of Kingston [8gb ddr3 ecc memory](https://amzn.to/30MjyRQ). This server initially ran CentOS, and was mainly used to host game servers like Minecraft and Starbound. Unfortunately in hindsight, this server does not have IPMI, which would have been worth paying more for. IPMI is a life saver when you need to boot from a remote ISO and have remote access to the video and keyboard. Not having IPMI also meant that there was no out of band fan speed management. Since the fans were kind of loud, I had to install and run `fancontrol` on Linux to make it quieter. I upgraded the fans to [Noctua](https://amzn.to/3mpiPO1) fans when I replaced the OS with ESXI in 2021.

The second server I built was a much larger system named ‘Mjolnir’. It ran FreeNAS 9, and was upgraded over time.

![image](/posts/2022-01-05_evolving-a-homelab/images/3.jpeg#layoutTextWidth)
that’s a lot of bytes



- case: [Silverstone Raven RV03](https://amzn.to/3J72B5X)  
- CPU: dual [AMD opteron 6272](https://amzn.to/3EviOyB)  
- RAM: [Kingston 16GB](https://amzn.to/33OxSKW) (8 sticks, 1 for each channel)   
- [Icy Dock hot swap bay](https://amzn.to/32sHpXr)   
- 5x [WD 4TB Red drives](https://amzn.to/3Fil7Gc)   
- A[sus PIKE card](https://amzn.to/3yPnPk5)

The 5 4TB drives were setup with ZFS RAIDZ on Freenas. I used the FreeNAS plugin system to run services like Plex and Sonarr. I was also able to run hobby projects in VMs using the Virtualbox plugin for Freenas, However this plugin was later discontinued.

These 2 initial servers were treated like pets ([pets vs cattle](https://devops.stackexchange.com/questions/653/what-is-the-definition-of-cattle-not-pets)). I had to manually keep track of updating each server, and manually ssh in to make any changes. This wasn’t a huge deal initially as I only had 2 servers and the free time to manage them, but this would not scale.

The first big roadblock I hit was when a Freenas 9 update stopped supporting the Virtualbox plugin. Later versions of Freenas would use Bhyve for running virtual machines, and use docker for running containers. Migrating to either would require a lot of work. This was the first sign that I needed to think of a more future proofed setup. I was able to roll back to a previous version of Freenas 9 and keep my virtual machines going for the time.

![image](/posts/2022-01-05_evolving-a-homelab/images/4.jpeg#layoutTextWidth)
SSD in the Asus RS100-X7 with a 3D printed adapter



When looking for a potential hypervisor for the homelab, I came across Proxmox. It looked like an easy to use Debian-based hypervisor I could use to manage all the servers from one web interface. Proxmox made it easy to set up VMs across both servers, and gave me a way to run services like Plex in VMs without having to worry about changes in Freenas. I was able to run a newer version of FreeNAS (which renamed to Truenas) in a VM on Proxmox, by using pci passthrough to pass the RAID controller directly to the VM. Passing the RAID card to the Truenas VM gave it direct access to all the disks. This allowed me to run Proxmox on both servers, while also preserving my existing data and NFS shares on ZFS. Proxmox does support ZFS natively, but I still wanted to use some Truenas features like data replication.

Running a cluster with 2 nodes was not a great setup, as Mjolnir was a single point of failure with the RAID. So I got myself a [Truenas Mini](https://amzn.to/3slZzF7) to use as a remote backup server. Data from the Truenas VM on the homelab is replicated to the remote Truenas Mini every night.

My personal gaming computer (named Burtgang) at the time was getting pretty old, and needed to get replaced. I upgraded to an [HP Spectre](https://amzn.to/3yNb5KR) and a R[azer Core X Chroma eGPU](https://amzn.to/3srbT7a). The older gaming PC originally had a Geforce GTX Titan when it was first built. However a few years ago it stopped working, and I replaced with an [EVGA gtx 1070](https://amzn.to/3pi5c57). I took the 1070 out of the gaming pc and used it in the Razer Core with the HP Spectre laptop.

I was later able to do a hot-air reflow to fix the GTX Titan, and managed to get the old gaming PC working again to use in the proxmox cluster. This was pretty awesome, as then I could use pci passthrough to pass the GPU to a VM!

#### Conclusion

This finishes the story of where my homelab was at during 2019 and early 2020. 3 servers running Proxmox. one had a ZFS pool of disks, and one with a GPU.

I learned during this time that it’s important to try to add redundancy while reducing complexity. This can be very difficult when you have a mix of random hardware and a tight budget. Reducing the number of single points of failure make it a lot easier to debug issues and deal with problems when they come up. If you build a system for exactly the capacity you want, you immediately run into problems when things inevitably change. I think it’s a good idea to 2x everything from RAID size to network throughput, to give yourself wiggle room to operate in.

I think it’s also important to try to specialize each piece of the system to a specific task. This helps improve performance and simplify debugging, but does add more costs from more servers and networking. My initial plan when building Mjolnir was to have one big testbed server to do everything. However this quickly breaks down when you start having any performance or stability problems. Having to reboot the entire server and hope it comes back up properly is a huge pain. Debugging performance issues is almost a non-starter, as there are so many processes running it’s hard to diagnose where the bottlenecks are. If I could go back in time to change things, I would have started by having separate servers for Storage and Compute. Having cores dedicated entirely to Storage would be a huge boost to performance and simplicity, especially with a software heavy solution like ZFS.

During 2021 I’ve been migrating to VMWare, and have added additional hardware like a new AMD EPYC server and a nice Unifi switch. I hope to write more posts on the homelab adventure this year!

If you love homelabs, feel free to follow me on Medium, Twitter, or on Youtube for more! I also host a backup of my blog at [https://monofuel.dev/](https://monofuel.dev/)

As an Amazon Associate I earn from qualifying purchases.
