module Data.Product exposing (Product, decode)

import Json.Decode as Decode exposing (Decoder, float, string)
import Json.Decode.Pipeline exposing (required)


type alias Product =
    { id : String
    , name : String
    , description : String
    , price : Float
    }


decode : Decoder Product
decode =
    Decode.succeed Product
        |> required "id" string
        |> required "name" string
        |> required "description" string
        |> required "price" float
