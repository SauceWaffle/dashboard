module View exposing (..)


import Html as Html exposing (..)
import Html.Attributes as Attribs exposing (..)
import Html.Events exposing (..)

import Date exposing (Date)
import Date.Extra.I18n.I_en_us exposing (monthName)
import Date.Extra.TimeUnit as TimeUnit
import Date.Extra.Core as DateExtra
import Date.Extra.Utils as DateUtils
import Date.Extra.Field as DateField
import Date.Extra.Duration as DateDuration
import Date.Extra.Compare as DateCompare
import Round as MyRho exposing (..)

import Types exposing (..)
import Messages exposing (..)
import Utilities exposing (..)
import AppNavigation exposing (urlFromPage)


-- VIEW

view : Model -> Html Messages.Msg
view model =
  let
    shown = style [("display","initial")]
    hidden = style [("display","none")]

    startMenu = model.pageMenu
    rpt = case model.currentPage of
              ReportRoute r -> r
              _ -> ""
    uid = case model.currentPage of
              UserRoute u -> u
              _ -> 0
  in
    div [ id "fullPage" ]
    [ topheader model
    , nav [ class "header-menu" ] [ menuBar model startMenu ]
    , div [ if model.currentPage == HomeRoute then shown else hidden ] [ homeView model ]
    , div [ if model.currentPage == SupplyDashRoute then shown else hidden ] [ gaugeView model ]
    , div [ if model.currentPage == ReportRoute rpt then shown else hidden ] [ reportsView rpt model ]
    , div [ if model.currentPage == ITRequestsRoute then shown else hidden ] [ itRequestsView model ]
    -- , div [ if model.currentPage == UserRoute uid then shown else hidden ] [ userView uid model ]
    , div [ if model.currentPage == QEDFitnessRoute then shown else hidden ] [ fitnessTrackingView model ]
    , div [ if model.currentPage == EditMetricsRoute then shown else hidden ] [ editMetricsView model ]
    ]


blankDiv : Html Messages.Msg
blankDiv =
  div [ style [("display","none")] ] []




topheader : Model -> Html Messages.Msg
topheader model =
  let
    bannerText = if model.loggedIn then model.loginData.userId else ""
  in
    div [ class "top-header" ]
    [ div [ class "header-time" ] [ text (getHRDateTime model.rightNow) ]
    , span [ class "floatRight" ] [ userMenu model ]
    ]


userMenu : Model -> Html Messages.Msg
userMenu model =
  loginView model




loginView : Model -> Html Messages.Msg
loginView model =
  let
    inOrOut =
        case model.loggedIn of
          True ->
            div [ class "user" ]
                [ i [ class "userphoto material-icons md-36" ] [ text "account_circle" ]
                , logoutDropDown model
                , div [ class "top-header-user-name" ] [ text (model.loginData.firstName ++ " " ++ model.loginData.lastName) ]
                ]
          False ->
            div [ class "user" ]
            [ i [ class "userphoto material-icons md-36" ] [ text "account_circle" ]
            , loginDropDown model
            ]
  in
    inOrOut


loginDropDown : Model -> Html Msg
loginDropDown model =
  div [ class "user-login-menu", id "loginMenu" ]
  [ ul []
    [ li [] [ div [ class "login-label" ] [ text "Username" ] ]
    , li [] [ input [ class "login-textbox", onInput SetLoginUser, value model.username ] [] ]
    , li [] [ div [ class "login-label" ] [ text "Password" ] ]
    , li [] [ input [ class "login-textbox"
                    , type_ "password"
                    , onInput SetLoginPass
                    , onKeyUp LogInKeyUp
                    , value model.password ] [] ]
    , li [ style [("text-align", "center")] ]
      [ button [ class "login-button mui-btn mui-btn--raised"
               , onClick (EncryptLogin (model.username ++ "|" ++ model.password))
               ]
               [ text "Log In" ]
                                              ]
    ]
  ]

logoutDropDown : Model -> Html Msg
logoutDropDown model =
  div [ class "user-logout-menu", id "logoutMenu" ]
  [ button [ class "logout-button mui-btn mui-btn--raised"
            , onClick LogOut
            ]
            [ text "Log Out" ] ]





menuBar : Model -> List Menu -> Html Messages.Msg
menuBar model menus =
  let
    menu = List.map (\m -> menuItem model m) menus
  in
    div []
    [ ul [] menu
    ]


menuItem : Model -> Menu -> Html Messages.Msg
menuItem model item =
  case item.subMenus of
    [] -> li [ onClick (LinkTo (urlFromPage item.link))
             , if model.currentPage == item.link then class "curLink"
               else class ""
             ]
          [ text item.name
          ]

    first :: rest ->
      li [ onClick (LinkTo (urlFromPage item.link))
               , if model.currentPage == item.link then class "curLink"
                 else class ""
               ]
            [ text item.name
            ]
      -- let
      --   subs = List.map (\s -> { name = s
      --                           , link =
      --                               case item.link of
      --                                 ReportRoute rpt -> ReportRoute s
      --                                 _ -> item.link
      --                           , subMenus = [] }) item.subMenus
      -- in
      --   li [ if model.currentPage == item.link then class "curLink"
      --        else class ""
      --      ]
      --   [ span [ onClick (LinkTo (urlFromPage item.link)) ]
      --       [ text item.name
      --       , i [ classList [ ("material-icons", True)
      --                       , ("menu-down-arrow", True)
      --                       ]
      --           ]
      --           [ text "keyboard_arrow_down" ]
      --       ]
      --   , menuBar model subs
      --   ]







homeView : Model -> Html Messages.Msg
homeView model =
  div [ id "home-page", class "home-page" ]
    [ div [ class "home-top-row" ]
      [ bannerView model
      , carouselView model
      , quickLinksView model
      ]

    , companyInfoView model
    , quickInfoView model

    , footerView model
    , homePagePopupView model
    ]


bannerView : Model -> Html Messages.Msg
bannerView model =
  div [ class "home-banner" ]
  [ h1 [] [ text "Quality Electrodynamics (QED)" ]
  ]

footerView : Model -> Html Messages.Msg
footerView model =
  div [ class "home-footer" ]
  [ div [] [ span [] [ text "CONFIDENTIALITY NOTICE: This site and any links may contain confidential information which is legally privileged. The information is intended only for the use of Quality Electrodynamics employees and assignees. You are hereby notified that any disclosure, copying, distribution of, or the taking of any action in reliance on, the contents of this information is strictly prohibited." ] ]
  ]

homePagePopupView : Model -> Html Messages.Msg
homePagePopupView model =
  let
    showThePopup = if model.homePopupShown then class "home-popup shown" else class "home-popup"

    bodyContent =
        case model.homePopupContent of
          "employeeDirectory" -> employeeDirectoryView model
          _ -> iframe [ class "home-popup-frame", src model.homePopupContent ] []
  in
    div [ showThePopup ]
      [ div [ class "home-popup-area" ]
          [ div [ class "home-popup-header" ]
              [ button [ class "home-popup-back mui-btn mui-btn--raised", onClick ClosePopup ] [ text "Close" ]
              , div [ class "home-popup-header-text" ] [ text model.homePopupTitle ]
              ]

          , div [ class "home-popup-body" ] [ bodyContent ]
          ]
      ]


