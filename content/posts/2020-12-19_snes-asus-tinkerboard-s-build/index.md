---
title: "SNES Asus Tinkerboard S Build"
author: "monofuel"
date: 2020-12-19T05:49:27.812Z
lastmod: 2022-01-05T23:29:13Z

description: ""

subtitle: "Building my own Retropie Mini Snes"
tags:
 - Retropie
 - Tinkerboard
 - Twitch
 - Snes

image: "/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/1.jpeg" 
images:
 - "/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/1.jpeg"
 - "/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/2.jpeg"
 - "/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/3.jpeg"
 - "/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/4.jpeg"
 - "/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/5.jpeg"
 - "/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/6.jpeg"
 - "/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/7.jpeg"
 - "/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/8.jpeg"


aliases:
    - "/snes-asus-tinkerboard-s-build-e03cddc270ac"

---

![image](/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/1.jpeg#layoutTextWidth)
Building my own Retropie Mini Snes

When I saw the [Adafruit Pigrrl 2](https://learn.adafruit.com/pigrrl-2), I knew I had to build one with my 3D printer! It took a few days, but it was pretty sweet to build a portable Raspberry Pi gaming system with their kit. While it worked great with NES, SNES, GB and GBA games, it did struggle a bit with N64 games.

So, I decided to look into building a more powerful set-top box to plug into the TV! This build is a little old, but still works. I hope the process may help inspire others.

This blog is supported through Amazon Affiliate links. When you buy through product links, I may earn commissions to help fund future projects.

![image](/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/2.jpeg#layoutTextWidth)


### Parts list for my build

*   [SF30 Pro Controller](https://amzn.to/34r93SA)
*   [Kintaro Snes Case](https://amzn.to/3mztIKx)
*   [Asus Tinkerboard S](https://amzn.to/38x1dZ9)
*   [40mm Noctua Fan](https://amzn.to/3r7W8i9) (after modifying case)
*   [25mm fan](https://amzn.to/3ap5EaX) (for unmodified case)
*   [5V 3A PSU](https://amzn.to/3rasKrB)
*   [32GB Micro SD Card](https://amzn.to/3gYTx5w)

### Kintaro Case

I grew up with a Super Nintendo, so I went with the Kintaro SNES case. It comes with a heatsink intended for the Raspberry Pi 3B (which I confirm works great!). While this heatsink does not fit the Asus Tinkerboard (duh), the Tinkerboard does come with its own small heatsink.

![image](/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/3.jpeg#layoutTextWidth)


The Tinkerboard fits into the lower half of the case without any issues, all the ports line up fine. Thanks to being a Pi compatible, the connector on the top half of the case matches the 40 pin header perfectly. The case had a slot for a 25mm fan, which I had also ordered, but it was really loud.

![image](/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/4.jpeg#layoutTextWidth)


I experimented with blocking the vents on the bottom of the case. This was to try to encourage more airflow over the board to the back of the case. This helped a little bit when I was watching temps while playing games, but it was still a loud fan.

I used a Dremel to remove the mounting bracket for the fan, and replaced it with a 40mm Noctua fan. The Noctua fan ran whisper-quiet, even under full load, and offered plenty of cooling.

![image](/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/5.jpeg#layoutTextWidth)


The case has a few switches on the top. One for power, and one for reset. These are handled by a script that has to be installed on a Raspberry Pi. Keep on reading to see how I modified the script to work on the Tinkerboard!

### The Tinkerboard

The Tinkerboard S is a pretty sweet (but expensive) board with a lot of features. It has a fast CPU and GPU, with very fast eMMC storage built in. One of the downsides is that it is rather power hungry, so it’s recommend to have a high end 5V 3A power supply. It’s much more picky about power than a Raspberry Pi 2 or 3 would be.

![image](/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/6.jpeg#layoutTextWidth)


The Tinkerboard has a full gigabit ethernet port (unlike the Pi 2 or 3). It’s plenty fast for everything I tested on it! I wrote a custom script to handle syncing games + saves to my home server. I was also able to stream to [twitch](https://www.twitch.tv/monofuel) from the Tinkerboard!

I was able to play games on the Tinkerboard S at 1080p 60hz, and also at 4k 30hz, both working fine. Unfortunately this older board can’t do 4k 60hz, so the raspberry pi 4 may be a better choice these days. I’ve made a post about setting up 4k 60hz on the pi 4 [here](https://medium.com/@monofuel34089/running-your-raspberry-pi-4-at-4k60hz-78010a26e98d). I keep my Tinkerboard set for 1080p 60hz for the best performance on retro games.

My motivation to use this board was to run N64 games, which run great on the Tinkerboard with Retropie! I was able to play Zelda: Majora’s Mask just fine at 1080p 60fps.

I installed Armbian onto the built-in 16gb eMMC. The eMMC gave super fast boot-up times, compared to the slower SD card. I mounted the 32gb micro SD card at /home, which is where I put my Retropie games. This makes it easy to expand /home in the future for a bigger SD card with more games, without reinstalling the OS.

![image](/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/7.jpeg#layoutTextWidth)


### SF30 Pro Controller

To match the SNES case, I went with an 8Bitdo SF30 Pro controller. It’s a great retro controller, with extra buttons and joysticks to work with modern games as well. The d-pad and buttons feel like an original SNES controller. I was able to connect it to the Tinkerboard S using bluetooth without any problems.

The SF30 Pro can be used on the Switch like a Pro controller, and plays really well with the classic NES and SNES games that come with Switch Online. It works really well as on PC with Steam as well, after enabling Switch pro controller support.

### KintaroSnes Script

The original [KintaroSnes](https://github.com/MichaelKirsch/KintaroSnes) script was built with the Raspberry Pi in mind. I made a fork, and modified it for the Tinkerboard.

[monofuel/KintaroSnes](https://github.com/monofuel/KintaroSnes)


It needed some tweaks to use the ASUS GPIO library, and change how the script fetches the CPU temperature here: [https://github.com/monofuel/KintaroSnes/commit/fc9486a3c95383647415c7e7b4d23b6b178f1be5](https://github.com/monofuel/KintaroSnes/commit/fc9486a3c95383647415c7e7b4d23b6b178f1be5)

I tweaked the script to start the fan at 100% speed on bootup, to get the fan to start moving. On default it would start at 0%, and the fan doesn’t always start moving at low power.

### Ansible Scripts

My dream for setting up the software would be to have an automated system to build Retropie images for the Tinkerboard. I chose to go with Armbian as the OS, as they have really nice scripts and documentation to automate building &amp; testing images. Unfortunately I didn’t fit this in the scope of the project, but it would be nice to do in the future!

To configuring the software, I decided to go with Ansible. Ansible performs work via SSH, and does not need a client daemon. I wanted to avoid running any config management [daemons](https://www.reddit.com/r/ProgrammerHumor/comments/6af200/my_boss_is_great_at_many_things_coming_up_with/dheg3aq?utm_source=share&amp;utm_medium=web2x&amp;context=3), to give the most performance for gaming. It should be possible in the future to use the Ansible playbooks when automating building an image from scratch.

I created a repo for my work on automating the software setup:

[monofuel/mono-retropie](https://github.com/monofuel/mono-retropie)


I used these playbooks recently to configure my custom [GammaPi Portable](https://medium.com/@monofuel34089/gammapi-prototype-368f196e001a). One day I would like to have Ansible playbooks to automatically keep all of my retro gaming devices up-to-date and in sync with each other.

Some of the things I got working with Ansible:

*   Set up my customized script for the KintaroSnes case: [https://github.com/monofuel/mono-retropie/blob/master/roles/kintarosnes/tasks/main.yml](https://github.com/monofuel/mono-retropie/blob/master/roles/kintarosnes/tasks/main.yml)
*   Automated the installation of the Mali drivers on Armbian: [https://github.com/monofuel/mono-retropie/blob/master/roles/mali/tasks/main.yml](https://github.com/monofuel/mono-retropie/blob/master/roles/mali/tasks/main.yml) This was confirmed working on Armbian Stretch.
*   (hackily) automated Retropie installation: [https://github.com/monofuel/mono-retropie/blob/master/roles/retropie/tasks/main.yml](https://github.com/monofuel/mono-retropie/blob/master/roles/retropie/tasks/main.yml)
*   Experimented with syncing game saves to my home server; using Unison and NFS: [https://github.com/monofuel/mono-retropie/blob/master/roles/sync/tasks/main.yml](https://github.com/monofuel/mono-retropie/blob/master/roles/sync/tasks/main.yml).

Unison can technically work over SSH, However this would not work correctly as it requires identical Ocaml versions between client and server. I decided to make an NFS share for my home server, then run unison locally to sync between the share and the game folder.

My sync script is ran by a cron job, and automatically syncs games and saves between the SD Card and home server. This could also sync games between multiple Retropie devices, but may have conflicts if you play the same game on multiple devices at the same time.

### twitch streaming

Twitch streaming took a bit to get working, but luckily they had just added RTMP streaming support to retroarch when I started the project!

This is the retroarch record config that worked for me on the Tinkerboard. I saved it as `twitch.cfg` in `/home/monofuel`. This config could be adjusted based on supported codecs and performance.
`vcodec = libx264  
acodec = aac  
pix_fmt = yuv420p  
threads = 3  
scale_factor = 1  
format = flv``video_preset = medium  
video_profile = main  
video_tune = animation  
video_r = 60  
video_g = 120  
video_keyint_min = 60``sample_rate = 44100  
audio_preset = aac_he_v2  
audio_global_quality = 75`

To use this config, I edited `/opt/retropie/configs/snes/emulators.cfg` to add a launch option with streaming.
`lr-snes9x2010-stream = “/opt/retropie/emulators/retroarch/bin/retroarch -L /opt/retropie/libretrocores/lr-snes9x2010/snes9x2010_libretro.so — config /opt/retropie/configs/snes/retroarch.cfg %ROM% — record rtmp://192.168.13.120/myapp/monosnes — recordconfig /home/monofuel/twitch.cfg”`

For my setup, I started an Nginx RTMP relay in a docker container on my network at 192.168.13.120. The Tinkerboard would stream to the Nginx relay, which I added as a source on OBS. This allowed me to use my normal OBS setup on my desktop to stream to Twitch, with my camera &amp; mic. Alternatively, you could stream directly to twitch by using their provided RTMP url.

### Conclusion

I used this project to stream retro games on Twitch for AbleGamers Charity. My favorite game to play on it so far has been [Super Metroid: a Link to the Past crossover randomizer!](https://samus.link/)

![image](/posts/2020-12-19_snes-asus-tinkerboard-s-build/images/8.jpeg#layoutTextWidth)


If you want to talk about cool retro gaming projects, come on over to the [r/SBCGaming](https://www.reddit.com/r/SBCGaming/) Subreddit and Discord!

If you love this project, feel free to follow me on [Medium](https://medium.com/@monofuel34089), [Twitch](https://www.twitch.tv/monofuel), [Twitter](https://twitter.com/monofuel34089), or on [Youtube](https://www.youtube.com/user/monofuel) for more! I also host a backup of my blog at [https://monofuel.dev/](https://monofuel.dev/)

As an Amazon Associate I earn from qualifying purchases. This helps me budget for more projects!
