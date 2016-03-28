function startGps(app) {
  var module =
    {
      app: app
    };
  var options =
    {
      enableHighAccuracy: true,
      timeout: 5000,
      maximumAge: 0
    };
  navigator.geolocation.watchPosition(receivePos.bind(module),
                                      receiveErr.bind(module),
                                      options);
}

function receivePos(pos) {
  var rec =
    {
      latitude: pos.coords.latitude,
      longitude: pos.coords.longitude
    };
  this.app.ports.position.send(rec);
}

function receiveErr(err) {
  console.log("GPS err");
}

