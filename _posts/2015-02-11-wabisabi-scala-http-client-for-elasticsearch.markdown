---
layout: post
title:  "Wabisabi: A Scala HTTP Client for ElasticSearch"
date:   2015-02-11 08:01:08
categories: programming oss
---

[ElasticSearch](http://www.elasticsearch.org) is pretty great. I found it after spending a lot of time with [Solr](http://lucene.apache.org/solr/)
in production use. ElasticSearch was _so great_ compared to the state of the art at the time that
I leapt at the chance to use it and have since used it in a few production deployments.

I've also used it in many of my personal projects because it enables such fanastic discovery of information. I occasionally flirt with using it as a database but that's going to require [some more work](https://aphyr.com/posts/317-call-me-maybe-elasticsearch).

# The Client Situation

My initial uses of ElasticSearch (henceforth called ES to save my wrists) leveraged the ability to use an in-VM instance of ES. This was pretty awesome, since I could start ES and use it withouth requiring my users to set up a separate instance. But in production this is a pretty dumb idea, since you'd like to use [shards and replicas](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/_basic_concepts.html#_shards_amp_replicas).

Eventually I decided to leverage an external ES and I used the extensive [native Java API](http://www.elasticsearch.org/guide/en/elasticsearch/client/java-api/current/index.html). Eventually I wanted a slimmer, asynchronous and Scala-native version. [Wabisabi](https://github.com/gphat/wabisabi) was born!

# Thus Wabisabi

[Wabi-sabi](http://en.wikipedia.org/wiki/Wabi-sabi) is about the acceptance of imperfection. This name appealed to me for two reasons. The first was that I knew the client would be iterative and not contain all features in it's first version. The second was that I had no plans to handle *any* JSON parsing to avoid pushing a specific library on the user.

Deal with it!

# How Wabisabi Is Different

[Wabisabi](https://github.com/gphat/wabisabi) is written in Scala. It uses the [HTTP API for ElasticSearch](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-http.html). It uses [Dispatch](http://dispatch.databinder.net/Dispatch.html) to be asynchronous using [Futures](http://docs.scala-lang.org/overviews/core/futures.html). No JSON libraries are required and your narrow ass will have to pass it Strings.

Each of these was novel at the time. There are more [Scala clients](http://www.elasticsearch.org/guide/en/elasticsearch/client/community/current/clients.html#community-scala) now, so you may want to look at them. I haven't. ;)

# Using Wabisabi

[The documentation covers this](https://github.com/gphat/wabisabi#using-it) but it's nice to reiterate here in a more verbose way. Step one is adding the dependency and resolver to your `build.sbt`:

{% highlight scala %}
// Add the Dep
libraryDependencies += "wabisabi" %% "wabisabi" % "2.0.14"

// And a the resolver
resolvers += "gphat" at "https://raw.github.com/gphat/mvn-repo/master/releases/"
{% endhighlight %}

Next, you'll want to set up your connection to the cluster:

{% highlight scala %}
import wabisabi._

val client = new Client("http://localhost:9200")
{% endhighlight %}

I just realized that you might want to connect to one of many instances and providing a single one sort of sucks. Oh well, I'll have to add that. :)

Next we can perform a search:

{% highlight scala %}
val result: Future[Response] = client.search(
    index = "foo",
    query = "{\"query\": { \"match_all\": {} }"
)
{% endhighlight %}

The `Response` above is [Response](http://asynchttpclient.github.io/async-http-client/apidocs/com/ning/http/client/Response.html) from [AsyncHttpClient](https://github.com/AsyncHttpClient/async-http-client) which [Dispatch](http://dispatch.databinder.net/Dispatch.html) is a wrapper around. Notable methods are `getResponseBody`, `getStatusCode` and `getStatusText`. This is an area that could use improvement, as exposing the actual underlying implementation is a shortcoming in my opinion. What if I wanna change?

# That's Not All

Importantly, Wabisabi also implements quite a few of the features that ES exposes. As an example here's a sample that creates an index, verifies it, applies a mapping and creates an alias! I used this to do upgrades of indices without interrupting reads and writes via aliasing.

{% highlight scala %}
esClient.createIndex(name = name, settings = Some(indexSettings)) map { f =>
    esClient.health(indices = Seq(name), waitForNodes = Some(numShards)
} map { f =>
    esClient.putMapping(indices = Seq(name), `type` = typeNames(i), body = aMapping)
    // Create the write alias so that new writes go to the correct index
    esClient.createAlias(actions = """{ "remove": { "index": """" + oldName + """", "alias": """" + n + """-write" } }, { "add": { "index": """" + name  + """", "alias": """" + n + """-write" } }""")
} recover {
    case x: Throwable => {
      Logger.error(s"Failed to create index: $name")
      x.printStackTrace
    }
}
{% endhighlight %}

# The Future

Ha! Future!

Wabisabi is one of my most popular OSS projects and while I'm not currently working on any signficant projects that use ES, I do actively maintain and improve Wabisabi as users send me PRs or issues. If there's something you'd like to see [let me know](https://github.com/gphat/wabisabi/issues)!
