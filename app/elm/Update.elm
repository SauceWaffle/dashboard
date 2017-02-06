port module Update exposing (..)

import Http
import Task
import Time
import Date
import String exposing (..)
import Navigation as Nav
import Json.Decode as Json exposing (..)
import Date.Extra.Format as DateFormat
import Date.Extra.Duration as DateDuration

import Messages exposing (..)
import Types exposing (..)
import Keys exposing (..)
import Decoders exposing (..)


-- PORTS
port isPageReady : String -> Cmd msg

port getEncryptedString : List String -> Cmd msg
port clearLoginCookie : String -> Cmd msg

port returnHomeFromJS : (String -> msg) -> Sub msg
port initPhotoSlideshow : Int -> Cmd msg
port stopPhotoSlideshow : String -> Cmd msg
port slidePhotosLeft : String -> Cmd msg
port slidePhotosRight : String -> Cmd msg
port openTimeMatrixJS : String -> Cmd msg
port openLinkInJS : String -> Cmd msg


port saveActivityData : (Login, List SendActivity) -> Cmd msg
port saveActivityDataComplete : (String -> msg) -> Sub msg
port leadersChanged : (String -> msg) -> Sub msg
port alertWebSocket : (String, String, String) -> Cmd msg



port returnNewRequestFromJS : (String -> msg) -> Sub msg
port initializeNewRequestDatePicker : String -> Cmd msg
port returnNewRequestDueOnFromJS : (String -> msg) -> Sub msg
port getNewRequestDueOnFromJS : String -> Cmd msg
port getAddNoteValueFromJS : String -> Cmd msg
port returnAddNoteValueFromJS : (String -> msg) -> Sub msg
port returnRequestNotesFromJS : (String -> msg) -> Sub msg
port setRequestNoteSizes : String -> Cmd msg

port loadSupplyGauges : Gauges -> Cmd msg
port startGaugeWatcher : String -> Cmd msg
port stopGaugeWatcher : String -> Cmd msg
port returnGaugeGetValues : (String -> msg) -> Sub msg
port returnGaugeFromJS : (String -> msg) -> Sub msg
port returnLoginEncryptedString : (String -> msg) -> Sub msg

port returnReportFromJS : (String -> msg) -> Sub msg
port jsLoadSlideMenu : String -> Cmd msg
port jsClearSlideMenu : String -> Cmd msg


-- FUNCTIONS


getHomeSlideshow : Cmd Msg
getHomeSlideshow =
  Http.send GetHomeSlideshowResponse
    <| (Http.get (getHomeCarouselImages) (decodeHomeCarouselImages))

getPageMenuItems : Model -> Cmd Msg
getPageMenuItems model =
  let
    userName = model.loginData.userId
    userGroups = List.map (\g -> g.name) model.loginData.groups
  in
    Http.send PageMenuItemsResponse
      <| (Http.get (getPageMenuFromApi  ++ "&user=" ++ userName ++ "&groups=" ++ (toString userGroups) ) (decodePageMenu) )


getEmployeeDirectory : Model -> Cmd Msg
getEmployeeDirectory model =
  let
    apiQuery = "new_site"
  in
    Http.send GetEmployeeDirectoryResponse
      <| (Http.get (getActiveDirectoryDataFromApi apiQuery) (decodeEmployeeDirectory) )




getToday : Cmd Msg
getToday =
  Task.perform GotTime Time.now

getMyActivities : Login -> Cmd Msg
getMyActivities login =
  Http.send GetMyActivitiesResponse
    <| (Http.get (apiMyActivities ++ login.userId) (decodeActivities) )


getLeadersAll : Cmd Msg
getLeadersAll =
  Http.send LeaderBoardAllResponse
    <| (Http.get (apiLeaderboardAll) (decodeAllLeaders) )

getLeadersDept : Cmd Msg
getLeadersDept =
  Http.send LeaderBoardDeptResponse
    <| (Http.get (apiLeaderboardDept) (decodeDeptLeaders) )






getMyItRequests : Model -> Cmd Msg
getMyItRequests model =
  let
    apiQuery = "myRequests&user=" ++ model.loginData.userId
  in
    Http.send ItRequestsResponse
      <| (Http.get (getItRequestsFromApi apiQuery) (decodeAllRequests) )


addNoteToRequest : Model -> String -> Cmd Msg
addNoteToRequest model note =
  let
    apiQuery = "newNote&request=" ++ (toString model.selectedRequest) ++ "&notetext=" ++ note ++ "&user=" ++ model.loginData.userId
  in
    Http.send AddRequestNoteResponse
      <| (Http.get (saveItRequestNote apiQuery) (Json.at [] (Json.list (Json.field "Result" Json.string) )) )


