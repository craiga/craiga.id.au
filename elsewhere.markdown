---
title: Other places you can find me on the Internet
---

I like to sign up for things.

{% assign item_classes = 'col-xl-3 col-lg-4 col-sm-6 col-12 py-1 text-truncate text-sans-serif' %}
<div class="row no-gutters pb-3">
    {% for profile in site.external_profiles %}
        {% if profile.url %}
          <a class="{{item_classes}}" href="{{ profile.url }}">
        {% else %}
          <span class="{{item_classes}}">
        {% endif %}
            <i class="{{ profile.fontawesome-classes }} fa-fw" aria-hidden="true"></i>
            {{ profile.text }}
        {% if profile.url %}
          </a>
        {% else %}
          </span>
        {% endif %}
    {% endfor %}
</div>
