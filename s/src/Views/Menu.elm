module Views.Menu exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

type alias MenuItem =
    { text : String
    , link : String
    }

menuItems : List MenuItem
menuItems =
    [ MenuItem "Incidents" "#incidents"
    , MenuItem "Applications" "#applications"
    , MenuItem "Schedules" "#schedules"
    , MenuItem "Escalation Polciies" "#escalationPolicies"
    , MenuItem "Users" "#users"
    ]

renderItem : String -> MenuItem -> Html msg
renderItem activeLink item =
    li [] [ a [ href item.link
              , classList [ ("is-active", item.link == activeLink) ]
              ]
              [ text item.text ]
          ]

render : String -> List (Html msg)
render activeLink =
    List.map (renderItem activeLink) menuItems

view : String -> Html msg
view activeLink =
    div [ class "menu" ] [ ul [ class "menu-list" ] (render activeLink) ]
