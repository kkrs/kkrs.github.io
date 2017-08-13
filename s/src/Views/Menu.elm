module Views.Menu exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation

type Item
    = Incidents
    | Applications
    | Schedules
    | EscalationPolicies
    | Users

toRepresentation : Item -> (String, String)
toRepresentation item =
    case item of
        Incidents           -> ("Incidents", "#incidents")
        Applications        -> ("Applications", "#applications")
        Schedules           -> ("Schedules", "#schedules")
        EscalationPolicies  -> ("EscalationPolicies", "#escalationPolicies")
        Users               -> ("Users", "#users")

menu : List (String, String)
menu = 
    List.map toRepresentation [ Incidents, Applications, Schedules, EscalationPolicies, Users ]

toItem : Navigation.Location -> Maybe Item
toItem location =
    case location.hash of
        "#incidents"            -> Just Incidents
        "#applications"         -> Just Applications
        "#schedules"            -> Just Schedules
        "#escalationPolicies"   -> Just EscalationPolicies
        "#users"                -> Just Users
        _                       -> Nothing

renderItem : Navigation.Location -> (String, String) -> Html msg
renderItem location (txt, link) =
    li [] [ a [ href link, classList [ ("is-active", link == location.hash) ] ]
              [ text txt ]
          ]

render : Navigation.Location -> List (Html msg)
render location =
    List.map (renderItem location) menu

view : Navigation.Location -> Html msg
view location =
    div [ class "menu" ] [ ul [ class "menu-list" ] (render location) ]
