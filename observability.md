---
layout: page
title: Observability
permalink: /observability/
---

Observability is my specialty!

Through my career as a software engineer, manager and executive a common love of observability has been present.

[Observability](https://en.wikipedia.org/wiki/Observability) is more than monitoring and charts. **Observability is a measure for how well internal states of a system can be inferred by knowledge of its external outputs.** In other words, if you don't have sensors — metrics, logs, etc — that help you understand how your service is working then you can't tell if things are going wrong!

I've spent a lot of my time learning as much as I can about this subject as well as applying my knowledge to the things I work on. My earliest efforts were [a homegrown monitoring tool](http://onemogin.com/observability/tech/let-the-rithm-move-you.html) that I keep on GitHub for posterity.

## Open Source Work

* [Veneur](https://github.com/stripe/veneur) is a server implementation of [Datadog's](https://datadoghq.com) [DogStatsD](http://docs.datadoghq.com/guides/dogstatsd/) that brings efficient performance and the capability to approximate "global" histogram and timer percentiles using [Ted Dunning's t-digest](https://github.com/tdunning/t-digest) approximate histograms and sets using [HyperLogLogs](https://en.wikipedia.org/wiki/HyperLogLog). [You can read about how Stripe uses it](https://stripe.com/blog/introducing-veneur-high-performance-and-global-aggregation-for-datadog).
* [Censorinus](https://github.com/gphat/censorinus) is a JVM — by way of Scala, but with no other dependencies — \*StatsD client with support for both [StatsD](https://github.com/etsy/statsd) and [DogStatsD](http://docs.datadoghq.com/guides/dogstatsd/).
* [datadog-scala](https://github.com/gphat/datadog-scala) is a Scala library for interacting with the [Datadog API](http://docs.datadoghq.com/api/).
* [Dozens of contributions](https://github.com/datadog/dd-agent/pulls?utf8=✓&q=is%3Apr%20author%3Agphat) to [Datadog's monitoring agent](https://github.com/datadog/dd-agent).

## Visualization

* Perl charting library [Chart::Clicker](http://onemogin.com/chart-clicker/), with love to [Infinity Interactive](http://iinteractive.com) for being so supportive and [Stevan Little](https://twitter.com/stevanlittle) for being so inspirational.
* Hobby Javascript charting library [Clack](http://onemogin.com/clack/).

My frustration with charting tools of the day lead me to create my own: a marvelous Perl module called [Chart::Clicker](http://onemogin.com/chart-clicker/). Over years of development I honed my understanding of visualizations needed for performance and health data. My most recent endeavors are in a hobby Javascript library called [Clack](http://onemogin.com/clack/) meant to explore the best mix of performance and usability.

## Professional Work

After joining Twitter in 2012 I quickly found my calling in the Observability team. I [learned, maintained and created some marvelous stuff](https://blog.twitter.com/2013/observability-at-twitter) in that role. My next gig at [Keen IO](https://keen.io) was not specifically observability, but after the lessons learned at Twitter making sure that Keen's systems were as observable as possible was a focus of my work.

After joining Stripe in 2015 I worked to create an Observability team and worked to change Stripe's culture such that observing our systems was a core concern:

<iframe src="https://player.vimeo.com/video/173610034?portrait=0" width="640" height="360" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
<p><a href="https://vimeo.com/173610034">Monitorama PDX 2016 - Cory Watson - Creating A Culture of Observability at Stripe</a> from <a href="https://vimeo.com/monitorama">Monitorama</a> on <a href="https://vimeo.com">Vimeo</a>.</p>

[Here are the slides if you prefer to flip through them rather than listen to me talk](http://www.slideshare.net/CoryWatson8/building-a-culture-of-observability-at-stripe).

# Future

I hope to continue learning, teaching and pushing Observability in to the future. I feel that it is essential to the technical and social well-being of technology companies by keeping operations and teams in tip-top shape!
