module Pages.Login exposing (Model, Msg(..), update, view)

import Html exposing (Html, div, text, form, button, h2, label, input)
import Html.Attributes exposing (class, type_, action, value, attribute, placeholder, id, for)
import Html.Events exposing (onInput, onClick, onSubmit)


type alias Model =
    { githubId : String
    , accessToken : String
    }


type Msg
    = UpdateGitHubId String
    | UpdateAccessToken String
    | SignIn


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateGitHubId s ->
            ( { model | githubId = s }, Cmd.none )

        UpdateAccessToken s ->
            ( { model | accessToken = s }, Cmd.none )

        {- this event should never have to be handled, because caller should trap it instead of
           delegating it.
        -}
        SignIn ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "container signin-container" ]
        [ form [ class "form-signin", action "#/login", onSubmit SignIn ]
            [ h2 [ class "form-signin-heading" ]
                [ text "Please sign in" ]
            , label [ class "sr-only", for "githubId" ]
                [ text "GitHub ID" ]
            , input [ onInput UpdateGitHubId, attribute "autofocus" "", class "form-control", id "githubId", placeholder "GitHub ID", attribute "required" "", type_ "text" ]
                []
            , label [ class "sr-only", for "accessToken" ]
                [ text "Personal Access Token" ]
            , input [ onInput UpdateAccessToken, class "form-control", id "accessToken", placeholder "Personal Access Token", attribute "required" "", type_ "password" ]
                []
            , button [ class "btn btn-lg btn-primary btn-block", type_ "submit" ]
                [ text "Sign in" ]
            ]
        ]
