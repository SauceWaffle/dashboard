



  app.ports.saveActivityData.subscribe(function(allActivities) {
    var user = allActivities[0].userId;
    var first = allActivities[0].firstName;
    var last = allActivities[0].lastName;
    var dept = allActivities[0].department;
    var acts = allActivities[1];
    var newActs = new Array();

    for (var a = 0; a < acts.length; a++) {
      var save =
        { employee: user
        , firstname: first
        , lastname: last
        , department: dept
        , logdate: acts[a].date
        , distance: acts[a].distance
      };

      newActs.push(save);
    }

    var jsonO = JSON.stringify(newActs)

    $.support.cors = true
    $.ajax({
			type: "POST",
			url: "http://api.qualedyn.local/qedfitness_api.aspx?q=save",
			data: jsonO,
			contentType: "text/plain; charset=utf-8",
			dataType: "text/plain",
			complete: function(data) {
        var sqlResults = eval('(' + data.responseText + ')');

				if (sqlResults[0]["Result"] == "OK"){
					app.ports.saveActivityDataComplete.send("OK")
				}
				else {
					app.ports.saveActivityDataComplete.send("Error")
				}
			},
			error: function(e){
				app.ports.saveActivityDataComplete.send("Error")
			}
		});

  })
