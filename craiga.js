function konamiInit() {
  var keyLog = [];
  var konami = '38,38,40,40,37,39,37,39,66,65';
  $(document).keydown(function(e) {
    keyLog.push(e.keyCode);
    if (keyLog.toString().indexOf(konami) >= 0) {
      $('.konami-rotate').addClass('rotate');
      $('.konami-audio').get(0).play();
    }
  });
}

Raven.context(function () {
  konamiInit();
});
