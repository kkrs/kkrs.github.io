module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http
import Types.User as User exposing (User, Session)
import Types.Config exposing (Config)
import Request exposing (Credentials)
import Route exposing (Route)
import Navigation exposing (Location)
import Page exposing (Page)
import Views.Page as PageView
import Pages.User as UserPage
import Pages.Repos as ReposPage
import Pages.Login as LoginPage


{- Design

    * Every urlChange causes Navigation.program to create a message. In this case change in the url
      gets translated into a LoadPage.
    * LoadPage sets pageModel to the initial value - Loading. This is because, in this app,
      clicking on the link to a page, will transition to that page, show as much as can be shown and
      then show a spinner. LoadPage will also fire off any tasks required for that page.
    * When those tasks are completed, another Page specific Msg fires which gets handled by the
      page's update function.

    TODO
        x introduce routing
        x add pages
            x user
            x repos
            x login
                * on load automatically redirect to login if auth failed
        * move to path based routing
        x home page if auth succeeded
        * how to handle errors ?

        x LoginPage.SignIn should issue request
        x Navigation.load redirects to / on LoadedSession - no verification done as of now
        * else redirect back to loginPage
-}
-- model


type PageModel
    = LoginPageModel LoginPage.Model
    | UserPageModel UserPage.Model
    | ReposPageModel ReposPage.Model


-- FIXME: replicates Credentials
type alias Creds =
    { username: String, password: String }

type alias Model =
    { credentials : Creds
    , session : Session
    , pageModel : PageModel
    }



-- update


type Msg
    = LoadedSession (Result Http.Error User) -- Session is mostly just User
    | LoadPage Page
    | LoginPageMsg LoginPage.Msg
    | UserPageMsg UserPage.Msg
    | ReposPageMsg ReposPage.Msg


{-| loadPage handles `LoadPage` by delegating it to page specific load
-}
loadPage : Page -> Model -> ( Model, Cmd Msg )
loadPage page model =
    case page of
        Page.Login ->
            let
                pageModel =
                    LoginPageModel (LoginPage.Model "" "")
            in
                ( { model | pageModel = pageModel }, Cmd.none )

        Page.Logout ->  -- do nothing. the link will reload the page and state will be re-initialized
            ( model, Cmd.none )

        Page.User ->
            let
                pageModel =
                    UserPageModel (UserPage.Model (Session Page.Loading))

                pageCmd =
                    UserPage.load model.credentials
            in
                ( { model | pageModel = pageModel }
                , Cmd.map UserPageMsg pageCmd
                )

        Page.Repos ->
            let
                pageModel =
                    ReposPageModel (ReposPage.Model Page.Loading)

                pageCmd =
                    ReposPage.load model.credentials
            in
                ( { model | pageModel = pageModel }
                , Cmd.map ReposPageMsg pageCmd
                )


mapUpdate : (subModel -> PageModel) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
mapUpdate mapModel mapMsg model ( subModel, subCmd ) =
    ( { model | pageModel = mapModel subModel }, Cmd.map mapMsg subCmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.pageModel ) of
        ( LoginPageMsg LoginPage.SignIn, LoginPageModel pageModel ) ->
            let
                creds = Creds pageModel.githubId pageModel.accessToken

                loadSession =
                    User.request LoadedSession creds
            in
                Debug.log "LoginPageMsg" ( { model | session = Session Page.Loading, credentials = creds }, loadSession )

        ( LoadedSession userResult, _ ) ->
            let
                session = Session (Page.Loaded userResult)

                pageModel =
                    UserPageModel (UserPage.Model (Session Page.Loading))

                changeUrlToHome =
                    Navigation.newUrl (Route.toString Route.Home)
            in
                ( { model | session = session, pageModel = pageModel }, changeUrlToHome )

        ( LoginPageMsg pageMsg, LoginPageModel pageModel ) ->
            mapUpdate LoginPageModel LoginPageMsg model (LoginPage.update pageMsg pageModel)

        ( LoadPage page, _ ) ->
            Debug.log "loadPage" loadPage page model

        ( UserPageMsg pageMsg, UserPageModel pageModel ) ->
            mapUpdate UserPageModel UserPageMsg model (UserPage.update pageMsg pageModel)

        ( ReposPageMsg pageMsg, ReposPageModel pageModel ) ->
            mapUpdate ReposPageModel ReposPageMsg model (ReposPage.update pageMsg pageModel)

        ( _, _ ) ->
            -- catch cases where msg and model are mismatched, i.e.
            -- UserPageMsg with ReposPageModel and ignore them
            -- FIXME: make this debuggable
            ( model, Cmd.none )



-- view


view : Model -> Html Msg
view model =
    case model.pageModel of
        LoginPageModel loginPageModel ->
            LoginPage.view loginPageModel
                |> Html.map LoginPageMsg

        UserPageModel userPageModel ->
            UserPage.view userPageModel
                |> PageView.frame PageView.Home
                |> Html.map UserPageMsg

        ReposPageModel reposPageModel ->
            ReposPage.view reposPageModel
                |> PageView.frame PageView.Repos
                |> Html.map ReposPageMsg


{-| `init` maps initial Location to an initial `Model` and `Cmd` so Elm can
display the initial view. It sets the page model to delegates generating Cmd to
page specific init.
-}
init : Location -> ( Model, Cmd Msg )
init location =
    let
        emptyCreds = Creds "" ""
    in
        -- case page of
            -- Page.Login ->
                ( Model emptyCreds (Session Page.Loading) (LoginPageModel (LoginPage.Model "" ""))
                , Navigation.newUrl (Route.toString Route.Login)
                )

            {-
            Page.User ->
                ( Model emptyCreds Nothing (UserPageModel (UserPage.Model Page.Loading))
                , Cmd.map UserPageMsg (UserPage.load initCreds)
                )

            Page.Repos ->
                ( Model emptyCreds Nothing (ReposPageModel (ReposPage.Model Page.Loading))
                , Cmd.map ReposPageMsg (ReposPage.load initCreds)
                )
            -}


main =
    Navigation.program (LoadPage << Page.fromLocation)
        { init = init
        , view = view
        , update = update
        , subscriptions = (\model -> Sub.none)
        }
