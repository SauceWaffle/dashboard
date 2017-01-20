port module MyActivity exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http exposing (..)
import Task

import Date exposing (Date)
import Date.Extra.I18n.I_en_us exposing (monthName)
import Date.Extra.Floor as DateFloor
import Date.Extra.Core as DateExtra
import Date.Extra.Utils as DateUtils
import Date.Extra.Field as DateField
import Date.Extra.Duration as DateDuration
import Date.Extra.Compare as DateCompare

import Types exposing (..)
import Messages exposing (..)
import Decoders exposing (..)
import Keys exposing (..)



port saveActivityData : (Login, List SendActivity) -> Cmd msg
port saveActivityDataComplete : (String -> msg) -> Sub msg


getMyActivities : Login -> Cmd Msg
getMyActivities login =
  Task.perform GetMyActivitiesFail GetMyActivitiesSuccess (Http.get (decodeActivities) (apiMyActivities ++ login.userId) )



myActivitiesView : Model -> Html Msg
myActivitiesView model =
  let
    shown = style [("display", "block")]
    hidden = style [("display", "none")]
  in
    div [ class "my-activities-view", if model.loggedIn then shown else hidden ]
    [ viewSavingStatus model
    , viewCalendar model
    ]


viewSavingStatus : Model -> Html Msg
viewSavingStatus model =
  let
    errorClass = "my-activities-saving-status-bar saving-error"
    savedClass = "my-activities-saving-status-bar saving-ok"
    notSavedClass = "my-activities-saving-status-bar saving-needed"
    savingClass = "my-activities-saving-status-bar"
    barClass = case model.isSaving of
                  True -> savingClass
                  False -> case model.isSavingNeeded of
                              True -> notSavedClass
                              False -> case model.saveActivitiesError of
                                          2 -> errorClass
                                          1 -> savedClass
                                          _ -> savingClass

    barText = case model.isSaving of
                  True -> "Saving..."
                  False -> case model.isSavingNeeded of
                              True -> "Changes Have Not Been Saved"
                              False -> case model.saveActivitiesError of
                                          2 -> "Error Saving Your Data!"
                                          1 -> "Save Completed Successfully"
                                          _ -> "Enter Mileage Per Day From Fitness Tracker Below"
  in
    div [ class barClass ] [ text barText ]

viewCalendar : Model -> Html Msg
viewCalendar model =
  let
    shown = style [("display", "block")]
    hidden = style [("display", "none")]
    header =
      List.map text [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ]
        |> List.map (List.repeat 1)
        |> List.map (th [])
        |> thead []
  in
    div [ class "my-activities" ]
      [ viewCalendarControls model
      , div [ class "my-activities-calendar-body" ]
        [ table [ class "my-activities-calendar", attribute "cellpadding" "0" ] (header :: viewMonth model) ]
      ]



--- CALENDAR STUFF

viewCalendarControls : Model -> Html Msg
viewCalendarControls model =
  let
    month = Date.month model.viewDate |> monthName
    nextMonth = toString <| DateExtra.nextMonth <| Date.month model.viewDate
    prevMonth = toString <| DateExtra.prevMonth <| Date.month model.viewDate
    year = Date.year model.viewDate |> toString
  in
    div [ class "my-activities-calendar-header" ]
      [ button [ class "my-activities-calendar-prev-month mui-btn", onClick PreviousMonth ] [ text ( "< " ++ prevMonth ) ]
      , div [ class "my-activities-calendar-month" ] [ month ++ " " ++ year |> text  ]
      , button [ class "my-activities-calendar-next-month mui-btn", onClick NextMonth ] [ text ( nextMonth ++ " ›" ) ]
      ]


