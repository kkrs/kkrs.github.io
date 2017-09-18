module Request exposing (Credentials, get, load)

import Http
import Base64
import Json.Decode exposing (Decoder)


type alias Credentials c =
    { c | username : String, password : String }


toBasicAuth : Credentials c -> Http.Header
toBasicAuth { username, password } =
    let
        hash =
            Base64.encode (username ++ ":" ++ password)
    in
        Http.header "Authorization" ("Basic " ++ hash)


request : String -> String -> Decoder a -> Credentials c -> Http.Request a
request method url decoder creds =
    Http.request
        { method = method
        , headers = [ (toBasicAuth creds) ]

        -- , url = "https://api.github.com/user"
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = False -- FIXME: should be true with the correct CORS support.
        }


get : String -> Decoder a -> Credentials c -> Http.Request a
get =
    request "GET"


load : String -> Decoder a -> (Result Http.Error a -> msg) -> Credentials c -> Cmd msg
load url decoder resultToMsg creds =
    Http.send resultToMsg (get url decoder creds)
