module Page exposing (Page(..), frame)

import Html exposing (..)
import Html.Attributes exposing (..)
import Views.Menu as Menu
import Views.Login as Login
import Route exposing (Route(..))

type Page
    = Home
    | Login
    | Incidents
    | Users
    | Error

toMenuItem : Page -> Maybe Menu.Item
toMenuItem page =
    case page of
        Home        -> Just Menu.Incidents
        Incidents   -> Just Menu.Incidents
        Users       -> Just Menu.Users
        Error       -> Nothing
        _           -> Nothing

viewMain : Page -> Html msg
viewMain page =
    main_ []
        [ div [ id "main", class "is-fluid columns" ]
            [ div [ id "menu", class "column is-2" ] [ Menu.view (toMenuItem page) ]
            , div [ id "list", class "column is-4" ] []
            , div [ id "detail", class "column is-6" ] []
            ]
        ]

viewHeader : Html msg
viewHeader =
    let
        logoutLink = Route.toHref Logout
        logoutText = Route.toString Logout
    in
        header []
            [ nav [ class "navbar" ]
                [ div [ class "navbar-brand" ] [ a [ class "navbar-item", href "#" ] [ text "escalate" ] ]
                , div [ class "navbar-menu" ]
                    [ div [ class "navbar-end" ]
                        [ span [ class "navbar-item" ]
                            [ a [ class "button esc-button", href logoutLink ] [ span [] [ text logoutText ] ] ]
                        ]
                    ]
                ]
            ]

viewFooter : Html msg
viewFooter =
    footer []
        [ nav [ class "nav" ]
            [ div [ class "nav-center" ]
                [ span [ class "nav-item" ]
                    [ a [ class "is-brand", href "#" ] [ text "escalate" ]
                        -- \x00A0 is unicode for &nbsp
                    , text "\x00A0is licensed under\x00A0"
                    , a [ href "https://www.apache.org/licenses/LICENSE-2.0" ] [ text "Apache 2.0 " ]
                    , span [ attribute "style" "padding: 0 5px" ] [ text "—" ]
                    , text "© 2017 Karthik Krishnamurthy"
                    ]
                ]
            ]
        ]

viewLogin : Page -> List (Html msg)
viewLogin _ =
    [ Login.view
    , viewFooter
    ]

viewHome : Page -> List (Html msg)
viewHome page =
    [ viewHeader
    , viewMain page
    , viewFooter
    ]

frame : Page -> Html msg
frame page =
    let
        pageContent =
            case page of
                Login   -> viewLogin page
                _       -> viewHome page
    in 
        div [ class "page" ] pageContent
