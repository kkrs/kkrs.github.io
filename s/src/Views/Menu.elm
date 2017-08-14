module Views.Menu exposing (Item(..), view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Route exposing (Route)

type Item
    = Incidents
    {-
    | Applications
    | Schedules
    | EscalationPolicies
    -}
    | Users

toRepresentation : Item -> (Item, String, String)
toRepresentation item =
    case item of
        Incidents           -> (Incidents, "Incidents", (Route.toHref Route.Incidents))
        {-
        Applications        -> (Applications, "Applications", "#applications")
        Schedules           -> (Schedules, "Schedules", "#schedules")
        EscalationPolicies  -> (EscalationPolicies, "EscalationPolicies", "#escalationPolicies")
        -}
        Users               -> (Users, "Users", (Route.toHref Route.Users))

menu : List (Item, String, String)
menu = 
    List.map toRepresentation [ Incidents
                              {-
                              , Applications
                              , Schedules
                              , EscalationPolicies
                              -}
                              , Users
                              ]

{-
toItem : Route -> Maybe Item
toItem route =
    case route of
        Route.Incidents         -> Just Incidents
        Route.Applications      -> Just Applications
        Route.Schedules         -> Just Schedules
        Route.EsclationPolicies -> Just EscalationPolicies
        Route.Users             -> Just Users
        _                       -> Nothing
-}

renderItem : Maybe Item -> (Item, String, String) -> Html msg
renderItem maybeActiveItem (item, txt, link) =
    let
        isActive =
            case maybeActiveItem of
                Nothing ->
                    False
                Just activeItem ->
                    activeItem == item
    in
        li [] [ a [ href link, classList [ ("is-active", isActive) ] ]
                  [ text txt ]
              ]

render : Maybe Item -> List (Html msg)
render activeItem =
    List.map (renderItem activeItem) menu

view : Maybe Item -> Html msg
view activeItem =
    div [ class "menu" ] [ ul [ class "menu-list" ] (render activeItem) ]