carouselView : Model -> Html Messages.Msg
carouselView model =
  let
    firstPic = List.head model.homeCarouselImages
    firstPicDiv = case firstPic of
                    Just x -> [ div [ class "che-slideshow-slide" ]
                                  [ img [ src ("img/homecarousel/" ++ x.fileName) ] []
                                  ]
                              ]
                    Nothing -> []

    otherPics = List.tail model.homeCarouselImages
    otherPicDivs = case otherPics of
                      Just x -> x
                                |> List.map (\p ->
                                              div [ class "che-slideshow-slide inactive" ]
                                                [ img [ src ("img/homecarousel/" ++ p.fileName) ] []
                                                ]
                                            )
                      Nothing -> []
    pictures = List.append firstPicDiv otherPicDivs

    indicators = List.append
                    (List.map (\p -> li [ class "slideshow-indicator" ] []) firstPicDiv)
                    (List.map (\p -> li [ class "slideshow-indicator inactive-indicator" ] []) otherPicDivs)

  in
    div [ id "photosAreaViewPane", class "photosAreaViewPane" ]
      [ div [ class "che-slideshow" ]
        [ ol [ class "slideshow-indicator-container" ] indicators
        , div [ class "previousPhoto slideshow-control slideshow-left-control" ]
              [ i [ class "material-icons" ] [ text "keyboard_arrow_left" ]
              ]
        , div [ class "nextPhoto slideshow-control slideshow-right-control" ]
              [ i [ class "material-icons" ] [ text "keyboard_arrow_right" ]
              ]
        , div [] pictures
        ]
      ]




quickInfoView : Model -> Html Messages.Msg
quickInfoView model =
  div [ class "quick-info-area" ]
  [ h3 [] [ text "Quick Info" ]
  , div [ class "quick-info-meat" ]
      [ calendarsView model
      , addressesView model
      , phoneNumbersView model
      , benefitsInfoView model
      , webMailView model
      , publicSiteView model
      ]
  ]

companyInfoView : Model -> Html Messages.Msg
companyInfoView model =
  div [ class "company-info-area" ]
  [ h3 [] [ text "Company Info" ]
  , div [ id "qed101Pane", if model.companyInfoTabSelected == "qed101" then class "company-info-pane showpane" else class "company-info-pane" ]
    [ div [ class "quick-info-header", onClick (OpenPopupLink "Company Directory" "employeeDirectory") ]
        [ text "Company Directory"
        , i [ class "material-icons" ] [ text "open_in_browser" ]
        ]
    , div [ class "quick-info-header", onClick (OpenPopupLink "Employee Handbook" "http://internal.qualedyn.local/pdf/QED_Emp_Hb_Feb2015.pdf") ]
        [ text "Employee Handbook"
        , i [ class "material-icons" ] [ text "open_in_browser" ]
        ]
    , div [ class "quick-info-header", onClick (OpenPopupLink "QED Expectations and Policies" "http://internal.qualedyn.local/pdf/QED_Expectations_and_Policies.pdf") ]
        [ text "QED Expectations and Policies"
        , i [ class "material-icons" ] [ text "open_in_browser" ]
        ]
    -- , div [ class "quick-info-header", onClick (OpenPopupLink "QED Employee of the Month" "about:blank") ]
    --     [ text "QED Employee of the Month"
    --     , i [ class "material-icons" ] [ text "open_in_browser" ]
    --     ]
    , qedHistoryView model
    , fromHiroView model
    ]
  , div [ id "qualityPolicyPane", if model.companyInfoTabSelected == "quality" then class "company-info-pane showpane" else class "company-info-pane" ]
    [ qualityPolicyView model
    ]
  , div [ id "philosophyPane", if model.companyInfoTabSelected == "philosophy" then class "company-info-pane showpane" else class "company-info-pane" ]
    [ philosophyView model
    ]
  , ul [ class "company-info-tabs" ]
    [ li [ if model.companyInfoTabSelected == "qed101" then class "company-info-tab selected" else class "company-info-tab", onClick (SelectInfoTab "qed101") ] [ text "qed 101" ]
    , li [ if model.companyInfoTabSelected == "quality" then class "company-info-tab selected" else class "company-info-tab", onClick (SelectInfoTab "quality") ] [ text "quality" ]
    , li [ if model.companyInfoTabSelected == "philosophy" then class "company-info-tab selected" else class "company-info-tab", onClick (SelectInfoTab "philosophy") ] [ text "philosophy" ]
    ]
  ]

quickLinksView : Model -> Html Messages.Msg
quickLinksView model =
  div [ class "quick-links"]
  [ table [ class "quick-links-table" ]
    [ tr []
      [ td [ class "quick-links-header", colspan 2 ] [ span [] [ text "Quick Links" ] ]
      ]
    , tr [ class "quick-link-row" ]
        [ td [ class "quick-link", onClick (OpenQuickLink "http://qedaps01.qualedyn.local/Agile/PLMServlet") ] [ text "Agile" ]
        , td [ class "quick-link", onClick OpenTimeMatrix ] [ text "Time Matrix" ]
        ]
    , tr [ class "quick-link-row" ]
        [ td [ class "quick-link", onClick (OpenQuickLink "http://qedaps01.qualedyn.local:8180/ETR/") ] [ text "Electronic Training (ETR)" ]
        , td [ class "quick-link", onClick (OpenQuickLink "http://qedrms01/DWWebClient/") ] [ text "DocuWare" ]
        ]
    , tr [ class "quick-link-row" ]
        [ td [ class "quick-link", onClick (OpenQuickLink "mailto:QED-IT-Requests@qualedyn.net") ] [ text "Submit IT Request" ]
        , td [ class "quick-link", onClick (OpenQuickLink "mailto:QED-Office-Requests@qualedyn.net") ] [ text "Submit Office Request" ]
        ]

    ]
  ]


calendarsView : Model -> Html Messages.Msg
calendarsView model =
  div []
  [ div [ class "quick-info-header" ] [ text "Holiday Calendars" ]
  , div [ class "quick-info-link", onClick (OpenPopupLink "QED 2016 Holidays" "http://internal.qualedyn.local/pdf/QED%202016%20Holidays.pdf") ] [ text "QED 2016 Holidays" ]
  , div [ class "quick-info-link", onClick (OpenPopupLink "QED 2016 FW Calendar" "http://internal.qualedyn.local/pdf/QED%20FW%20Calendar%202016.pdf") ] [ text "QED 2016 FW Calendar" ]
  , div [ class "quick-info-link", onClick (OpenPopupLink "QED 2017 Holidays" "http://internal.qualedyn.local/pdf/QED%20Holidays%20-%202017.pdf") ] [ text "QED 2017 Holidays" ]
  , div [ class "quick-info-link", onClick (OpenPopupLink "QED 2017 FW Calendar" "http://internal.qualedyn.local/pdf/QED%20FW%20calendar%20-%202017.pdf") ] [ text "QED 2017 FW Calendar" ]
  ]

addressesView : Model -> Html Messages.Msg
addressesView model =
  div []
  [ div [ class "quick-info-header" ] [ text "QED Facility Information" ]
  , div [ class "quick-info-address"]
    [ div [ class "quick-info-info" ] [ text "6655 Beta Dr." ]
    , div [ class "quick-info-info" ] [ text "Suite 100" ]
    , div [ class "quick-info-info" ] [ text "Mayfield Village, OH 44143" ]
    ]
  , div [ class "quick-info-info" ] [ text "Telephone: 440-638-5106" ]
  , div [ class "quick-info-info" ] [ text "Fax: 440-638-5109" ]
  ]

phoneNumbersView : Model -> Html Messages.Msg
phoneNumbersView model =
  div []
  [ div [ class "quick-info-header" ] [ text "Important Phone Numbers" ]
  , div [ class "quick-info-info" ] [ text "Sick/Late Notification: 440-484-2999" ]
  , div [ class "quick-info-info" ] [ text "Food Delivery: x8009" ]
  , div [ class "quick-info-info" ] [ text "Emergency Dial-In: 440-638-5106 x8010" ]
  ]

benefitsInfoView : Model -> Html Messages.Msg
benefitsInfoView model =
  div []
  [ div [ class "quick-info-header" ] [ text "Benefits Portal" ]
  , div [ class "quick-info-link", onClick (OpenQuickLink "http://www.qed.benergy.com") ] [ text "qed.benergy.com" ]
  , div [ class "quick-info-info" ] [ text "UserID: QED" ]
  , div [ class "quick-info-info" ] [ text "Password: members" ]
  ]
