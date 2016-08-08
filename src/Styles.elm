module Styles exposing (..)

import Html.Attributes exposing (..)

styles = {
  floatLeft =
    style
      [ ("float", "left")
      ]

  , floatRight =
    style
      [ ("float", "right")
      ]

  , header =
    style
      [ ("backgroundColor", "rgba(48, 48, 48, .8)")
      , ("color", "white")
      , ("height", "50px")
      , ("width", "100%")
      ]

  , user =
    style
      [ ("font-size", "1em")
      , ("height", "50px")
      , ("line-height", "50px")
      ]

  , searchMap =
    style
    [ ("backgroundColor", "gray")
    , ("color", "black")
    , ("height", "50px")
    , ("width", "100%")
    ]

  , gauges =
    style
    [ ("width", "90%")
    , ("height", "80%")
    , ("margin", "auto")
    ]

  , gauge =
    style
    [ ("margin", "10px")
    , ("display", "inline-block")
    ]

  , mapArea =
    style
    [ ("width", "100%")
    , ("height", "100px")
    , ("backgroundColor", "#555")]

  , itRequests =
    style
    [ ("width", "100%")
    ]

  }
