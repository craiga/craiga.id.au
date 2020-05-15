---
title: Here are some things I built
id: home
layout: index
---


<article class="thing-i-built">
  <figure><img src="/assets/screenshots/unixtimestamp.jpg"></figure>
  <div>
    <h1><a href="http://unixtimesta.mp">unixtimesta.mp</a></h1>
    <p>Since 2011 I've been running this site which converts Unix Time to and from human-readable time.</p>
  </div>
</article>
<article class="thing-i-built">
  <figure><img src="/assets/screenshots/rough-trade.jpg"></figure>
  <div>
    <h1><a href="https://rough-trade-calendars.craiga.id.au">Rough Trade Calendars</a></h1>
    <p>This sites scrapes roughtrade.com for upcoming events, and then serves iCalendar feeds of those events.</p>
  </div>
</article>
<article class="thing-i-built">
  <figure><img src="/assets/screenshots/will-of-the-prophets.jpg"></figure>
  <div>
    <h1><a href="http://gagh.biz/game">Game of Buttholes: Will of the Prophets</a></h1>
    <p>A site I'm a little bit embarassed to have built for the hosts of one of my favourite podcasts.</p>
  </div>
</article>

<header>
  <h1>Here are some things I wrote</h1>
</header>

{% for post in site.posts %}
<article>
  {% if post.image %}
    <figure><img src="{{ post.image }}" alt="{{ post.image_description }}"></figure>
  {% endif %}
  <div>
    <h1><a href="{{ post.url }}">{{ post.title }}</a></h1>
    <p class="small">Published {{ post.date | date: "%e %B, %Y" }}.</p>
    {% if post.description %}
        <p>{{ post.description }}</p>
    {% endif %}
  </div>
</article>
{% endfor %}
