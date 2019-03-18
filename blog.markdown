---
title: Some Things I Wrote
---

Solutions to technical problems I've solved with occasional thoughts on random topics.

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
