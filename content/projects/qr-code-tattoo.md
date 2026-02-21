---
title: 'My QR Code Tattoo'
date: 2024-09-22T01:48:46Z
draft: false
---

Tattoos are seen as something permanent, so I think a tattoo that changes challenges that idea, and with a little work you can change what a QR code redirects to.

I've also wanted a QR code tattoo for a long time. So last summer, I finally did it, and [posted the code on GitHub](https://github.com/samanthavbarron/qr-code). To do it "correctly" was a fun challenge, and I'm happy with the result.

# Functionality / Longevity

Naturally, I want it to work. Making a QR code is simple, but in order for it to scan, it needs to be visible and not distorted. So it needs to be large enough to be scannable, and large enough so that it can fade/blur over time and still be functional. After reading through [some Reddit comments](https://www.reddit.com/r/tattoofade/comments/7cyk6f/a_5_year_update_on_my_qr_tattoo/), I got an idea of how large it needed to be. Mine ended up being a little larger than 3.5" in width and height.

Another challenge is that it needs to be somewhat flat to scan well. Some people [have studied](https://www.sciencedirect.com/science/article/pii/S0010448520301548) how well QR codes can be scanned when placed on a curved surface. I considered trying to deform the tattoo itself so from a certain angle it looks like it's on a flat surface, but I did not explore this much further. The most viable spot I could think of is below my collarbone and above my breast.

I also went ahead and paid for the domain registration for a decade so I wouldn't accidentally forget to renew it one year.

# Needs to Be "easy" to Tattoo

This was the most challenging part. I needed the QR code to have a small number of corners/borders/etc so that the tattoo itself doesn't have too much detail. This would make it easier to tattoo, but also make it less susceptible to the edges fading/blurring over time.

To do this, I [found a python package](https://pypi.org/project/qrcode/) that lets me generate QR codes. Then, I wrote a few functions to score the QR codes according to several different metrics based off their binary arrays, e.g. the number of corners/crosses in the resulting array.

I then randomized a few million domains with various common TLDs and scored them. After playing around with the weights from the various metrics, I landed on a setting that seemed good, and I picked one. Most of the domains that ended up being generated were available, that ended up not being an issue.

# Modifiable Redirect

Getting the redirect to change isn't interesting from a technical perspective, but a tattoo that changes? That's pretty interesting. I achieved this by [writing a flask app](https://github.com/samanthavbarron/api) which can dynamically change the redirect for one of its routes. In combination with a reverse proxy, this allows me to easily update the redirect to whatever I want from an iOS shortcut. I even have it so that it changes based on my location!

# Choosing an Artist

Finally, I needed a tattoo artist that I trusted. I ended up getting two floral tattoos that have fine lines on them so I could (a) talk to the artist and see if he's up for trying to work through this with me and (b) watch him do linework with fine lines. I did also want the tattoos independent of this, of course!

So I ended up getting it, and it worked! The guy tattooing me thought it was funny when he tested it for the first time and when he scanned it and it opened [his Instagram](https://www.instagram.com/thepapachicken/). I think he was more nervous than I was that it was going to work when he actually tried to scan it.

# Final Thoughts

Something I didn't anticipate was how frequently people would comment on it. I have other tattoos, but random people will usually comment on it if it's visible when I go out. It doesn't bother me, I just didn't expect it. Now I have it so that it automatically switches to the Wikipedia random page redirect when I leave home for privacy.

I'm really happy with how the tattoo turned out, I really like how it looks, I learned a lot through the whole process, and I'm happy I went through with it.
