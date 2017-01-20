module Decoders exposing (..)

import Task
import Http
import Date
import String
import Json.Decode as Json exposing (..)
import Json.Decode.Pipeline as Pipe exposing (..)
import Date.Extra.Utils as DateUtils

import Types exposing (..)
import Messages exposing (..)
import Keys exposing (..)




decodeLoginData : Json.Decoder Login
decodeLoginData =
  Json.at ["login"] decodeLogin

decodeLogin : Json.Decoder Login
decodeLogin =
  Json.map5 Login
  (Json.field "department" Json.string)
  (Json.field "firstName" Json.string)
  (Json.field "groups" (Json.list decodeGroups))
  (Json.field "lastName" Json.string)
  (Json.field "userId" Json.string)

decodeGroups : Json.Decoder LoginGroup
decodeGroups =
  Json.map LoginGroup
  (Json.field "name" Json.string)






decodeHomeCarouselImages : Json.Decoder (List Image)
decodeHomeCarouselImages =
  Json.at [] (Json.list decodeImage)

decodeImage : Json.Decoder Image
decodeImage =
  Json.map Image
    (Json.field "fileName" Json.string)



decodePageMenu : Json.Decoder (List String)
decodePageMenu =
  Json.at ["allMenu"] (Json.list Json.string)



decodeEmployeeDirectory : Json.Decoder (List Employee)
decodeEmployeeDirectory =
  Json.at [] (Json.list decodeEmployee)

decodeEmployee : Json.Decoder Employee
decodeEmployee =
  Pipe.decode Employee
    |> Pipe.required "department" Json.string
    |> Pipe.required "description" Json.string
    |> Pipe.required "firstname" Json.string
    |> Pipe.required "mail" Json.string
    |> Pipe.required "mobile" Json.string
    |> Pipe.required "office" Json.string
    |> Pipe.required "photo" Json.string
    |> Pipe.required "physicalDeliveryOfficeName" Json.string
    |> Pipe.required "sn" Json.string
    |> Pipe.required "title" Json.string








decodeActivities : Json.Decoder (List Activity)
decodeActivities =
  Json.at [] (Json.list decodeActivity)

decodeActivity : Json.Decoder Activity
decodeActivity =
  Json.map5 Activity
  (Json.field "changed" stringToBool)
  (Json.field "date" stringToDate)
  (Json.field "distance" Json.float)
  (Json.field "strDistance" Json.string)
  (Json.field "id" Json.int)


decodeAllLeaders : Json.Decoder (List LeadersAll)
decodeAllLeaders =
  Json.at [] (Json.list decodeLeaderAll)

decodeLeaderAll : Json.Decoder LeadersAll
decodeLeaderAll =
  Json.map3 LeadersAll
  (Json.field "distance" Json.float)
  (Json.field "employee" Json.string)
  (Json.field "place" Json.int)

decodeDeptLeaders : Json.Decoder (List LeadersDept)
decodeDeptLeaders =
  Json.at [] (Json.list decodeLeaderDept)


decodeLeaderDept : Json.Decoder LeadersDept
decodeLeaderDept =
  Json.map4 LeadersDept
  (Json.field "department" Json.string)
  (Json.field "distance" Json.float)
  (Json.field "employee" Json.string)
  (Json.field "place" Json.int)

stringToDate : Decoder Date.Date
stringToDate =
  Json.string
    |> andThen dateParser

dateParser : String -> Decoder Date.Date
dateParser val =
  succeed (DateUtils.unsafeFromString val)


stringToBool : Decoder Bool
stringToBool =
  Json.string
    |> andThen boolParser

boolParser : String -> Decoder Bool
boolParser val =
  case val of
      "true" -> succeed True
      "false" -> succeed False
      _ -> fail <| "Expecting \"true\" or \"false\" but found " ++ val







decodeAllRequests : Json.Decoder (List ItRequest)
decodeAllRequests =
  Json.at [] (Json.list decodeRequest)

decodeRequest : Json.Decoder ItRequest
decodeRequest =
  Pipe.decode ItRequest
    |> Pipe.required "age" Json.int
    |> Pipe.required "ageUnit" Json.string
    |> Pipe.required "assignedTo" Json.string
    |> Pipe.required "description" Json.string
    |> Pipe.required "dueOn" Json.string
    |> Pipe.required "id" Json.int
    |> Pipe.required "notes" (Json.list decodeRequestNote)
    |> Pipe.required "priority" Json.string
    |> Pipe.required "requestedBy" Json.string
    |> Pipe.required "requestedOn" Json.string
    |> Pipe.required "requestNumber" Json.string
    |> Pipe.required "requestType" Json.string
    |> Pipe.required "status" Json.string

decodeRequestNote : Json.Decoder RequestNote
decodeRequestNote =
  Json.map5 RequestNote
    (Json.field "author" Json.string)
    (Json.field "date" Json.string)
    (Json.field "id" Json.int)
    (Json.field "requestId" Json.int)
    (Json.field "text" Json.string)







decodeAllMenus : Json.Decoder (List ReportMenu)
decodeAllMenus =
  Json.at ["allMenu"] (Json.list decodeMenu)

decodeMenu : Json.Decoder ReportMenu
decodeMenu =
  Json.map2 ReportMenu
    (Json.field "items" (Json.list decodeMenuItems) )
    (Json.field "menuName" Json.string)

decodeMenuItems : Json.Decoder ReportMenuItem
decodeMenuItems =
  Json.map4 ReportMenuItem
    (Json.field "fullPath" Json.string)
    (Json.field "menuOrItem" Json.string)
    (Json.field "name" Json.string)
    (Json.field "subMenuName" Json.string)








decodeGaugeData : Json.Decoder (Gauges)
decodeGaugeData =
  Json.at [] (Json.list decodeGauge)

decodeGauge : Json.Decoder Gauge
decodeGauge =
  Pipe.decode Gauge
    |> Pipe.required "badEnd" Json.float
    |> Pipe.required "badStart" Json.float
    |> Pipe.required "goodEnd" Json.float
    |> Pipe.required "goodStart" Json.float
    |> Pipe.required "id" Json.string
    |> Pipe.required "okEnd" Json.float
    |> Pipe.required "okStart" Json.float
    |> Pipe.required "max" Json.float
    |> Pipe.required "min" Json.float
    |> Pipe.required "title" Json.string
    |> Pipe.required "value" Json.float
