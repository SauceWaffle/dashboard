module Components.ItRequests.Update exposing (..)

import Task
import Http
import Json.Decode as Json exposing (..)

import Models exposing (..)
import Components.ItRequests.Models exposing (..)
import Messages exposing (..)
import Keys exposing (getItRequestsFromApi)

getMyItRequests : Models.Model -> Cmd Msg
getMyItRequests model =
  let
    apiQuery = "myRequests&user=" ++ model.loginData.userId
  in
    Task.perform ItRequestsFail ItRequestsSuccess (Http.get (decodeAllRequests) (getItRequestsFromApi apiQuery) )


apply : Json.Decoder (a -> b) -> Json.Decoder a -> Json.Decoder b
apply func value =
  Json.object2 (<|) func value

decodeAllRequests : Json.Decoder (List ItRequest)
decodeAllRequests =
  Json.at [] (Json.list decodeRequest)

decodeRequest : Json.Decoder ItRequest
decodeRequest =
  Json.map ItRequest
    ("age" := Json.int)
    `apply` ("ageUnit" := Json.string)
    `apply` ("assignedTo" := Json.string)
    `apply` ("description" := Json.string)
    `apply` ("dueOn" := Json.string)
    `apply` ("id" := Json.int)
    `apply` ("notes" := (Json.list decodeRequestNote) )
    `apply` ("priority" := Json.string)
    `apply` ("requestedBy" := Json.string)
    `apply` ("requestedOn" := Json.string)
    `apply` ("requestNumber" := Json.string)
    `apply` ("requestType" := Json.string)
    `apply` ("status" := Json.string)

decodeRequestNote : Json.Decoder RequestNote
decodeRequestNote =
  Json.object5 RequestNote
    ("author" := Json.string)
    ("date" := Json.string)
    ("id" := Json.int)
    ("requestId" := Json.int)
    ("text" := Json.string)