delNoteFromRequest : Int -> Cmd Msg
delNoteFromRequest noteId =
  Http.send DeleteRequestNoteResponse
    <| (Http.get (deleteItRequestNote (toString noteId) ) (Json.at [] (Json.list (Json.field "Result" Json.string) )) )




addRequest : Model -> Cmd Msg
addRequest model =
  let
    apiQuery = "newRequest&due=" ++ model.addRequestData.dueOn
                ++ "&priority=" ++ model.addRequestData.priority
                ++ "&requestedby=" ++ (toLower model.loginData.userId)
                ++ "&assignedto=" ++ (toLower model.loginData.userId)
                ++ "&description=" ++ model.addRequestData.description
  in
    Http.send AddRequestResponse
      <| (Http.get (addItRequest apiQuery) (Json.at [] (Json.list (Json.field "Result" Json.string) )) )


delRequest : Int -> Cmd Msg
delRequest reqId =
  Http.send DeleteRequestResponse
    <| (Http.get (deleteItRequest (toString reqId) ) (Json.at [] (Json.list (Json.field "Result" Json.string) )) )



attemptLogin : String -> Cmd Msg
attemptLogin encStr =
  Http.send LoginResponse
    <| (Http.get (loginApi ++ encStr) (decodeLoginData))



getReportMenuItems : Model -> Cmd Msg
getReportMenuItems model =
  let
    userName = model.loginData.userId
    userGroups = List.map (\g -> g.name) model.loginData.groups
  in
    Http.send SlideMenuItemsResponse
      <| (Http.get (getReportMenuFromApi ++ "&user=" ++ userName ++ "&groups=" ++ (toString userGroups) ) (decodeAllMenus) )



getGaugeData : Cmd Msg
getGaugeData =
  Http.send GaugeValuesResponse
    <| (Http.get getGaugeDataFromApi (decodeGaugeData) )





