---
layout: post
title: Twitter's OAuth Implementation
date: '2010-09-06T03:10:29+01:00'
date_updated: 2019-06-11T13:50
original_url: http://blog.craiga.id.au/post/1072859377/twitters-oauth-implementation
---

[Ryan Paul, writing for Ars Technia](http://arstechnica.com/security/guides/2010/09/twitter-a-case-study-on-how-to-do-oauth-wrong.ars/):

> Aside from handling the consumer secret issue poorly, Twitter's OAuth implementation has a number of bugs, defects, and inconsistencies that pose challenges for users and developers.
> 
> Third-party developers are finding that it is maddeningly difficult to debug client-side support for Twitter's OAuth implementation because Twitter tends to spit out very generic 401 errors for practically every kind of authentication failure. It doesn't provide enough specific feedback to make it possible for the developer to easily troubleshoot or isolate the cause when authentication is unsuccessful.
> 
> This is especially frustrating in situations where authentication is failing because of a bug or defect in Twitter's implementation. For example, authentication will sometimes fail if the system clock on the end user's computer is running slightly fast. This issue has to do with the timestamp that is embedded in the requests, but it's not entirely obvious what causes it to occur.

[The OAuth specification](http://oauth.net/) isn't particularly complicated, but I found writing code to authenticate against Twitter beyond me. In the end, [the OAuth PECL extension](http://pecl.php.net/package/oauth) [descended from heaven to save me](http://toys.lerdorf.com/archives/50-Using-pecloauth-to-post-to-Twitter.html), but I've still got no idea why it works where my own code didn't.

It's nice to know it wasn't just me.
