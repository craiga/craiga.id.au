---
title: Some Things I Wrote
---

<ul class="list-unstyled">
    {% for post in site.posts %}
        <li class="mb-5">
            <h2 class="h4"><a href="{{ post.url }}">{{ post.title }}</a></h2>
            {% if post.description %}
                <p>{{ post.description }}</p>
            {% endif %}
        </li>
    {% endfor %}
</ul>
