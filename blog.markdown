---
title: Some Things I Wrote
description: A collection of infrequent thoughts on random topics alongside solutions to very specific problems.
layout: index
disable-sidebar-indexes: true
---
{% for post in site.posts %}
<article class="preview">
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
