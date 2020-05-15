---
---

# If no_fathom_tracking is on the query string, set a cookie which doesn't expire for a
# long time.
if window.location.href.indexOf("no_fathom_tracking") != -1
  date = new Date()
  date.setTime(date.getTime() + (10*365*24*60*60*1000))  # now + 10 years
  document.cookie = "no_fathom_tracking=true; expires=" + date.toUTCString()
else if window.location.href.indexOf("fathom_tracking") != -1
  document.cookie = "no_fathom_tracking=; expires=Thu, 01 Jan 1970 00:00:00 UTC"

# Add a link to add or remove the no_fathom_tracking cookie.
trackingMessageElement = document.getElementById("tracking-message")
if document.cookie.indexOf("no_fathom_tracking") == -1
  trackingMessageElement.innerHTML = "<a href='?no_fathom_tracking'>Opt out of analytics by setting a cookie.</a>"
else
  trackingMessageElement.innerHTML = "<a href='?fathom_tracking'>Opt in to analytics.</a>"

# For elements with data-fathom-goal-id defined, set up a click handler to report the
# click to Fathom.
for element in document.querySelectorAll("a[data-fathom-goal-id]")
  element.onclick = ->
    if fathom?
      fathom('trackGoal', this.getAttribute("data-fathom-goal-id"), 0)

roomForMoreInSidebar = () ->
  if window.innerWidth < 768
    return false

  mainContent = document.getElementsByTagName("main")[0];
  sidebar = document.getElementById("sidebar")
  mainContentHeight = Array.from(mainContent.children)
    .map (child) ->
      child.offsetHeight
    .reduce (a, b) ->
      a + b
  sidebarHeight = Array.from(sidebar.children)
    .map (child) ->
      child.offsetHeight
    .reduce (a, b) ->
      a + b

  return mainContentHeight > (sidebarHeight + 300)

sidebar = document.getElementById("sidebar")

if roomForMoreInSidebar() and window.location.pathname not in ["/blog", "/"]
  # Add recent blog posts to sidebar
  fetch('/feed.xml')
    .then (response) -> response.text()
    .then (responseText) ->
      parser = new window.DOMParser()
      return parser.parseFromString(responseText, "text/xml")
    .then (responseDom) ->

      blogPostSection = document.createElement("section")
      blogPostSection.setAttribute("id", "sidebar-index")
      header = document.createElement("header")
      heading = document.createElement("h1")
      heading.innerText = "Recent Blog Posts"
      header.appendChild(heading)
      blogPostSection.appendChild(header)
      sidebar.appendChild(blogPostSection)

      dateFormat = Intl.DateTimeFormat("en-AU", {day: "numeric", month: "long", year: "numeric"})

      for entry in responseDom.getElementsByTagName("entry")
        article = document.createElement("article")

        link  = document.createElement("a")
        link.setAttribute("href", entry.getElementsByTagName("link")[0].getAttribute("href"))
        link.innerText = entry.getElementsByTagName("title")[0].textContent

        heading = document.createElement("h1")
        heading.appendChild(link)
        article.appendChild(heading)

        publishedDate = new Date()
        publishedDate.setTime(Date.parse(entry.getElementsByTagName("published")[0].textContent))
        dateline = document.createElement("p")
        dateline.setAttribute("class", "small")
        dateline.innerText = "Published " + dateFormat.format(publishedDate) + "."
        article.appendChild(dateline)

        blogPostSection.appendChild(article)

        if !roomForMoreInSidebar()
          break

      link  = document.createElement("a")
      link.setAttribute("href", "/blog")
      link.innerText = "More…"
      paragraph = document.createElement("p")
      paragraph.appendChild(link)
      footer = document.createElement("footer")
      footer.appendChild(paragraph)
      blogPostSection.appendChild(footer)

