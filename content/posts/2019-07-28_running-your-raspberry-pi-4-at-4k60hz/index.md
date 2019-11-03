---
title: "Running your Raspberry Pi 4 at 4k60hz"
author: "monofuel"
date: 2019-07-28T02:44:09.791Z
lastmod: 2019-11-03T04:30:09Z

description: ""

subtitle: "It looks so good it hertz"

image: "/posts/2019-07-28_running-your-raspberry-pi-4-at-4k60hz/images/1.jpeg" 
images:
 - "/posts/2019-07-28_running-your-raspberry-pi-4-at-4k60hz/images/1.jpeg" 
 - "/posts/2019-07-28_running-your-raspberry-pi-4-at-4k60hz/images/2.jpeg" 
 - "/posts/2019-07-28_running-your-raspberry-pi-4-at-4k60hz/images/3.png" 
 - "/posts/2019-07-28_running-your-raspberry-pi-4-at-4k60hz/images/4.png" 


aliases:
    - "/running-your-raspberry-pi-4-at-4k60hz-78010a26e98d"
---

#### It looks so good it hertz



![image](/posts/2019-07-28_running-your-raspberry-pi-4-at-4k60hz/images/1.jpeg)

Last week I got a [CanaKit Raspberry Pi 4 Model B 4gb](https://amzn.to/2y6X0Jv) (paid link), and wanted to try Steam Remote Play at 4k60hz. Previously, the Raspberry Pi 3 b+ was limited to 1080p. Other SBCs (Single Board Computers) like the [Asus Tinkerboard](https://amzn.to/32FVBYD) (paid link) could output 4k over HDMI, however it was limited to 30hz.

4k60hz is not enabled out of the box, and may need some extra debugging. At default, the pi will start at 4k30hz, and the mouse will feel sluggish to move around. This can cause issues, as many retro games are meant to run at 60hz and may have flickering issues at 30hz.

### Hardware

I have two 4k monitors to test with. An older BenQ BL3201PH, and a newer [BenQ PD3200U](https://amzn.to/2XSuQRX) (paid link). The PD3200U has HDMI 2.0 ports, and works great at 4k60hz over HDMI. The older BL3201PH has HDMI 1.4 ports, and can only do 4k60hz over DisplayPort. The HDMI 1.4 ports and the DVI port are only capable of doing 4k at 30hz. An active HDMI to DisplayPort adapter could be used with the pi 4, but they are expensive and I don’t have any on hand to test.




![image](/posts/2019-07-28_running-your-raspberry-pi-4-at-4k60hz/images/2.jpeg)



### Cables

I picked up some cables at the local store that were labeled on the packaging as micro HDMI to HDMI 1.4, and I also ordered some [micro HDMI to HDMI 2.0](https://amzn.to/2K6u8af) (paid link) cables on amazon. Both types of cables will happily work with 4k60hz, the only difference I saw is that the HDMI 2.0 cables also supported ethernet. It turns out that they’re both just “high speed HDMI” cables, and that the HDMI version in the name doesn’t matter.

### Software

Out of the box, the pi 4 runs at 4k 30hz. Following the [Official Documentation](https://www.raspberrypi.org/documentation/configuration/hdmi-config.md), you need to add need to add the line `hdmi_enable_4kp60=1` to `/boot/config.txt` to enable 60hz. There is no line for it already, so you can add it by running the following command in a terminal:
`sudo sh -c &#34;echo hdmi_enable_4kp60=1 &gt;&gt; /boot/config.txt&#34;`

After adding the line, you can reboot the raspberry pi to enable the change, however this won’t turn on 60hz just yet.




![image](/posts/2019-07-28_running-your-raspberry-pi-4-at-4k60hz/images/3.png)



Open the Screen Configuration tool from the preferences menu. Right-click HDMI-1 (which is actually HDMI-0 on the board) and make sure 4k 60hz is selected in the Resolution menu(top option). If you don’t see a 60hz option, make sure your using an HDMI 2.0 port and a high-speed HDMI cable. Also make sure you’re plugged into HDMI-0 on the pi (on the left by the power connector), and not HDMI-1 (on the right by the audio connector).




![image](/posts/2019-07-28_running-your-raspberry-pi-4-at-4k60hz/images/4.png)



After enabling 60hz, the mouse should be moving much smoother now!

### Steam Link

The Raspberry Pi deb package from Valve’s [official post](https://steamcommunity.com/app/353380/discussions/0/1743353164093954254/?ctp=4) still works on the pi 4. It can be installed with the following commands in a terminal:
``curl -#Of [http://media.steampowered.com/steamlink/rpi/steamlink_1.0.7_armhf.deb](http://media.steampowered.com/steamlink/rpi/steamlink_1.0.7_armhf.deb)  
sudo dpkg -i steamlink_1.0.7_armhf.deb``

Then, you can configure and run steam link from the games menu! Here’s a side-by-side comparison video, with the pi on the left and PC on the right. Steam Remote Play was left on default settings (balanced) with hardware decoding enabled.






Unfortunately my camera is only 1080p, but it does show how remote play is very responsive and runs at a good framerate. The image quality is sharper on the PC display, but the stream on the pi is pretty close and perfectly playable.

Please leave a comment if you have any tips for steam remote play! If you have any questions, you can find help on the [SBCGaming Discord](https://discord.gg/JdXc6nx).

(As an Amazon Associate I earn from qualifying purchases.)
