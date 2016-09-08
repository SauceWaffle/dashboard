module Components.ItRequests.View exposing (..)

import Html exposing (..)
import Html.Attributes as Attribs exposing (..)
import Html.Events exposing (..)
import Time exposing (..)
import Json.Decode as Json exposing (..)

import Models exposing (..)
import Components.ItRequests.Models exposing (..)
import Styles exposing (..)
import Messages exposing (..)
import Utilities exposing (..)




-- VIEW

itRequestsView : Models.Model -> Html Messages.Msg
itRequestsView model =
  div [ styles.itRequests ]
  [ requestsView model
  , requestDetails model
  , requestNotes model
  --, requestsFooter model
  ]


requestsHeader : Models.Model -> Html Messages.Msg
requestsHeader model =
  div [ class "requests-header" ]
  [ text "IT Requests Center"
  ]



requestsView : Models.Model -> Html Messages.Msg
requestsView model =
  let
    requests =
        if model.addRequestOpen
          then List.append (List.map (\r -> (requestLine model r)) model.itRequests) [ (requestAddRequest model) ]
          else if model.itRequests == [emptyItRequest] then [] else List.map (\r -> (requestLine model r)) model.itRequests
  in
    case model.loggedIn of
      True ->
              div [ class "itrequests" ]
              [ ul [ class "requests-table-header" ]
                [ li [ class "itrequest-due" ] [ text "Due Date" ]
                , li [ class "itrequest-priority" ] [ text "Priority" ]
                , li [ class "itrequest-age" ] [ text "Due In" ]
                --, li [ class "itrequest-assign" ] [ text "Assigned To" ]
                , li [ class "itrequest-desc" ] [ text "Task" ]
                --, li [] [ text "Date Requested" ]
                --, li [] [ text "Requested By" ]
                ]
              , ul [ class "requests-table-lines" ] requests
              , i [ class "material-icons md-36 requests-add", title "Add New Task", onClick OpenAddRequest ] [ text "add" ]
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
        [ i [ class "material-icons requests-toolbar-delete", title "Clear This Task", onClick (DeleteRequest request.id) ] [ text "clear" ]
        --,i [ class "material-icons", title "Set Up Reminder" ] [ text "feedback" ]
        --, i [ class "material-icons", title "Schedule Meeting" ] [ text "date_range" ]
        --, i [ class "material-icons", title "Edit This Task" ] [ text "create" ]
        ]
  ]

requestAddRequest : Models.Model -> Html Messages.Msg
requestAddRequest model =
  li [ class "requests-add-line" ]
  [ ul [ class "itrequest" ]
    [ li [ class "requests-add-due" ] [ input [ type' "text", id "dueOnDatePicker" ] [] ]
    , li [ class "requests-add-priority" ]
      [ select [ onInput SetNewRequestPriority ]
        [ option [] [ text "Low" ]
        , option [ attribute "selected" "True" ] [ text "Normal" ]
        , option [] [ text "High"]
        ]
      ]
    , li [ class "itrequest-age requests-add-age" ] [ text "" ]
    --, li [ class "itrequest-assign" ] [ text request.assignedTo ]
    , li [ class "requests-add-desc" ] [ textarea [ onInput SetNewRequestDescription ] [] ]
    ]
  , div [ class "requests-add-toolbar" ]
    [ i [ class "material-icons requests-add-close", title "Cancel", onClick CloseAddRequest ] [ text "clear" ]
    , i [ class "material-icons requests-add-commit", title "Commit", onClick AddRequest ] [ text "done" ]
    ]
  ]


requestDetails : Models.Model -> Html Messages.Msg
requestDetails model =
  div [ class "requests-details" ]
  [ text "Notes"--("details for Task " ++ (toString model.addRequestData.dueOn) )
  ]

requestNotes : Models.Model -> Html Messages.Msg
requestNotes model =
  let
    notes =
      if model.addNoteOpen
        then List.append [ (requestAddNote model) ] (List.map (\n -> requestNote n) model.selectedRequestData.notes)
        else List.map (\n -> requestNote n) model.selectedRequestData.notes
  in
    if model.selectedRequest == 0 then
      div [ class "requests-notes" ] [ ul [] notes ]
    else
      div [ class "requests-notes" ]
      [ ul [] notes
      , i [ class "material-icons md-36 requests-notes-add", title "Add Note", onClick OpenAddNote ] [ text "add" ]
      ]


requestNote : RequestNote -> Html Messages.Msg
requestNote note =
  li [ class "requests-notes-note" ]
  [ ul []
    [ li [ class "requests-note-date" ]
      [ text note.date
      , i [ class "requests-note-add-cancel material-icons", title "Delete This Note", onClick (DeleteRequestNote note.id) ] [ text "cancel" ]
      ]
    , li [ class "requests-note-text" ] [ textarea [ Attribs.value note.text, class "requests-note-textarea", attribute "readonly" "true" ] [] ]
    ]
  ]

requestsFooter : Models.Model -> Html Messages.Msg
requestsFooter model =
  div [ class "requests-footer" ]
  [ text "Jim K. Made This"
  ]


requestAddNote : Models.Model -> Html Messages.Msg
requestAddNote model =
  li [ class "requests-notes-note" ]
  [ ul []
    [ li [ class "requests-note-date" ]
      [ text (getHRDate model.rightNow)
      , i [ class "requests-note-add-cancel material-icons", title "Cancel", onClick CloseAddNote ] [ text "cancel" ]
      ]
    , li [ class "requests-note-text" ] [ textarea [ id "addRequestNoteTextArea", class "requests-add-note-text" ] [] ]
    , li [ class "requests-note-add-commit" ] [ i [ class "material-icons md-36", title "Save Note", onClick AddRequestNote ] [ text "check_circle" ] ]
    ]
  ]
