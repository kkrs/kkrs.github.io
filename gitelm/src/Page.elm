module Page exposing (Data(..), Page(..), fromLocation)

import Route exposing (Route(..))
import Navigation exposing (Location)


type Data error value
    = Loading
    | Loaded (Result error value)


type Page
    = Login
    | Logout
    | User
    | Repos


fromLocation : Location -> Page
fromLocation location =
    let
        maybeRoute =
            Route.fromLocation (location)
    in
        case maybeRoute of
            Just Route.Home ->
                User

            Just Route.Login ->
                Login

            Just Route.Logout ->
                Logout

            Just Route.User ->
                User

            Just Route.Repos ->
                Repos

            Nothing ->
                User
