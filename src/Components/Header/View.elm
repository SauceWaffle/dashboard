module Components.Header.View exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Styles exposing (..)
import Messages exposing (..)


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
  let
    loggedIn = model.loggedIn
  in
    if loggedIn then
      div [ styles.user ]
      [ i [ class "material-icons md-36", onClick LogOut ] [ text "account_circle" ]
        -- Menu.render MDL [0] model.mdl
        -- [ Menu.bottomRight
        -- , Menu.ripple
        -- , Menu.icon "account_circle"
        -- ]
        -- [ Menu.Item False True <| div [] [ text "My Profile" ]
        -- , Menu.Item True True <| div [] [ text "Settings" ]
        -- , Menu.Item False True <| div [ onClick LogOut ] [ text "Log Out" ]
        -- ]

      ]
    else
      div [ styles.user ]
      [ i [ class "material-icons md-36", onClick LogIn ] [ text "account_circle" ]
        -- Menu.render MDL [1] model.mdl
        -- [ Menu.bottomRight
        -- , Menu.ripple
        -- , Menu.icon "account_circle"
        -- ]
        -- [ Menu.Item False True <| div [ onClick LogIn ] [ text "Log In" ]
        -- ]

      ]