webMailView : Model -> Html Messages.Msg
webMailView model =
  div []
  [ div [ class "quick-info-header" ] [ text "Web Mail Access" ]
  , div [ class "quick-info-link", onClick (OpenQuickLink "https://mail.qualedyn.net/owa") ] [ text "Qualedyn.net" ]
  , div [ class "quick-info-link", onClick (OpenQuickLink "http://mail.qualedyn.com") ] [ text "Qualedyn.com" ]
  ]

publicSiteView : Model -> Html Messages.Msg
publicSiteView model =
  div []
  [ div [ class "quick-info-header" ] [ text "QED Public Site" ]
  , div [ class "quick-info-link", onClick (OpenQuickLink "http://www.qualityelectrodynamics.com/") ] [ text "Public Website" ]
  , div [ class "quick-info-link", onClick (OpenQuickLink "http://www.qualityelectrodynamics.com/info/category-865ca542-2c72-4d1a-adac-56061f573562.aspx") ] [ text "Careers Page" ]
  ]

qualityPolicyView : Model -> Html Messages.Msg
qualityPolicyView model =
  div []
  [ div [ class "quick-info-header" ] [ text "QED Quality Policy" ]
  , div [ class "quick-info-info" ] [ text "QED is committed to producing products that comply with all applicable regulations and meet customer and user requirements regarding performance, safety, reliability, and quality, and to maintaining the effectiveness of its quality management system." ]
  , div [ class "quick-info-header" ] [ text "2016 Quality Objectives" ]
  , div [ class "quick-info-info" ]
    [ ul [ class "quality-objectives" ]
      [ li [ class "quality-objective" ] [ text "98% of product have no defects found in final inspection (DUR-A) and ≥ 70% of product have no defects found in-process (DUR-B)" ]
      , li [ class "quality-objective" ] [ text "Identify and establish a baseline for the cost of poor quality; reduce cost of poor quality by ≥ 20%" ]
      , li [ class "quality-objective" ] [ text "100% of Urgent and Important complaints closed within 90 days of device receipt (if returned) or origination (if not returned)" ]
      , li [ class "quality-objective" ] [ text "100% of suppliers that produce components that are critical to safety (Category A) or critical to function (Category B) have a supplier reject rate of ≤ 3%" ]
      , li [ class "quality-objective" ] [ text "Implement UDI on all relevant products by July 2016" ]
      ]
    ]
  ]

philosophyView : Model -> Html Messages.Msg
philosophyView model =
  let
    missionArrowClass = if model.companyInfoDropSelected == "mission" then class "material-icons quick-info-header-shown" else class "material-icons"
    missionBlockClass = if model.companyInfoDropSelected == "mission" then class "quick-info-block quick-info-block-shown" else class "quick-info-block"
    corpArrowClass = if model.companyInfoDropSelected == "corp" then class "material-icons quick-info-header-shown" else class "material-icons"
    corpBlockClass = if model.companyInfoDropSelected == "corp" then class "quick-info-block quick-info-block-shown" else class "quick-info-block"
    codeArrowClass = if model.companyInfoDropSelected == "code" then class "material-icons quick-info-header-shown" else class "material-icons"
    codeBlockClass = if model.companyInfoDropSelected == "code" then class "quick-info-block quick-info-block-shown" else class "quick-info-block"
    sevenArrowClass = if model.companyInfoDropSelected == "seven" then class "material-icons quick-info-header-shown" else class "material-icons"
    sevenBlockClass = if model.companyInfoDropSelected == "seven" then class "quick-info-block quick-info-block-shown" else class "quick-info-block"
  in
    div []
    [ div [ missionBlockClass ]
        [ div [ class "quick-info-header", onClick (SelectInfoDropdownArea "mission") ]
            [ text "Mission Statement"
            , i [ missionArrowClass ] [ text "keyboard_arrow_right" ]
            ]
        , ul [ class "philosophy-list" ]
            [ li [ class "philosophy-list-item" ] [ text "QED succeeds by delivering outstanding performance and quality products." ]
            , li [ class "philosophy-list-item" ] [ text "We believe in service beyond expectations, achieved through a constant desire to anticipate and fulfill evolving customer needs." ]
            , li [ class "philosophy-list-item" ] [ text "The honesty, intelligence and commitment of our associates are vital to QED’s mission and long-term success." ]
            , li [ class "philosophy-list-item" ] [ text "We share pride in QED and respect each individual’s contribution at every level." ]
            , li [ class "philosophy-list-item" ] [ text "Exemplary customer relationships drive QED’s growth and prosperity." ]
            , li [ class "philosophy-list-item" ] [ text "QED is dedicated to pushing the limits of excellence, standing at the forefront to provide the finest and healthiest environments attainable in the industry." ]
            , li [ class "philosophy-list-item" ] [ text "QED always strives to exceed its best." ]
            ]
        ]

    , div [ corpBlockClass ]
        [ div [ class "quick-info-header", onClick (SelectInfoDropdownArea "corp") ]
            [ text "Corporate Values"
            , i [ corpArrowClass ] [ text "keyboard_arrow_right" ]
            ]
        , ul [ class "philosophy-list" ]
            [ li [ class "philosophy-list-item-header" ] [ text "Purpose" ]
            , li [ class "philosophy-list-item-clean" ] [ text "To provide opportunities for all of our associates and contribute positively to customer and society through our collaborative efforts." ]

            , li [ class "philosophy-list-item-header" ] [ text "Integrity" ]
            , li [ class "philosophy-list-item-clean" ] [ text "Be ethical. Do the right thing as a human being while always maintaining the highest ethical standards in both internal and external relationships." ]

            , li [ class "philosophy-list-item-header" ] [ text "Attitude" ]
            , li [ class "philosophy-list-item-clean" ] [ text "\"Equation of Life\"" ]
            , li [ class "philosophy-list-item-clean" ] [ text "Outcome = Ability x Effort x Attitude" ]
            , li [ class "philosophy-list-item-clean" ] [ text "The outcome of what one does in life and work is a product of three qualities, i.e., \"Ability,\" \"Effort,\" and \"Attitude.\" The values for \"Ability\" and \"Effort\" range from 0 to 100 whereas the value for \"Attitude\" ranges from -100 to +100. This means no matter how capable or talented one is, his/her outcome or impact becomes very negative and undesirab le if his/her attitude is negative. Thus, always keep a positive attitude." ]

            , li [ class "philosophy-list-item-header" ] [ text "Accountability" ]
            , li [ class "philosophy-list-item-clean" ] [ text "Set very hight performance standards and hold ourselves - both individually and collectively - accountable to meet our objectives." ]

            , li [ class "philosophy-list-item-header" ] [ text "Harmony" ]
            , li [ class "philosophy-list-item-clean" ] [ text "Embrace teamwork. Business is based upon partnerships and must raise everyone together. Having a positive attitude is the most important for everything we do. Be kind-hearted and sincere. Care for others." ]

            , li [ class "philosophy-list-item-header" ] [ text "Innovations" ]
            , li [ class "philosophy-list-item-clean" ] [ text "Make a positive difference for betterment of human society through producing innovative and superior products. Innovate and improve continuously. Today should be better than yesterday, and tomorrow better than today. Always keep in mind that if the rate of change on the outside exceeds the rate of change on the inside, the end is near. The business must be administered with a sense of competitive urgency, and must be kept in balance with the forces at work in this environment." ]
            ]
        ]
    , div [ codeBlockClass ]
        [ div [ class "quick-info-header", onClick (SelectInfoDropdownArea "code") ]
            [ text "Code of Conduct"
            , i [ codeArrowClass ] [ text "keyboard_arrow_right" ]
            ]
        , ul [ class "philosophy-list" ]
            [ li [ class "philosophy-list-item-header" ] [ text "1. Keep a Passionate Desire in Your Hearts" ]
            , li [ class "philosophy-list-item-clean" ] [ text "Your desire must be strong and persistent to penetrate into your subconscious mind." ]

            , li [ class "philosophy-list-item-header" ] [ text "2. Strive Harder than Anyone Else" ]
            , li [ class "philosophy-list-item-clean" ] [ text "Work steadily, enthusiastically and diligently, one step at a time, never relenting in tedious tasks." ]

            , li [ class "philosophy-list-item-header" ] [ text "3. Success is Determined by Willpower" ]
            , li [ class "philosophy-list-item-clean" ] [ text "Conducting business requires a persistent, determined and indomitable spirit." ]

            , li [ class "philosophy-list-item-header" ] [ text "4. Face Every Challenge with Courage" ]
            , li [ class "philosophy-list-item-clean" ] [ text "Be result-orientated and deliver results even in an uncertain world." ]

            , li [ class "philosophy-list-item-header" ] [ text "5. Have Clear and Quality Communication" ]
            , li [ class "philosophy-list-item-clean" ] [ text "Being able to clearly and succinctly describe what you want done is extremely important. So much is done through communication. Know your audience. It is how initiatives are launched, results are reported, and many things are done in between. Communication is a two-way street with listening as important as speaking. Ask great questions, and listen well." ]
            ]
        ]
    , div [ sevenBlockClass ]
        [ div [ class "quick-info-header", onClick (SelectInfoDropdownArea "seven") ]
            [ text "Seven Principles of Managment"
            , i [ sevenArrowClass ] [ text "keyboard_arrow_right" ]
            ]
        , ul [ class "philosophy-list" ]
            [ li [ class "philosophy-list-item numbered" ]
                [ span [] [ text "Clearly state the purpose and mission of each task. Set objectives and specific goals clearly, and aim high. Once targets are set, share them with your team" ]
                , span [] [ text "Have a vision." ]
                , span [] [ text "Get the strategy right and be strategically focused." ]
                , span [] [ text "Keep everyone focused on the things that matter most." ]
                , span [] [ text "Execute the strategy." ]
                , span [] [ text "Be results orientated." ]
                , span [] [ text "Be customer-focused. Customers determine our success." ]
                , span [] [ text "Put the right people in the right places." ]
                , span [] [ text "Manage multiple priorities that others see as conflicting." ]
                , span [] [ text "Learn and adapt to win." ]
                , span [] [ text "Stay lean and nimble to quickly adapt to ever changing conditions." ]
                ]
            , li [ class "philosophy-list-item numbered" ] [ text "Earn fair and yet maximized profit through ethical business practices that result in quality products at best prices, i.e., customer-pleasing products resulting from ongoing R&D and sincere service" ]
            , li [ class "philosophy-list-item numbered" ] [ text "Manage our company with a respect for others as if we were a family, bound by the bond of our hearts and the shared purpose, devoid of antagonism, helping each other with a mutual sense of gratitude and appreciation" ]
            , li [ class "philosophy-list-item numbered" ] [ text "Maximize revenue and minimize expenses. Measure your inflow and control your outflow. Do well (i.e., make the best profit) by doing good (i.e., by adding the best value to customer). However, do not chase short-term profits at the expense of long-term strategic value creation" ]
            , li [ class "philosophy-list-item numbered" ] [ text "Pricing is management. Pricing is top management's responsibility and strategy. Find that one price point where customers are happy to pay and the company is most profitable" ]
            , li [ class "philosophy-list-item numbered" ] [ text "Think, think and think. Think both inside and outside the box. Positively and proactively. Associates must treat company assets as they would their own assets" ]
            , li [ class "philosophy-list-item numbered" ] [ text "Decisiveness. Make high-quality decisions. Decisions must be based upon facts (i.e., data), objectively considered, fact-founded thought-through approach to decision making. Understand, reflect, and learn about your decision making process. Leaders need to make both quality and timely decisions. In certain situations, difficult and timely decisions must be made in the best interests of the entire organization, decisions that require a firmness, authority, and finality that will not please everyone. Leaders must know when not to act unilaterally but instead foster collaborative decision-making." ]
        ]
      ]
    ]

