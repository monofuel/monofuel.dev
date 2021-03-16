---
title: "GammaPi Prototype"
author: "monofuel"
date: 2020-06-28T22:24:22.040Z
lastmod: 2020-11-16T07:01:33Z

description: ""

subtitle: "Designing a 3D printed Raspberry Pi 3 A+ Portable"
tags:
 - Raspberry Pi
 - Adafruit
 - 3D Printing
 - Retro Gaming

image: "/posts/2020-06-28_gammapi-prototype/images/1.jpeg" 
images:
 - "/posts/2020-06-28_gammapi-prototype/images/1.jpeg"
 - "/posts/2020-06-28_gammapi-prototype/images/2.png"
 - "/posts/2020-06-28_gammapi-prototype/images/3.jpeg"
 - "/posts/2020-06-28_gammapi-prototype/images/4.jpeg"
 - "/posts/2020-06-28_gammapi-prototype/images/5.jpeg"
 - "/posts/2020-06-28_gammapi-prototype/images/6.jpeg"


aliases:
    - "/gammapi-prototype-368f196e001a"

---

Designing a 3D printed Raspberry Pi 3 A+ Portable
![image](/posts/2020-06-28_gammapi-prototype/images/1.jpeg#layoutTextWidth)
### history

A couple years ago I bought my first 3D printer kit, a Makerfarm Prusa i3. This last year, I upgraded it into a massive [Makerfarm Pegasus 12&#34;](https://www.makerfarm.com/index.php/3d-printer-kits/12-pegasus-kit.html). Ever since I first got a 3D printer, I’ve been on the lookout for cool things to 3D print.

I grew up playing the Super Nintendo, so the [Adafruit Pigrrl 2](https://learn.adafruit.com/pigrrl-2) looked like an awesome project! I ordered a kit, printed all the parts, spent a few days assembling, and ended up with a working gaming handheld. I even modified the back, to support a right-angle HDMI connector! [thingiverse link](https://www.thingiverse.com/thing:2969569).

However the Pigrrl 2 didn’t really fit in my pocket, and the thin case was kind of brittle when printed in PLA. I tried printing the case in ABS, but it warped too much. So I decided to try to build a [Pigrrl Zero](https://learn.adafruit.com/pigrrl-zero/overview)! It took a lot longer to assemble. There was a lot of careful wiring and soldering, but all that work resulted in a much smaller portable. Unfortunately, the Raspberry Pi Zero w only has 1 core, so this limits what games can be played. Since the Pi Zero is soldered directly to the LCD, it was challenging to try to modify the wiring to add features like an audio port or speaker. I began to wonder if I could reach some sort of balance between the Pigrrl 2 and Pigrrl Zero.

This isn’t my first Raspberry Pi project, feel free to check out my [Raspberry Pi cluster](https://medium.com/@monofuel34089/influxdb-raspberry-pi-monitoring-cluster-23b76621d5b0) or my [talking toaster](https://www.youtube.com/watch?v=CeTM4jQWmZM)!

### About This Post

This will not be a how-to guide on how to build this new portable, but instead a story of what I learned and discovered when designing a gaming handheld. I work as a Software Engineer for my day job, so hardware is not my strong suit! I’m amazed the final results works without releasing the magic smoke.

#### Initial Planning

I began with coming up a list of requirements.

- Good battery life  
- must fit in pocket  
- easy to assemble and modify  
- have an exposed HDMI and audio port  
- must feel durable like an original Gameboy

The requirement of ‘must fit in my pocket’ was hard to narrow down. The Pigrrl 2 does not, but the Pigrrl Zero does. I began with using the dimensions of the original Gameboy to make a mockup for my portable.

![image](/posts/2020-06-28_gammapi-prototype/images/2.png#layoutTextWidth)
The 4 holes in the middle are for 4 bumper buttons- l1, l2, r1 and r2!



With those dimensions in mind, I had to pick a Raspberry Pi to use. The full sized [Raspberry Pi 3 model b](https://amzn.to/35ys46u) (paid link), or the [Pi 4](https://amzn.to/2IH4fjU) (paid link), are both way too big for this. They use a lot of power, and the collection of Ethernet and USB ports on the side take up way too much space. The [Pi Zero](https://amzn.to/3pzgbFF) (paid link) is much smaller, but doesn’t have very much performance. The Pi Zero also has a mini HDMI port, and I don’t really want to mess with adapters.

If I was a bit more skilled with hardware, the Pi Compute Module could have been a good fit. However I wanted to avoid the complexity of designing a custom circuit board, to reduce the scope of the project.

Luckily during the time I was planning the project, the [Raspberry Pi 3 A+](https://amzn.to/3f14yCt) (paid link) came out! This small board has similar specs to the pi 3, except with reduced ram and only 1 USB port on the side. This smaller, simpler board was perfect.

![image](/posts/2020-06-28_gammapi-prototype/images/3.jpeg#layoutTextWidth)


With the board settled on, The next decision was picking out a screen. The Pigrrl 2 featured a really sweet [2.8&#34; PiTFT](https://www.adafruit.com/product/2298) from Adafruit. It has a full 40 pin pass-through header on the back, which was connected to the controller through a ribbon cable. I had to steal this idea, as it made the front of the case easy to work on. However a 2.8&#34; screen was a bit too big for my portable.

The Pigrrl Zero had a much more compact [2.2&#34; PiTFT](https://www.adafruit.com/product/2315), which was soldered directly to the Pi Zero. All of the wires for the controller had to be carefully soldered to the board. While this made the system very compact, I was not a fan of the added difficulty to modify or repair.

![image](/posts/2020-06-28_gammapi-prototype/images/4.jpeg#layoutTextWidth)


A good balance was found with Adafruit’s [2.4&#34; PiTFT](https://www.adafruit.com/product/2455). It was the perfect size for the pi 3 A+! the 2.4&#34; PiTFT had a header that passed through 26 of the 40 pins on the side of the screen. Out of those 26, 10 of them are GPIO, which was enough for all of the front-facing buttons. Out of the remaining 14 pins not passed through, the screen used 5 of those GPIO lines for the buttons along the top. This left 4 GPIO lines to be used on the back buttons for L1, R1, L2 and R2.

The Pigrrl 2 had a front-facing speaker, however I did not like having extra wires running between the back and the front of the case. To help simplify the design, I decided to follow what the Pigrrl Zero did, and not include a speaker. I would rather plug in headphones, or use bluetooth audio. I accomplished this by flipping the pi 3 A+ around, to expose the audio and HDMI ports out of the top. This placed the 40 pin header in the middle of the case, unlike the Pigrrl 2. For the gamma Pi, the 40 pin header is the only connection between the front and back of the case.

#### Learning OpenSCAD

I’m not very experienced with 3D modeling, other than a small amount of work in OpenSCAD and Blender. Since this project needed some precision and careful planning, I decided to go with OpenSCAD to design the Gamma Pi. All of the source code can be found on [github!](https://github.com/monofuel/handheld)

I began by measuring the components that I had, and making models for them on OpenSCAD. modelling the Pi and the PiTFT screen provided a good foundation for designing the rest of the handheld around.

The Pigrrl 2 and Pigrrl Zero both have different variations on the case, with alternative ways to fasten them together. Their most recent versions feature a clamshell design that clicks together. I didn’t really like this, as it placed stress along the horizontal layers of the 3D printed case, which is where 3D printed parts usually break. For the Gamma Pi, I went with a screw on each corner of the case to firmly hold the device together.

Both the Pigrrl 2 and Pigrrl Zero have a lot of flex to the case, as the walls of the case are kind of thin. they were light and quick to print, but felt fragile to hold. They didn’t feel like they could survive a fall like the original Gameboy. I decided to go with a thicker wall the entire way around the case for the Gamma Pi. This does take longer to print, but the fully assembled Gamma Pi feels very solid.

To screw together all the parts, I went with 4–40 3/8&#34; screws that I already had lying around. They were a bit long, so I designed and printed a couple different sizes of washers. This was really handy for the controller, as it gave me some flexibility in the distance between the 3D printed flexible buttons and the switches behind them.

#### Building the Prototype

![image](/posts/2020-06-28_gammapi-prototype/images/5.jpeg#layoutTextWidth)
Wiring and testing the controller buttons



of course, nothing comes together perfect on the first try! I made a mistake on the back of the case, with the positioning of the Powerboost 1000C. i forgot that the connector for the battery sticks out the side, I didn’t include enough room for the cable. I only had to extend the case a few more mm to accommodate the wire, and give more room for the battery.

![image](/posts/2020-06-28_gammapi-prototype/images/6.jpeg#layoutTextWidth)


I tried to include an extra 2 buttons on the front of the case, but failed to notice that I didn’t have enough GPIO pins. I thought I had 2 more free pins, but they were actually in use by the PiTFT. I also needed to cut the backlight trace on the PiTFT to re-gain a GPIO pin to use for a button.

#### Conclusion

Getting to design a custom gameboy sized portable was a great experience, and there is still a lot of customization left to do! the software alone is worthy of it’s own post.

If you would like help with 3D printing or your Raspberry Pi projects, please come ask questions on the [SBC Gaming Discord](https://discord.gg/JdXc6nx)!

If you love this project, feel free to follow me on [Medium](https://medium.com/@monofuel34089), [Twitter](https://twitter.com/monofuel34089), or on [Youtube](https://www.youtube.com/user/monofuel) for more! I also host a backup of my blog at [https://monofuel.dev/](https://monofuel.dev/)

As an Amazon Associate I earn from qualifying purchases.

[Projects · andrew brower / handheld](https://gitlab.com/monofuel34089/handheld)
