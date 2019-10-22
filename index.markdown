---
title: Hello, I'm Craig Anderson
id: home
---

By day, [I'm a freelance web developer specialising in Python and Django](/work). [I've given some talks about my work](/talks), and I hope to give more.

By night, you might find me exploring my adopted home city of London, [playing around in the kitchen](https://www.pinterest.co.uk/craiga/things-i-cooked-that-were-great/), [seeing live music](https://www.songkick.com/users/craigeanderson), or [enjoying craft beer](https://untappd.com/user/craiganderson). When back in [my home town of Melbourne](/melbourne), I might occasionally play bass guitar in [Look Who's Toxic](http://lookwhostoxic.com).

I also run [a Unix Timestamp conversion site](https://www.unixtimesta.mp), [a board game for a podcast I'm a little embarrassed to be subscribed to](http://gagh.biz/game), and [a site tracking upcoming events at Rough Trade stores](https://rough-trade-calendar.herokuapp.com).

## Latest Blog Posts

<div id="home-blog-posts" class="card-deck">
    {% for post in site.posts limit:2 %}
        <a href="{{ post.url }}" class="card">
            {% if post.image %}
                <img src="{{ post.image }}" class="card-img-top" alt="">
            {% endif %}
            <div class="card-body">
                <h3 class="card-title mt-0">{{ post.title }}</h3>
                {% if post.description %}
                    <div class="card-body">{{ post.description }}</div>
                {% endif %}
            </div>
            <div class="card-footer">
              <small class="text-muted">Published {{ post.date | date: "%e %B, %Y" }}</small>
            </div>
        </a>
    {% endfor %}
</div>