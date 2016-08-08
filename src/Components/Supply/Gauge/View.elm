module Components.Supply.Gauge.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Styles exposing (..)
import Messages exposing (..)

import Components.Supply.Gauge.Models exposing (..)


-- VIEW

gaugeView : Models.Model -> Html Messages.Msg
gaugeView model =
  let
    gauges = List.map (\g -> costGauge g) model.supplyGauges
  in
    div []
    [ ul [ styles.gauges ] gauges
    ]

costGauge : Gauge -> Html Messages.Msg
costGauge gauge =
  li [ styles.gauge ]
  [ canvas [ id gauge.id, height 250, width 250 ] []
  ]
