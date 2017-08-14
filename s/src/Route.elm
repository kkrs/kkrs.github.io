module Route exposing (Route(..), toString, toHref, fromLocation)

import Navigation exposing (Location)
import UrlParser as Url exposing((</>), Parser, oneOf, s, parseHash)

type Route
    = Home
    | Login
    | Logout
    | Incidents
    | Users

toString : Route -> String
toString route =
    case route of
        Home        -> "home"
        Login       -> "login"
        Logout      -> "logout"
        Incidents   -> "incidents"
        Users       -> "users"

toHref : Route -> String
toHref route =
    "#" ++ (toString route)

parser : Parser (Route -> a) a
parser =
    oneOf
        [ Url.map Home (s "")
        , Url.map Login (s "login")
        , Url.map Logout (s "logout")
        , Url.map Incidents (s "incidents")
        , Url.map Users (s "users")
        ]

fromLocation : Location -> Maybe Route
fromLocation location = 
    if String.isEmpty location.hash then
        Just Home
    else
        parseHash parser location
