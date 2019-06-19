---
title: I'm a nerd for making lists
---

<ul class="list-unstyled">
    {% assign sorted_lists = site.lists | sort: "date" | reverse %}
    {% for list in sorted_lists %}
        <li class="mb-5">
            <h2 class="h4"><a href="{{ list.url }}">{{ list.title }}</a></h2>
            <p class="small">Last updated {{ list.date | date: "%e %B, %Y" }}.</p>
            {% if list.description %}
                <p>{{ list.description }}</p>
            {% endif %}
        </li>
    {% endfor %}
</ul>
