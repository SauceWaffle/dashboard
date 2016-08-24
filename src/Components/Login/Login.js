

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
  deleteAllCookies()
})
