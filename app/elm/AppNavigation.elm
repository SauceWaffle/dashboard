module AppNavigation exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Messages exposing (..)
import Types exposing (Page(..))


locationFor : Location -> Msg
locationFor location =
    UrlParser.parseHash route location
        |> GoTo


route : UrlParser.Parser (Page -> a) a
route =
    UrlParser.oneOf
        [ UrlParser.map HomeRoute (UrlParser.s "home")
        , UrlParser.map SupplyDashRoute (UrlParser.s "supply")
        , UrlParser.map UserLoginRoute (UrlParser.s "login")
        , UrlParser.map UserRoute (UrlParser.s "user" </> int)
        , UrlParser.map ReportRoute (UrlParser.s "report" </> string)
        , UrlParser.map ITRequestsRoute (UrlParser.s "tasks")
        , UrlParser.map QEDFitnessRoute (UrlParser.s "fitness")
        , UrlParser.map EditMetricsRoute (UrlParser.s "edit_metrics")
        ]


urlFromPage : Page -> String
urlFromPage page =
  "/#/" ++
    case page of
      HomeRoute -> "home"
      SupplyDashRoute -> "supply"
      UserLoginRoute -> "login"
      UserRoute uid -> "user" ++ "/" ++ (toString uid)
      ReportRoute rpt -> "report" ++ "/" ++ rpt
      ITRequestsRoute -> "tasks"
      QEDFitnessRoute -> "fitness"
      EditMetricsRoute -> "edit_metrics"
      _ -> "home"

-- matcherHome : PathMatcher Route
-- matcherHome =
--     match1 HomeRoute ""
--
-- matcherSupplyDash : PathMatcher Route
-- matcherSupplyDash =
--     match1 SupplyDashRoute "/supply"
--
-- matcherLogin : PathMatcher Route
-- matcherLogin =
--     match1 UserLoginRoute "/login"
--
-- matcherUser : PathMatcher Route
-- matcherUser =
--     match2 UserRoute "/user/" int
--
-- matcherReport : PathMatcher Route
-- matcherReport =
--     match2 ReportRoute "/report/" str
--
-- matcherITRequests : PathMatcher Route
-- matcherITRequests =
--     match1 ITRequestsRoute "/tasks"
