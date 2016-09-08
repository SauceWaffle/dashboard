module Components.ItRequests.Models exposing (..)

type alias ItRequest =
  { age : Int
  , ageUnit : String
  , assignedTo : String
  , description : String
  , dueOn : String
  , id : Int
  , notes : (List RequestNote)
  , priority : String
  , requestedBy : String
  , requestedOn : String
  , requestNumber : String
  , requestType : String
  , status : String
  }

type alias RequestNote =
  { author : String
  , date : String
  , id : Int
  , requestId : Int
  , text : String
  }

emptyItRequest : ItRequest
emptyItRequest =
  {age = 0
  , ageUnit = ""
  , assignedTo = ""
  , description = ""
  , dueOn = ""
  , id = 0
  , notes = []--emptyRequestNote
  , priority = ""
  , requestedBy = ""
  , requestedOn = ""
  , requestNumber = ""
  , requestType = ""
  , status = ""
  }

emptyRequestNote : List RequestNote
emptyRequestNote =
  [{author = ""
  , date = ""
  , id = 0
  , requestId = 0
  , text = ""
  }]
