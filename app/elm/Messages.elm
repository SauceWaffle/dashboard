module Messages exposing (..)

import Types exposing (..)
import Http
import Time exposing (..)
import Date exposing (..)

type Msg
  = GoTo (Maybe Page)
  | LinkTo String

  | CommitRow
  | TimeChanged Time.Time

  | SetLoginUser String
  | SetLoginPass String

  | EncryptLogin String
  | LogInKeyUp Int
  | LogIn String
  | LoginResponse (Result Http.Error Login)
  | LogOut


  -- HOME
  | GetHomeSlideshowResponse (Result Http.Error (List Image) )
  | LoadSlideshow String
  | OpenTimeMatrix
  | OpenQuickLink String
  | OpenPopupLink String String
  | ClosePopup

  | SelectInfoTab String
  | SelectInfoDropdownArea String

  | PageMenuItemsResponse (Result Http.Error (List String) )

  | GetEmployeeDirectoryResponse (Result Http.Error (List Employee) )
  | SetEmployeeDirectorySortBy String
  | SetSelectedEmployee Employee
  | SetHoverEmployee Employee



  -- FITNESS TRACKING
  | ShowThisThing String
  | GotTime Time.Time

  | RefreshLeaderboards String
  | LeaderBoardAllResponse (Result Http.Error (List LeadersAll) )
  | LeaderBoardDeptResponse (Result Http.Error (List LeadersDept) )

  | GetMyActivitiesResponse (Result Http.Error (List Activity) )
  | SaveMyActivityChanges
  | SaveMyActivityChangesDone String

  | SetCurrentActivity Int Date.Date
  | DistanceChanged String

  | PreviousMonth
  | NextMonth


  -- MY TASKS PAGE
  | ItRequestsResponse (Result Http.Error (List ItRequest) )
  | SelectRequestRow Int
  | AddRequest
  | AddRequestResponse (Result Http.Error (List String) )
  | OpenAddRequest
  | CloseAddRequest
  | LoadDueOnDatePicker String
  | NewRequestDueOnChanged
  | DeleteRequest Int
  | DeleteRequestResponse (Result Http.Error (List String) )
  | SetNewRequestDue String
  | SetNewRequestPriority String
  | SetNewRequestDescription String
  | RequestNotesAreReady String
  | AddRequestNote
  | ActuallyAddRequestNote String
  | AddRequestNoteResponse (Result Http.Error (List String) )
  | OpenAddNote
  | CloseAddNote
  | DeleteRequestNote Int
  | DeleteRequestNoteResponse (Result Http.Error (List String) )


  -- REPORTS PAGE
  | LoadSlideMenu String
  | SlideMenuItemsResponse (Result Http.Error (List Types.ReportMenu) )


  -- SUPPLY GAUGES
  | LoadGauges String
  | GetGaugeValues String
  | GaugeValuesResponse (Result Http.Error Gauges)


  -- EDIT METRICS
  | SetCurrentMetricRow MetricRow
  | SaveMetricChanges
