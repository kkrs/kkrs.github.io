module Views.Page exposing (frame)

import Views.Menu as Menu

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation

viewMain : Navigation.Location -> Html msg
viewMain location =
    main_ []
        [ div [ id "main", class "is-fluid columns" ]
            [ div [ id "menu", class "column is-2" ] [ Menu.view location ]
            , div [ id "list", class "column is-4" ] []
            , div [ id "detail", class "column is-6" ] []
            ]
        ]

viewHeader : Html msg
viewHeader =
    header []
        [ nav [ class "navbar" ]
            [ div [ class "navbar-brand" ] [ a [ class "navbar-item", href "#" ] [ text "escalate" ] ]
            , div [ class "navbar-menu" ]
                [ div [ class "navbar-end" ]
                    [ span [ class "navbar-item" ]
                        [ a [ class "button esc-button", href "/login.html" ] [ span [] [ text "logout" ] ] ]
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

frame : Navigation.Location -> Html msg
frame location =
    div [ class "page" ]
        [ viewHeader
        , viewMain location
        , viewFooter
        ]
