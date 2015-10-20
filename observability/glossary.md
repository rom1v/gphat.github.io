---
layout: post
title:  "Glossary"
date:   2015-10-31 23:20:08
categories: observability
---

{% include observability.html %}

## Observability
[Application performance management](https://en.wikipedia.org/wiki/Application_performance_management) is "the monitoring and management of performance and availability of software applications". I like to use "Observability" because it sounds better than "software and practices for monitoring and management of performance and availability of software applications". That's also what we called it [at Twitter](https://blog.twitter.com/2013/observability-at-twitter) so I'm biased.

## Components

The common components of an observability system are:

* [Agent](#agent)
* [Errors](#errors)
* [Events](#events)
* [Log Analysis](#log-analysis)
* [Visualization](#visualization)
* [Monitoring](#monitoring)
* [Notification](#notification)

Some systems represent one or more of these domains. Some try to do most or all of them and are [holistic](#holistic).

## Agent

An agent is a software probe that collects metrics from a monitored system.

## Errors

Errors, similar to [events](#events), generally represent *aperiodic*, unfavorable occurrences but are treated specially! Events:

* Generally represent a unfavorable condition that is diagnosable via context we can store. They often correspond to some sort of code change or can be entered as an issue for tracking.
* Often occur in batches and need some sort of rate limiting to prevent inundating anyone being notified.
* If unique enough, can be stored and monitored for future reoccurrence. Regressions, boo!

## Events

While most data can be represented as a time series, event data often represents *aperiodic* occurrences. This is useful for tracking deploys, new hosts and more. These events are typically too "low-level" individually to warrant notification, but might be useful in the aggregate.

## Holistic

A system **holistic** if addresses *most* of the major [components](#components) of observability in one package.

## Log Analysis

Log output is a rich source of information in many systems. Analyzing and presenting this information can be very valuable when diagnosing or monitoring.

## Monitoring

Monitoring uses the data collected from the systems and, if rules are violated, triggers some sort of [notification](#notification).

## Notification

When a situation warrants attention from a human, systems use notification: email, text messages, phone calls or push notifications. These are often complex rule-based systems to enable the representation of different schedules.

## Visualization

It's not much good to have a bunch of information if there's no way to visualize it. With charts and other widgets you can present the data in more human-digestable ways.
