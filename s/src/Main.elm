module Escalate exposing (..)

import Views.Menu as Menu
import Views.Page as Page

import Html exposing (..)
import Navigation

type Page
    = Home
    | Incidents
    | Applications
    | Schedules
    | EscalationPolicies
    | Users
    | Error

toHref : Page -> String
toHref page =
    case page of
        Home ->
            ""
        Incidents ->
            "#incidents"
        Applications ->
            "#applications"
        Schedules ->
            "#schedules"
        EscalationPolicies ->
            "#escalationPolicies"
        Users ->
            "#users"
        Error ->
            "#error"

toPage : Navigation.Location -> Page
toPage location =
    case location.hash of
        "" ->
            Home
        "#incidents" ->
            Incidents
        "#applications" ->
            Applications
        "#schedules" ->
            Schedules
        "#escalationPolicies" ->
            EscalationPolicies
        "#users" ->
            Users
        "#error" ->
            Error
        _ ->
            Error

type alias Model =
    { activeLink : String
    , currentPage : Page
    }

view : Model -> Html msg
view model =
    Page.frame model.activeLink

-- update

type Msg
    = UrlChange Navigation.Location

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        UrlChange location ->
            let
                new = { model
                      | currentPage = (toPage location)
                      , activeLink = location.hash
                      }
            in
                (new, Cmd.none)

init : Navigation.Location -> (Model, Cmd msg)
init location =
    (Model "#incidents" (toPage location), Cmd.none)

main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }

    {-
    Html.beginnerProgram
        { model = Model Menu.initialModel Incidents
        , view = view
        , update = update
        }
    -}
