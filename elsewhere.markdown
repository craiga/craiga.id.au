---
title: Other places you can find me on the Internet
---

I like to sign up for things.

<div class="row no-gutters">
    {% for link in site.external_profiles %}
        <a class="col-md-3 col-sm-4 col-xs-4 py-1 text-truncate text-sans-serif" href="{{ link.url }}">
            <i class="{{ link.fontawesome-classes }} fa-fw" aria-hidden="true"></i>&nbsp; {{ link.name }}
        </a>
    {% endfor %}
</div>
