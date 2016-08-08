module Components.Supply.Gauge.Models exposing (..)

type alias Gauges =
  List Gauge

type alias Gauge =
  { badEnd : Float
  , badStart : Float
  , goodEnd : Float
  , goodStart : Float
  , id : String
  , okEnd : Float
  , okStart : Float
  , max : Float
  , min : Float
  , title : String
  , value : Float
  }



theGauges : Gauges
theGauges = [ {id = "aGauge", title = "Cost Savings", value = 0, min = 0.0, max = 500.0, badStart = 0, badEnd = 250, okStart = 250, okEnd = 350, goodStart = 350, goodEnd = 500 }
            , {id = "bGauge", title = "On Time Delivery", value = 0, min = 0.0, max = 100.0, badStart = 0, badEnd = 65, okStart = 65, okEnd = 90, goodStart = 90, goodEnd = 100 }
            , {id = "cGauge", title = "Supplier Reject", value = 100, min = 100.0, max = 0.0, badStart = 100, badEnd = 40, okStart = 40, okEnd = 10, goodStart = 10, goodEnd = 0 }
            , {id = "dGauge", title = "Packing Efficiency", value = 0, min = 0.0, max = 100.0, badStart = 0, badEnd = 65, okStart = 65, okEnd = 90, goodStart = 90, goodEnd = 100 }
            , {id = "eGauge", title = "Inventory Counting", value = 0, min = 0.0, max = 100.0, badStart = 0, badEnd = 65, okStart = 65, okEnd = 90, goodStart = 90, goodEnd = 100 }
            , {id = "fGauge", title = "Dollars and Turns", value = 0, min = 0.0, max = 5.0, badStart = 0, badEnd = 2.5, okStart = 2.5, okEnd = 4.0, goodStart = 4.0, goodEnd = 5.0 }
            , {id = "gGauge", title = "Kitting Errors", value = 0, min = 100.0, max = 0.0, badStart = 100, badEnd = 65, okStart = 65, okEnd = 20, goodStart = 20, goodEnd = 0 }
            , {id = "hGauge", title = "Kitting Efficiency", value = 100, min = 0.0, max = 100.0, badStart = 0, badEnd = 65, okStart = 65, okEnd = 90, goodStart = 90, goodEnd = 100 }
            , {id = "iGauge", title = "Whatever Man", value = 0, min = 0.0, max = 100.0, badStart = 0, badEnd = 65, okStart = 65, okEnd = 90, goodStart = 90, goodEnd = 100 }
            ]
