---
title: Some Things I Wrote
---

A collection of infrequent thoughts on random topics alongside solutions to *very* specific problems.

<ul class="list-unstyled">
    {% for post in site.posts %}
        <li class="mb-5">
            <h2 class="h4"><a href="{{ post.url }}">{{ post.title }}</a></h2>
            <p class="small">Published {{ post.date | date: "%e %B, %Y" }}.</p>
            {% if post.description %}
                <p>{{ post.description }}</p>
            {% endif %}
        </li>
    {% endfor %}
</ul>
