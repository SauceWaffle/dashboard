module Routing.Utils exposing (..)

import Hop exposing (matcherToPath)
import Models exposing (..)
import Routing.Config exposing (..)
import Routing.Matchers exposing (..)


reverse : Route -> String
reverse route =
    case route of
        HomeRoute ->
            matcherToPath matcherHome []

        SupplyDashRoute ->
            matcherToPath matcherSupplyDash []

        UserLoginRoute ->
            matcherToPath matcherLogin []

        UserRoute userid ->
            matcherToPath matcherUser [ toString userid ]

        ReportRoute reportname ->
            matcherToPath matcherReport [ reportname ]

        ITRequestsRoute ->
            matcherToPath matcherITRequests []

        NotFoundRoute ->
            ""
