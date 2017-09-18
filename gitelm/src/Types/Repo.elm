module Types.Repo exposing (Repo, decoder)

import Json.Decode exposing (Decoder, string, nullable)
import Json.Decode.Pipeline exposing (decode, required)


type alias Repo =
    { name : String
    , url : String
    , description : Maybe String
    }


decoder : Decoder Repo
decoder =
    decode Repo
        |> required "name" string
        |> required "html_url" string
        |> required "description" (nullable string)
