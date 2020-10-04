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
      fathom.trackGoal(this.getAttribute("data-fathom-goal-id"), 0)


getRoomInSidebar = () ->
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


inMobileLayout = () ->
  mainContent = document.getElementsByTagName("main")[0];
  sidebar = document.getElementById("sidebar")
  return mainContent.offsetWidth == sidebar.offsetWidth


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

  if getRoomInSidebar() > roomForAnotherIndex and not inMobileLayout()

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


doSearch = (event) ->
  event.preventDefault()
  searchForm = document.getElementById("search")
  searchText = searchForm.getElementsByTagName("input")[0].value;
  scrollOptions = {
    behavior: "smooth",
    block: "nearest"
  }

  searchResults = document.querySelectorAll(".search-result")
  for searchResult in searchResults
    searchResult.parentNode.removeChild(searchResult)

  loadingMessage = document.createElement("p")
  loadingMessage.innerHTML = "Searching for <b>#{searchText}</b>…"
  loadingIndicator = document.createElement("section")
  loadingIndicator.classList.add("search-loading-indicator")
  loadingIndicator.appendChild(loadingMessage)
  searchForm.parentNode.insertBefore(loadingIndicator, searchForm.nextSibling)  # https://stackoverflow.com/a/4793630/1852024

  loadingMessage.scrollIntoView(scrollOptions)

  redrawSidebar()

  for element in searchForm.elements
    element.disabled = true

  fetch("https://www.googleapis.com/customsearch/v1?q=#{searchText}&key=AIzaSyD9q2Q2jjMderdsMpbkI-_umYmcS02dQIM&cx=007129523963313219349:yjpcuhhjc73")
    .then (response) -> response.json()
    .then (responseData) ->
      for loadingIndicator in document.querySelectorAll(".search-loading-indicator")
        loadingIndicator.parentNode.removeChild(loadingIndicator)

      afterSearch = searchForm.nextSibling
      if parseInt(responseData.searchInformation.totalResults) > 1
        for searchResult in responseData.items
          resultArticle = document.createElement("article")
          resultArticle.classList.add("search-result")
          resultArticle.innerHTML = "<div><h1><a href='#{ searchResult.link }'>#{ searchResult.htmlTitle }</a></h1><p>#{ searchResult.htmlSnippet }</p></div>"
          searchForm.parentNode.insertBefore(resultArticle, afterSearch)
      else
        resultArticle = document.createElement("article")
        resultArticle.classList.add("search-result")
        resultArticle.innerHTML = "<div><p>No results for <b>#{searchText}</b>.</p></div>"
        searchForm.parentNode.insertBefore(resultArticle, afterSearch)

      for element in searchForm.elements
        element.disabled = false

      document.getElementsByClassName("search-result")[0].scrollIntoView(scrollOptions)

      redrawSidebar()


document.getElementById("search").addEventListener("submit", doSearch)


fetch("//ws.audioscrobbler.com/2.0/?method=user.gettopartists&user=craiganderson&period=7day&api_key=ad34f34858f38de2ed2a097d31a882eb&format=json")
  .then (response) -> response.json()
  .then (responseData) ->
    artists = responseData.topartists.artist

    linkForArtist = (artist, fathomGoalId) ->
      link = document.createElement("a")
      link.setAttribute("href", artist.url)
      link.setAttribute("data-fathom-goal-id", fathomGoalId)
      link.innerText = artist.name
      return link

    if artists.length > 3
      lastFmPlaceholder = document.getElementById("lastfm-placeholder")
      fathomGoalId = lastFmPlaceholder.getElementsByTagName("a")[0].getAttribute("data-fathom-goal-id")

      lastFmPlaceholder.innerText = ""

      link = document.createElement("a")
      link.setAttribute("href", "https://www.last.fm/user/craiganderson")
      link.setAttribute("data-fathom-goal-id", fathomGoalId)
      link.innerText = "Lately I've been listening to"
      lastFmPlaceholder.appendChild(link)
      lastFmPlaceholder.appendChild(document.createTextNode(" "))
      lastFmPlaceholder.appendChild(linkForArtist(artists[0], fathomGoalId))
      lastFmPlaceholder.appendChild(document.createTextNode(", "))
      lastFmPlaceholder.appendChild(linkForArtist(artists[1], fathomGoalId))
      lastFmPlaceholder.appendChild(document.createTextNode(", and "))
      lastFmPlaceholder.appendChild(linkForArtist(artists[2], fathomGoalId))
      lastFmPlaceholder.appendChild(document.createTextNode("."))


fetch("https://api.untappd.com/v4/user/checkins/craiganderson?client_id=DF32364366DD7CE975FAFF52336891109955F940&client_secret=FD1AE98E636B1F6609FB5C45E9EABC39C1D7CB42&compact=true")
  .then (response) -> response.json()
  .then (responseData) ->
    checkin = responseData.response.checkins.items[0]
    section = document.getElementById("sidebar-beer")
    fathomGoalId = section.getElementsByTagName("a")[0].getAttribute("data-fathom-goal-id")

    untappdPlaceholder = document.getElementById("untappd-placeholder")
    untappdPlaceholder.innerText = ""
    untappdPlaceholder.appendChild(document.createTextNode("Recently I tried "))

    link = document.createElement("a")
    link.setAttribute("href", "https://untappd.com/b/#{ checkin.beer.beer_slug }/#{ checkin.beer.bid }")
    link.setAttribute("data-fathom-goal-id", fathomGoalId)
    link.innerText = checkin.beer.beer_name
    untappdPlaceholder.appendChild(link)

    untappdPlaceholder.appendChild(document.createTextNode(" from "))

    link = document.createElement("a")
    link.setAttribute("href", checkin.brewery.contact.url)
    link.setAttribute("data-fathom-goal-id", fathomGoalId)
    link.innerText = checkin.brewery.brewery_name
    untappdPlaceholder.appendChild(link)

    untappdPlaceholder.appendChild(document.createTextNode(". "))

    link = document.createElement("a")
    link.setAttribute("href", "https://untappd.com/user/craiganderson/checkin/#{ checkin.checkin_id }")
    link.setAttribute("data-fathom-goal-id", fathomGoalId)
    link.innerText = "I gave it #{ checkin.rating_score } out of 5"
    untappdPlaceholder.appendChild(link)

    untappdPlaceholder.appendChild(document.createTextNode("."))

    for checkin in responseData.response.checkins.items
      if checkin.media.count > 0
        newBackground = checkin.media.items[0].photo.photo_img_lg
        backgroundImageCss = getComputedStyle(section).getPropertyValue("background-image")
        backgroundImageCss = backgroundImageCss.replace(/url\([^\)]*\)/, "url('#{ newBackground }')")
        section.style.backgroundImage = backgroundImageCss
        break
