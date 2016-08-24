module Messages exposing (..)

import Models exposing (Route, Login)
import Components.Supply.Gauge.Models exposing (..)
import Components.ItRequests.Models exposing (..)
import Http

type Msg
  = CommitRow

  | SetLoginUser String
  | SetLoginPass String

  | EncryptLogin String
  | LogIn String
  | LoginSuccess Login
  | LoginFail Http.Error
  | LogOut

  | RouteError
  | RouteTo Route

  | PageMenuItemsSuccess (List String)
  | PageMenuItemsFail Http.Error

  | ItRequestsSuccess (List ItRequest)
  | ItRequestsFail Http.Error
  | SelectRequestRow Int

  | LoadSlideMenu String
  | LoadGauges String
  | SlideMenuItemsSuccess (List Models.ReportMenu)
  | SlideMenuItemsFail Http.Error


  | GetGaugeValues String
  | GaugeValuesSuccess Gauges
  | GaugeValuesFail Http.Error
