module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import Messages exposing (..)

import Components.Supply.Gauge.View exposing (..)
import Components.Header.View exposing (topheader)
import Components.Menu.View exposing (menuBar)
import Components.Reports.View exposing (reportsView)
import Components.ItRequests.View exposing (itRequestsView)
import Components.Login.View exposing (loginView)
import Components.User.View exposing (userView)

-- VIEW

view : Models.Model -> Html Messages.Msg
view model =
  let
    startMenu = model.pageMenu
  in
    div [ id "fullPage" ]
    [ topheader model
    , nav [ class "header-menu" ] [ menuBar model startMenu ]
    , case model.route of
        HomeRoute -> homeView model
        SupplyDashRoute -> gaugeView model
        ReportRoute rpt -> reportsView rpt model
        ITRequestsRoute -> itRequestsView model
        UserLoginRoute  -> loginView model
        UserRoute userid-> userView userid model
        NotFoundRoute   -> homeView model
    ]

homeView : Models.Model -> Html Messages.Msg
homeView model =
  div []
  [ text (toString model)
  ]
