---
layout: post
title: Luminance
description: How to determine if text displayed on top of a colour should be black or white.
date: '2008-10-27T12:22:00+00:00'
date-updated: 2020-06-30T18:50
original_url: http://blog.craiga.id.au/post/56560319/converting-a-color-to-grayscale
---

I've looked for this formula, on average, once a year for the past five or so years. It’s useful for determining what colour text to display over a colour.

Hopefully by posting it here, I’ll be able to find it a bit easier next time.

```
// r, g and b = the red, green and blue components of a colour
luminance = 0.3r + 0.59g + 0.11b
// if luminance > 0.5, display black; otherwise, display white.
```

Update: In 2020—almost 12 years after I orignally wrote it—I'm still refererring back to this post. Here's a simple Sass function to calculate this value for any colour:

```sass
@function luminance($color) {
  @return 0.3 * (red($color) / 255) + 0.59 * (green($color) / 255) + 0.11 * (blue($color) / 255)
}
```
