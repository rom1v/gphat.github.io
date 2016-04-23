---
layout: post
title:  "GC Tuning for Noobs: Part 3, Parallelism"
date:   2016-04-23 09:01:08
categories: java gc
---

We've previously covered [generational garbage collection](http://localhost:4000/java/gc/java-gc-tuning-generational.html) and why it's useful. The division
of memory spaces allows us to more efficiently handle the work of collecting garbage. But that's not the end of optimizations. The next one we're going to
discuss is parallelism.

# Parallel GC

As of Java 8 the [parallel collector is the default for the JVM](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html). It is a
generational collector as we've discussed. The use of the `-XX:+UseParallelGC` flag turns on parallel collection for the young and old generations. The parallel
collector's claim to fame is that it uses multiple threads to do it's work. Aside from the overhead of synchronization and bookkeeping that come with multiple
threads the idea is that multiple threads will make this whole shebang faster by divvying up the work required for scanning and cleaning. This is of **extra**
importance in modern machines with multiple cores!

Using [instructions from our first post](http://onemogin.com/java/gc/java-gc-tuning-for-noobs-1.html) we can find out the defaults of how the parallel GC is
set up:

<pre>
java -XX:+PrintFlagsFinal -version | grep Para
…
    uintx ParallelGCBufferWastePct                  = 10                                  {product}
    uintx ParallelGCThreads                         = 8                                   {product}
     bool ParallelGCVerbose                         = false                               {product}
     …
     bool PrintParallelOldGCPhaseTimes              = false                               {product}
     bool TraceParallelOldGCTasks                   = false                               {product}
     bool UseParallelGC                            := true                                {product}
     bool UseParallelOldGC                          = true                                {product}
java version "1.8.0_66"
Java(TM) SE Runtime Environment (build 1.8.0_66-b17)
Java HotSpot(TM) 64-Bit Server VM (build 25.66-b17, mixed mode)
</pre>

The above is from my Macbook Pro, with some things trimmed out for brevity. By inspecting my machine and it's resources the JVM has
selected `ParallelGCThreads = 8`. That means we'll have 8 threads sharing the load and decreasing our pauses times.

One last, **important** note about the parallel collector: When it pauses to do collection it also pauses your **entire program**. The upside is that being
multithreaded means that pause times are likely lower than the older serial collector!

# Next Level Ish: Concurrent Mark Sweep

We've decreased pause times with the default collector, but we stand to improve pause times even further if we could allow the JVM to do some of it's GC work
concurrently with our running program. This is more complex, of course, as anyone who tries to multi-task will tell you. But the wonderful JVM engineers of the
world have spent countless hours making this work, and we reap the benefits!

You can enable the Concurrent Mark Sweep (CMS) collector via the command line option `XX:+UseConcMarkSweepGC`. CMS is still generational just like the aforementioned
parallel collector, but it has an amazing new trick: much of the work it does to collect garbage is done *while your program is running*.

The magic here is that CMS breaks down it's work in to [a few different phases](https://blogs.oracle.com/jonthecollector/entry/hey_joe_phases_of_cms). Two of
the phases (the first: `mark`, and the fourth: `remark`) require stopping the world. The rest is done concurrently with your program and that means the pause
times can be *deliciously* low.

# A Word On Defaults

Why isn't CMS the default for the JVM? Because there are still reasons you might want to use parallel GC. Imagine an application that crunches a huge amount
of data and spits out an answer, a la Hadoop or friends. These types of workloads typically prefer speed over responsiveness. This is a great place to use the
parallel collector. A web application, meanwhile, needs to make lots of tiny jobs happen quickly and therefore values responsiveness over speed. That's where
CMS comes in.

Generally speaking I immediately change any JVM I run to use CMS. The benefits outlined above are obvious. But as with all things in life, nothing is free.
CMS is not a panacea and we need to cover what can go wrong.

# Paying The Piper: Concurrent Mode Failure

All of this concurrency has a cost. **Not** stopping the world means that application can continue to allocate memory while you work. This is sort like being
a cook and taking orders, but having new guests arrive and leave from the party. Sometimes you'll get caught out and not have enough food (memory) to satisfy
all your customers!

CMS calls this a "concurrent mode failure". All those threads are furiously going about their business as your program runs and sometimes the old generation
(often called "tenured" in JVM docs) fills up *before* the concurrent portions can finish. When this occurs a stop the world (STW) pause kicks as a failsafe to
prevent an `OutOfMemoryError` from shutting down our party. This is often a sign that you need to adjust CMS parameters, increase heap size or modify your
program to allocate less often.

Since CMS needs to run concurrently with our program, it needs to be smart and keep an eye on the workload. Using our earlier cook analogy we can imagine
that the cook is watching the door and eyeing the crowd. These heuristics give the chef some insight in to how much food to make. Back to the JVM, there is some
sort of magic in the JVM that figures this out based on your workload. In *practice* a lot of folks end up setting an "initiating occupancy fraction" via the imaginatively named
`CMSInitiatingOccupancyFraction` option. If set to say, 70, then CMS will start doing it's thug thizzle at 70% full oldgen. Another fun note: The JVM
will completely fucking ignore your `CMSInitiatingOccupancyFraction` unless you *also* turn on `UseCMSInitiatingOccupancyOnly`. That flag says "Shut up, JVM.
Use the flag I gave you", natch. You can use this if you see the old gen filling up and causing concurrent mode failures to give the JVM a stronger hint.

# Putting It All Together

[Anatoliy Sokolenko](http://blog.sokolenko.me/2014/11/javavm-options-production.html) has a great post that summarizes a set of starter JVM options to use
for web-based, responsive-valuing applications. It covers everything I've covered here and adds a few more magical items:

* `-XX:+CMSParallelRemarkEnabled` - This makes the remark phase parallel instead of single threaded. It's not always faster, but a reasonable default for many workloads.
* `-XX:+ScavengeBeforeFullGC -XX:+CMSScavengeBeforeRemark` - Inform CMS to clean up the new gen before a full GC or the remark phase.

That's it, folks! I hope you've find this useful as a starting point for how modern JVM GC works and what you can do to start your program off on a good foot.
