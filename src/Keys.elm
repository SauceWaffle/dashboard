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