qedHistoryView : Model -> Html Messages.Msg
qedHistoryView model =
  let
    historyBlockClass = if model.companyInfoDropSelected == "history" then class "quick-info-block quick-info-block-shown" else class "quick-info-block"
    historyArrowClass = if model.companyInfoDropSelected == "history" then class "material-icons quick-info-header-shown" else class "material-icons"
  in
    div [ historyBlockClass ]
    [ div [ class "quick-info-header", onClick (SelectInfoDropdownArea "history") ]
        [ text "History of QED"
        , i [ historyArrowClass ] [ text "keyboard_arrow_right" ]
        ]
    , div [ class "company-history-year" ] [ text "2006" ]
    , div [ class "company-history-text" ] [ text "QED moves to 777 Beta Drive and leases 3,500 square feet of space." ]
    , div [ class "company-history-year" ] [ text "2009" ]
    , div [ class "company-history-text" ] [ text "QED relocates to 27,000 square feet at 700 Beta Drive. The facility further expands to 35,000 square feet between January 2009 and May 2015." ]
    , div [ class "company-history-year" ] [ text "2015-05-19" ]
    , div [ class "company-history-text" ] [ text "QED Lease Signing Ceremony. 6655 Beta Drive is one of the largest commercial buildings in Mayfield Village and will be the newest home of QED. On May 5, 2015, Quality Electrodynamics (QED) committed to leasing 77,000 suqare feet of space, expandable up to 200,000 square feet." ]
    ]

fromHiroView : Model -> Html Messages.Msg
fromHiroView model =
  let
    hiroBlockClass = if model.companyInfoDropSelected == "hiro" then class "quick-info-block quick-info-block-shown" else class "quick-info-block"
    hiroArrowClass = if model.companyInfoDropSelected == "hiro" then class "material-icons quick-info-header-shown" else class "material-icons"
  in
    div [ hiroBlockClass ]
    [ div [ class "quick-info-header", onClick (SelectInfoDropdownArea "hiro") ]
        [ text "From Dr. Fujita"
        , i [ hiroArrowClass ] [ text "keyboard_arrow_right" ]
        ]
    , div [ class "quick-info-link", onClick (OpenPopupLink "New Year's Message 2015" "http://internal.qualedyn.local/Dr.Fujita/NY%20Email%202015.pdf") ] [ text "New Year's Message 2015" ]
    , div [ class "quick-info-link", onClick (OpenPopupLink "New Year's Message 2014" "http://internal.qualedyn.local/Dr.Fujita/NY%20Email%202014.pdf") ] [ text "New Year's Message 2014" ]
    , div [ class "quick-info-link", onClick (OpenPopupLink "New Year's Message 2013" "http://internal.qualedyn.local/Dr.Fujita/NY%20Email%202013.pdf") ] [ text "New Year's Message 2013" ]
    , div [ class "quick-info-link", onClick (OpenPopupLink "New Year's Message 2012" "http://internal.qualedyn.local/Dr.Fujita/NY%20Email%202012.pdf") ] [ text "New Year's Message 2012" ]
    , div [ class "quick-info-link", onClick (OpenPopupLink "New Year's Message 2011" "http://internal.qualedyn.local/Dr.Fujita/NY%20Email%202011.pdf") ] [ text "New Year's Message 2011" ]
    , div [ class "quick-info-link", onClick (OpenPopupLink "New Year's Message 2010" "http://internal.qualedyn.local/Dr.Fujita/NY%20Email%202010.pdf") ] [ text "New Year's Message 2010" ]
    ]






