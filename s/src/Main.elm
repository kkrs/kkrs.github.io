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

type alias Model = { navigateTo : Navigation.Location }

view : Model -> Html msg
view model =
    Page.frame model.navigateTo

-- update

type Msg
    = UrlChange Navigation.Location

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        UrlChange location ->
            ({ model | navigateTo = location}, Cmd.none)

init : Navigation.Location -> (Model, Cmd msg)
init location =
    (Model location, Cmd.none)

main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
