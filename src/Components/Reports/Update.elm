module Components.Reports.Update exposing (..)

import Task
import Http
import Json.Decode as Json exposing (..)

import Models exposing (..)
import Messages exposing (..)
import Keys exposing (getReportMenuFromApi)

getReportMenuItems : Model -> Cmd Msg
getReportMenuItems model =
  let
    userName = model.loginData.userId
    userGroups = List.map (\g -> g.name) model.loginData.groups
  in
    Task.perform SlideMenuItemsFail SlideMenuItemsSuccess (Http.get (decodeAllMenus) (getReportMenuFromApi ++ "&user=" ++ userName ++ "&groups=" ++ (toString userGroups) ) )


decodeAllMenus : Json.Decoder (List ReportMenu)
decodeAllMenus =
  Json.at ["allMenu"] (Json.list decodeMenu)

decodeMenu : Json.Decoder ReportMenu
decodeMenu =
  Json.object2 ReportMenu
    ("items" := Json.list decodeMenuItems)
    ("menuName" := Json.string)

decodeMenuItems : Json.Decoder ReportMenuItem
decodeMenuItems =
  Json.object4 ReportMenuItem
    ("fullPath" := Json.string)
    ("menuOrItem" := Json.string)
    ("name" := Json.string)
    ("subMenuName" := Json.string)
