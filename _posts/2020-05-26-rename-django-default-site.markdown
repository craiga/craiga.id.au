---
title: Renaming example.com, Django's Default Site
date: 2020-05-26 21:25:00 +0100
date-updated: 2020-12-02 12:44:00 +0000
---

When you make use of Django's sites framework, it'll create a default site named "example.com".

This default site will pop up in a few places, and I often see it when making use of [django-allauth](https://django-allauth.readthedocs.io). Out of the box, password reset emails will be sent with the subject "[example.com] Password Reset E-mail", start with "Hello from example.com!", and will go on to mention example.com a couple more times.

Of course you can just rename this default site in admin, but I'm forgetful and want to avoid product launches inviting users to check out "example.com".

---

To rename the site you'll need a data migration, but it's a little tricky to get this right.

The default "example.com" site already exists if you've already run migrations, but it won't exist if you're running migrations to create a new app ([the default site is created in a post-migration hook](https://docs.djangoproject.com/en/stable/ref/contrib/sites/#enabling-the-sites-framework)).

Thankfully, the code which creates the default site is clever enough to check if a site was already created during migrations. So we just need to get in before it tries to be helpful.

After running a few tests, this was the data migration I came up with:

```python
from django.db import migrations


def setup_default_site(apps, schema_editor):
    """
    Set up or rename the default example.com site created by Django.
    """
    Site = apps.get_model("sites", "Site")

    name = "My Cool Site"
    domain = "my-cool-site.craiga.id.au"

    try:
        site = Site.objects.get(domain="example.com")
        site.name = name
        site.domain = domain
        site.save()

    except Site.DoesNotExist:
        # No site with domain example.com exists.
        # Create a default site, but only if no sites exist.
        if Site.objects.count() == 0:
            Site.objects.create(name=name, domain=domain)


class Migration(migrations.Migration):

    dependencies = [
        ("my_cool_site", "0001_initial"),
        ("sites", "0002_alter_domain_unique"),
    ]

    operations = [
        migrations.RunPython(setup_default_site, migrations.RunPython.noop),
    ]
```