employeeDirectoryView : Model -> Html Messages.Msg
employeeDirectoryView model =
  let
    empSort = case model.employeeDirectorySortBy of
                      "First Name" -> .firstname
                      "Last Name" -> .sn
                      "Title" -> .title
                      "Department" -> .department
                      _ -> .sn
    emps = model.employeeDirectory
            |> List.sortBy empSort
            |> List.map (\e -> employeeNameView model e)
  in
    div [ class "employee-directory" ]
      [ div [ class "employee-directory-names" ]
          [ div [ class "employee-directory-names-header" ]
              [ div [ class "mui-dropdown" ]
                [ button [ class "employee-directory-sortby mui-btn", attribute "data-mui-toggle" "dropdown" ]
                    [ text "Sort By "
                    , span [ class "mui-caret" ] []
                    ]
                , ul [ class "mui-dropdown__menu" ]
                    [ li [ onClick (SetEmployeeDirectorySortBy "First Name") ] [ a [ href "#" ] [ text "First Name" ] ]
                    , li [ onClick (SetEmployeeDirectorySortBy "Last Name") ] [ a [ href "#" ] [ text "Last Name" ] ]
                    -- , li [ onClick (SetEmployeeDirectorySortBy "Title") ] [ a [ href "#" ] [ text "Title" ] ]
                    , li [ onClick (SetEmployeeDirectorySortBy "Department") ] [ a [ href "#" ] [ text "Department" ] ]
                    ]
                ]
              ]

          , ul [ class "employee-directory-list" ] emps
          ]

      , if model.selectedEmployee == emptyEmployee then emptyEmployeeDetailsView else employeeDetailsView model
      ]


employeeNameView : Model -> Employee -> Html Msg
employeeNameView model emp =
  let
    listClass = classList
                  [ ("employee-directory-list-item", True)
                  , ("selected", model.selectedEmployee.sn == emp.sn && model.selectedEmployee.firstname == emp.firstname)
                  , ("hovered", model.hoverEmployee.sn == emp.sn && model.hoverEmployee.firstname == emp.firstname)
                  ]

    phoneNumbers = [
                    if String.isEmpty emp.office then blankDiv else span [] [ text ("Office: " ++ emp.office) ]

                  , if String.isEmpty emp.mobile then blankDiv else span [] [ text ("Cell: " ++ emp.mobile) ]

                  ]

  in
    li [ listClass
        , onClick (SetSelectedEmployee emp)
        , onMouseEnter (SetHoverEmployee emp)
        , onMouseLeave (SetHoverEmployee emptyEmployee)
        ]
      [ div [ class "employee-header" ]
          [ span [ class "employee-header-name" ] [ text ( emp.firstname ++ " " ++ emp.sn ) ]
          , span [ class "employee-header-dept" ] [ text emp.department ]
          ]
      , div [ class "employee-footer" ] phoneNumbers
      ]

employeeDetailsView : Model -> Html Msg
employeeDetailsView model =
  let
    empPhoto =
        if model.selectedEmployee.photo == ""
          then i [ class "employee-detail-card-no-photo material-icons md-96" ] [ text "face" ]
          else img [ class "employee-detail-card-photo", src ("img/employees/" ++ model.selectedEmployee.photo) ] []

    officePhoneShown = if model.selectedEmployee.office == ""
                          then blankDiv
                          else div []
                                  [ div [ class "employee-detail-card-detail-phone-label" ] [ text "Office:" ]
                                  , div [ class "employee-detail-card-detail-phone" ] [ text model.selectedEmployee.office ]
                                  ]

    mobilePhoneShown = if model.selectedEmployee.mobile == ""
                          then blankDiv
                          else div []
                                  [ div [ class "employee-detail-card-detail-phone-label" ] [ text "Cell:" ]
                                  , div [ class "employee-detail-card-detail-phone" ] [ text model.selectedEmployee.mobile ]
                                  ]

  in
    div [ class "employee-directory-details" ]
      [ div [ class "employee-detail-card" ]
          [ div [ class "employee-detail-card-name" ] [ text ( model.selectedEmployee.firstname ++ " " ++ model.selectedEmployee.sn ) ]
          , div [ class "employee-detail-card-body" ]
              [ div [ class "employee-detail-card-photo-area" ] [ empPhoto ]
              , div [ class "employee-detail-card-detail-area" ]
                  [ div [ class "employee-detail-card-detail-title" ] [ text model.selectedEmployee.title ]
                  , div [ class "employee-detail-card-detail-dept" ] [ text model.selectedEmployee.department ]
                  , officePhoneShown
                  , mobilePhoneShown
                  , div [ class "employee-detail-card-detail-email" ]
                      [ button [ class "mui-btn", onClick (OpenQuickLink ("mailto:" ++ model.selectedEmployee.mail)) ] [ text ("Email " ++ model.selectedEmployee.firstname) ]
                      ]
                  ]
              ]
          ]
      ]


emptyEmployeeDetailsView : Html Msg
emptyEmployeeDetailsView =
  div [ class "employee-directory-details" ]
    [ div [ class "employee-detail-card" ] []
    ]







fitnessTrackingView : Model -> Html Msg
fitnessTrackingView model =
  let
    saveChangesEnabled = if model.isSavingNeeded then attribute "cool" "" else attribute "disabled" ""
  in
    case model.view of
      "calendar" ->
          div [ class "fitness-full-page" ]
              [ fitnessHeaderView model
              , myActivitiesView model
              ]
      _ ->
          div [ class "fitness-full-page" ]
              [ fitnessHeaderView model
              , leaderboardView model
              ]


fitnessHeaderView : Model -> Html Msg
fitnessHeaderView model =
    div [ class "fitness-page-header" ]
    [ fitnessUserView model
    , toggleView model
    , myStatsView model
    , saveChangesView model
    ]


fitnessUserView : Model -> Html Msg
fitnessUserView model =
  let
    loggedIn = model.loggedIn
  in
    if loggedIn then
      div [ class "fitness-user" ]
      [ div [ class "fitness-user-header" ] [ text "QED Walk/Run Challenge" ]
      , div [ class "fitness-user-status" ]
        [ i [ class "material-icons md-48" ] [ text "account_circle" ]
        , div [ class "fitness-user-status-name" ] [ text (model.loginData.firstName ++ " " ++ model.loginData.lastName) ]
        ]
      ]
    else
      div [ class "fitness-user" ]
      [ div [ class "fitness-user-header" ] [ text "QED Walk/Run Challenge" ]
      , div [ class "fitness-user-status" ] [ text "Please Login To Start Tracking" ]
      ]



toggleView : Model -> Html Msg
toggleView model =
  let
    shown = style [("display", "block")]
    hidden = style [("display", "none")]

    calendarEnabled = if model.view == "calendar" then attribute "disabled" "" else attribute "cool" ""
    leadersEnabled = if model.view == "leaders" then attribute "disabled" "" else attribute "cool" ""
  in
    div [ class "fitness-header-toggle", if model.loggedIn then shown else hidden ]
    [ button [ onClick (ShowThisThing "leaders")
              , class "mui-btn mui-btn--primary mui-btn--raised fitness-show-leaders-button"
              , leadersEnabled
              ]
              [ text "Leaders" ]
    , button [ onClick (ShowThisThing "calendar")
              , class "mui-btn mui-btn--primary mui-btn--raised fitness-show-calendar-button"
              , calendarEnabled
              ]
              [ text "Calendar" ]
    ]


myStatsView : Model -> Html Msg
myStatsView model =
  let
    shown = style [("display", "block")]
    hidden = style [("display", "none")]

    allTimeTotal = List.foldl (+) 0 (List.map (\a -> a.distance) model.myActivities)
    thisMonthTotal = List.foldl (+) 0 (List.map (\a -> if (TimeUnit.startOfTime TimeUnit.Day (DateExtra.toFirstOfMonth model.today)) == (TimeUnit.startOfTime TimeUnit.Day (DateExtra.toFirstOfMonth a.date))
                                                          then a.distance
                                                          else 0
                                                ) model.myActivities
                                      )
    shownMonthTotal = List.foldl (+) 0 (List.map (\a -> if (TimeUnit.startOfTime TimeUnit.Day (DateExtra.toFirstOfMonth model.viewDate)) == (TimeUnit.startOfTime TimeUnit.Day (DateExtra.toFirstOfMonth a.date))
                                                          then a.distance
                                                          else 0
                                                ) model.myActivities
                                      )
  in
    div [ class "fitness-my-statistics", if model.loggedIn then shown else hidden ]
    [ div [ class "fitness-my-statistics-group" ]
      [ div [ class "fitness-my-statistics-label" ] [ text "Total" ]
      , div [ class "fitness-my-statistics-value" ] [ span [] [ text (MyRho.round 2 allTimeTotal) ], span [ class "my-statistics-uom" ] [ text " mi" ] ]
      ]
    , div [ class "fitness-my-statistics-group" ]
      [ div [ class "fitness-my-statistics-label" ] [ text "This Month" ]
      , div [ class "fitness-my-statistics-value" ] [ span [] [ text (MyRho.round 2 thisMonthTotal) ], span [ class "my-statistics-uom" ] [ text " mi" ] ]
      ]
    , div [ class "fitness-my-statistics-group" ]
      [ div [ class "fitness-my-statistics-label" ] [ text (dateFormatMonYYYY model.viewDate) ]
      , div [ class "fitness-my-statistics-value" ] [ span [] [ text (MyRho.round 2 shownMonthTotal) ], span [ class "my-statistics-uom" ] [ text " mi" ] ]
      ]
    ]


