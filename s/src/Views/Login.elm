module Views.Login exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

view : Html msg
view = 
    main_ []
        [ div [ class "columns is-centered", id "main" ]
            [ div [ class "column is-half", id "login" ]
                [ div [ class "card" ]
                    [ div [ class "card-content" ]
                        [ a [ class "button esc-button", href "/", id "login-link" ]
                            [ span [ class "icon" ] [ i [ class "fa fa-github" ] [] ]
                            , span [] [ text "Login with Github" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]
