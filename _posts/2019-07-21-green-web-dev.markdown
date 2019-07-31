---
title: Becoming a Greener Web Developer
description: Thoughts about the climate impact of my work, and what I can do about that impact.
date: 2019-07-21 12:00:00 +0100
date_updated: 2019-07-31 12:00:00 +0100
redirect_from: /2019/07/20/green-web-dev
---

[In 2015, data centres were responsible for about 2% of greenhouse gas emissions, contributing to global warming about as much as the aviation industry.](https://www.theguardian.com/environment/2015/sep/25/server-data-centre-emissions-air-travel-web-google-facebook-greenhouse-gas)

[Consumer devices and network transmission are both projected to use massive amounts of energy in the coming years, possibly increasing that number to 21% by 2030.](https://www.nature.com/articles/d41586-018-06610-y)

As a web developer who knows climate change is the biggest issue facing humanity, this makes for some uncomfortable reading. So I've started looking into what I can do about it.

[The article cited by Nature above](https://www.mdpi.com/2078-1547/6/1/117/htm) identifies four ways a web site might use energy:

* 
{:toc}


I'm planning on focusing on these four ways of using energy to guide changes to the sites I'm responsible for to reduce their carbon footprint.

Here are some of my initial thoughts on how I might do that, and how you might do the same.


# Consumer Device Energy Use

This is the use of energy on the laptop, smartphone, or other device which might be accessing a web site.

Consumer device energy use can be measured with tools like Activity Monitor on Mac OS, Task Manager on Windows, or `top` on Unix.

In my opinion, there's a huge impact which could be made here. Small changes to instructions executed on devices could save a small amount of energy on hundreds, thousands, or millions of devices. A small change multiplied by all of those devices could be massive.

If you've ever used an ad blocker, you've probably observed the extra load advertising and tracking scripts add to many web sites. I encourage people to install ad-blockers to reduce the huge load imposed by those irresponsible scripts[^dont-block-everything]. Anyone with any kind of influence should work to remove such scripts from their sites. Developers should ensure their code is as efficient as it can be.

In my experiments, it seems like CSS animations can be a big, somewhat hidden contributor to consumer device energy use. In the past I've tried adding some subtle animation to this site, but found that it caused unusually high CPU usage in Firefox, which doesn't seem to be as optimised to offload those animations to the GPU as some other browsers. 


# Network Energy Use

This is the energy used delivering data to consumer devices, and is projected to increase massively over the next few years.

Network use can be observed in most browsers' development tools.

In the same way a small change in consumer device energy use can have a massive multiplying effect, reducing the size of a web page by a small amount can also have a big impact.

Obvious ways to reduce network use is to make the files comprising a web site smaller and to eliminate unnecessary downloads.

Setting appropriate caching headers so that resources are only fetched when required can help, as can making use of a CDN to reduce the need to transport data over long distances.


# Data Centre Energy Use

This is the cost of running the site in data centres. This includes web hosting as well as other hosted services: CI/CD, logging, email, monitoring, test servers, and so on.

Energy use in the data centre is far more controllable than the other sources of energy use discussed here. It's possible to ensure that the data centres you use are powered by renewable energy. You can check how power is generated around the world at [Electricity Map](https://www.electricitymap.org), and check specific sites at [The Green Web Foundation](https://www.thegreenwebfoundation.org).

Even if your site is using renewable energy in the data centre, it should still be efficient. I find [Django Debug Toolbar](https://django-debug-toolbar.readthedocs.io/) an invaluable tool to highlight any places for optimisation.


# Production of Devices Energy Use

This is the energy used in manufacturing consumer devices.

Your web site mightn't be able to talk someone out of buying a new iPad, but it should work on old devices.

Also, you should look after the devices you have and only replace them when you have to. I use an iPhone 6s which is coming up to its fourth birthday, and am still quite happy with it. I only recently replaced a 2011 MacBook Air with a 2016 MacBook Pro which I hope to get more than five years life out of.


# Next Steps
{:.no_toc}

From here, I'm going to start implementing changes to sites I'm responsible for to reduce their energy use. These sites include:

 * this site ([some of the changes I made are explained in this blog post]({% post_url 2019-07-30-craiga-id-au-carbon-footprint %}));
 * [Game of Buttholes: Will of the Prophets](http://gagh.biz/game);
 * [unixtimesta.mp](https://www.unixtimesta.mp); and
 * [Rough Trade Calendars](https://rough-trade-calendar.herokuapp.com).

I will write further posts about this process in the hope it will inspire others to make similar changes to their sites.


[^dont-block-everything]: I also encourage people to keep the "allow some non-intrusive ads" option enabled. Not all ads are terrible, and responsible publishers should be supported.

