module Main exposing (..)

import Dict
import Time exposing (..)
import Navigation as Nav
import UrlParser

import AppNavigation exposing (locationFor, route)
import Messages exposing (..)
import Types exposing (..)
import Update exposing (..)
import View exposing (view)
import Keys exposing (loginKey,loginIV)


-- MODEL

init : Nav.Location -> (Model, Cmd Msg)
init location =
  let
      page =
          case UrlParser.parseHash route location of
              Nothing ->
                  HomeRoute

              Just page ->
                  page

      model = initModel
      theModel = {model | currentPage = page}

      alwaysCmds =  [ getToday
                    , getLeadersAll
                    , getLeadersDept
                    , getHomeSlideshow
                    , getEmployeeDirectory model
                    , getEncryptedString ["", loginKey,loginIV]
                    , getGaugeData
                    ]

      loginCmds = case model.loggedIn of
                      True -> [ (getReportMenuItems model) ]
                      False -> []

      pageCmds = case model.currentPage of
                      ReportRoute rpt -> [ (isPageReady "report"), (isPageReady "home") ]
                      _ -> [ (isPageReady "home") ]

      commands = Cmd.batch (List.concat [ alwaysCmds, loginCmds, pageCmds ] )
  in
    (theModel, commands)




-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ returnHomeFromJS LoadSlideshow
    , returnReportFromJS LoadSlideMenu
    , returnGaugeFromJS LoadGauges
    , returnGaugeGetValues GetGaugeValues
    , returnLoginEncryptedString LogIn

    , returnLoginEncryptedString LogIn
    , saveActivityDataComplete SaveMyActivityChangesDone
    , leadersChanged RefreshLeaderboards

    , returnAddNoteValueFromJS ActuallyAddRequestNote
    , returnNewRequestFromJS LoadDueOnDatePicker
    , returnNewRequestDueOnFromJS SetNewRequestDue
    , returnRequestNotesFromJS RequestNotesAreReady

    , Time.every second TimeChanged
    ]


main : Program Never Model Msg
main =
  Nav.program locationFor
    { view = view
    , update = update
    , subscriptions = subscriptions
    , init = init
    }
