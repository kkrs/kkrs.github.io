module Pages.User exposing (..)

import Types.User as User exposing (User, Session)
import Request exposing (Credentials)
import Page
import Http
import Html exposing (..)
import Html.Attributes exposing (class)


-- model


type alias Model =
    { session : Session }



-- update


type Msg
    = Loaded (Result Http.Error User)


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Loaded userResult ->
            ( { model | session = Session (Page.Loaded userResult) }, Cmd.none )



-- view


viewLoading : Html msg
viewLoading =
    div [ class "spinner" ]
        [ div [ class "bounce1" ] []
        , div [ class "bounce2" ] []
        , div [ class "bounce3" ] []
        ]


viewLoaded : Result Http.Error User -> Html msg
viewLoaded userResult =
    let
        txt =
            case userResult of
                Ok user ->
                    text ("User: " ++ (toString user))

                Err error ->
                    text ("Error: " ++ (toString error))
    in
        div [] [ txt ]


view : Model -> Html msg
view model =
    case model.session.user of
        Page.Loading ->
            viewLoading

        Page.Loaded result ->
            viewLoaded result


load : Credentials c -> Cmd Msg
load creds =
    User.request Loaded creds
