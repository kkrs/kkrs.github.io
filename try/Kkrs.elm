module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation
import Debug exposing (log)


-- model


type Page
    = Home
    | Error
    | Cats
    | Dogs


toString : Page -> String
toString page =
    case page of
        Home ->
            "home"

        Error ->
            "error"

        Cats ->
            "cats"

        Dogs ->
            "dogs"


toHash : Page -> String
toHash page =
    case page of
        Home ->
            ""

        _ ->
            "#" ++ (toString page)


toPage : Navigation.Location -> Page
toPage location =
    case location.hash of
        "" ->
            Home

        "#cats" ->
            Cats

        "#dogs" ->
            Dogs

        _ ->
            Error


type alias Model =
    { currentPage : Page }



-- view


view : Model -> Html msg
view model =
    div []
        [ h1 [] [ text (toString model.currentPage) ]
        , h2 [] [ text "pages" ]
        , ul [] (List.map renderLink [ Home, Cats, Dogs ])
        ]


renderLink : Page -> Html msg
renderLink page =
    li [] [ a [ href (toHash page) ] [ text (toString page) ] ]



-- update


type Msg
    = UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ({ model | currentPage = (toPage location)}, Cmd.none)


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( Model (toPage location), Cmd.none )


main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = (\_ -> Sub.none)
        }
