---
title: 'adwatch'
date: 2025-01-16T01:29:14Z
draft: false
---

I hate ads. I especially hate ads when I'm listening to a podcast first thing in the morning.

So I wrote a simple command line utility, [`adwatch`](https://github.com/samanthavbarron/ad-begone/tree/main) which watches a given directory for MP3 files, detects ads in them, and removes them. It is intended for use with Audiobookshelf, which provides exactly this sort of directory.

The way this tool works is by using OpenAI's Whisper Speech-To-Text transcription service, along with the OpenAI Chat Completions API. The latter takes the transcription from the former in chunks of segments, and uses OpenAI's tool functionality to point specifically to where the ads begin and end. Then we can split the MP3 into different parts, drop the ads, and recombine. It also adds a short bell-like notification where ads were removed.

In my testing most of the billing usage from OpenAI's API is due to the Whisper transcription service. Removing ads on a ~20 minute podcast cost me about $0.30, so roughly $1/hour. That's a bit steep for frequent use in my opinion, but since the bottleneck is the transcription and the Whisper model is open source, the costs could likely be improved.
