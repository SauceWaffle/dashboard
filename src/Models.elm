module Models exposing (..)

import Hop.Types exposing (Location)
import Components.Supply.Gauge.Models exposing (..)

type alias Menu =
  { name : String
  , link : Route
  , subMenus : List String
  }

type alias ReportMenu =
  { items : List ReportMenuItem
  , menuName : String
  }

type alias ReportMenuItem =
  { fullPath : String
  , menuOrItem : String
  , name : String
  , subMenuName : String
  }

type Route
  = HomeRoute
  | SupplyDashRoute
  | UserLoginRoute
  | UserRoute Int
  | ReportRoute String
  | ITRequestsRoute
  | NotFoundRoute


type alias Model =
  { loggedIn : Bool
  , username : String
  , route : Route
  , routeLocation : Location
  , slideMenuInit : Bool
  , slideMenuData : List ReportMenu
  , supplyGauges : Gauges
  }


initModel : Route -> Hop.Types.Location -> Model
initModel route location =
  { loggedIn = False
  , username = ""
  , route = route
  , routeLocation = location
  , slideMenuInit = False
  , slideMenuData = [{items = [{fullPath="",name="",menuOrItem="",subMenuName=""}], menuName = ""}]
  , supplyGauges = theGauges
  }
