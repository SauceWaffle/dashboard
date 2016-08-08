module Components.ITRequests.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import Styles exposing (..)
import Messages exposing (..)



-- VIEW

itRequestsView : Models.Model -> Html Messages.Msg
itRequestsView model =
  div [ styles.itRequests ]
  [ h1 [] [ text "IT Requests Center" ]
  ]
