---
layout: post
title:  "Observability Primer"
date:   2015-01-18 09:01:08
categories: observability primer
---

Now that we've talked about my [old shit](http://www.onemogin.com/observability/tech/let-the-rithm-move-you.html), my [medium shit](http://www.onemogin.com/observability/charting/a-chart-is-worth-some-words.html) we can mention [my more recent shit](https://blog.twitter.com/2013/observability-at-twitter).

# Twitter

I joined Twitter as an SRE working on [Kestrel](https://github.com/twitter/kestrel). I spent a lot of time on call for Kestrel and that's not relevant to this I guess. Anyway, Twitter's Observability stuff is awesome. [You can read about it](https://blog.twitter.com/2013/observability-at-twitter). I didn't built any of it, but I used the shit out of it, became an expert on it's use, made some contributions and spent some time helping the team make more cool shit as manager. As such I'm probably [as qualified as anyone FIXME](XXXFIXME) to talk about how you can observe systems! Huzzah.

# Observability?

What do I mean when I say *observability*. I don't see this word used a lot in this context. People often talk about monitoring and visualization and metrics, but to me observability covers the whole gamut. Periodic data such as [load average](http://en.wikipedia.org/wiki/Load_%28computing%29) is the common case. Aperiodic events like deployments, machine restarts or package updates are also a consideration. Good luck finding good shit there tho.

# Tools Of The Trade

I'm going to write things that try and sum up the options available to us in the endeavor of obervability. This post will act as a guide for getting started. Hopefully we'll link these lists up over time!

## Agents

## Collectors

## Services
