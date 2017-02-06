

window.app.ports.openLinkInJS.subscribe(function(incoming) {
  if (incoming.startsWith('mailto'))
    window.location.href=incoming
  else
    window.open(incoming,'_blank');
})


window.app.ports.openTimeMatrixJS.subscribe(function(incoming) {
  window.open('http://timematrix.qualedyn.local','Windows','width=400,height=400,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,directories=no,status=no');
})
