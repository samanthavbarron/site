---
title: 'ClamNet'
date: 2024-09-22T01:29:14Z
draft: false
image: https://samantha.wiki/images/clamnet_v4.png
---

Note: Images best viewed in light mode, figures censored for privacy

# Introduction

`ClamNet` is the name of my [homelab](https://reddit.com/r/homelab). It started in early 2021 so I could better understand computer networking. My initial curiosity was to answer the question for myself: "When one computer communicates with another, how does that work?" as well as to have better control over my own digital privacy.

The name was chosen because at some point I thought it would be funny to buy domain names about clams. It was. Accordingly, I named the different hosts after different types of clams (in retrospect, there are not a lot of clam names that are short and memorable).

This post is intended to be a brief overview of how `ClamNet` has evolved over time and what I've used it for. This project has been an incredible learning experience. If you are reading this thinking you would like to do something similar or just learn more about computers in general, I would highly recommend it.

# Version 1

The first iteration began with something like the [GL.iNet GL-A1300](https://www.amazon.com/GL-iNet-GL-A1300-Encrypted-Tethering-Pocket-Sized/dp/B0B4ZSR2PX/ref=sr_1_11?crid=2C0BHYRUUOVXS&keywords=gl.inet&qid=1705275144&sprefix=gl.in%2Caps%2C140&sr=8-11&th=1) in my apartment. I started with learning how to forward ports, assign static IP addresses, set up different subnets and firewall rules, etc.

At some point I added a [GL.iNet GL-E750](https://www.amazon.com/GL-iNet-GL-E750-OpenWrt-WireGuard-Installed/dp/B08JP7YWPR/ref=sr_1_20?crid=2C0BHYRUUOVXS&keywords=gl.inet&qid=1705275144&sprefix=gl.in%2Caps%2C140&sr=8-20) mobile router with a Mint Mobile SIM card in it. I did this because I installed [GrapheneOS](https://grapheneos.org) on my phone because I started to get interested in digital privacy and security. I would connect my phone to the mobile router when I wanted to use data. Around this time I was using [QubesOS](https://www.qubes-os.org) as my main operating system. I found this liberating from a digital privacy perspective, but that OS is not very well-suited for every-day use in my opinion.

This setup was incredible for my attention span and relationship with technology, but was ultimately not usable for everyday use. I found it difficult to do things in everyday life without things being clunky or awkward.

![ClamNet V1](/images/clamnet_v1.png)

# Version 2

At some point I repurposed the desktop running [QubesOS](https://www.qubes-os.org/)  into a server (which I named `pearl`) that sat in my closet. Unfortunately, my laptop was stolen around this point. I was too stubborn to buy a new one, and ended up configuring and working on `pearl` exclusively in a terminal on my iPad with [Blink.sh](https://blink.sh/) when setting up [ArchLinux](https://archlinux.org/). After a while I got a new laptop, switched to [Unraid](https://unraid.net/), and then [Ubuntu](https://ubuntu.com/).

During this version I got more comfortable with the basics of networking and started using [Docker](https://www.docker.com/) containers for various services. I got really into Home Assistant and started to better understand firewalls in order to isolate the IOT devices from the more sensitive portions of my network. I also added a media stack. I also added a bunch of monitoring/observability services, some of which I ended up not using much.

Around this time I added a [Digital Ocean](http://digitalocean.com/) instance which hosted a couple public-facing services to isolate them from my home network. Initially this started more as a learning experience with not much functional purpose. But that quickly changed! I also tinkered around with some Cloudflare stuff, but didn't get far with it.

![ClamNet V2](/images/clamnet_v2.png)

# Version 3

In this version, I added a Synology NAS (primarily for backups), which I named `barnacle`. I also started to rely more heavily on cloud VPSs to host certain services. I also replaced Wireguard with TailScale, which allowed me to close all the ports on the more core part of the network.

![ClamNet V3](/images/clamnet_v3.png)

# Version 4 (current)

Changes in this version:

- **Tailscale**: In the last version, I learned how powerful it can be, and I felt more comfortable leaning on it for some core functionality.
- **No more `pearl`**: Over time I had less of a desire to have a desktop running in my apartment hosting services. This comes at the cost of less privacy and a dependency on the internet, but for me this was outweighed by the flexibility in hardware and not having as much stuff in my apartment.

In looking through the services running on `pearl` to see how I would replace/transfer them, there was an obvious barrier. If I were to continue to have a Home Assistant instance, it would need to be able to communicate with the devices on my home network from the cloud. I got around this by installing [TailScale on my Synology NAS](https://tailscale.com/kb/1131/synology), and then using a [subnet router](https://tailscale.com/kb/1019/subnets) to pass traffic between my home network and the rest of my TailNet. Problem solved! After that, the pros outweighed the cons, and I got rid of `pearl`. She served me well. 🫡

I also ended up using [Tailscale DNS](https://tailscale.com/kb/1054/dns) to point all DNS requests on my TailNet towards `ClamNet`. This and the reverse proxy running on `ClamNet` allow me to use sub-domains like `paperless.clamnet.local` throughout my Tailnet. Also, [Tailscale ACLs](https://tailscale.com/kb/1018/acls) allow me to isolate certain device groups from each other.
![ClamNet V4](/images/clamnet_v4.png)

# What's Next?

- **NixOS**: I've heard a lot of good things about NixOS, maybe I'll look into it more.
- **API**: I don't always want to carry my laptop around, so I use my iPad and iPhone for a lot of things. Sometimes firing up a terminal is a bit clunky, especially to do little things. One method of exposing certain functionality would be to use web requests and iOS shortcuts to streamline certain things. This would also allow me to more easily integrate things.
