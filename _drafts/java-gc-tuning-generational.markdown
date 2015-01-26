## Generations and Ratios

To speed things up the JVM uses a *generational* system. When an object is created it is allocated in the *young generation*. If it stays around for a while (i.e. is still in use or has references in the running program) then it is *promoted* to the *old generation*.

We'll cover this more later. For now it's important to know that the size of these generations are dictated by the heap and some ratios.

Referring back to our [defaultsFIXME]() we can find the ratio!

`NewRatio` defaults to 2. The [JVM options](http://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html) docs say that this means the ratio of old/new generation sizes will be 2. In other words we'll have 1/3rd of the heap dedicated to *new generation* and 2/3rds for the *old generation*.

The new generation isn't just a big pile of memory. It's composed of *survivor spaces* and *eden*. The eden portion of the new generation is where newly created objects are allocated.

## Survivor Spaces

The new generation portion of the heap has another, less discussed, job. That's to contain the *survivor spaces*.

The survivor spaces play an integral role in the generational system. There are *two* survivor spaces. The survivor spaces don't consume the entire new generation. The size of the two survivor spaces are controlled by the `SurvivorRatio` parameter. It [defaultsFIXME]() to 8 in FIXME JVM. This tells the JVM to make **each** survivor space to 1:8 with the eden space. With these defaults we'll end up with:

* Two survivor spaces, each 1/8th of the size of the total *new generation*
* An eden space that is 3/4ths (simplified from 6/8ths) of the total *new generation*.

## I Will Survive, The Object Lifecycle

When a java object is created memory is allocated in the *eden space* to hold it. This is, of course, a limited resource. At some point eden will be full and we'll need to clean it up. We won't cover the triggers for eden GC, but we'll talk about what happens when it runs!

Firstly, cleaning up eden is called a *minor collection*. It's called minor because it's usually trivially fast. The garbage collector scans the objects in eden and separates the wheat from the chaff. Objects that are still "alive" are copied into survivor space A. The collector can then mark the the *entire* eden space as free because remaining objects are garbage!

## The Juggle is Real

Now we've moved a batch of still-alive objects into survivor space A.

The **next** time a minor GC occurs, the JVM does the same thing. But this time it looks at eden *and* the survivor space A. It determines what objects are alive in these two places and copies all of them in to survivor space B. It continues this back and forth "juggling" of objects.

## Getting Out of the Juggle

The JVM doesn't just promote any ol' object into the *old generation*. The old generation is a quiet place that we hope to avoid collecting very often. To get there the object must first stay alive for a while. This is called *tenure* in the JVM and when you've hit the right amount of tenure you get *promoted* into the *old generation*.

Tenure is a value that the JVM defines for you based on it's understanding of the memory situation. This can be artificially chosen, if you like, via the `MaxTenuringThreshold` parameter. Ours defaults
to `15` with default options, but can change since it's a `product`.

You may be asking what tenure is. Tenure is the number of GC cycles that an object has survived. Each iteration of GC increases the object's tenure counter.

## NewSize

The `NewSize` option allows you to explicitly define the size of the new generation.

**NewSize**: The new size normally defaults to an initial size that is 1/3rd of the total heap size. We're artificially setting this lower. Unless we know *why* it's better to let the JVM decide this for us.

Note that `MaxNewSize` dictates the **maximum** size. We're not touching that so we can look at a long-running JVM and determine if it's upped the default through it's own machinations.

## Checking Current Usage

FIXME All of our topologies specify this `NewSize` parameter at 128M. Let's take a look at one of our production machines with a long-running topology and see where we're at. We already know from the above discussion that the `NewSize` parameter specifies an **initial** size. If the JVM has decided we need more, then it will allocate it and change up the heap.

### Query Topology

Our first candidate is a query topology. It's been running for 2 days and 16 hours. That's more than enough time to see all kinds of queries and get good and warmed up.

We'll use JMX and `jvisualvm` to peek into the JVM. We don't have historical data for this right now because we've never been able to get it to work in Storm. :(

Unfortunately there is no JMX parameter to get the size of the new generation. We'll have to infer it from some other spaces!

Here's the numbers we get from poking around in the MemoryPool MBean:

* Par Survivor Space, Peak Usage: 143.131MB
* Par Eden Space, Peak Usage: 1.14537GB

Let's see if the math works out. Since our ratio is 1:8 then the eden should be 75% of the total new generation and the survivor spaces each 12.5%. We've got 1.2885GB of total new generation by adding up eden + 2 x survivor.

Our heap is 4GB, so 1.2885G is pretty damned close to 1/3rd of the heap. We'll call that good enough!

### Write Event Topology

This one has been running for 3d and 22h. Since everything is a ratio and we did the math above, let's just look at Eden:

* Par Eden Space, Peak Usage: 1.14537GB

Again, that's a shitload more than 128M

# Conclusion

Based on the above evidence I think it's clear that we should remove the `NewSize` parameter and let the JVM size this based on it's ratios. This is not a particularly dangerous choice because the JVM is already resizing the `NewSize`. We're just providing it with an inefficient starting default.
