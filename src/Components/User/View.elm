module Components.User.View exposing (..)

import Html exposing (..)
import Models exposing (..)
import Messages exposing (..)




-- VIEW

userView : Int -> Models.Model -> Html Messages.Msg
userView userid model =
  let
    location = ""
  in
    div []
    [
      span [] [ text ("This is User " ++ toString userid ++ "'s Page")]
    ]
