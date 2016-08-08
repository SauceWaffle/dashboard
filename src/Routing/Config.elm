module Routing.Config exposing (..)

import Hop.Types exposing (Config, Location, Query, Router, PathMatcher, newLocation)
import Models exposing (..)
import Routing.Matchers exposing (..)


matchers : List (PathMatcher Route)
matchers =
    [ matcherHome
    , matcherSupplyDash
    , matcherLogin
    , matcherUser
    , matcherReport
    , matcherITRequests
    ]


getConfig : Config Route
getConfig =
    { basePath = "/"
    , hash = True
    , matchers = matchers
    , notFound = NotFoundRoute
    }
