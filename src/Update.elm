port module Update exposing (..)

import Messages exposing (..)
import Models exposing (..)
import Components.Reports.Update exposing (getReportMenuItems)
import Components.Supply.Gauge.Update exposing (getGaugeData)
import Components.Supply.Gauge.Models exposing (..)
import Components.Login.Update exposing (attemptLogin)
import Components.Menu.Update exposing (getPageMenuItems)
import Components.ItRequests.Update exposing (getMyItRequests, addRequest, delRequest, addNoteToRequest, delNoteFromRequest)
import Components.ItRequests.Models exposing (emptyItRequest)

import Navigation
import Hop exposing (makeUrl, matchUrl, makeUrlFromLocation)
import Hop.Types exposing (Location, Query)
import Routing.Config exposing (..)
import Routing.Utils exposing (..)
import Keys exposing (..)

-- ROUTING
navigationCmd : String -> Cmd a
navigationCmd path =
    Navigation.newUrl (makeUrl Routing.Config.getConfig path)

urlParser : Navigation.Parser ( Route, Hop.Types.Location )
urlParser =
    Navigation.makeParser (.href >> matchUrl Routing.Config.getConfig)


urlUpdate : ( Route, Hop.Types.Location ) -> Model -> ( Model, Cmd Msg )
urlUpdate ( route, location ) model =
  ({ model | route = route, routeLocation = location }, Cmd.none )



-- PORTS
port isPageReady : String -> Cmd msg

port getEncryptedString : List String -> Cmd msg
port clearLoginCookie : String -> Cmd msg


port returnReportFromJS : (String -> msg) -> Sub msg
port jsLoadSlideMenu : String -> Cmd msg
port jsClearSlideMenu : String -> Cmd msg


port loadSupplyGauges : Gauges -> Cmd msg
port startGaugeWatcher : String -> Cmd msg
port stopGaugeWatcher : String -> Cmd msg
port returnGaugeGetValues : (String -> msg) -> Sub msg
port returnGaugeFromJS : (String -> msg) -> Sub msg
port returnLoginEncryptedString : (String -> msg) -> Sub msg


port returnNewRequestFromJS : (String -> msg) -> Sub msg
port initializeNewRequestDatePicker : String -> Cmd msg
port returnNewRequestDueOnFromJS : (String -> msg) -> Sub msg
port getNewRequestDueOnFromJS : String -> Cmd msg
port getAddNoteValueFromJS : String -> Cmd msg
port returnAddNoteValueFromJS : (String -> msg) -> Sub msg
port returnRequestNotesFromJS : (String -> msg) -> Sub msg
port setRequestNoteSizes : String -> Cmd msg


-- FUNCTIONS






