module Main exposing (..)

import Dict

import Messages exposing (..)
import Models exposing (..)
import Update exposing (..)
import Components.Reports.Update exposing (getReportMenuItems)
import Components.Supply.Gauge.Update exposing (getGaugeData)
import View exposing (view)
import Keys exposing (loginKey,loginIV)

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
      ReportRoute rpt ->
        case model.loggedIn of
          True -> (model, Cmd.batch [ (navigationCmd path), (getReportMenuItems model) ] )
          False -> (model, Cmd.batch [ (navigationCmd path), (getEncryptedString ["",loginKey,loginIV])  ])
      SupplyDashRoute -> (model, Cmd.batch [ (navigationCmd path), getGaugeData, (getEncryptedString ["",loginKey,loginIV])  ] )
      _ -> (model, Cmd.batch [ (navigationCmd path), (getEncryptedString ["",loginKey,loginIV]) ])


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
    { view = view
    , update = update
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    , init = init
    }