saveChangesView : Model -> Html Msg
saveChangesView model =
  let
    saveChangesEnabled = if model.isSavingNeeded then attribute "cool" "" else attribute "disabled" ""
  in
    div [ class "fitness-save-changes" ]
      [ button [ onClick SaveMyActivityChanges
                , class "mui-btn mui-btn--primary mui-btn--raised fitness-save-changes-button"
                , saveChangesEnabled
                ]
                [ text "Save Changes" ]
      ]





myActivitiesView : Model -> Html Msg
myActivitiesView model =
  let
    shown = style [("display", "block")]
    hidden = style [("display", "none")]
  in
    div [ class "fitness-my-activities-view", if model.loggedIn then shown else hidden ]
    [ viewSavingStatus model
    , viewCalendar model
    ]


viewSavingStatus : Model -> Html Msg
viewSavingStatus model =
  let
    errorClass = "fitness-my-activities-saving-status-bar fitness-saving-error"
    savedClass = "fitness-my-activities-saving-status-bar fitness-saving-ok"
    notSavedClass = "fitness-my-activities-saving-status-bar fitness-saving-needed"
    savingClass = "fitness-my-activities-saving-status-bar"
    barClass = case model.isSaving of
                  True -> savingClass
                  False -> case model.isSavingNeeded of
                              True -> notSavedClass
                              False -> case model.saveActivitiesError of
                                          2 -> errorClass
                                          1 -> savedClass
                                          _ -> savingClass

    barText = case model.isSaving of
                  True -> "Saving..."
                  False -> case model.isSavingNeeded of
                              True -> "Changes Have Not Been Saved"
                              False -> case model.saveActivitiesError of
                                          2 -> "Error Saving Your Data!"
                                          1 -> "Save Completed Successfully"
                                          _ -> "Enter Mileage Per Day From Fitness Tracker Below"
  in
    div [ class barClass ] [ text barText ]


leaderboardView : Model -> Html Msg
leaderboardView model =
  div [ class "fitness-leaderboard" ]
  [ leadersDeptView model.loggedIn model.today model.leaderboardDept model.loginData.department
  , leadersAllView model.today model.leaderboardAll
  ]


leadersDeptView : Bool -> Date.Date -> (List LeadersDept) -> String -> Html Msg
leadersDeptView loggedIn today leaders myDept =
  let
    emptyLeader = {department = myDept, distance = 0.0, employee = "", place = 0}
    paddingList = List.repeat 5 emptyLeader
    allList = List.foldr (::) paddingList leaders
    theList =
          case loggedIn of
            False ->
              List.repeat 1 (li [ class "fitness-leaderboard-logged-out" ] [ text "Log In To View" ])
            True ->
              List.take 5
                <| List.map (\l -> leaderView l.place l.employee l.distance)
                <| List.filter (\l -> l.department == myDept ) allList
    header = li [ class "fitness-leaderboard-header" ]
              [ span [ style [("float","left")] ] [ text "Leaders in My Department" ]
              , span [ style [("float","right")] ] [ text (dateFormatMonYYYY today) ]
              ]
  in
    div [ class "fitness-leaderboard-box" ]
    [ ul [ class "fitness-leaderboard-table" ] (header :: theList)
    ]


leadersAllView : Date.Date -> (List LeadersAll) -> Html Msg
leadersAllView today leaders =
  let
    emptyLeader = {distance = 0.0, employee = "", place = 0}
    paddingList = List.repeat 5 emptyLeader
    allList = List.foldr (::) paddingList leaders
    theList = List.take 5
                <| List.map (\l -> leaderView l.place l.employee l.distance) allList
    header = li [ class "fitness-leaderboard-header" ]
              [ span [ style [("float","left")] ] [ text "All Associates Leaders" ]
              , span [ style [("float","right")] ] [ text (dateFormatMonYYYY today) ]
              ]
  in
    div [ class "fitness-leaderboard-box" ]
    [ ul [ class "fitness-leaderboard-table" ] (header :: theList)
    ]

leaderView : Int -> String -> Float -> Html Msg
leaderView place employee distance =
  let
    editPlace = if employee == "" then "" else toString place
    editEmployee = String.map (\c -> if c == '.' then ' ' else c) employee
    editDistance = if employee == "" then "" else (MyRho.round 2 distance) ++ " mi"
  in
    li [ class "fitness-leaderboard-row" ]
    [ div [ class "fitness-leaderboard-cell" ]
      [ div [ class "place" ] [ text editPlace ]
      , div [ class "employee" ] [ text editEmployee ]
      , div [ class "distance" ] [ text editDistance ]
      ]
    ]



viewCalendar : Model -> Html Msg
viewCalendar model =
  let
    shown = style [("display", "block")]
    hidden = style [("display", "none")]
    header =
      List.map text [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ]
        |> List.map (List.repeat 1)
        |> List.map (th [])
        |> thead []
  in
    div [ class "fitness-my-activities" ]
      [ viewCalendarControls model
      , div [ class "fitness-my-activities-calendar-body" ]
        [ table [ class "fitness-my-activities-calendar", attribute "cellpadding" "0" ] (header :: viewMonth model) ]
      ]



--- CALENDAR STUFF

viewCalendarControls : Model -> Html Msg
viewCalendarControls model =
  let
    month = Date.month model.viewDate |> monthName
    nextMonth = toString <| DateExtra.nextMonth <| Date.month model.viewDate
    prevMonth = toString <| DateExtra.prevMonth <| Date.month model.viewDate
    year = Date.year model.viewDate |> toString
  in
    div [ class "fitness-my-activities-calendar-header" ]
      [ button [ class "fitness-my-activities-calendar-prev-month mui-btn", onClick PreviousMonth ] [ text ( "< " ++ prevMonth ) ]
      , div [ class "fitness-my-activities-calendar-month" ] [ month ++ " " ++ year |> text  ]
      , button [ class "fitness-my-activities-calendar-next-month mui-btn", onClick NextMonth ] [ text ( nextMonth ++ " ›" ) ]
      ]


