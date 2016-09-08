
require('../../js/autosize.js')

window.app.ports.getAddNoteValueFromJS.subscribe(function(incoming) {
  var noteText = $('#addRequestNoteTextArea').val()

  if (noteText) {
    setTimeout(function(){window.app.ports.returnAddNoteValueFromJS.send( noteText.replace(/(\r\n|\r|\n)/gm,"CHAR(10)") )},50)
  }
  else {
    setTimeout(function(){window.app.ports.returnAddNoteValueFromJS.send( "Couldn't get note text" )},50)
  }

})


window.app.ports.initializeNewRequestDatePicker.subscribe(function(incoming) {
  $( function() {  $("#dueOnDatePicker").datepicker() } )

  $("#dueOnDatePicker").change( function() {
    var theDate = $("#dueOnDatePicker").val()
    theDate.replace("/","%2F")

    setTimeout(function(){window.app.ports.returnNewRequestDueOnFromJS.send( theDate )},50)
  } )
})

window.app.ports.getNewRequestDueOnFromJS.subscribe(function(incoming) {
  setTimeout(function(){window.app.ports.returnNewRequestDueOnFromJS.send( $("#dueOnDatePicker").val() )},50)
})


window.app.ports.setRequestNoteSizes.subscribe(function(incoming) {
  var notes = document.getElementsByClassName("requests-note-textarea")

  for (i = 0; i < notes.length; i++) {
    window.app.autosize(notes[i])
  }

})
