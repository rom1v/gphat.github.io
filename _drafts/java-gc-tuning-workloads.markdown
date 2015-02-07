---
layout: post
title:  "GC Tuning for Noobs: Part 2, Workloads"
date:   2015-02-01 09:01:08
categories: java gc
---

{% include gc.html %}

When we last met our heroes they had [learned how to establish a baseline and also how to delve in to the JVM's options]({% post_url 2015-01-25-why-garbage-collection %}). With that arcane knowledge we can get started framing the question of how to tune.

# What The Fuck Are You Doing?

Seriously. What are you doing? The app or service or whatever you are making has some sort of workload. Since we're going to need to *size* our JVM, let's cover the implications of size.

# Heaps and Heaps of Memory

First off: Bigger heaps are **not** necessarily better. Bigger heaps often means less frequent GC but it also means that the when you have to pay the GC piper, the cost is higher because there is a lot of shit to dig through!

Most JVM-based OSS projects come with reasonable defaults set through lots of testing and real-world experience. Your project may not have that yet. You'll have to guess.

# Guessing: Trust The Defaults

Start with the defaults. Seriously. The JVM is a pretty spiffy bit of kit. Dumping a bunch of random, pulled-out-of-your-ass options into the mix is just gonna confuse things.

Buuuuut, I'm using the word *guess* on purpose. Every program you write is basically an ugly snowflake, so it's not like someone can tell you what settings to use.

# Informed Guessin'

If your service works with small database rows in a [CRUD](http://en.wikipedia.org/wiki/Create,_read,_update_and_delete)y way then the heap may not need to be very big because none of the objects are very big. If you work with multi-megabyte strings like JSON and you do a *lot* of that work then you'll need more heap. Using a 1GB to 2GB heap is probably a good place to start. We'll learn how to determine if it's the right size later.

# Profilers
