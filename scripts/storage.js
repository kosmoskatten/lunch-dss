function startStorage(app) {
    app.ports.storageCtrl.subscribe(function(obj) {
      console.log("storage: " + obj.op);
    });
}
