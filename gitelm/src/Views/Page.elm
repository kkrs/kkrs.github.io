module Views.Page exposing (ActivePage(..), frame)

import Html exposing (..)
import Html.Attributes exposing (class, classList, id, type_, href, style, attribute)
import Route exposing (Route, toHref)


type ActivePage
    = Home
    | Repos


sideNavItem : Bool -> Route -> Html msg -> Html msg
sideNavItem isActive route linkContent =
    li [ class "nav-item" ]
        [ a [ classList [ ( "nav-link", True ), ( "active", isActive ) ], toHref route ] [ linkContent ] ]


frameHeader : Html msg
frameHeader =
    nav [ class "navbar navbar-expand-md navbar-dark fixed-top bg-dark" ]
        [ a [ class "navbar-brand", href "#" ] [ text "Dashboard" ]
        , button [ class "navbar-toggler d-lg-none", attribute "data-target" "#navbarsExampleDefault", attribute "data-toggle" "collapse", type_ "button" ]
            [ span [ class "navbar-toggler-icon" ] [] ]
        , div [ class "collapse navbar-collapse", id "navbarsExampleDefault" ]
            [ ul [ class "navbar-nav mr-auto" ] []
              -- style required for some reason
            , form [ class "form-inline mt-2 mt-md-0", style [ ( "margin-bottom", "0em" ) ] ]
                -- will do a reload
                [ button [ class "btn btn-outline-primary my-2 my-sm-0", type_ "submit" ]
                    [ text "Logout" ]
                ]
            ]
        ]


frameMain : ActivePage -> Html msg -> Html msg
frameMain activePage main =
    div [ class "container-fluid" ]
        [ div [ class "row" ]
            [ nav [ class "col-sm-3 col-md-2 d-none d-sm-block bg-light sidebar" ]
                [ ul [ class "nav nav-pills flex-column" ]
                    [ sideNavItem (activePage == Home) Route.Home (text "Home")
                    , sideNavItem (activePage == Repos) Route.Repos (text "Repos")
                    ]
                ]
            , main_ [ class "col-sm-9 ml-sm-auto col-md-10 pt-3", attribute "role" "main" ]
                [ main ]
            ]
        ]


frame : ActivePage -> Html msg -> Html msg
frame activePage content =
    div []
        [ frameHeader
        , frameMain activePage content
        ]
