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

function mapLoadPlace(map, placeName) {
  var placeRequest = {
    location: map.getCenter(),
    radius: '10',
    query: placeName
  };
  var placesService = new google.maps.places.PlacesService(map);
  placesService.textSearch(placeRequest, function callback(results, status) {
    if (status == google.maps.places.PlacesServiceStatus.OVER_QUERY_LIMIT) {
      setTimeout(function() {
        mapLoadPlace(map, placeName);
      }, 5000);
    } else if (status == google.maps.places.PlacesServiceStatus.OK) {
      result = results[0];
      var marker = new google.maps.Marker({
        map: map,
        place: {
          placeId: result.place_id,
          location: result.geometry.location
        }
      });
      map.setCenter(result.geometry.location);
    }
  });
}

function mapInject() {
  regex = /google\.(?:[\w\.]+)\/maps\/place\/(.+)\/@(\-?[\d\.]+),(\-?[\d\.]+)/i;
  $('a').each(function(i, link) {
    var href = $(link).attr('href');
    matches = regex.exec(href);
    if (matches) {
      placeName = decodeURIComponent(matches[1]);
      coords = {lat: parseFloat(matches[2]), lng: parseFloat(matches[3])};
      var mapEle = $('<div class="map"></div>').get(0);
      var map = new google.maps.Map(mapEle, {
        zoom: 15,
        center: coords
      });
      $(link).parent().after(mapEle);
      google.maps.event.trigger(map, 'resize');
      mapLoadPlace(map, placeName);
    }
  });
}

Raven.context(function () {
  konamiInit();
});
