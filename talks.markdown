---
title: Some Talks I've Given
---

<ul class="list-unstyled">
    {% assign sorted_talks = site.talks | sort: "date" | reverse %}
    {% for talk in sorted_talks %}
        <li class="mb-5">
            <h2 class="h4"><a href="{{ talk.url }}">{{ talk.title }}</a></h2>
            <p class="small">Published {{ talk.date | date: "%e %B, %Y" }}.</p>
            {% if talk.description %}
                <p>{{ talk.description }}</p>
            {% endif %}
        </li>
    {% endfor %}
</ul>

