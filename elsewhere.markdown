---
title: Other places you can find me on the Internet
---

I like to sign up for things.

<ul>
  {% for profile in site.external_profiles %}
    <li>
      {% if profile.url %}
        <a href="{{ profile.url }}"{% if profile.fathom_goal_id %} data-fathom-goal-id="{{ profile.fathom_goal_id }}"{% endif %}>
      {% else %}
        <span>
      {% endif %}
      {{ profile.text }}
      {% if profile.url %}
        </a>
      {% else %}
        </span>
      {% endif %}
    </li>
  {% endfor %}
</ul>
