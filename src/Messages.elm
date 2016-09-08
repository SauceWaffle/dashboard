module Messages exposing (..)

import Models exposing (Route, Login)
import Components.Supply.Gauge.Models exposing (..)
import Components.ItRequests.Models exposing (..)
import Http
import Time

type Msg
  = CommitRow
  | TimeChanged Time.Time

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
  | AddRequest
  | AddRequestSuccess (List String)
  | AddRequestFail Http.Error
  | OpenAddRequest
  | CloseAddRequest
  | LoadDueOnDatePicker String
  | NewRequestDueOnChanged
  | DeleteRequest Int
  | DeleteRequestSuccess (List String)
  | DeleteRequestFail Http.Error
  | SetNewRequestDue String
  | SetNewRequestPriority String
  | SetNewRequestDescription String
  | RequestNotesAreReady String
  | AddRequestNote
  | ActuallyAddRequestNote String
  | AddRequestNoteSuccess (List String)
  | AddRequestNoteFail Http.Error
  | OpenAddNote
  | CloseAddNote
  | DeleteRequestNote Int
  | DeleteRequestNoteSuccess (List String)
  | DeleteRequestNoteFail Http.Error

  | LoadSlideMenu String
  | LoadGauges String
  | SlideMenuItemsSuccess (List Models.ReportMenu)
  | SlideMenuItemsFail Http.Error


  | GetGaugeValues String
  | GaugeValuesSuccess Gauges
  | GaugeValuesFail Http.Error
