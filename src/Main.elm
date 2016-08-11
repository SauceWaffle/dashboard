module Main exposing (..)

import Dict

import Messages exposing (..)
import Models exposing (..)
import Update exposing (..)
import Components.Reports.Update exposing (getReportMenuItems)
import Components.Supply.Gauge.Update exposing (getGaugeData)
import View exposing (view)

import Navigation
import Hop.Types exposing (Router)
import Routing.Utils

-- MODEL

init : ( Route, Hop.Types.Location ) -> ( Model, Cmd Msg )
init ( route, location )=
  let
    path = Routing.Utils.reverse (route)
    model = case route of
              ReportRoute rpt -> initModel HomeRoute { path = [], query = Dict.empty }
              SupplyDashRoute -> initModel SupplyDashRoute { path = [], query = Dict.empty }
              _ -> initModel HomeRoute { path = [], query = Dict.empty }
  in
    case route of
      ReportRoute rpt -> (model, Cmd.batch [ (navigationCmd path), (getReportMenuItems model) ] )
      SupplyDashRoute -> (model, Cmd.batch [ (navigationCmd path), getGaugeData ] )
      _ -> (model, (navigationCmd path) )


-- SUBSCRIPTIONS

subscriptions : Models.Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ returnReportFromJS LoadSlideMenu
    , returnGaugeFromJS LoadGauges
    , returnGaugeGetValues GetGaugeValues
    , returnLoginEncryptedString LogIn
    ]


main : Program Never
main =
  Navigation.program urlParser
    { init = init
    , view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    }
