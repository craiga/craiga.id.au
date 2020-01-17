---
title: XML HTTP Request Test
---

This page <span id="state">will make</span> an XML HTTP request to `https://jsonplaceholder.typicode.com/users`.

<script src="https://code.jquery.com/jquery-3.4.1.min.js" integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo=" crossorigin="anonymous"></script>

<script>
  jQuery(function() {
    $("#state").text("is making");
    $.get("https://jsonplaceholder.typicode.com/users", function(a,b,c) {
      $("#state").text("made");
    });
  });
</script>