viewDay : Model -> Bool -> Date -> Date -> Int -> Html Msg
viewDay model isExternal inToday viewedMonth day =
  let
    shown = style [("display", "block")]
    hidden = style [("display", "none")]
    dayClass = if model.monthsFromToday < -1 || model.monthsFromToday > 0 then class "fitness-my-activities-calendar-day locked"
                  else
                    case isExternal of
                      True -> class "fitness-my-activities-calendar-day locked"
                      False -> class "fitness-my-activities-calendar-day"
    dayReadOnly = if model.monthsFromToday < -1 || model.monthsFromToday > 0 then attribute "readonly" ""
                  else
                    case isExternal of
                      True -> attribute "readonly" ""
                      False -> attribute "cool" ""
    today = TimeUnit.startOfTime TimeUnit.Day inToday
    viewedDay =
      DateField.fieldToDateClamp (DateField.DayOfMonth day) viewedMonth
        |> TimeUnit.startOfTime TimeUnit.Day
    isToday =
        (&&) (Date.day today == day) (Date.month today == Date.month viewedMonth)
        |> (&&) (Date.year today == Date.year viewedMonth)
    newActivity = { id =
                        0 -
                          ( ((viewedDay |> Date.month |> DateExtra.monthToInt) * 1000000)
                          + ((Date.day viewedDay) * 10000)
                          + (Date.year viewedDay)
                          )
                  , date = viewedDay
                  , distance = 0.00
                  , strDistance = ""
                  , changed = False
                  }
    activity = case List.head (List.filter (\a -> DateCompare.is DateCompare.Same viewedDay a.date) model.myActivities) of
                Just x -> x
                Nothing -> newActivity

    cleanDistance = if activity.strDistance == "0.00" then ""
                      else if String.endsWith ".00" activity.strDistance
                              then String.slice 0 ((String.length activity.strDistance)-3) activity.strDistance
                              else if String.endsWith ".0" activity.strDistance
                                         then activity.strDistance
                                         else if String.endsWith "0" activity.strDistance
                                            then String.slice 0 ((String.length activity.strDistance)-1) activity.strDistance
                                            else activity.strDistance
  in
    td [ dayClass ]
    [ div [ class "fitness-my-activities-calendar-day-header"]
      [ div [ class "fitness-my-activities-calendar-day-number" ] [ text (toString day) ]
      ]
    , div [ if activity.distance > 26.2
              then class "fitness-my-activities-calendar-day-body bad"
              else
                if activity.changed
                  then class "fitness-my-activities-calendar-day-body changed"
                  else class "fitness-my-activities-calendar-day-body"
          ]
      [ input [ class "fitness-my-activities-calendar-day-distance"
              , type_ "number"
              , attribute "step" "0.01"
              , dayReadOnly
              , Attribs.min "0"
              , Attribs.max "250.00"
              , value cleanDistance
              , onFocus (SetCurrentActivity activity.id activity.date)
              , onInput DistanceChanged
              ] []
      ]
    ]



viewDays : Model -> List Int -> Date -> Date -> Bool -> List (Html Msg)
viewDays model days viewedMonth today isExternal =
  List.map (viewDay model isExternal today viewedMonth) days


viewMonth : Model -> List (Html Msg)
viewMonth model =
  let
    previousDays =
      let days = lastWeekOfMonth (prevMonth model.viewDate)
      in if List.length days < 7 then days else []
    currentDays = List.range 1 (DateExtra.daysInMonthDate model.viewDate)
    nextDays =
      let days = firstWeekOfMonth (nextMonth model.viewDate)
      in if List.length days < 7 then days else []
  in
    viewDays model nextDays (nextMonth model.viewDate) model.today True
      |> List.append (viewDays model currentDays model.viewDate model.today False)
      |> List.append (viewDays model previousDays (prevMonth model.viewDate) model.today True)
      |> splitWeeks
      |> List.map (tr [])


splitWeeks: List (Html Msg) -> List (List (Html Msg))
splitWeeks days =
  if List.length days == 0 then []
  else
    let
      thisWeek = List.take 7 days |> List.repeat 1
      remainingDays = List.drop 7 days
    in
      List.append thisWeek (splitWeeks remainingDays)


firstWeekOfMonth : Date -> List Int
firstWeekOfMonth date =
  let
    days =
      let weekDay = Date.dayOfWeek (DateExtra.toFirstOfMonth date)
      in DateExtra.daysBackToStartOfWeek Date.Sun weekDay
    dd = Debug.log "D" (Date.day date)
  in
    List.range 1 days


lastWeekOfMonth : Date -> List Int
lastWeekOfMonth date =
  let
    days =
      let weekDay = Date.dayOfWeek (DateExtra.lastOfMonthDate date)
      in DateExtra.daysBackToStartOfWeek weekDay Date.Sun
    daysInMonth = DateExtra.daysInMonthDate date
  in
    List.range (daysInMonth - days) (daysInMonth)

prevMonth : Date -> Date
prevMonth date =
  DateDuration.add DateDuration.Month -1 date


nextMonth : Date -> Date
nextMonth date =
  DateDuration.add DateDuration.Month 1 date










reportsView : String -> Model -> Html Messages.Msg
reportsView rpt model =
  let
    menus = List.map (\m -> reportMenu m) model.slideMenuData
  in
    case model.loggedIn of
      True ->
        div [ class "container" ]
        [ div [ class "slide-menu-open-area" ] [ button [ classList [("action", True), ("action--open", True) ], attribute "aria-label" "Open Menu" ] [ span [ classList [("icon", True), ("icon--menu", True) ] ] [] ] ]
        , nav [ id "ml-menu", class "side-menu menu--open" ]
          [ button [ classList [("action", True), ("action--close", True) ], attribute "aria-label" "Close Menu" ] [ span [ classList [("icon", True), ("icon--menu", True) ] ] [] ]
          , div [ id "menuDiv", class "menu__wrap" ]
          menus
          ]
        , iframe [ class "content reports-content" ] []
        ]
      False ->
        div [ class "reports-not-logged-in" ]
        [ text "Must Be Logged In To View Reports" ]


reportsDash : Model -> Html Messages.Msg
reportsDash model =
  div []
  [
    h1 [] [ text "Reports Dashboard" ]
  ]


reportView : String -> Model -> Html Messages.Msg
reportView rpt model =
  div []
  [
    h1 [] [ text ("This is the " ++ rpt ++ " Report")]
  ]

reportMenu : ReportMenu -> Html Messages.Msg
reportMenu menu =
  let
    subMenus = List.map (\m -> reportMenuItem m) menu.items
  in
    ul [ attribute "data-menu" menu.menuName
       , class "menu__level"
       ]
       subMenus

reportMenuItem : ReportMenuItem -> Html Messages.Msg
reportMenuItem val =
  let
    subAttribute = if val.menuOrItem == "menu" then (attribute "data-submenu" val.subMenuName) else (attribute "none" "none")
    pathAttribute= if val.menuOrItem == "menu" then (attribute "data-fullreportpath" ("{\"path\": \"\", \"name\": \"" ++ val.subMenuName ++ "\"}") )
                     else (attribute "data-fullreportpath" ("{\"path\": \"" ++ val.fullPath ++ "\", \"name\": \"" ++ val.name ++ "\"}") )
  in
    li [ class "menu__item" ]
       [ a [ class "menu__link"
           , href "#"
           , subAttribute
           , pathAttribute
           ]
           [ text val.name ]
       ]










itRequestsView : Model -> Html Messages.Msg
itRequestsView model =
  div [ class "it-requests" ]
  [ requestsView model
  , requestDetails model
  , requestNotes model
  --, requestsFooter model
  ]


requestsHeader : Model -> Html Messages.Msg
requestsHeader model =
  div [ class "requests-header" ]
  [ text "IT Requests Center"
  ]



requestsView : Model -> Html Messages.Msg
requestsView model =
  let
    requests =
        if model.addRequestOpen
          then List.append (List.map (\r -> (requestLine model r)) model.itRequests) [ (requestAddRequest model) ]
          else if model.itRequests == [emptyItRequest] then [] else List.map (\r -> (requestLine model r)) model.itRequests
  in
    case model.loggedIn of
      True ->
              div [ class "itrequests" ]
              [ ul [ class "requests-table-header" ]
                [ li [ class "itrequest-due" ] [ text "Due Date" ]
                , li [ class "itrequest-priority" ] [ text "Priority" ]
                , li [ class "itrequest-age" ] [ text "Due In" ]
                --, li [ class "itrequest-assign" ] [ text "Assigned To" ]
                , li [ class "itrequest-desc" ] [ text "Task" ]
                --, li [] [ text "Date Requested" ]
                --, li [] [ text "Requested By" ]
                ]
              , ul [ class "requests-table-lines" ] requests
              , i [ class "material-icons md-36 requests-add", title "Add New Task", onClick OpenAddRequest ] [ text "add" ]
              ]
      False ->
              div [ class "requests-not-logged-in" ] [ text "Must Be Logged In To View Your Tasks" ]

