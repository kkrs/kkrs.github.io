module Main exposing (main)

import Html exposing (..)
import Navigation
import Page exposing (Page)
import Route exposing (Route)

-- model

type alias Model = { navigateTo : Page.Page }

-- view

view : Model -> Html msg
view model =
    Page.frame model.navigateTo

-- update

type Msg
    = NavigateTo (Maybe Route)

logout : Model -> (Model, Cmd msg)
logout model =
    (model, Navigation.newUrl (Route.toHref Route.Login))

navigateTo : Maybe Route -> Model -> (Model, Cmd msg)
navigateTo maybeRoute model =
    case maybeRoute of
        Nothing ->
            ({ model | navigateTo = Page.Error}, Cmd.none)
        Just Route.Home ->
            ({ model | navigateTo = Page.Incidents}, Cmd.none)
        Just Route.Login ->
            ({ model | navigateTo = Page.Login}, Cmd.none)
        Just Route.Logout ->
            logout model    -- handle redirect without a view
        Just Route.Incidents ->
            ({ model | navigateTo = Page.Incidents}, Cmd.none)
        Just Route.Users ->
            ({ model | navigateTo = Page.Users}, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NavigateTo maybeRoute ->
            navigateTo maybeRoute model

-- init

init : Navigation.Location -> (Model, Cmd msg)
init location =
    {-
    let
        model
            = Route.fromLocation location
            |> maybeRouteToPage
            |> Model
    in
        (model, Cmd.none)
    -}
    navigateTo (Route.fromLocation location) (Model Page.Home)

main : Program Never Model Msg
main =
    Navigation.program (NavigateTo << Route.fromLocation)
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
