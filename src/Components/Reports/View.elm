module Components.Reports.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (..)
import Messages exposing (..)


-- VIEW

reportsView : String -> Models.Model -> Html Messages.Msg
reportsView rpt model =
  let
    menus = List.map (\m -> reportMenu m) model.slideMenuData
  in
    case model.loggedIn of
      True ->
        div [ class "container" ]
        [ button [ classList [("action", True), ("action--open", True) ], attribute "aria-label" "Open Menu" ] [ span [ classList [("icon", True), ("icon--menu", True) ] ] [] ]
        , nav [ id "ml-menu", class "side-menu" ]
          [ button [ classList [("action", True), ("action--close", True) ], attribute "aria-label" "Close Menu" ] [ span [ classList [("icon", True), ("icon--cross", True) ] ] [] ]
          , div [ id "menuDiv", class "menu__wrap" ]
          menus
          ]
        , iframe [ class "content" ] []
        ]
      False ->
        div []
        [ text "Must Be Logged In To View Reports" ]


reportsDash : Models.Model -> Html Messages.Msg
reportsDash model =
  div []
  [
    h1 [] [ text "Reports Dashboard" ]
  ]


reportView : String -> Models.Model -> Html Messages.Msg
reportView rpt model =
  div []
  [
    h1 [] [ text ("This is the " ++ rpt ++ " Report")]
  ]

reportMenu : ReportMenu -> Html Messages.Msg
reportMenu menu =
  let
    subMenus = List.map (\m -> reportMenuItem m) menu.items
  in
    ul [ attribute "data-menu" menu.menuName
       , class "menu__level"
       ]
       subMenus

reportMenuItem : ReportMenuItem -> Html Messages.Msg
reportMenuItem val =
  let
    subAttribute = if val.menuOrItem == "menu" then (attribute "data-submenu" val.subMenuName) else (attribute "none" "none")
    pathAttribute= if val.menuOrItem == "menu" then (attribute "data-fullreportpath" ("{\"path\": \"\", \"name\": \"" ++ val.subMenuName ++ "\"}") )
                     else (attribute "data-fullreportpath" ("{\"path\": \"" ++ val.fullPath ++ "\", \"name\": \"" ++ val.name ++ "\"}") )
  in
    li [ class "menu__item" ]
       [ a [ class "menu__link"
           , href "#"
           , subAttribute
           , pathAttribute
           ]
           [ text val.name ]
       ]