requestLine : Model -> ItRequest -> Html Messages.Msg
requestLine model request =
  li [ onClick (SelectRequestRow request.id), class (if model.selectedRequest == request.id then "selected-request-line" else "full-request-line") ]
  [ ul [ class "itrequest" ]
    [ li [ class "itrequest-due" ] [ text request.dueOn ]
    , li [ class "itrequest-priority" ] [ text request.priority ]
    , li [ class (if request.age <= 0 then "itrequest-age itrequest-past-due" else "itrequest-age") ]
         [ text ( case request.age of
                    9999 -> ""
                    _ -> if request.age <= 0 then "Past Due" else (toString request.age) ++ request.ageUnit
                )
         ]
    --, li [ class "itrequest-assign" ] [ text request.assignedTo ]
    , li [ class "itrequest-desc" ] [ text request.description ]
    ]
  , div [ class "requests-toolbar" ]
        [ i [ class "material-icons requests-toolbar-delete", title "Clear This Task", onClick (DeleteRequest request.id) ] [ text "clear" ]
        --,i [ class "material-icons", title "Set Up Reminder" ] [ text "feedback" ]
        --, i [ class "material-icons", title "Schedule Meeting" ] [ text "date_range" ]
        --, i [ class "material-icons", title "Edit This Task" ] [ text "create" ]
        ]
  ]

requestAddRequest : Model -> Html Messages.Msg
requestAddRequest model =
  li [ class "requests-add-line" ]
  [ ul [ class "itrequest" ]
    [ li [ class "requests-add-due" ] [ input [ type_ "text", id "dueOnDatePicker" ] [] ]
    , li [ class "requests-add-priority" ]
      [ select [ onInput SetNewRequestPriority ]
        [ option [] [ text "Low" ]
        , option [ attribute "selected" "True" ] [ text "Normal" ]
        , option [] [ text "High"]
        ]
      ]
    , li [ class "itrequest-age requests-add-age" ] [ text "" ]
    --, li [ class "itrequest-assign" ] [ text request.assignedTo ]
    , li [ class "requests-add-desc" ] [ textarea [ onInput SetNewRequestDescription ] [] ]
    ]
  , div [ class "requests-add-toolbar" ]
    [ i [ class "material-icons requests-add-close", title "Cancel", onClick CloseAddRequest ] [ text "clear" ]
    , i [ class "material-icons requests-add-commit", title "Commit", onClick AddRequest ] [ text "done" ]
    ]
  ]


requestDetails : Model -> Html Messages.Msg
requestDetails model =
  div [ class "requests-details" ]
  [ text "Notes"--("details for Task " ++ (toString model.addRequestData.dueOn) )
  ]

requestNotes : Model -> Html Messages.Msg
requestNotes model =
  let
    notes =
      if model.addNoteOpen
        then List.append [ (requestAddNote model) ] (List.map (\n -> requestNote n) model.selectedRequestData.notes)
        else List.map (\n -> requestNote n) model.selectedRequestData.notes
  in
    if model.selectedRequest == 0 then
      div [ class "requests-notes" ] [ ul [] notes ]
    else
      div [ class "requests-notes" ]
      [ ul [] notes
      , i [ class "material-icons md-36 requests-notes-add", title "Add Note", onClick OpenAddNote ] [ text "add" ]
      ]


requestNote : RequestNote -> Html Messages.Msg
requestNote note =
  li [ class "requests-notes-note" ]
  [ ul []
    [ li [ class "requests-note-date" ]
      [ text note.date
      , i [ class "requests-note-add-cancel material-icons", title "Delete This Note", onClick (DeleteRequestNote note.id) ] [ text "cancel" ]
      ]
    , li [ class "requests-note-text" ] [ textarea [ Attribs.value note.text, class "requests-note-textarea", attribute "readonly" "true" ] [] ]
    ]
  ]

requestsFooter : Model -> Html Messages.Msg
requestsFooter model =
  div [ class "requests-footer" ]
  [ text "Jim K. Made This"
  ]


requestAddNote : Model -> Html Messages.Msg
requestAddNote model =
  li [ class "requests-notes-note" ]
  [ ul []
    [ li [ class "requests-note-date" ]
      [ text (getHRDate model.rightNow)
      , i [ class "requests-note-add-cancel material-icons", title "Cancel", onClick CloseAddNote ] [ text "cancel" ]
      ]
    , li [ class "requests-note-text" ] [ textarea [ id "addRequestNoteTextArea", class "requests-add-note-text" ] [] ]
    , li [ class "requests-note-add-commit" ] [ i [ class "material-icons md-36", title "Save Note", onClick AddRequestNote ] [ text "check_circle" ] ]
    ]
  ]










gaugeView : Model -> Html Messages.Msg
gaugeView model =
  let
    gauges = List.map (\g -> costGauge g) model.supplyGauges
  in
    div [ class "gauge-view-full" ]
    [ ul [ class "gauges" ] gauges
    ]

costGauge : Gauge -> Html Messages.Msg
costGauge gauge =
  li [ class "gauge" ]
  [ canvas [ id gauge.id, height 250, width 250 ] []
  ]






editMetricsView : Model -> Html Messages.Msg
editMetricsView model =
    div [ class "edit-metrics" ]
      [ div [ class "edit-metrics-title" ] [ text "Supply Chain Metrics" ]
      , golferDataView model
      , div [ class "edit-metrics-save-changes" ]
            [ button [ onClick SaveMetricChanges, class "mui-btn mui-btn--raised" ] [ text "Save Changes" ]
            ]
      ]

golferDataView : Model -> Html Msg
golferDataView model =
  let
    listOfMetricRows = List.map (\g ->  golferDataRow model g ) model.allMetricRows
  in
    table [ class "edit-metrics-table" ] (golferDataHeader :: listOfMetricRows)

golferDataHeader : Html Msg
golferDataHeader =
  thead []
          [ th [] [ text "Name" ]
          , th [] [ text "Linked Account" ]
          , th [] [ text "Place" ]
          , th [] [ text "Handicap" ]
          , th [] [ text "Average Score" ]
          , th [] [ text "Total Score" ]
          , th [] [ text "Number of Rounds" ]
          , th [] [ text "Chatroom Font Color" ]
          , th [] [ text "Remove Golfer" ]
          ]

golferDataRow : Model -> MetricRow -> Html Msg
golferDataRow model mr =
  let
    rowSelected = if model.currentMetricRow.id == mr.id
                    then class "selected-row"
                    else class ""
  in
    tr [ onClick (SetCurrentMetricRow mr), rowSelected ]
      [ td [] [ text "" ]--input [ type_ "text", onInput (UpdateCurrentGolfer "name"), value g.name ] [] ]
      , td [] [ text "" ]--select [ onInput (UpdateCurrentGolfer "uid") ] linkedUserOptions ]
      , td [] [ text "" ]--text (toString g.place) ]
      , td [] [ text "" ]--input [ type_ "text", onInput (UpdateCurrentGolfer "handicap"), value (toString g.handicap) ] [] ]
      , td [] [ text "" ]--text ( (g.totalScore // g.numOfRounds) |> toString) ]
      , td [] [ text "" ]--input [ type_ "text", onInput (UpdateCurrentGolfer "total"), value (toString g.totalScore) ] [] ]
      , td [] [ text "" ]--input [ type_ "text", onInput (UpdateCurrentGolfer "rounds"), value (toString g.numOfRounds) ] [] ]
      , td [] [ text "" ]--input [ type_ "color", onInput (UpdateCurrentGolfer "color"), value g.chatroomColor ] [] ]
      , td [] [ text "X" ]
      ]






userView : Int -> Model -> Html Messages.Msg
userView userid model =
  let
    location = ""
  in
    div []
    [
      span [] [ text ("This is User " ++ toString userid ++ "'s Page")]
    ]
