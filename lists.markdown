---
title: I'm a nerd for making lists
layout: index
---

{% assign lists = site.lists | sort: "date-updated" | reverse %}
{% for list in lists %}
<article class="preview">
  <div>
    <h1><a href="{{ list.url }}">{{ list.title }}</a></h1>
    <p class="small">Last updated {{ list.date-updated | date: "%e %B, %Y" }}.</p>
    {% if list.description %}
        <p>{{ list.description }}</p>
    {% endif %}
  </div>
  {% if list.image %}
    <img src="{{ list.image }}" alt="{{ list.image_description }}">
  {% endif %}
</article>
{% endfor %}
