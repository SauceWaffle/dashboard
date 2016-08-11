module Components.Header.View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Styles exposing (..)
import Messages exposing (..)

import Components.Login.View exposing (loginView)


-- VIEW

topheader : Models.Model -> Html Messages.Msg
topheader model =
  let
    bannerText = "QED Dashboard - Logged In (" ++ toString model.loggedIn ++ ")"
  in
    div [ styles.header ]
    [ span [ styles.floatLeft ]
      [
        text bannerText
      ]

    , span [ styles.floatRight ]
      [
        userMenu model
      ]
    ]


userMenu : Models.Model -> Html Messages.Msg
userMenu model =
  loginView model
