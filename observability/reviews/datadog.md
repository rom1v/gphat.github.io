---
layout: post
title:  "Datadog"
date:   2015-10-31 23:20:08
categories: observability
---

{% include observability.html %}

Reviewed on 2015-10-19.

## High-Level Overview

Datadog is a **[holistic](/observability/glossary.html#holistic)** system.

## High-Level Design

## Agent

The Datadog Agent is an [open source](https://github.com/DataDog/dd-agent), active agent written in Python.

The agent is [composed of multiple parts that work together](http://help.datadoghq.com/hc/en-us/articles/203034929-What-is-the-Datadog-Agent-What-resources-does-it-consume-).

### Installation

The Datadog agent is [packaged for multiple operating systems](https://app.datadoghq.com/account/settings#agent).

In addition to multiple operating systems there are integrations with popular configuration management tools: Ansible, Chef and Puppet.

### Extensibility

The Datadog team accepts pull-requests and issues via [GitHub](https://github.com/DataDog/dd-agent).

Datadog's documentation refers to an extension to it's agent as a *check*. You can extend the agent by writing [custom checks](http://docs.datadoghq.com/guides/agent_checks/) in Python. The check itself is a simple Python object and method, with configuration from a YAML file with a matching name. The check can be enabled by placing the check's `.py` file and it's config in the appropriate directories and restarting the agent.

There is an included `info` command for verifying the status of plugins to ensure that what you've written works.

### Reliability

If an agent cannot contact the Datadog servers, data is retained *in memory* until a certain number of bytes has accumulated, then the oldest data is dropped first.

### System

Standard metrics are collected for Linux systems. I'm not aware of any notable exclusions.

### Integrations

Datadog claims [100+ integrations](http://docs.datadoghq.com/integrations/). All the standard things are supported. Of particular note are the integrations with AWS, Azure and App Engine. TODO

## Collection

### Resolution

## Events

## Errors

## Visualization

In addition to standard chart types — line, bar and scatter — Datadog also supports heatmaps.

### Querying

Datadog has an extensive [query language](http://docs.datadoghq.com/graphing/)

## Monitoring

## Notification

## Log Analysis

## Support

## Pricing

Pricing is [public](https://www.datadoghq.com/pricing/). Billing is per-host, although per-metric billing seems to be possible. You'll need to contact sales for that. 100 custom metrics are allowed per host, in addition to those from the agent and it's integrations.

<table class="table table-bordered">
 <thead>
  <tr>
   <th>Hosts</th>
   <th>Price</th>
   <th>Retention</th>
   <th>Support</th>
   <th>Notes</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><= 5</td>
   <td>Free</td>
   <td>1 day</td>
   <td>Discussion group</td>
   <td>100 custom metrics per host, events, **no metric alerting**</td>
  </tr>
  <tr>
   <td><= 500</td>
   <td>$18 / host / month, $15 if paid annually</td>
   <td>13 months</td>
   <td>Email</td>
   <td>100 custom metrics per host, events, metric alerting</td>
  </tr>
  <tr>
   <td>> 500</td>
   <td>Custom</td>
   <td>Custom</td>
   <td>Email & Phone</td>
   <td>100 custom metrics per host, events, metric alerting</td>
  </tr>
 </tbody>
</table>
