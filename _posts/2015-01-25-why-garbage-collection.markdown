---
layout: post
title:  "Why Garbage Collection"
date:   2015-01-25 13:51:08
categories: programming gc
---

{% include gc.html %}

Recently I've had to spend some time fiddling with garbage collection at [work](http://keen.io) for new JVM based services and for monitoring existing OSS services. In discussing the JVM and it's GC fun with a friend an interesting question came up: Why is garbage collection such a big deal? A second point also met our attention: Most people don't know what garbage collection is and that it's happening right under their noses.

# Why You Should Give A Fuck

Memory management is not free in any program. Be it assembler, C or Javascript. At some point, even in your high level RoR application memory management will bite you in the ass. It might even be biting you now and you are mistaking it for slowness somewhere else. Or maybe you just have a numb ass.

# Garbage In, Garbage Out

Why does garbage collection exist? The simple answer is because memory management is hard. I spent my fair share of time writing C wherein I had to [malloc and free](http://en.wikipedia.org/wiki/C_dynamic_memory_allocation) everything. This really fucking tedious and error-prone. It's probably worth spending a bit of time talking about what these manual systems do.

Basic, [run-of-the-mill](http://en.wikipedia.org/wiki/C_dynamic_memory_allocation) allocators use heap allocation. Every time you ask for memory with `malloc` the system looks for an unused chunk of memory of the size requested. If it can't find it then it will [increase the heap](http://en.wikipedia.org/wiki/Sbrk). When you call `free` the previously allocated chunks of memory are freed for other uses. This can cause [fragmentation](http://en.wikipedia.org/wiki/Fragmentation_(computing)) and decrease the overall efficiency and speed of your program. Searching for free memory and expanding the heap are not free. Hahah, free.

There are probably lots of other problems with allocators and the Wikipedia article above lists all manner of alternative allocators to address the shortcomings you may run in to. Suffice it to say that manual memory management isn't as easy as it sounds and it's very tedious to do effectively in a large program.

# Automatic Memory Management

Garbage collection is old. It was invented by [John McCarthy](http://en.wikipedia.org/wiki/John_McCarthy_(computer_scientist)) in 195-fucking-9 for use with Lisp. The basic idea is that the system keeps track of the allocation of memory and when it is no longer used. Then it automatically frees the memory so you don't have to. This decreases or eliminates many common programming errors such as [dangling pointers](http://en.wikipedia.org/wiki/Dangling_pointer), [double frees](https://www.owasp.org/index.php/Double_Free) and many types of leaks.

<blockquote class="twitter-tweet" lang="en"><p>garbage collection: ˈgärbij kəˈlekSHən&#10;&#10;noun&#10;&#10;the practice of mortgaging performance</p>&mdash; Cory ᕕ( ᐛ )ᕗ Watson (@gphat) <a href="https://twitter.com/gphat/status/558358029158973440">January 22, 2015</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Garbage collection isn't a panacea though. This automation comes with costs such as tracking overhead and lack of predicability. Since there's a bunch of bookkeeping to be done the allocation of memory and tracking of it's use adds overhead to the running program. When GC decides to run, you have little control over it as the developer.

<div class="panel panel-info">
  <div class="panel-heading">
    <div class="panel-title"><i class="fa fa-question"></i> Interested in Mark and Sweep Basics?</div>
  </div>
  <div class="panel-body">
    If you are interesed in a basic mark and sweep implementation checkout my <a href="https://github.com/gphat/babyvm">babyvm</a> project on GitHub!
  </div>
</div>

# Sneaky GC: Reference Counting

When you think of garbage collection I bet you think of Java and get all dismissive. We'll come back to Java. First, let's talk about the sneaky GC that's happening in your beloved languages:

## Python

Python < 2 used [reference counting](http://en.wikipedia.org/wiki/Garbage_collection_(computer_science)#Reference_counting). Python > 2, confusingly uses "reference counting and garbage collection". To detect cycles Python uses the count of allocated objects versus deallocated objects and, at a certain threshold, performs a collection. This collection goes around looking for cycles to free. You can find your threshold with:
{% highlight python %}
import gc
print "Garbage collection thresholds: %r" % gc.get_threshold()
{% endhighlight %}

There is evidently some sort of generational collection going on in there. The point of this isn't to teach you how Python GC works, though. It's to point out that it's not magic.

## Ruby

For some reason I've been more in tune with Ruby's GC journeys over the years. Before version 2 Ruby used a simple mark and sweep system. When it ran out of space for new shit, the collector would run and free any objects that were no longer referenced. Each object had a flag in it containing information about current references. [In Ruby 2.0 things changed](http://magazine.rubyist.net/?Ruby200SpecialEn-gc) to use bitmap marking. In [Ruby 2.1 generational GC](http://www.infoq.com/news/2013/09/ruby-2-1-gc-revamp) was added.

Not so simple now, eh?

## JavaScript

Even darling [Javscript has GC](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Memory_Management). The implementations are scattered because each browser ships their own JS runtime but as of 2012 all browsers ship a mark-and-sweep GC for Javascript.  Fancy, eh?

**Update 01/25/2015**: As a matter of fact Kaushik Srenevasan, lead on the VM Diagnostics team at Twitter and friend of the show, wrote in to say that JavaScript is "the most advanced VM and GC implementation" and adds "among dynamic language implementations". He further tells us that [V8](https://code.google.com/p/v8/), Google's OSS JavaScript engine, is the latest in a history of virtual machine luminaries that began with [Self](http://en.wikipedia.org/wiki/Self_%28programming_language%29) and preceded through [HotSpot](http://en.wikipedia.org/wiki/HotSpot).

You can [see Kaushik talking about his team's work on JVM profiling on YouTube](https://www.youtube.com/watch?v=Yg6_ulhwLw0).

It's really impressive how quickly JavaScript's technical implementations have grown. It's also very interesting to me that this deeply technical aspect of CompSci so deeply permeates our work and we barely even notice! Yay for the engineers that do this work.  Thanks Kaushik!

## Java

Like any complex machine, Java has a lot of knobs, switches, bells and whistles. Because of the breadth of workloads for Java and, I imagine, because of the technical nature of it's virtual machine, there are *lots* of GC options for Java.

The choices exist because Java takes the stance that no single garbage collection implementation is right for all workloads. The above dynamic languages are proof that your approach to GC must change as a language matures. Furthermore it is a dance to balance different workloads with your GC implementation. Java's GC is modular and therefore some burden is placed on the engineer to figure out how best to use it.

The important choices are between throughput and latency. Throughput optimizes for really fast allocations, but has the downside of low pause times and unpredictable latency. Other collectors offer lower latency and pause times but have lower throughput.

# The Tip Of The Iceberg

The above should give you some reasonable understanding of why GC is such a Big Deal™. Java catches shit for being complicated in this regard. This is a tradeoff of complexity for customization! Even your friendly neighborhood scripting languages make use of garbage collection and the effects can be surprising. In the future, we'll spend more time discussing garbage collection!

# Changelog

* Added point about JavaScript's guts from Kaushik Srenevasan
