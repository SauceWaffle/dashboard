module Types exposing (..)

import Date exposing (Date)
import Time
import Task
import Date.Extra.Utils as DateUtils


type Page
    = HomeRoute
    | SupplyDashRoute
    | UserLoginRoute
    | UserRoute Int
    | ReportRoute String
    | ITRequestsRoute
    | QEDFitnessRoute
    | EditMetricsRoute
    | NotFoundRoute


type alias Login =
  { department : String
  , firstName : String
  , groups : (List LoginGroup)
  , lastName : String
  , userId : String
  }

type alias LoginGroup =
  { name : String
  }


type alias Image =
  { fileName : String
  }

type alias Menu =
  { name : String
  , link : Page
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




type alias Model =
  { rightNow : Time.Time
  , loggedIn : Bool
  , loginData : Login
  , username : String
  , password : String

  , currentPage : Page
  , pageMenu : List Menu


  -- HOME PAGE
  , homeCarouselImages : List Image
  , companyInfoTabSelected : String
  , companyInfoDropSelected : String
  , homePopupShown : Bool
  , homePopupTitle : String
  , homePopupContent : String

  , employeeDirectory : List Employee
  , roomDirectory : List Room
  , employeeDirectorySortBy : String
  , selectedEmployee : Employee
  , hoverEmployee : Employee


  -- FITNESS TRACKING
  , view : String
  , leaderboardAll : List LeadersAll
  , leaderboardDept : List LeadersDept

  , myActivities : List Activity
  , monthsFromToday : Int
  , currentActivityId : Int
  , currentActivityDate : Date
  , mySendActivities : List SendActivity
  , isSaving : Bool
  , isSavingNeeded : Bool
  , saveActivitiesError : Int

  , today: Date
  , viewDate: Date


  -- MY TASKS PAGE
  , itRequests : List ItRequest
  , addRequestData : ItRequest
  , addRequestOpen : Bool
  , addNoteOpen : Bool
  , selectedRequest : Int
  , selectedRequestData : ItRequest
  , slideMenuInit : Bool
  , slideMenuData : List ReportMenu


  -- SUPPLY CHAIN DASHBOARD
  , supplyGauges : Gauges


  -- EDIT METRICS
  , currentMetricRow : MetricRow
  , metric : Metric
  }


initModel : Model
initModel =
  { rightNow = 0
  , loggedIn = False
  , loginData = {department = "", firstName = "", groups = [], lastName = "", userId = ""}
  , username = ""
  , password = ""

  , currentPage = HomeRoute
  , pageMenu = newPageMenu

  -- HOME PAGE
  , homeCarouselImages = []
  , companyInfoTabSelected = "qed 101"
  , companyInfoDropSelected = ""
  , homePopupShown = False
  , homePopupTitle = ""
  , homePopupContent = ""

  , employeeDirectory = []
  , roomDirectory = []
  , employeeDirectorySortBy = "Last Name"
  , selectedEmployee = emptyEmployee
  , hoverEmployee = emptyEmployee


  -- FITNESS TRACKING
  , view = "leaders"
  , leaderboardAll = []
  , leaderboardDept = []

  , myActivities = []
  , monthsFromToday = 0
  , currentActivityId = 0
  , currentActivityDate = DateUtils.unsafeFromString "January 1, 1900"
  , mySendActivities = []
  , isSaving = False
  , isSavingNeeded = False
  , saveActivitiesError = 0

  , today = DateUtils.unsafeFromString "January 1, 1900"
  , viewDate = DateUtils.unsafeFromString "January 1, 1900"


  -- MY TASKS PAGE
  , itRequests = [emptyItRequest]
  , addRequestData = emptyItRequest
  , addRequestOpen = False
  , addNoteOpen = False
  , selectedRequest = 0
  , selectedRequestData = emptyItRequest
  , slideMenuInit = False
  , slideMenuData = [{items = [{fullPath="",name="",menuOrItem="",subMenuName=""}], menuName = ""}]


  -- SUPPLY CHAIN DASHBOARD
  , supplyGauges = theGauges


  -- EDIT Metrics
  , currentMetricRow = { id = 0 }
  , metric =
    { columns = [ "Name", "Linked Account", "Place", "Handicap", "Average Score", "Total Score", "Number of Rounds", "Chatroom Font Color", "Remove Golfer" ]
    , rows = [ {id = 1}
            , {id = 2}
            , {id = 3}
            , {id = 4}
            , {id = 5}
            ]
    }
  }


newPageMenu : List Menu
newPageMenu =
  [{ name = "Home", link = HomeRoute, subMenus = [] }
  ,{ name = "Fitness", link = QEDFitnessRoute, subMenus = [] }
  ,{ name = "Reports", link = (ReportRoute "home"), subMenus = [] }
  ]





type alias Employee =
  { department : String
  , description : String
  , firstname : String
  , mail : String
  , mobile : String
  , office : String
  , photo : String
  , physicalDeliveryOfficeName : String
  , sn : String
  , title : String
  }

type alias Room =
  { name : String
  , phoneNumber : String
  }

emptyEmployee : Employee
emptyEmployee =
  { department = ""
  , description = ""
  , firstname = ""
  , mail = ""
  , mobile = ""
  , office = ""
  , photo = ""
  , physicalDeliveryOfficeName = ""
  , sn = ""
  , title = ""
  }






type alias Activity =
  { changed : Bool
  , date : Date
  , distance : Float
  , strDistance : String
  , id : Int
  }

type alias SendActivity =
  { changed : Bool
  , date : String
  , distance : Float
  , id : Int
  }

type alias LeadersAll =
  { distance : Float
  , employee : String
  , place : Int
  }

type alias LeadersDept =
  { department : String
  , distance : Float
  , employee : String
  , place : Int
  }


emptyActivity : Activity
emptyActivity =
  { id = 0
  , date = DateUtils.unsafeFromString "January 1, 1900"
  , distance = 0.00
  , strDistance = ""
  , changed = False
  }





type alias ItRequest =
  { age : Int
  , ageUnit : String
  , assignedTo : String
  , description : String
  , dueOn : String
  , id : Int
  , notes : (List RequestNote)
  , priority : String
  , requestedBy : String
  , requestedOn : String
  , requestNumber : String
  , requestType : String
  , status : String
  }

type alias RequestNote =
  { author : String
  , date : String
  , id : Int
  , requestId : Int
  , text : String
  }

emptyItRequest : ItRequest
emptyItRequest =
  {age = 0
  , ageUnit = ""
  , assignedTo = ""
  , description = ""
  , dueOn = ""
  , id = 0
  , notes = []--emptyRequestNote
  , priority = "Normal"
  , requestedBy = ""
  , requestedOn = ""
  , requestNumber = ""
  , requestType = ""
  , status = ""
  }

emptyRequestNote : List RequestNote
emptyRequestNote =
  [{author = ""
  , date = ""
  , id = 0
  , requestId = 0
  , text = ""
  }]







type alias Gauges =
  List Gauge

type alias Gauge =
  { badEnd : Float
  , badStart : Float
  , goodEnd : Float
  , goodStart : Float
  , id : String
  , okEnd : Float
  , okStart : Float
  , max : Float
  , min : Float
  , title : String
  , value : Float
  }



theGauges : Gauges
theGauges = [ {id = "aGauge", title = "Cost Savings", value = 0, min = 0.0, max = 500.0, badStart = 0, badEnd = 250, okStart = 250, okEnd = 350, goodStart = 350, goodEnd = 500 }
            , {id = "bGauge", title = "On Time Delivery", value = 0, min = 0.0, max = 100.0, badStart = 0, badEnd = 65, okStart = 65, okEnd = 90, goodStart = 90, goodEnd = 100 }
            , {id = "cGauge", title = "Supplier Reject", value = 100, min = 100.0, max = 0.0, badStart = 100, badEnd = 40, okStart = 40, okEnd = 10, goodStart = 10, goodEnd = 0 }
            , {id = "dGauge", title = "Packing Efficiency", value = 0, min = 0.0, max = 100.0, badStart = 0, badEnd = 65, okStart = 65, okEnd = 90, goodStart = 90, goodEnd = 100 }
            , {id = "eGauge", title = "Inventory Counting", value = 0, min = 0.0, max = 100.0, badStart = 0, badEnd = 65, okStart = 65, okEnd = 90, goodStart = 90, goodEnd = 100 }
            , {id = "fGauge", title = "Dollars and Turns", value = 0, min = 0.0, max = 5.0, badStart = 0, badEnd = 2.5, okStart = 2.5, okEnd = 4.0, goodStart = 4.0, goodEnd = 5.0 }
            , {id = "gGauge", title = "Kitting Errors", value = 0, min = 100.0, max = 0.0, badStart = 100, badEnd = 65, okStart = 65, okEnd = 20, goodStart = 20, goodEnd = 0 }
            , {id = "hGauge", title = "Kitting Efficiency", value = 100, min = 0.0, max = 100.0, badStart = 0, badEnd = 65, okStart = 65, okEnd = 90, goodStart = 90, goodEnd = 100 }
            , {id = "iGauge", title = "Whatever Man", value = 0, min = 0.0, max = 100.0, badStart = 0, badEnd = 65, okStart = 65, okEnd = 90, goodStart = 90, goodEnd = 100 }
            ]



type alias Metric =
  { columns : List String
  , rows : List MetricRow
  }

type alias MetricRow =
  { id : Int
  }


type alias CIContent =
  { tab : String
  , contents : List Content
  }

type alias Content =
  { style : String
  , label : String
  , link : String
  , subcontentType : String
  , subcontent : List ContentLine
  }

type alias ContentLine =
  { style : String
  , label : String
  , link : String
  }
