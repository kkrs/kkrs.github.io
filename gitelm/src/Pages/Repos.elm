module Pages.Repos exposing (..)

import Http
import Html exposing (Html, div, table, td, tr, text)
import Html.Attributes exposing (class)
import Json.Decode
import Types.Repo as Repo exposing (Repo)
import Request exposing (Credentials)
import Page exposing (Data(..))


-- model


type alias Model =
    { reposData : Page.Data Http.Error (List Repo) }



-- update


type Msg
    = LoadedRepos (Result Http.Error (List Repo))


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        LoadedRepos reposResult ->
            ( { model | reposData = Loaded reposResult }, Cmd.none )



-- view


viewLoading : Html msg
viewLoading =
    div [ class "spinner" ]
        [ div [ class "bounce1" ] []
        , div [ class "bounce2" ] []
        , div [ class "bounce3" ] []
        ]


descToString : Maybe String -> String
descToString maybeDesc =
    case maybeDesc of
        Just desc ->
            desc

        Nothing ->
            "No description provided"


viewRepo : Repo -> Html msg
viewRepo repo =
    tr []
        [ td [] [ text repo.name ]
        , td [] [ text repo.url ]
        , td [] [ text (descToString repo.description) ]
        ]


viewLoaded : Result Http.Error (List Repo) -> Html msg
viewLoaded result =
    let
        body =
            case result of
                Ok repos ->
                    List.map viewRepo repos

                Err error ->
                    [ text ("Error: " ++ (toString error)) ]
    in
        div [] body


view : Model -> Html msg
view model =
    case model.reposData of
        Page.Loading ->
            viewLoading

        Page.Loaded result ->
            viewLoaded result


load : Credentials c -> Cmd Msg
load creds =
    let
        decoder =
            Json.Decode.list Repo.decoder
    in
        Request.load "https://api.github.com/user/repos" decoder LoadedRepos creds
