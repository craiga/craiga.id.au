---
---

# If fathom is blocked, change tracking message to re-enable it.
if localStorage.getItem("blockFathomTracking") == "true"
  trackingMessageElement = document.getElementById("tracking-message")
  trackingMessageElement.setAttribute("href", "javascript:fathom.enableTrackingForMe()")
  trackingMessageElement.innerText = "Opt in to analytics."

# For elements with data-fathom-goal-id defined, set up a click handler to report the
# click to Fathom.
for element in document.querySelectorAll("a[data-fathom-goal-id]")
  element.onclick = ->
    if fathom?
      fathom('trackGoal', this.getAttribute("data-fathom-goal-id"), 0)


getRoomInSidebar = () ->
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

  return mainContentHeight - sidebarHeight


hiddenArticlesRemainInSidebarIndex = (sidebarIndex) ->
  for article in sidebarIndex.getElementsByTagName("article")
    if getComputedStyle(article).getPropertyValue("display") == "none"
      if not articleLinksToCurrentPage(article)
        return true

  return false


hiddenArticlesRemain = () ->
  for sidebarIndex in document.getElementsByClassName("sidebar-index")
    if hiddenArticlesRemainInSidebarIndex(sidebarIndex)
      return true

  return false


articleLinksToCurrentPage = (article) ->
  for a in article.getElementsByTagName("a")
    if a.href == window.location.href
      return true

  return false


redrawSidebar = () ->
  # Hide everything in each sidebar index.
  for sidebarIndex in document.getElementsByClassName("sidebar-index")
    for element in sidebarIndex.children
      element.style.display = "none"

  roomForAnotherIndex = 600
  roomForAnotherArticle = 300

  if getRoomInSidebar() > roomForAnotherIndex

    # If there's space, show the header, footer and first two articles in each sidebar index.
    for sidebarIndex in document.getElementsByClassName("sidebar-index")
      if getRoomInSidebar() > roomForAnotherIndex
        for header in sidebarIndex.getElementsByTagName("header")
          header.style.display = "block"
        for footer in sidebarIndex.getElementsByTagName("footer")
          footer.style.display = "block"

        articlesShown = 0
        for article in sidebarIndex.getElementsByTagName("article")
          if articleLinksToCurrentPage(article)
            continue

          article.style.display = "block"

          articlesShown += 1
          if articlesShown >= 2
            break

        if not hiddenArticlesRemainInSidebarIndex(sidebarIndex)
          for footer in sidebarIndex.getElementsByTagName("footer")
            footer.style.display = "none"

    for i in [0..20]
      if getRoomInSidebar() < roomForAnotherArticle or not hiddenArticlesRemain()
        break

      for sidebarIndex in document.getElementsByClassName("sidebar-index")
        if getRoomInSidebar() < roomForAnotherArticle
          break

        if not hiddenArticlesRemainInSidebarIndex(sidebarIndex)
          break

        for article in sidebarIndex.getElementsByTagName("article")
          if articleLinksToCurrentPage(article)
            continue

          if getComputedStyle(article).getPropertyValue("display") == "none"
            article.style.display = "block"

            if not hiddenArticlesRemainInSidebarIndex(sidebarIndex)
              for footer in sidebarIndex.getElementsByTagName("footer")
                footer.style.display = "none"

            break

redrawSidebar()
window.addEventListener("load", redrawSidebar)
window.addEventListener("resize", redrawSidebar)


fetch("//ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=craiganderson&period=7day&api_key=ad34f34858f38de2ed2a097d31a882eb&format=json")
  .then (response) -> response.json()
  .then (responseData) ->
    artists = responseData.topartists.artist
    if artists.length > 3
      lastFmPlaceholder = document.getElementById("lastfm-placeholder")
      fathomGoalId = lastFmPlaceholder.getElementsByTagName("a")[0].getAttribute("data-fathom-goal-id")

      lastFmPlaceholder.innerText = ""

      link = document.createElement("a")
      link.setAttribute("href", "https://www.last.fm/user/craiganderson")
      link.setAttribute("data-fathom-goal-id", fathomGoalId)
      link.innerText = "Lately I've been listening to"
      lastFmPlaceholder.appendChild(link)

      linkForArtist = (artist, fathomGoalId) ->
        link = document.createElement("a")
        link.setAttribute("href", artist.url)
        link.setAttribute("data-fathom-goal-id", fathomGoalId)
        link.innerText = artist.name
        return link

      lastFmPlaceholder.appendChild(document.createTextNode(" "))
      lastFmPlaceholder.appendChild(linkForArtist(artists[0], fathomGoalId))
      lastFmPlaceholder.appendChild(document.createTextNode(", "))
      lastFmPlaceholder.appendChild(linkForArtist(artists[1], fathomGoalId))
      lastFmPlaceholder.appendChild(document.createTextNode(", and "))
      lastFmPlaceholder.appendChild(linkForArtist(artists[2], fathomGoalId))
      lastFmPlaceholder.appendChild(document.createTextNode("."))
