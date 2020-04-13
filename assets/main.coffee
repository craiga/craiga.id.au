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
console.log(trackingMessageElement)
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
