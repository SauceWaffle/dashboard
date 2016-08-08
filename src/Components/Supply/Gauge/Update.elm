module Components.Supply.Gauge.Update exposing (..)

import Task
import Http
import Json.Decode as Json exposing (..)

import Components.Supply.Gauge.Models exposing (..)
import Messages exposing (..)
import Keys exposing (getGaugeDataFromApi)

getGaugeData : Cmd Msg
getGaugeData =
  Task.perform GaugeValuesFail GaugeValuesSuccess (Http.get (decodeGaugeData) getGaugeDataFromApi)


apply : Json.Decoder (a -> b) -> Json.Decoder a -> Json.Decoder b
apply func value =
  Json.object2 (<|) func value

decodeGaugeData : Json.Decoder (Gauges)
decodeGaugeData =
  Json.at [] (Json.list decodeGauge)

decodeGauge : Json.Decoder Gauge
decodeGauge =
  Json.map Gauge
  ("badEnd" := Json.float)
  `apply` ("badStart" := Json.float)
  `apply` ("goodEnd" := Json.float)
  `apply` ("goodStart" := Json.float)
  `apply` ("id" := Json.string)
  `apply` ("okEnd" := Json.float)
  `apply` ("okStart" := Json.float)
  `apply` ("max" := Json.float)
  `apply` ("min" := Json.float)
  `apply` ("title" := Json.string)
  `apply` ("value" := Json.float)
