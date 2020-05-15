---
title: I'm a nerd for making lists
layout: index
---

{% assign sorted_lists = site.lists | sort: "date" | reverse %}
{% for list in sorted_lists %}
<article>
  <div>
    <h1><a href="{{ list.url }}">{{ list.title }}</a></h1>
    <p class="small">Last updated {{ list.date | date: "%e %B, %Y" }}.</p>
    {% if list.description %}
        <p>{{ list.description }}</p>
    {% endif %}
  </div>
  {% if list.image %}
    <img src="{{ list.image }}" alt="{{ list.image_description }}">
  {% endif %}
</article>
{% endfor %}
