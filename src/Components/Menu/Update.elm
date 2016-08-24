module Components.Menu.Update exposing (..)

import Task
import Http
import Json.Decode as Json exposing (..)

import Models exposing (..)
import Messages exposing (..)
import Keys exposing (getPageMenuFromApi)


getPageMenuItems : Model -> Cmd Msg
getPageMenuItems model =
  let
    userName = model.loginData.userId
    userGroups = List.map (\g -> g.name) model.loginData.groups
  in
    Task.perform PageMenuItemsFail PageMenuItemsSuccess (Http.get (decodePageMenu) (getPageMenuFromApi  ++ "&user=" ++ userName ++ "&groups=" ++ (toString userGroups) ) )

decodePageMenu : Json.Decoder (List String)
decodePageMenu =
  Json.at ["allMenu"] (Json.list Json.string)
