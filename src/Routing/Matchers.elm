module Routing.Matchers exposing (..)

import Hop.Types exposing (Config, Location, Query, Router, PathMatcher, newLocation)
import Hop.Matchers exposing (..)
import Models exposing (..)

matcherHome : PathMatcher Route
matcherHome =
    match1 HomeRoute ""

matcherSupplyDash : PathMatcher Route
matcherSupplyDash =
    match1 SupplyDashRoute "/supply"

matcherLogin : PathMatcher Route
matcherLogin =
    match1 UserLoginRoute "/login"

matcherUser : PathMatcher Route
matcherUser =
    match2 UserRoute "/user/" int

matcherReport : PathMatcher Route
matcherReport =
    match2 ReportRoute "/report/" str

matcherITRequests : PathMatcher Route
matcherITRequests =
    match1 ITRequestsRoute "/itrequests" 
