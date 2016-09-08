module Models exposing (..)

import Time
import Hop.Types exposing (Location)
import Components.Supply.Gauge.Models exposing (..)
import Components.ItRequests.Models exposing (..)

type alias Login =
  { firstName : String
  , groups : (List LoginGroup)
  , lastName : String
  , userId : String
  }

type alias LoginGroup =
  { name : String
  }


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
  { rightNow : Time.Time
  , loggedIn : Bool
  , loginData : Login
  , username : String
  , password : String
  , route : Route
  , routeLocation : Location
  , pageMenu : List Menu
  , itRequests : List ItRequest
  , addRequestData : ItRequest
  , addRequestOpen : Bool
  , addNoteOpen : Bool
  , selectedRequest : Int
  , selectedRequestData : ItRequest
  , slideMenuInit : Bool
  , slideMenuData : List ReportMenu
  , supplyGauges : Gauges
  }


initModel : Route -> Hop.Types.Location -> Model
initModel route location =
  { rightNow = 0
  , loggedIn = False
  , loginData = {firstName = "", groups = [], lastName = "", userId = ""}
  , username = ""
  , password = ""
  , route = route
  , routeLocation = location
  , pageMenu = newPageMenu
  , itRequests = [emptyItRequest]
  , addRequestData = emptyItRequest
  , addRequestOpen = False
  , addNoteOpen = False
  , selectedRequest = 0
  , selectedRequestData = emptyItRequest
  , slideMenuInit = False
  , slideMenuData = [{items = [{fullPath="",name="",menuOrItem="",subMenuName=""}], menuName = ""}]
  , supplyGauges = theGauges
  }


newPageMenu : List Menu
newPageMenu =
  [{ name = "Home", link = HomeRoute, subMenus = [] }
  ,{ name = "My Tasks", link = ITRequestsRoute, subMenus = [] }
  ,{ name = "Supply Chain", link = SupplyDashRoute, subMenus = [] }
  ,{ name = "Reports", link = (ReportRoute "home"), subMenus = [] }
  ]
