
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
var Elm = require( './Main.elm' );
//window.app = Elm.Main.fullscreen();
window.app = Elm.Main.embed( document.getElementById('main') );

require( './Components/Supply/Gauge/Gauge.js' )
require( './Components/Reports/slidemenu.js' )
require( './Components/Login/Login.js' )




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
    case "report": setTimeout(function(){window.app.ports.returnReportFromJS.send(incoming)},250); break;
    case "gauge":  setTimeout(function(){window.app.ports.returnGaugeFromJS.send(incoming)},250); break;
  }
})
