---
title: Outsourcing Opinions
description: "or: how I learned to stop worrying and love smart people"
date: 2019-03-21 16:30:00 +0000
---

For years I've been checking [The Wirecutter](https://thewirecutter.com) before making any substantial purchase. It's like a trusted, nerdy friend who's done a ton of research into hundreds of product categories.

If you need a good hammer, [The Wirecutter's got you covered](https://thewirecutter.com/reviews/best-hammer/).

I love The Wirecutter because it's opinionated—it knows what it thinks the best hammer is, and it has the experience, research, and testing to back that opinion up.

---

Software developers can be *extremely* opinionated and unwilling to let go of those opinions.

<p class="video-wrapper video-wrapper-16-9">
    <iframe width="560" height="315" src="https://www.youtube-nocookie.com/embed/SsoOG6ZeyUI" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</p>

As Richard is uneasy about Winnie using spaces over tabs[^spaces-vs-tabs], I felt uneasy when I first unleashed [Black](https://black.readthedocs.io/), a Python auto-formatter, on my code.

Years of practice taught me that Python code should look like this:

```python
data_thing = {
    'string': 'this is a string',
    'user_message': "A message for a user",
    'list_of_ints': [1, 2, 3, 4, 5, 6, 7,
                     8, 9, 10],
}
```

…and that this[^exaggerated-effect] is somehow wrong:

```python
data_thing = {
    "string": "this is a string",
    "user_message": "A message for a user",
    "list_of_ints": [
        1,
        2,
        # …
        9,
        10,
    ],
}
```

Double-quoted strings and lists with one element per line felt ugly and wasteful. Many programmers I've shown Black to have reacted in similar ways.

But once I put those concerns aside and let Black do its job, I felt liberated.

It's *wonderful!*

I no longer need to worry about formatting when I have a class that inherits from multiple mixins with verbose names. I just write what I mean, and let Black decide how to format it. This mess:

```python
class MyCoolModel(model_mixins.CredentialsMixin, model_mixins.UserMixin,
                  model_mixins.EventLogMixin,
                  TimeStampedModel):
```

…becomes sensible and consistent:

```python
class MyCoolModel(
    model_mixins.CredentialsMixin,
    model_mixins.UserMixin,
    model_mixins.EventLogMixin,
    TimeStampedModel,
):
```

As The Wirecutter has an opinion on hammers, Black has an opinion on what my class declaration should look like. That opinion is backed up by experience, research, and testing.

---

When the word "opinionated" is characterised [in the dictionary](https://en.oxforddictionaries.com/definition/opinionated), it sounds like a jerk:

> an arrogant and opinionated man

But does it have to be?

---

Last week I came across [Django: An Unofficial Opinionated FAQ](https://blog.doismellburning.co.uk/django-an-unofficial-opinionated-faq/). It draws on the collective knowledge of `#django` on Freenode to give simple, opinionated answers to complex questions.

Just as The Wirecutter and Black have opinions about hammers and code formatting, this guide has excellent answers to questions most Django projects will need to consider at some time.

> **Should I use Gunicorn or uWSGI to run Django?**
>
> Gunicorn.

> **Where should I deploy my app?**
> 
> Heroku.

> **How should I split my settings file between production / development?**
> 
> Don’t.

---

There's no shortage of opinionated people on the internet. Many of them are the jerks the dictionary describes. But there are also many useful opinions out there born of experience, testing and research.

Instead of expending energy researching, comparing options, and coming to decisions yourself, seek out sites and tools with good opinions. They're the quickest shortcuts to getting good answers quickly I know.

Once you've found those opinions, they can be as valuable as you'll let them be.

---

[^spaces-vs-tabs]: Just to be clear, Richard's obviously wrong.

[^exaggerated-effect]: I ran Black with a short line length to exaggerate it's effect.