-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of

      CommitRow ->
        (model, Cmd.none)

      TimeChanged rightnow ->
        ({model | rightNow = rightnow}, Cmd.none)


      SetLoginUser user ->
        ({model | username = user}, Cmd.none)

      SetLoginPass pass ->
        ({model | password = pass}, Cmd.none)

      EncryptLogin encStr ->
        ({model | username = "", password = ""}, getEncryptedString [encStr,loginKey,loginIV])

      LogIn encStr ->
        (model, attemptLogin encStr)

      LoginSuccess login ->
        case model.route of
          ReportRoute rpt -> ({model | loginData = login, loggedIn = True}, Cmd.batch [ (getReportMenuItems {model | loginData = login, loggedIn = True}), (getPageMenuItems {model | loginData = login, loggedIn = True}) ])
          ITRequestsRoute -> ({model | loginData = login, loggedIn = True}, Cmd.batch [ (getMyItRequests {model | loginData = login, loggedIn = True}), (getPageMenuItems {model | loginData = login, loggedIn = True}) ])
          _ -> ({model | loginData = login, loggedIn = True}, (getPageMenuItems {model | loginData = login, loggedIn = True}))

      LoginFail _ ->
        ({model | loggedIn = False, loginData = {firstName = "", groups = [], lastName = "", userId = ""} }, clearLoginCookie "me" )

      LogOut ->
        let
          logout = {firstName = "", groups = [], lastName = "", userId = ""}
        in
          case model.route of
            ReportRoute rpt -> ({model | loginData = logout, loggedIn = False, slideMenuInit = False}, (clearLoginCookie "me") )--(jsClearSlideMenu "clearReport") )
            ITRequestsRoute -> ({model | itRequests = [emptyItRequest], loginData = logout, loggedIn = False}, (clearLoginCookie "me") )
            _ -> ({model | loginData = logout, loggedIn = False}, (clearLoginCookie "me") )





      RouteError ->
        (model, Cmd.none)

      RouteTo route ->
        let
          path = Routing.Utils.reverse (route)
        in
          case route of
            ReportRoute rpt ->
              case model.loggedIn of
                True -> (model, Cmd.batch [ (navigationCmd path), (getReportMenuItems model), (stopGaugeWatcher "gauge") ] )
                False -> (model, Cmd.batch [ (navigationCmd path), (stopGaugeWatcher "gauge") ] )
            SupplyDashRoute -> ({model | slideMenuInit = False}, Cmd.batch [ (navigationCmd path), getGaugeData ] )
            ITRequestsRoute -> ({model | addRequestOpen = False, addNoteOpen = False}, Cmd.batch [ (navigationCmd path), (getMyItRequests model), (stopGaugeWatcher "gauge") ])
            _ -> ({model | slideMenuInit = False}, Cmd.batch [ (navigationCmd path), (stopGaugeWatcher "gauge") ])






      PageMenuItemsSuccess menuData ->
        (model, Cmd.none)
        -- ({model | pageMenu = [{ name = "Home", link = HomeRoute, subMenus = [] }
        --                     ,{ name = "IT Requests", link = ITRequestsRoute, subMenus = [] }
        --                     ,{ name = "Supply Chain", link = SupplyDashRoute, subMenus = [] }
        --                     ,{ name = "Reports", link = (ReportRoute "home"), subMenus = menuData }
        --                     ] }, Cmd.none )

      PageMenuItemsFail _ ->
        (model, Cmd.none)






      ItRequestsSuccess requests ->
        let
          selected =  case List.filter ( \r -> (r.id == model.selectedRequest) ) requests of
                        x :: xs -> x
                        [] -> emptyItRequest
        in
          ({model | itRequests = requests, selectedRequestData = selected }, Cmd.none )

      ItRequestsFail _ ->
        (model, Cmd.none)

      SelectRequestRow selectedId ->
        let
          selected =  case List.filter ( \r -> (r.id == selectedId) ) model.itRequests of
                        x :: xs -> x
                        [] -> emptyItRequest
        in
          ({model | selectedRequest = selectedId, selectedRequestData = selected}, isPageReady "requestNotes" )

      OpenAddRequest ->
        ({model | addRequestOpen = True, addRequestData = emptyItRequest}, isPageReady "newRequest")

      CloseAddRequest ->
        ({model | addRequestOpen = False}, Cmd.none)

      LoadDueOnDatePicker _ ->
        (model, initializeNewRequestDatePicker "")

      NewRequestDueOnChanged ->
        (model, getNewRequestDueOnFromJS "")

      AddRequest ->
        (model, addRequest model)

      AddRequestSuccess yesOrNo ->
        ({model | addRequestOpen = False}, (getMyItRequests model) )

      AddRequestFail _ ->
        (model, Cmd.none)

      DeleteRequest reqId ->
        (model, delRequest reqId)

      DeleteRequestSuccess yesOrNo ->
        (model, (getMyItRequests model) )

      DeleteRequestFail _ ->
        (model, Cmd.none)

      SetNewRequestDue due ->
        let
          curData = model.addRequestData
          newData = {curData | dueOn = due}
        in
          ({model | addRequestData = newData}, Cmd.none)

      SetNewRequestPriority prio ->
        let
          curData = model.addRequestData
          newData = {curData | priority = prio}
        in
          ({model | addRequestData = newData}, Cmd.none)

      SetNewRequestDescription desc ->
        let
          curData = model.addRequestData
          newData = {curData | description = desc}
        in
          ({model | addRequestData = newData}, Cmd.none)


      RequestNotesAreReady _ ->
        (model, setRequestNoteSizes "" )

      OpenAddNote ->
        ({model | addNoteOpen = True}, Cmd.none)

      CloseAddNote ->
        ({model | addNoteOpen = False}, Cmd.none)

      AddRequestNote ->
        (model, getAddNoteValueFromJS "note")

      ActuallyAddRequestNote note ->
        (model, addNoteToRequest model note)

      AddRequestNoteSuccess yesOrNo ->
        ({model | addNoteOpen = False}, (getMyItRequests model) )

      AddRequestNoteFail _ ->
        (model, Cmd.none)

      DeleteRequestNote noteId ->
        (model, delNoteFromRequest noteId)

      DeleteRequestNoteSuccess yesOrNo ->
        (model, (getMyItRequests model) )

      DeleteRequestNoteFail _ ->
        (model, Cmd.none)



      LoadSlideMenu message ->
        case model.route of
          ReportRoute rpt -> case model.slideMenuInit of
                              False -> case model.loggedIn of
                                        True -> ({model | slideMenuInit = True }, jsLoadSlideMenu message )
                                        _ -> (model, Cmd.none)
                              True -> (model, Cmd.none)
          _ -> (model, Cmd.none)

      SlideMenuItemsSuccess menuData ->
        ({model | slideMenuData = menuData}, (isPageReady "report") )

      SlideMenuItemsFail _ ->
        (model, Cmd.none)





      LoadGauges message ->
        case model.route of
          SupplyDashRoute -> (model, Cmd.batch [ (loadSupplyGauges model.supplyGauges), (startGaugeWatcher "gauge") ])
          _ -> (model, Cmd.none)

      GetGaugeValues message ->
        (model, getGaugeData)

      GaugeValuesSuccess gaugeData ->
        ({model | supplyGauges = gaugeData }, (isPageReady "gauge"))

      GaugeValuesFail _ ->
        (model, Cmd.none)
