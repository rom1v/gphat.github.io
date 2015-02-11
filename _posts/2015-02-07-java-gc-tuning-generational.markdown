---
layout: post
title:  "Java GC Tuning for Noobs Part 2: Generational"
date:   2015-02-07 09:01:08
categories: java gc
---

{% include gc.html %}

## Generations and Ratios

To speed things up the JVM uses a generational memory system. When an object is created it is allocated in the young generation. If it stays around for a while (i.e. is still in use or has references in the running program) then it is promoted to the old generation.

Here's a really great diagram of the Java memory model which I found on [Jörg Prante's post about Elasticsearch JVM settings](http://jprante.github.io/2012/11/28/Elasticsearch-Java-Virtual-Machine-settings-explained.html):

![Java Memory Model!](/assets/images/jvm-memory-model.png)

Note that this is largely an explanation for Java 7. Java 8 is a bit different. We'll cover that some other time.

## Why?

The majority of the time the objects you allocate don't live that long. Most are alive for a very brief time and then discarded. With that in mind we could stand to gain a lot of benefit if, instead of one giant heap of memory, we broke things down by **age**. New objects can live in a section that we clean frequently and the few that make it could be moved to other less frequently tended areas.

## The Deets

The JVM attempts to take advantage of the age thing by breaking up the heap into smaller bits. It's important to know that the size of the generations are dictated by the heap size and some ratios. Referring back to our [defaults]({% post_url 2015-01-25-why-garbage-collection %}) we can find the ratio!

`NewRatio` defaults to **2**. The [JVM option docs](http://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html) say that this means the ratio of old/new generation sizes will be **2**. In other words we'll have &#8531; of the heap dedicated to new generation and &#8532; for the old generation.

The new generation isn't just a big pile of memory. It's composed of survivor spaces and eden. The eden portion of the new generation is where newly created objects are allocated.

## Survivor Spaces

As mentioned above, the new generation portion of the heap has another less discussed job. That's to contain the survivor spaces.

The survivor spaces play an integral role in the generational system. There are *two* survivor spaces. The survivor spaces don't consume the entire new generation. The size of the two survivor spaces are controlled by the `SurvivorRatio` parameter. It [defaults]({% post_url 2015-01-25-why-garbage-collection %}) to **8**. This tells the JVM to make **each** survivor space to 1:8 with the eden space. With these defaults we'll end up with:

* Two survivor spaces, each &#8539; of the size of the total *new generation*
* An eden space that is &frac34; of the total new generation.

## I Will Survive, The Object Lifecycle

When a java object is created memory is allocated in the *eden space* to hold it. This is, of course, a limited resource. At some point eden will be full and we'll need to clean it up. We won't cover the triggers for eden GC, but we'll talk about what happens when it runs!

Firstly, cleaning up eden is called a minor collection. It's called minor because it's usually trivially fast. The garbage collector scans the objects in eden and separates the wheat from the chaff. Objects that are still "alive" are copied into survivor space A. The collector can then mark the the *entire* eden space as free because remaining objects are garbage!

## The Juggle is Real

Now we've moved a batch of still-alive objects into survivor space *A*.

The **next** time a minor GC occurs, the JVM does the same thing. But this time it looks at eden *and* the survivor space *A*. It determines what objects are alive in these two places and copies all of them in to survivor space *B*. It continues this back and forth "juggling" of objects for a while.

## Getting Out of the Juggle

The JVM doesn't just promote any ol' object into the old generation. The old generation is a quiet place that we hope to avoid collecting very often. To get there the object must first stay alive for a while. This is called *tenure* in the JVM and when you've hit the right amount of tenure you get *promoted* into the old generation.

Tenure threshold is a value that the JVM defines for you based on it's understanding of the memory situation. This can be artificially chosen, if you like, via the `MaxTenuringThreshold` parameter. Ours defaults
to **15** with default options, but we can change since it's a `product`!

You may be asking what tenure is. Tenure is the number of GC cycles that an object has survived. Each iteration of GC increases the object's tenure counter.

## Putting It Together

Fuuuuck we just spent a lot of time talking about a relatively small part of the JVM and it's memory model.  Why? Because knowing this behavior is important when understanding how to tune GC to your workload. Knowing that you generate lots of short-lived objects is important, as is knowing how many of your objects might make it into the OldGen.

With this information you can use the ratios to determine how your heap will be sliced up for various uses!

Next we'll talk about workloads!

