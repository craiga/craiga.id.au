function konamiRotate(rotator) {
  if (rotator === void(0)) {
    rotator = $({deg: 0});
  } else {
    rotator.get(0).deg = 0;
  }

  return rotator.animate(
    {deg: 360},
    {
      duration: 45 / 60 * 1000,  // 45 RPM
      easing: 'linear',
      step: function(x){
        $('.konami-rotate').css({transform: 'rotate(' + x + 'deg)'});
      },
      complete: function(){
        konamiRotate($('.konami-rotate'), rotator);
      },
    }
  );
}

function konamiInit() {
  var keyLog = [];
  var konami = '38,38,40,40,37,39,37,39,66,65';
  $(document).keydown(function(e) {
    keyLog.push(e.keyCode);
    if (keyLog.toString().indexOf(konami) >= 0) {
      $(document).unbind('keydown',arguments.callee);
      konamiRotate();
      $('.konami-audio').get(0).play();
    }
  });
}

Raven.context(function () {
  konamiInit();
});
