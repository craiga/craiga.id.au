---
title: Reducing craiga.id.au's Carbon Footprint
date: 2019-07-31 12:00:00 +0100
---

As [promised previously]({% post_url 2019-07-21-green-web-dev %}), I've made some changes to this site to reduce it's carbon footprint.

To recap, I was inspired by a study which identified four kinds of energy use communications technology may be responsible for:

* consumer device;
* network;
* data centre; and
* production of devices.

A post discouraging you from a new smartphone, laptop or internet-connected microwave feels like quite a separate thing from addressing the first three of these points, so I'll focus on those here.

## Reducing Consumer Device Energy Use

### JavaScript and CSS

To measure the impact of JavaScript and CSS on this site, I loaded the site in Safari, then watched Activity Monitor to see how much CPU time was being used.

I then disabled JavaScript and styles in Safari's Develop menu, and repeated the process.

The results each time were about the same: there was a small spike in CPU usage when the page was loaded, but that quickly went down to zero.

From this, I can infer that there's nothing about the JavaScript and CSS on my site which causes any significant device energy use.

### Does Dark Mode Save Power?

Something I've been wondering about for a while was whether bright, white web sites use more power than dark-coloured ones. [Turns out that this was a rather dated notion in 2007](https://www.scientificamerican.com/article/fact-or-fiction-black-is/), but [may be making a comeback with evolving OLED technology](https://www.phonearena.com/news/Smartphone-Displays---AMOLED-vs-LCD_id13824/page/2#media-33658).

 * It's true that a bright, white CRT monitor (with it's electron beam exciting all of the pixels across the screen) used far more power than a black one (which didn't excite any pixels at all).
 * However, LCD screens are a bit more complicated than that. In fact, a black screen on an LCD monitor may use more power than a white one.
 * OLED screens, on the other hand, do use more power to produce a screen full of white pixels.

As it's pretty safe to say that there would be very few CRT screens being used to access this web site, the decision of whether to switch to a darker colour scheme should be decided by LCD vs OLED screens. However, I haven't been able to find any reliable sources on how common OLED screens are, and what the power consumption differences would actually be in practice.

As such, I feel it's a bit premature to switch to dark mode just yet, though I'll certainly be keeping an eye on it.

For what it's worth, this site uses the `prefers-color-scheme: dark` CSS media query. If you have an OLED screen and haven't already, consider enabling dark mode to save a bit of energy.


## Reducing Network Energy Use

My spirits were pretty high after seeing how well my site did with consumer device energy use.

Looking into how bloated this site has become brought them crashing down to earth.

Take a look at how large the front page of this site is:

![Network tab of Safari developer tools before optimisation](/assets/craiga-id-au-carbon-footprint/network-before.png)

Grouping these resources, we see some very hefty assets are being downloaded for what is a very simple page:

| Resource type                                | Size           | %&nbsp;of&nbsp;content | %&nbsp;of&nbsp;content + my&nbsp;face |
| -------------------------------------------- | -------------: | ---------------------: | ------------------------------------: |
| HTML content                                 | 9.10&nbsp;KB   | 100%                   | 9%                                    |
| My face                                      | 83.08&nbsp;KB  | 913%                   | 90%                                   |
| Easter egg (jQuery, JavaScript and MP3 file) | 359.85&nbsp;KB | 3954%                  | 390%                                  |
| CSS (Bootstrap, Font Awesome, and Rouge)     | 223.38&nbsp;KB | 2455%                  | 242%                                  |
| Font Awesome assets                          | 143.76&nbsp;KB | 1580%                  | 156%                                  |
| Google fonts                                 | 40.38&nbsp;KB  | 444%                   | 43%                                   |
| Raven (error reporting)                      | 13.48&nbsp;KB  | 148%                   | 14%                                   |
| -------------------------------------------- | -------------: | ---------------------: | ------------------------------------: |
| Total                                        | 873.03&nbsp;KB | 9594%                  | 947%                                  |
{: .table}

I decided that the HTML of the page and a picture of my face is the important content of the home page, then I measured the size of everything else in relation to that.

Here are the steps I went through to slim this page down:

 * The easter egg I'd included in this website (hidden behind the Konami code and probably never actually discovered) was four times as large as the important content of the home page. It had to go.

 * The combination of Bootstrap and Font Awesome was also far too large for such a simple site. Just by replacing `@import "bootstrap-4.3.1/bootstrap";` with the following (which picks out the parts of Bootstrap I need), I knocked almost 90 kilobytes off the CSS download.

    ```scss
    @import "bootstrap-4.3.1/functions";
    @import "bootstrap-4.3.1/variables";
    @import "bootstrap-4.3.1/mixins";
    @import "bootstrap-4.3.1/root";
    @import "bootstrap-4.3.1/reboot";
    @import "bootstrap-4.3.1/type";
    @import "bootstrap-4.3.1/code";
    @import "bootstrap-4.3.1/grid";
    @import "bootstrap-4.3.1/tables";
    @import "bootstrap-4.3.1/utilities";
    @import "bootstrap-4.3.1/print";
    ```

 * I switched to using individual SVG files from Font Awesome. This cut down the CSS even further, and reduced the size of Font Awesome assets to 8.55 KB.

 * The Google fonts I was using weren't spectacular. Merriweather is *very* similar to Georgia, and I am just as happy using a collection of widely installed fonts for my headings. So I removed the Google Fonts.

 * As I was no longer making use of any client-side script, Raven is no longer required.

After this, the network tab in Developer Tools was looking much better. But there was one more asset I could look at shrinking—the picture of my face.

I had always served this image from Gravatar, a site which serves user avatars to sites which don't want to manage user avatars themselves. I was really surprised by how little the avatar they served was optimised for use on the web.

| Optimisation | Size       |
| ------------ | ---------: |
| Gravatar     | 83&nbsp;KB |
| Unoptimised  | 95&nbsp;KB |
| MozJPEG      | 46&nbsp;KB |
{: .table}

Switching to a version of the image optimised using MozJPEG saved a further 37 KB.

![Network tab of Safari developer tools after optimisation](/assets/craiga-id-au-carbon-footprint/network-after.png)

| Resource type             | Size           | %&nbsp;of&nbsp;content | %&nbsp;of&nbsp;content + my&nbsp;face |
| ------------------------- | -------------: | ---------------------: | ------------------------------------: |
| HTML content              | 8.02&nbsp;KB   | 100%                   | 15%                                   |
| My face                   | 45.42&nbsp;KB  | 566%                   | 85%                                   |
| CSS (Bootstrap and Rouge) | 74.92&nbsp;KB  | 934%                   | 140%                                  |
| Font Awesome icons        | 8.55&nbsp;KB   | 107%                   | 16%                                   |
| ------------------------- | -------------: | ---------------------: | ------------------------------------: |
| Total                     | 174.92&nbsp;KB | 1707%                  | 256%                                  |
{: .table}

Over a weekend afternoon, I went from a total page weight of 873.03 KB (947% of 92.18 KB important content) to just 174.92 KB (256% of 53.44 KB of important content).


### Caching and CDNs

As this site is hosted on GitHub Pages, it is [served from Fastly's CDN](https://www.fastly.com/customers/github) which has [a pretty widespread network](https://www.fastly.com/network-map) which I get for free.

I'm unable to change the site's caching behaviour, but thankfully GitHub Pages' default response headers are pretty much what I'd want. They include a `Cache-Control` header which allows assets to be cached for one hour, and an `ETag` header which clients can use to figure out whether assets are still valid once that hour is up.

Ideally the Font Awesome icons I'm using would come from a separate CDN which serves those assets to lots of sites with a *really* long cache time, but I wasn't able to find a service offering this.

## Reducing Data Centre Energy Use

### GitHub and GitHub Pages

As this is a static web site, it doesn't require much CPU to keep it running. After each commit to the master branch, GitHub compiles the site and puts it onto it's CDN network.

[There's not a lot of information about GitHub and their energy use that I was able to find](https://github.community/t5/How-to-use-Git-and-GitHub/GitHub-s-Data-Centres-and-Renewable-Energy/m-p/28210/thread-id/7954), but there's not a great deal of energy being used generating, storing, and serving the site.

### CircleCI

Before starting this exercise, I ran tests on every change to this site on CircleCI. These tests checked that the site's configuration was not badly broken, and that the site was spelled correctly.

[CircleCI runs on AWS's Eastern US regions](https://discuss.circleci.com/t/where-are-the-build-servers-located-geographically/20571), [which have come under criticism from Greenpeace](https://www.theguardian.com/technology/2019/apr/09/amazon-accused-of-abandoning-100-per-cent-renewable-energy-goal) for not keeping pace with the industry's efforts to switch to 100% renewable energy.

For this site, constant integration isn't that important. I run these same tests in a pre-commit hook, GitHub handles misconfiguration gracefully, and spelling mistakes aren't that big of a deal.

Given this, I've switched CircleCI off for this site.


## Summary

The majority of this work was done over a few hours across two Sundays while enjoying a few beers. I feel like even this small amount of effort has made a big change to amount of energy used by this site.

A nice side-effect of this work has been making this site feel super fast.

There's opportunity to take this even further by switching to a lighter CSS framework (or ditching CSS frameworks all together), but that would involve quite a bit of work.

If you run even a small web presence, I'd recommend that you go through the a similar process.
