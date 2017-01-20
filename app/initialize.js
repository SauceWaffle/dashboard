
if (typeof Object.assign != 'function') {
  Object.assign = function(target) {
    'use strict';
    if (target == null) {
      throw new TypeError('Cannot convert undefined or null to object');
    }

    target = Object(target);
    for (var index = 1; index < arguments.length; index++) {
      var source = arguments[index];
      if (source != null) {
        for (var key in source) {
          if (Object.prototype.hasOwnProperty.call(source, key)) {
            target[key] = source[key];
          }
        }
      }
    }
    return target;
  };
}



// inject bundled Elm app into div#main

document.addEventListener('DOMContentLoaded', () => {
  const elmNode = document.getElementById('elm-main')
  window.app = Elm.Main.embed(elmNode)


  var $ = require('jquery');


  $.getScript('js/Gauge.js')
  $.getScript('js/slidemenu.js')
  $.getScript('js/autosize.js')
  $.getScript('js/ItRequests.js')
  $.getScript('js/photoslideshow.js')
  $.getScript('js/Home.js')
  $.getScript('js/fitness.js')

  var wsImpl = window.WebSocket || window.MozWebSocket;

  // create a new websocket and connect
  window.ws = new wsImpl('ws://api.qualedyn.local:8181/');

  // when data is comming from the server, this metod is called
  ws.onmessage = function (msg) {
      var e = msg.data;

      if (e != null) {

        if (e == "qedfitness_leaders_updated")
        {
          window.app.ports.leadersChanged.send("");
        }

      }
  };

  // when the connection is established, this method is called
  ws.onopen = function () {
      console.log('Connected to WebSocket Server');
  };

  // when the connection is closed, this method is called
  ws.onclose = function () {
      console.log('Disconnected from WebSocket Server');
  }


  window.app.ports.alertWebSocket.subscribe(function(msg) {
    var sendMsg =
      { origin: msg[0]
      , event: msg[1]
      , nextStep: msg[2]
      }

    var json = JSON.stringify(sendMsg)
    ws.send(json)
  })






  window.app.ports.stopPhotoSlideshow.subscribe(function(incoming) {
    if (window.slideshow) {
      clearInterval(window.slideshow);
      window.slideshow = null;
    }
  })



  window.app.ports.startGaugeWatcher.subscribe(function(incoming) {
    if (!window.gaugeWatcher)
      window.gaugeWatcher = setInterval(function(){window.app.ports.returnGaugeGetValues.send(incoming)},5000);
  })

  window.app.ports.stopGaugeWatcher.subscribe(function(incoming) {
    if (window.gaugeWatcher) {
      clearInterval(window.gaugeWatcher);
      window.gaugeWatcher = null;
    }
  })

  window.app.ports.isPageReady.subscribe(function(incoming) {
    switch (incoming) {
      case "home": setTimeout(function(){window.app.ports.returnHomeFromJS.send(incoming)},250); break;
      case "report": setTimeout(function(){window.app.ports.returnReportFromJS.send(incoming)},250); break;
      case "gauge":  setTimeout(function(){window.app.ports.returnGaugeFromJS.send(incoming)},250); break;
      case "requestNotes":  setTimeout(function(){window.app.ports.returnRequestNotesFromJS.send(incoming)},250); break;
      case "newRequest": setTimeout(function(){window.app.ports.returnNewRequestFromJS.send(incoming)},250); break;
    }
  })





  function getCookie(name) {
      var nameEQ = name + "=";
      var ca = document.cookie.split(';');
      for(var i = 0; i < ca.length; i++) {
          var c = ca[i];
          while (c.charAt(0) == ' ') c = c.substring(1, c.length);
          if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
      }
      return null;
  }

  function deleteAllCookies() {
      var cookies = document.cookie.split(";");

      for (var i = 0; i < cookies.length; i++) {
      	var cookie = cookies[i];
      	var eqPos = cookie.indexOf("=");
      	var name = eqPos > -1 ? cookie.substr(0, eqPos) : cookie;
      	document.cookie = name + "=;expires=Thu, 01 Jan 1970 00:00:00 GMT";
      }
  }


  window.app.ports.getEncryptedString.subscribe(function(incoming) {

    if (!getCookie('loginData')) {

      var key = CryptoJS.enc.Utf8.parse(incoming[1]);
      var iv = CryptoJS.enc.Utf8.parse(incoming[2]);

      var encryptedData = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(incoming[0]), key,
      {
          keySize: 128 / 8,
          iv: iv,
          mode: CryptoJS.mode.CBC,
          padding: CryptoJS.pad.Pkcs7
      });

      //console.log("Result: " + encryptedData.toString());

      var expDate = new Date()
      expDate.setDate(expDate.getDate() + 30)
      document.cookie = 'loginData='+ encryptedData.toString() +'; expires=' + expDate.toString() +'; path=/'
    }


    if (getCookie('loginData')) {
        setTimeout(function(){window.app.ports.returnLoginEncryptedString.send(getCookie('loginData'))},50)
    }
    else {
      window.app.ports.returnLoginEncryptedString.send("No Login")
    }

  })

  window.app.ports.clearLoginCookie.subscribe(function(incoming) {
    document.cookie = 'loginData=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/';
    //deleteAllCookies()
  })


})