-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
      GoTo page ->
          case page of
              Nothing ->
                  ( { model | currentPage = HomeRoute }, Cmd.none )

              Just page ->
                  case page of
                        ReportRoute rpt -> ({ model | currentPage = page }, Cmd.batch [ (stopGaugeWatcher "gauge"), (stopPhotoSlideshow "gauge") ] )
                        SupplyDashRoute -> ({model | currentPage = page}, Cmd.batch [ getGaugeData, (stopPhotoSlideshow "gauge") ] )
                        ITRequestsRoute -> ({model | currentPage = page, addNoteOpen = False}, Cmd.batch [ (getMyItRequests model), (stopGaugeWatcher "gauge"), (stopPhotoSlideshow "gauge") ])
                        HomeRoute -> ({model | currentPage = page}, Cmd.batch [ (stopGaugeWatcher "gauge"), (isPageReady "home") ])
                        _ -> ({model | currentPage = page}, Cmd.batch [ (stopGaugeWatcher "gauge"), (stopPhotoSlideshow "gauge") ])


      LinkTo path ->
          ({ model | homePopupShown = False }, Nav.newUrl path )



      CommitRow ->
        (model, Cmd.none)

      TimeChanged rightnow ->
        ({model | rightNow = rightnow}, Cmd.none)


      GetHomeSlideshowResponse (Ok images) ->
        let
          newImages = List.filter (\i -> i.fileName /= "endOfFiles") images
          picCount = List.length newImages
        in
          ({model | homeCarouselImages = newImages}, initPhotoSlideshow picCount )

      GetHomeSlideshowResponse (Err _) ->
        (model, Cmd.none)


      SetLoginUser user ->
        ({model | username = user}, Cmd.none)

      SetLoginPass pass ->
        ({model | password = pass}, Cmd.none)

      EncryptLogin encStr ->
        ({model | username = "", password = ""}, getEncryptedString [encStr,loginKey,loginIV])

      LogInKeyUp key ->
        let
          commands = case key of
                      13 -> getEncryptedString [(model.username ++ "|" ++ model.password),loginKey,loginIV]
                      _ -> Cmd.none
        in
          (model, commands)


      LogIn encStr ->
        (model, attemptLogin encStr)

      LoginResponse (Ok login) ->
        let
          newModel = {model | loginData = login, loggedIn = True, username = "", password = ""}
          alwaysCmds = [ (getMyItRequests newModel)
                       , (getPageMenuItems newModel)
                       , (getMyActivities login)
                       , getLeadersAll
                       , getLeadersDept
                       , (getReportMenuItems newModel)
                       ]

          allCmds = alwaysCmds

          commands = Cmd.batch allCmds
        in
          (newModel, commands)

      LoginResponse (Err _) ->
        ({model | loggedIn = False, loginData = {department = "", firstName = "", groups = [], lastName = "", userId = ""} }, clearLoginCookie "me" )

      LogOut ->
        let
          commands = case model.isSavingNeeded of
                        True -> Cmd.batch [ (clearLoginCookie "me"), saveActivityData (model.loginData, model.mySendActivities) ]
                        False -> (clearLoginCookie "me")

          logout = {department = "", firstName = "", groups = [], lastName = "", userId = ""}
          theModel = {model | loginData = logout
                            , loggedIn = False
                            , slideMenuInit = False
                            , itRequests = [emptyItRequest]
                            , pageMenu = newPageMenu}
        in
          case model.currentPage of
            ReportRoute rpt -> ( theModel, commands )
            ITRequestsRoute -> ( theModel, commands )
            _ -> ( theModel , commands )





      LoadSlideshow _ ->
          (model, Cmd.none)--initPhotoSlideshow picCount )

      OpenTimeMatrix ->
        (model, openTimeMatrixJS "")

      OpenQuickLink address ->
        (model, openLinkInJS address)

      OpenPopupLink title content ->
        ({ model | homePopupShown = True, homePopupTitle = title, homePopupContent = content}, Cmd.none)

      ClosePopup ->
        ({ model | homePopupShown = False, homePopupTitle = "", homePopupContent = ""}, Cmd.none)

      SelectInfoTab tab ->
        ({model | companyInfoTabSelected = tab}, Cmd.none)

      SelectInfoDropdownArea panel ->
        let
          selectedPanel = if model.companyInfoDropSelected == panel then "" else panel
        in
          ({model | companyInfoDropSelected = selectedPanel}, Cmd.none)




      PageMenuItemsResponse (Ok menuData) ->
        let
          baseMenus = [{ name = "Home", link = HomeRoute, subMenus = [] }
                      ,{ name = "Fitness", link = QEDFitnessRoute, subMenus = [] }
                      ,{ name = "Reports", link = (ReportRoute "home"), subMenus = menuData }
                      ]

          groupMenus = if model.loginData.userId == "James.Kolenc"
                          then [ { name = "Supply Chain", link = SupplyDashRoute, subMenus = [] } ]
                          else []

          myMenus = if model.loginData.userId == "James.Kolenc"
                        then  [ { name = "My Tasks", link = ITRequestsRoute, subMenus = [] }
                              , { name = "Edit Metrics", link = EditMetricsRoute, subMenus = [] } ]
                    else if model.loginData.userId == "Mark.Vondrak"
                            then  [ { name = "Edit Metrics", link = EditMetricsRoute, subMenus = [] } ]
                    else []

          allMenus = List.concat [baseMenus, groupMenus, myMenus]
        in
          ({model | pageMenu = allMenus }, Cmd.none )

      PageMenuItemsResponse (Err _) ->
        (model, Cmd.none)


      GetEmployeeDirectoryResponse (Ok directory) ->
        ({model | employeeDirectory = directory }, Cmd.none )

      GetEmployeeDirectoryResponse (Err _) ->
        (model, Cmd.none)

      SetEmployeeDirectorySortBy sorty ->
        ({ model | employeeDirectorySortBy = sorty }, Cmd.none)

      SetSelectedEmployee emp ->
        ({ model | selectedEmployee = emp }, Cmd.none)

      SetHoverEmployee emp ->
        ({ model | hoverEmployee = emp }, Cmd.none)





      ShowThisThing newView ->
        ({ model | view = newView, saveActivitiesError = 0}, Cmd.none)

      GotTime time ->
        ({model | today = Date.fromTime time, viewDate = Date.fromTime time}, Cmd.none)

      RefreshLeaderboards _ ->
        (model, Cmd.batch [getLeadersAll,getLeadersDept])

      LeaderBoardAllResponse (Err _) ->
        (model, Cmd.none)

      LeaderBoardAllResponse (Ok leaders) ->
        ({model | leaderboardAll = leaders}, Cmd.none)

      LeaderBoardDeptResponse (Err _) ->
        (model, Cmd.none)

      LeaderBoardDeptResponse (Ok leaders) ->
        ({model | leaderboardDept = leaders}, Cmd.none)




      GetMyActivitiesResponse (Ok activities) ->
        ({model | myActivities = activities}, Cmd.none)

      GetMyActivitiesResponse (Err _) ->
        (model, Cmd.none)

      SaveMyActivityChanges ->
        ({model | isSaving = True }, saveActivityData (model.loginData, model.mySendActivities) )

      SaveMyActivityChangesDone message ->
        case message of
          "OK" -> ({model | isSaving = False, isSavingNeeded = False, saveActivitiesError = 1}, Cmd.batch [ getMyActivities model.loginData, alertWebSocket ("qedfitness", "save", "") ] )
          _ -> ({model | isSaving = False, saveActivitiesError = 2}, Cmd.batch [ getLeadersAll, getLeadersDept ] )






      SetCurrentActivity id d ->
        ({model | currentActivityId = id, currentActivityDate = d}, Cmd.none )

      DistanceChanged dist ->
        let
          foundActivity = List.head (List.filter (\a -> a.id == model.currentActivityId) model.myActivities)

          newDist = case String.toFloat dist of
                      Ok val -> val
                      Err e -> 0.0

          newStrDist = dist


          newActivity = case foundActivity of
                          Just x -> {x | distance = newDist, strDistance = newStrDist, changed = True}
                          Nothing -> { id = model.currentActivityId
                                      , date = model.currentActivityDate
                                      , distance = newDist
                                      , strDistance = newStrDist
                                      , changed = True
                                      }

          newMyActivities = case foundActivity of
                              Just x -> List.map (\a -> if a.id == model.currentActivityId then newActivity else a) model.myActivities
                              Nothing -> newActivity :: model.myActivities
          newSendActivities = List.map (\a ->
                                        { id = a.id
                                        , date = DateFormat.isoDateString a.date
                                        , distance = a.distance
                                        , changed = a.changed
                                        })
                              newMyActivities
        in
          ({model | isSavingNeeded = True, myActivities = newMyActivities, mySendActivities = newSendActivities}, Cmd.none)

      PreviousMonth ->
        let
          months = model.monthsFromToday - 1
          commands = case model.isSavingNeeded of
                        True -> saveActivityData (model.loginData, model.mySendActivities)
                        False -> Cmd.none
        in
          ({ model | viewDate = DateDuration.add DateDuration.Month -1 model.viewDate, monthsFromToday = months }, commands)

      NextMonth ->
        let
          months = model.monthsFromToday + 1
          commands = case model.isSavingNeeded of
                        True -> saveActivityData (model.loginData, model.mySendActivities)
                        False -> Cmd.none
        in
          ({ model | viewDate = DateDuration.add DateDuration.Month 1 model.viewDate, monthsFromToday = months }, commands)







      ItRequestsResponse (Ok requests) ->
        let
          selected =  case List.filter ( \r -> (r.id == model.selectedRequest) ) requests of
                        x :: xs -> x
                        [] -> emptyItRequest
        in
          ({model | itRequests = requests, selectedRequestData = selected }, Cmd.none )

      ItRequestsResponse (Err _) ->
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

      AddRequestResponse (Ok yesOrNo) ->
        ({model | addRequestOpen = False}, (getMyItRequests model) )

      AddRequestResponse (Err _) ->
        (model, Cmd.none)

      DeleteRequest reqId ->
        (model, delRequest reqId)

      DeleteRequestResponse (Ok yesOrNo) ->
        (model, (getMyItRequests model) )

      DeleteRequestResponse (Err _) ->
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

      AddRequestNoteResponse (Ok yesOrNo) ->
        ({model | addNoteOpen = False}, (getMyItRequests model) )

      AddRequestNoteResponse (Err _) ->
        (model, Cmd.none)

      DeleteRequestNote noteId ->
        (model, delNoteFromRequest noteId)

      DeleteRequestNoteResponse (Ok yesOrNo) ->
        (model, (getMyItRequests model) )

      DeleteRequestNoteResponse (Err _) ->
        (model, Cmd.none)




      LoadSlideMenu message ->
        case model.slideMenuInit of
            False -> case model.loggedIn of
                      True -> ({model | slideMenuInit = True }, jsLoadSlideMenu message )
                      _ -> (model, Cmd.none)
            True -> (model, Cmd.none)

      SlideMenuItemsResponse (Ok menuData) ->
        ({model | slideMenuData = menuData}, (isPageReady "report") )

      SlideMenuItemsResponse (Err _) ->
        (model, Cmd.none)





      LoadGauges message ->
        case model.currentPage of
          SupplyDashRoute -> (model, Cmd.batch [ (loadSupplyGauges model.supplyGauges), (startGaugeWatcher "gauge") ])
          _ -> (model, Cmd.none)

      GetGaugeValues message ->
        (model, getGaugeData)

      GaugeValuesResponse (Ok gaugeData) ->
        ({model | supplyGauges = gaugeData }, (isPageReady "gauge"))

      GaugeValuesResponse (Err _) ->
        (model, Cmd.none)




      SetCurrentMetricRow metric ->
        ({model | currentMetricRow = metric}, Cmd.none)

      SaveMetricChanges ->
        (model, Cmd.none)
