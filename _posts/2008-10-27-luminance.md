---
layout: post
title: Luminance
description: How to determine if text displayed on top of a colour should be black or white.
date: '2008-10-27T12:22:00+00:00'
date_updated: 2019-03-19T14:45
original_url: http://blog.craiga.id.au/post/56560319/converting-a-color-to-grayscale
---

I've looked for this formula, on average, once a year for the past five or so years. It’s useful for determining what colour text to display over a colour.

Hopefully by posting it here, I’ll be able to find it a bit easier next time.

```
// r, g and b = the red, green and blue components of a colour
luminance = 0.3r + 0.59g + 0.11b
// if luminance > 0.5, display white; otherwise, display black.
```
