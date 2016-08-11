module Components.Login.Update exposing (..)

import Task
import Http
import Json.Decode as Json exposing (..)

import Models exposing (Login, LoginGroup)
import Messages exposing (..)
import Keys exposing (loginApi)

attemptLogin : String -> Cmd Msg
attemptLogin encStr =
  Task.perform LoginFail LoginSuccess (Http.get (decodeLoginData) (loginApi ++ encStr))


decodeLoginData : Json.Decoder Login
decodeLoginData =
  Json.at ["login"] decodeLogin

decodeLogin : Json.Decoder Login
decodeLogin =
  Json.object4 Login
  ("firstName" := Json.string)
  ("groups" := (Json.list decodeGroups))
  ("lastName" := Json.string)
  ("userId" := Json.string)

decodeGroups : Json.Decoder LoginGroup
decodeGroups =
  Json.object1 LoginGroup
  ("name" := Json.string)
