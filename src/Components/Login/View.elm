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
    loggedIn = model.loggedIn
  in
    if loggedIn then
      div [ class "user" ]
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
      div [ class "user" ]
      [ i [ class "material-icons md-36" ] [ text "account_circle" ]
      , loginDropDown model
      ]


loginDropDown : Models.Model -> Html Messages.Msg
loginDropDown model =
  div [ id "loginMenu" ]
  [ ul []
    [ li [] [ span [] [ text "Username" ] ]
    , li [] [ input [ onInput SetLoginUser ] [] ]
    , li [] [ span [] [ text "Password" ] ]
    , li [] [ input [ styles.password, onInput SetLoginPass ] [] ]
    , li [ style [("text-align", "center")] ] [ button [ onClick (EncryptLogin (model.username ++ "|" ++ model.password)) ] [ text "Log In" ] ]
    ]
  ]
