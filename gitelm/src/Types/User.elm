module Types.User exposing (User, Session, decoder, request)

import Page

import Json.Decode exposing (Decoder, string)
import Json.Decode.Pipeline exposing (decode, required)
import Http
import Request exposing (Credentials)


type alias User =
    { login : String
    , name : String
    , email : String
    }


type alias Session =
    { user : Page.Data Http.Error User }


decoder : Decoder User
decoder =
    decode User
        |> required "login" string
        |> required "name" string
        |> required "email" string


request : (Result Http.Error User -> msg) -> Credentials c -> Cmd msg
request mapToMsg creds =
    Request.load "https://api.github.com/user" decoder mapToMsg creds
