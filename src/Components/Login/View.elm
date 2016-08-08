module Components.Login.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)
import Styles exposing (..)
import Messages exposing (..)




-- VIEW

loginView : Models.Model -> Html Messages.Msg
loginView model =
  let
    location = ""
  in
    div []
    [
      button [ onClick LogIn ] [ text "Login" ]
    ]
