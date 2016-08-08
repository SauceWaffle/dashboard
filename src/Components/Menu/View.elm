module Components.Menu.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models as App exposing (..)
import Messages exposing (..)



menus : List Menu
menus =
  [{ name = "Home", link = HomeRoute, subMenus = [] }
  ,{ name = "IT Requests", link = ITRequestsRoute, subMenus = [] }
  ,{ name = "Supply Chain", link = SupplyDashRoute, subMenus = [] }
  ,{ name = "Reports", link = (ReportRoute "home"), subMenus = [ "IT", "Material", "Stockroom" ] }
  ]

-- VIEW

menuBar : App.Model -> List Menu -> Html Messages.Msg
menuBar model menus =
  let
    menu = List.map (\m -> menuItem model m) menus
  in
  div []
  [
    ul [] menu
  ]


menuItem : App.Model -> Menu -> Html Messages.Msg
menuItem model item =
  case item.subMenus of
    [] -> li [ onClick (RouteTo item.link)
             , if model.route == item.link then class "curLink"
               else class ""
             ]
          [ text item.name
          ]

    first :: rest ->
      let
        subs = List.map (\s -> { name = s
                                , link =
                                    case item.link of
                                      ReportRoute rpt -> ReportRoute s
                                      _ -> item.link
                                , subMenus = [] }) item.subMenus
      in
        li [ if model.route == item.link then class "curLink"
             else class ""
           ]
        [ span [ onClick ( RouteTo item.link ) ] [ text item.name
                  , i [ classList [ ("material-icons", True)
                                  , ("menu-down-arrow", True)
                                  ]
                      ]
                      [ text "keyboard_arrow_down" ]
                  ]
        , menuBar model subs
        ]
