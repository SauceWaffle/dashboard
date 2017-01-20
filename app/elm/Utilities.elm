module Utilities exposing (..)

import Time exposing (..)
import Date exposing (..)
import String exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json


onKeyUp : (Int -> msg) -> Attribute msg
onKeyUp tagger =
  on "keyup" (Json.map tagger keyCode)


getHRDate : Time -> String -- to human readable date
getHRDate t =
   let
     date = Date.fromTime t
     d = toString (Date.day date) -- day
     m = toString (Date.month date) -- month
     y = toString (Date.year date) -- year
     hrd = (monthNumber m) ++ "/" ++ (padLeft 2 '0' d) ++ "/" ++ y
  in
    hrd

getHRDateTime : Time -> String
getHRDateTime t =
  let
    date = Date.fromTime t
    ss = Date.second date |> toString |> padLeft 2 '0'
    mm = Date.minute date |> toString |> padLeft 2 '0'
    hh = Date.hour date |> toString |> padLeft 2 '0'
    d = Date.day date |> toString |> padLeft 2 '0'
    m = Date.month date |> toString |> monthNumber
    y = Date.year date |> toString
    hrdt = m ++ "/" ++ d ++ "/" ++ y ++ " " ++ (twelveHour hh) ++ ":" ++ mm ++ ":" ++ ss ++ " " ++ (amOrPm hh)
  in
    hrdt

monthNumber : String -> String
monthNumber mon =
  case mon of
    "Jan" -> "01"
    "Feb" -> "02"
    "Mar" -> "03"
    "Apr" -> "04"
    "May" -> "05"
    "Jun" -> "06"
    "Jul" -> "07"
    "Aug" -> "08"
    "Sep" -> "09"
    "Oct" -> "10"
    "Nov" -> "11"
    "Dec" -> "12"
    _ -> "00"


dateFormatMonYYYY : Date -> String
dateFormatMonYYYY date =
  let
    theMonth = month date
    mon = case theMonth of
              Jan -> "Jan"
              Feb -> "Feb"
              Mar -> "Mar"
              Apr -> "Apr"
              May -> "May"
              Jun -> "Jun"
              Jul -> "Jul"
              Aug -> "Aug"
              Sep -> "Sep"
              Oct -> "Oct"
              Nov -> "Nov"
              Dec -> "Dec"

    yyyy = toString <| year <| date
  in
    mon ++ " " ++ yyyy



twelveHour : String -> String
twelveHour h =
  let
    start = case toInt h of
              Ok val -> val
              Err msg -> 0
    comp = if start > 12 then start - 12 else start
    end = comp |> toString |> padLeft 2 '0'
  in
    end

amOrPm : String -> String
amOrPm h =
  let
    hr = case toInt h of
            Ok val -> val
            Err msg -> 0
  in
    if hr < 12 then "AM" else "PM"
