---
title: Other places you can find me
id: elsewhere
layout: index
description: I like to sign up for things.
disable-sidebar-indexes: true
---

<ul>
{% for profile in site.external_profiles %}
  <li>
    {% if profile.url %}
      <a
        href="{{ profile.url }}"
        {% if profile.fathom_goal_id %} data-fathom-goal-id="{{ profile.fathom_goal_id }}"{% endif %}
      >
    {% else %}
      <div>
    {% endif %}
    <img src="/fontawesome/{{ profile.fontawesome_file }}.svg" alt="" />
    <span>{{ profile.text }}</span>
    {% if profile.url %}
      </a>
    {% else %}
      </div>
    {% endif %}
  </li>
{% endfor %}
</ul>
