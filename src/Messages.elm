module Messages exposing (..)

import Models exposing (Route)
import Components.Supply.Gauge.Models exposing (..)
import Http

type Msg
  = SwitchView
  | CommitRow
  | LogIn
  | LogOut
  | Hello String
  | RouteError
  | RouteTo Route
  | LoadSlideMenu String
  | LoadGauges String
  | SlideMenuItemsSuccess (List Models.ReportMenu)
  | SlideMenuItemsFail Http.Error
  | GetGaugeValues String
  | GaugeValuesSuccess Gauges
  | GaugeValuesFail Http.Error
