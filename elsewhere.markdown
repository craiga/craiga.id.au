---
title: Other places you can find me on the Internet
---

I like to sign up for things.

{% assign item_classes = 'col-lg-4 col-sm-6 col-12 py-1 text-truncate  text-sans-serif' %}
<div class="row no-gutters pb-3">
    {% for profile in site.external_profiles %}
        {% if profile.url %}
          <a class="{{item_classes}}" href="{{ profile.url }}"{% if profile.fathom_goal_id %} data-fathom-goal-id="{{ profile.fathom_goal_id }}"{% endif %}>
        {% else %}
          <span class="{{item_classes}}">
        {% endif %}
            <span class="pseudo-link-underline">
                <img src="/fontawesome/{{ profile.fontawesome_file }}.svg" class="fa-svg">{{ profile.text }}
            </span>
        {% if profile.url %}
          </a>
        {% else %}
          </span>
        {% endif %}
    {% endfor %}
</div>
