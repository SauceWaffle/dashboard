module Keys exposing (..)


getPageMenuFromApi : String
getPageMenuFromApi =
  "http://api.qualedyn.local/ssrs_api.aspx?query=getMyReportsMenu"

getReportMenuFromApi : String
getReportMenuFromApi =
  "http://api.qualedyn.local/ssrs_api.aspx?query=getMyReports"


getGaugeDataFromApi : String
getGaugeDataFromApi =
  "http://api.qualedyn.local/sqlutils_supplydashboard.aspx?query=getGaugeValues_new"



loginApi : String
loginApi =
  "http://api.qualedyn.local/activedirectory_login.aspx?login="

loginKey : String
loginKey =
  "jimisthegreatest"

loginIV : String
loginIV =
  "d2hhdCBpcyB0X4Na"

getActiveDirectoryDataFromApi : String -> String
getActiveDirectoryDataFromApi query =
  let
    apiQuery = if not (String.isEmpty query) then "?q=" ++ query else ""
  in
    "http://api.qualedyn.local/activedirectory_api.aspx" ++ apiQuery





apiMyActivities : String
apiMyActivities =
  "http://api.qualedyn.local/qedfitness_api.aspx?q=get&e="


apiLeaderboardAll : String
apiLeaderboardAll =
  "http://api.qualedyn.local/qedfitness_api.aspx?q=leader_all"

apiLeaderboardDept : String
apiLeaderboardDept =
  "http://api.qualedyn.local/qedfitness_api.aspx?q=leader_dept"





getItRequestsFromApi : String -> String
getItRequestsFromApi query =
  "http://8F128793C.qualedyn.local/sqlutils.aspx?query=" ++ query

addItRequest : String -> String
addItRequest query =
  "http://8F128793C.qualedyn.local/sqlutils.aspx?query=" ++ query

deleteItRequest : String -> String
deleteItRequest reqId =
  "http://8F128793C.qualedyn.local/sqlutils.aspx?query=closeRequest&request=" ++ reqId


saveItRequestNote : String -> String
saveItRequestNote query =
  "http://8F128793C.qualedyn.local/sqlutils.aspx?query=" ++ query

deleteItRequestNote : String -> String
deleteItRequestNote noteId =
  "http://8F128793C.qualedyn.local/sqlutils.aspx?query=delNote&noteId=" ++ noteId




getHomeCarouselImages : String
getHomeCarouselImages =
  "http://api.qualedyn.local/sqlutils.aspx?files=homecarousel"

getCurrentWeather : String
getCurrentWeather =
  "http://api.openweathermap.org/data/2.5/weather?lat=41.55&lon=-81.44&APPID=ddcc389c98ab03cd8b36f243cd16065a"
