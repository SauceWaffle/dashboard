module Components.ItRequests.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (..)
import Components.ItRequests.Models exposing (..)
import Styles exposing (..)
import Messages exposing (..)




-- VIEW

itRequestsView : Models.Model -> Html Messages.Msg
itRequestsView model =
  div [ styles.itRequests ]
  [ requestsView model
  , requestDetails model
  , requestNotes model
  , requestsFooter model
  ]


requestsHeader : Models.Model -> Html Messages.Msg
requestsHeader model =
  div [ class "requests-header" ]
  [ text "IT Requests Center"
  ]



requestsView : Models.Model -> Html Messages.Msg
requestsView model =
  let
    requests = if model.itRequests == [emptyItRequest] then [] else List.map (\r -> (requestLine model r)) model.itRequests
  in
    case model.loggedIn of
      True ->
              div []
              [ ul [ class "requests-table-header" ]
                [ li [ class "itrequest-due" ] [ text "Due Date" ]
                , li [ class "itrequest-priority" ] [ text "Priority" ]
                , li [ class "itrequest-age" ] [ text "Due In" ]
                --, li [ class "itrequest-assign" ] [ text "Assigned To" ]
                , li [ class "itrequest-desc" ] [ text "Task" ]
                --, li [] [ text "Date Requested" ]
                --, li [] [ text "Requested By" ]
                ]
              , ul [ class "requests-table-lines" ]
                requests
              ]
      False ->
              div [ class "requests-not-logged-in" ] [ text "Must Be Logged In To View Your Tasks" ]

requestLine : Models.Model -> ItRequest -> Html Messages.Msg
requestLine model request =
  li [ onClick (SelectRequestRow request.id), class (if model.selectedRequest == request.id then "selected-request-line" else "full-request-line") ]
  [ ul [ class "itrequest" ]
    [ li [ class "itrequest-due" ] [ text request.dueOn ]
    , li [ class "itrequest-priority" ] [ text request.priority ]
    , li [ class (if request.age <= 0 then "itrequest-age itrequest-past-due" else "itrequest-age") ]
         [ text ( case request.age of
                    9999 -> ""
                    _ -> if request.age <= 0 then "Past Due" else (toString request.age) ++ request.ageUnit
                )
         ]
    --, li [ class "itrequest-assign" ] [ text request.assignedTo ]
    , li [ class "itrequest-desc" ] [ text request.description ]
    ]
  , div [ class "requests-toolbar" ]
        [ i [ class "material-icons", title "Set Up Reminder" ] [ text "feedback" ]
        , i [ class "material-icons", title "Schedule Meeting" ] [ text "date_range" ]
        , i [ class "material-icons", title "Edit This Task" ] [ text "create" ]
        , i [ class "material-icons", title "Clear This Task" ] [ text "clear" ]
        ]
  ]


requestDetails : Models.Model -> Html Messages.Msg
requestDetails model =
  div [ class "requests-details" ]
  [ text ("details for Task " ++ (toString model.selectedRequest) )
  ]

requestNotes : Models.Model -> Html Messages.Msg
requestNotes model =
  let
    notes = List.map (\n -> requestNote n) model.selectedRequestData.notes
  in
    div [ class "requests-notes" ]
    [ ul [] notes
    ]

requestNote : RequestNote -> Html Messages.Msg
requestNote note =
  li []
  [ ul []
    [ li [] [ text note.date ]
    , li [] [ text note.text ]
    ]
  ]

requestsFooter : Models.Model -> Html Messages.Msg
requestsFooter model =
  div [ class "requests-footer" ]
  [ text "Jim K. Made This"
  ]
