module Escalate exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Json.Encode as Encode

encode : String -> Attribute msg
encode name =
    property "classname" (Encode.string name)

type Msg
    = SelectMenuItem String

type alias MenuItem =
    { text : String
    , link : String
    }

type alias MenuModel =
    { items : List MenuItem
    , activeText : String
    }

renderMenuItem : String -> MenuItem -> Html Msg
renderMenuItem activeText item =
    li [] [ a [ href item.link
              , onClick (SelectMenuItem item.text)
              , classList [ ("is-active", item.text == activeText) ]
              ]
              [ text item.text ]
          ]

renderMenu : MenuModel -> List (Html Msg)
renderMenu menu =
    List.map (renderMenuItem menu.activeText) menu.items


viewMenu : MenuModel -> Html Msg
viewMenu model =
    div [ class "menu" ] [ ul [ class "menu-list" ] (renderMenu model) ]

{- empty not styled properly yet
viewDetail : Html msg
viewDetail =
    div [ class "empty" ] []
-}

viewMain : MenuModel -> Html Msg
viewMain menuModel =
    main_ []
        [ div [ id "main", class "is-fluid columns" ]
            [ div [ id "menu", class "column is-2" ] [ viewMenu menuModel ]
            , div [ id "list", class "column is-4" ] []
            , div [ id "detail", class "column is-6" ] []
            ]
        ]

viewHeader : Html Msg
viewHeader =
    header []
        [ nav [ class "navbar" ]
            [ div [ class "navbar-brand" ] [ a [ class "navbar-item", href "#" ] [ text "escalate" ] ]
            , div [ class "navbar-menu" ]
                [ div [ class "navbar-end" ]
                    [ span [ class "navbar-item" ]
                        [ a [ class "button" ] [ span [] [ text "logout" ] ] ]
                    ]
                ]
            ]
        ]

viewFooter : Html Msg
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

type alias Model =
    { menu : MenuModel }

view : Model -> Html Msg
view model =
    div [ class "page" ] [ viewHeader, viewMain model.menu, viewFooter ]

initialModel : Model
initialModel =
    { menu =
        { items = [ { text = "Incidents", link = "#" }
              , { text = "Services", link = "#" }
              , { text = "Escalation Policies", link = "#" }
              , { text = "Schedule", link = "#" }
              , { text = "Users", link = "#" }
              ]
        , activeText = "Incidents"
        }
    }

update : Msg -> Model -> Model
update msg model =
    case msg of
        SelectMenuItem text ->
            let
                oldMenu = model.menu
                newMenu = { oldMenu | activeText = text }
            in
                { model | menu = newMenu }

main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }
