module Utilities exposing (..)

import Time exposing (..)
import Date exposing (..)
import String exposing (..)

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
