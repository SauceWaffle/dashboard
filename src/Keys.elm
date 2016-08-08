module Keys exposing (..)

type alias Center =
  { lat : Float
  , lng : Float
  }

gmapsKey : String
gmapsKey =
  "AIzaSyDXeeuxb1vyD__b-jT4FX_sAbYcvUNXxSw"

gmapsCenter : Center
gmapsCenter =
  { lat = 41.583768, lng = -81.4114034 }

getReportMenuFromApi : String
getReportMenuFromApi =
  "http://8F128793C.qualedyn.local/ssrs_api.aspx?query=getMyReportMenu"


getGaugeDataFromApi : String
getGaugeDataFromApi =
  "http://api.qualedyn.local/sqlutils_supplydashboard.aspx?query=getGaugeValues_test"
