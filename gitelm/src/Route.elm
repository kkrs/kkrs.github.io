module Route exposing (Route(..), fromLocation, toString, toHref)

import Navigation exposing (Location)
import UrlParser as Url exposing (map, Parser, oneOf, s, parseHash)
import Html exposing (Attribute)
import Html.Attributes as Attributes


type Route
    = Home
    | Login
    | Logout
    | User
    | Repos


toSimpleString : Route -> String
toSimpleString route =
    case route of
        Home ->
            ""

        Login ->
            "login"

        Logout ->
            "logout"

        User ->
            "user"

        Repos ->
            "repos"


toString : Route -> String
toString route =
    "#/" ++ (toSimpleString route)


toHref : Route -> Attribute msg
toHref route =
    Attributes.href (toString route)


toParser : Route -> Parser (Route -> a) a
toParser route =
    map route (s (toSimpleString route))


parser : Parser (Route -> a) a
parser =
    oneOf
        [ toParser Home
        , toParser Login
        , toParser User
        , toParser Repos
        ]


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Home
    else
        parseHash parser location
