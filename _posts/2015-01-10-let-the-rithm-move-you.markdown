---
layout: post
title:  "Let The Rithm Move You"
date:   2015-01-10 23:20:08
categories: observability tech
---

I've been a professional computery person for about 20 years as of the time I'm writing this. I've enjoyed working on ways to make my computer systems shit "observable" for at least 15 of those 20 years.

# Humble Beginnings

My first stab at making systems more observable was a cron job that periodically output [Solaris'](http://en.wikipedia.org/wiki/Solaris_%28operating_system%29) [sar](http://docs.oracle.com/cd/E23824_01/html/821-1451/spmonitor-8.html) counters to… something. I forget were the state was kept. Probably just the filesystem. On a single box, cuz that was how we rolled back then. Each evening, I'd generate a transparent GIF from the day's counters. The fancy tool I wrote, likely some sort of Perl script, let you put in a number of days and *overlaid the fucking GIFs*. Day over day comparison, motherfuckers!

# Overly Ambitious Middles

Fast forward a couple years, but at the same company. Now I'm considerably more badass. I created [Loggerithim](https://github.com/gphat/loggerithim). The idea was to learn the *rhythm* of your systems using software. Algorithim is a software word, sooooo Logger-ithm! Except I didn't know how to spell algarithm at the time. Hyuck!

Loggerithim worked with Solaris and Linux machines, since that's what we ran at this company. Each host ran the [loggeragent](https://github.com/gphat/loggeragent). This agent, written in C, used [plugins](https://github.com/gphat/loggeragent/tree/master/plugins) to enable metric collection, information gathering and even some manner of system automation. The idea that developed over many years was that the system that collected all this data could eventually *act* on it, right?

![Loggerithim!](/assets/images/lr-shot.png)

# So Awesome

Loggerithim was *so* fucking awesome. It did basically everything. Inventory? You got it. It kept historical time series information for all manner of system metrics. It monitored thresholds and notified us of problems. It even logged event data to correlate it with… I dunno *important stuff*. On top of that it [used SSL](https://github.com/gphat/loggeragent/blob/master/src/network.c#L70). For all I know it even used it correctly!

![Loggerithim!](/assets/images/lr-over.png)

To this day former coworkers from that period of my career ask me if I still work on Loggerithim. They remember it proudly and fondly. What's not to love about that?

# A Career Follows

Up to the present day, this has been my *favorite* part of working with complex computer systems. **In some ways I think that I like working with and building these systems so that I can then visualize and study them!**

I hope you've enjoyed this little digression into my past. There's another one of these I'm gonna write up next describing the deep, deep rabbit hole I ended up in after Loggerithim.

