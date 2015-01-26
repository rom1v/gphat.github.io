---
layout: post
title:  "GC Tuning for Noobs: Part 3"
date:   2015-01-18 09:01:08
categories: java gc
---

The `UseConcMarkSweepGC` actually implicitly enabled `UseParNewGC` but we'll set it explicitly to ensure changes to the JVM don't change the behavior.

# Why In Excruciating Detail?

The default JVM GC setup for 1.7.0_72 at present is to enable `UseParallelOldGC` which is `Parallel Scavenge` for the young gen and `Parallel` for the old gen based on my testing:

```
$ java -Xmx4G -Xms4G -XX:+PrintFlagsFinal -version | grep UseParal
     bool UseParallelGC                            := true            {product}
     bool UseParallelOldGC                          = true            {product}
java version "1.7.0_72"
Java(TM) SE Runtime Environment (build 1.7.0_72-b14)
Java HotSpot(TM) 64-Bit Server VM (build 24.72-b04, mixed mode)
```
So this change adjust things so that CMS and ParNew on.

# Concurrent Mark & Sweep

In the JVM GC world *parallel* means "use multiple threads to perform garbage collection when it's time to do it". *Concurrent* means "try and do GC **while the app is running**".

Woah.  Soak that in!  It's *voodoo*.

This is way more than I want to learn about, but the gist is this: CMS has 6 phases. They execute consecutively and only *two* of them (first and fourth) stop the world. The others run while the JVM is letting code run. Cool!

One other important note: If the above fails to provide enough memory then the JVM will run a good ol' fashioned stop-every-fucking-thing full, serial GC. This is called a "concurrent mode failure" and it's to be avoided.

# ParNew

What is ParNew, you ask? Welp, it's basically the same as the default parallel new collector, but it's special in that is aware of CMS and knows how to interleave it's shit with CMS in a useful way. They should be used together.

```
-XX:+UseParNewGC -J-XX:+UseConcMarkSweepGC
```

# Bonus: What Causes GC to Run?!

From past discussion of the generational system we know what causes minor or new generation collections. What causes tenured / old gen collections?

It gets full.

Seriously, it's that easy! When it can't satisfy a request to allocate, it stops the world and collects in parallel. Buuuut, CMS is a trickster. Since it's going to run at the same time as JVM code it's got to start earlier. There is some sort of rain dance in the JVM that figures this out based on your workload. In *practice* a lot of folks end up setting an *initiating occupancy fraction* via the imaginatively named `CMSInitiatingOccupancyFraction` option. If set to say, 70, then CMS will start doing it's thug thizzle at 70% full. Another fun note: The JVM may completely fucking ignore your `CMSInitiatingOccupancyFraction` unless you *also* turn on `UseCMSInitiatingOccupancyOnly`. That flag says "Shut up, JVM. Use the flag I gave you", natch.
