

window.app.ports.getEncryptedString.subscribe(function(incoming) {
  var key = CryptoJS.enc.Utf8.parse(incoming[1]);
  var iv = CryptoJS.enc.Utf8.parse(incoming[2]);

  var encryptedData = CryptoJS.AES.encrypt(CryptoJS.enc.Utf8.parse(incoming[0]), key,
  {
      keySize: 128 / 8,
      iv: iv,
      mode: CryptoJS.mode.CBC,
      padding: CryptoJS.pad.Pkcs7
  });

  console.log("Result: " + encryptedData.toString());

  window.app.ports.returnLoginEncryptedString.send(encryptedData.toString())

})
