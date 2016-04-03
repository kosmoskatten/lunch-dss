function startStorage(app) {
  var module =
  {
    app: app,
    storage: window.localStorage
  };

  app.ports.storageCtrl.subscribe(function(obj) {
    if (obj.op == "inc") {
      changeRating.bind(module)(obj,
        {
          defaultValue: "1",
          op: function(x) { return x + 1 }
        });
    } else if (obj.op == "dec") {
      changeRating.bind(module)(obj,
        {
          defaultValue: "-1",
          op: function(x) { return x - 1 }
        });
    } else if (obj.op == "fetchAll") {
      var restaurants = obj.restaurants;
      module.app.ports.storageData.send(
        restaurants.map(getRating.bind(module))
      );
    } else {
      console.log("Got unexpected: " + obj.op);
    }
  });
}

function changeRating(obj, param) {
  var rating = this.storage.getItem(obj.restaurant);
  console.log("Rating value: " + rating);

  if (rating != null) {
    var changed = param.op(parseInt(rating));
    this.storage.setItem(obj.restaurant, changed.toString());
  } else {
    this.storage.setItem(obj.restaurant, param.defaultValue);
  }
}

function getRating(obj) {
  var rating = this.storage.getItem(obj.name);
  if (rating != null) {
    obj.rating = parseInt(rating);
    return obj;
  } else {
    return obj;
  }
}
