---
---

# If no_fathom_tracking is on the query string, set a cookie which doesn't expire for a
# long time.
if window.location.href.indexOf("no_fathom_tracking") != -1
  document.cookie = "no_fathom_tracking=true; expires=Tue, 31 Dec 2030 23:59:59 UTC"

# For elements with data-fathom-goal-id defined, set up a click handler to report the
# click to Fathom.
for element in document.querySelectorAll("a[data-fathom-goal-id]")
  element.onclick = ->
    if fathom?
      fathom('trackGoal', this.getAttribute("data-fathom-goal-id"), 0)
