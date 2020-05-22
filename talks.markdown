---
title: Some Talks I've Given
layout: index
---
{% assign talks = site.talks | sort: "date" | reverse %}
{% for talk in talks %}
<article class="preview">
  <div>
    <h1><a href="{{ talk.url }}">{{ talk.title }}</a></h1>
    <p class="small">Published {{ talk.date | date: "%e %B, %Y" }}.</p>
    {% if talk.description %}
        <p>{{ talk.description }}</p>
    {% endif %}
  </div>
  {% if talk.image %}
    <img src="{{ talk.image }}" alt="{{ talk.image_description }}">
  {% endif %}
</article>
{% endfor %}