viewDay : Model -> Bool -> Date -> Date -> Int -> Html Msg
viewDay model isExternal today viewedMonth day =
  let
    shown = style [("display", "block")]
    hidden = style [("display", "none")]
    dayClass = if model.monthsFromToday < -1 || model.monthsFromToday > 0 then class "my-activities-calendar-day locked"
                  else
                    case isExternal of
                      True -> class "my-activities-calendar-day locked"
                      False -> class "my-activities-calendar-day"
    dayReadOnly = if model.monthsFromToday < -1 || model.monthsFromToday > 0 then attribute "readonly" ""
                  else
                    case isExternal of
                      True -> attribute "readonly" ""
                      False -> attribute "cool" ""
    today = DateFloor.floor DateFloor.Day today
    viewedDay =
      DateField.fieldToDateClamp (DateField.DayOfMonth day) viewedMonth
        |> DateFloor.floor DateFloor.Day
    isToday =
        (&&) (Date.day today == day) (Date.month today == Date.month viewedMonth)
        |> (&&) (Date.year today == Date.year viewedMonth)
    newActivity = { id =
                        0 -
                          ( ((viewedDay |> Date.month |> DateExtra.monthToInt) * 1000000)
                          + ((Date.day viewedDay) * 10000)
                          + (Date.year viewedDay)
                          )
                  , date = viewedDay
                  , distance = 0.00
                  , changed = False
                  }
    activity = case List.head (List.filter (\a -> DateCompare.is DateCompare.Same viewedDay a.date) model.myActivities) of
                Just x -> x
                Nothing -> newActivity
    aDistance = if (activity.distance == 0.00) then "" else (toString activity.distance)
  in
    td [ dayClass ]
    [ div [ class "my-activities-calendar-day-header"]
      [ div [ class "my-activities-calendar-day-number" ] [ text (toString day) ]
      ]
    , div [ if activity.distance > 26.2
              then class "my-activities-calendar-day-body bad"
              else
                if activity.changed
                  then class "my-activities-calendar-day-body changed"
                  else class "my-activities-calendar-day-body"
          ]
      [ input [ class "my-activities-calendar-day-distance"
              , type' "number"
              , attribute "step" "0.01"
              , dayReadOnly
              , Html.Attributes.min "0"
              , Html.Attributes.max "250.00"
              , value aDistance
              , onFocus (SetCurrentActivity activity.id activity.date)
              , onInput DistanceChanged
              ] []
      ]
    ]



viewDays : Model -> List Int -> Date -> Date -> Bool -> List (Html Msg)
viewDays model days viewedMonth today isExternal =
  List.map (viewDay model isExternal today viewedMonth) days


viewMonth : Model -> List (Html Msg)
viewMonth model =
  let
    previousDays =
      let days = lastWeekOfMonth (prevMonth model.viewDate)
      in if List.length days < 7 then days else []
    currentDays = [1..(DateExtra.daysInMonthDate model.viewDate)]
    nextDays =
      let days = firstWeekOfMonth (nextMonth model.viewDate)
      in if List.length days < 7 then days else []
  in
    viewDays model nextDays (nextMonth model.viewDate) model.today True
      |> List.append (viewDays model currentDays model.viewDate model.today False)
      |> List.append (viewDays model previousDays (prevMonth model.viewDate) model.today True)
      |> splitWeeks
      |> List.map (tr [])


splitWeeks: List (Html Msg) -> List (List (Html Msg))
splitWeeks days =
  if List.length days == 0 then []
  else
    let
      thisWeek = List.take 7 days |> List.repeat 1
      remainingDays = List.drop 7 days
    in
      List.append thisWeek (splitWeeks remainingDays)


firstWeekOfMonth : Date -> List Int
firstWeekOfMonth date =
  let
    days =
      let weekDay = Date.dayOfWeek (DateExtra.toFirstOfMonth date)
      in DateExtra.daysBackToStartOfWeek Date.Sun weekDay
    dd = Debug.log "D" (Date.day date)
  in
    [1..days]


lastWeekOfMonth : Date -> List Int
lastWeekOfMonth date =
  let
    days =
      let weekDay = Date.dayOfWeek (DateExtra.lastOfMonthDate date)
      in DateExtra.daysBackToStartOfWeek weekDay Date.Sun
    daysInMonth = DateExtra.daysInMonthDate date
  in
    [(daysInMonth - days)..(daysInMonth)]

prevMonth : Date -> Date
prevMonth date =
  DateDuration.add DateDuration.Month -1 date


nextMonth : Date -> Date
nextMonth date =
  DateDuration.add DateDuration.Month 1 date
