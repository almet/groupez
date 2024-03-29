module Data.Product exposing (Product, decode, empty)

import Json.Decode as Decode exposing (Decoder, float, string)
import Json.Decode.Pipeline exposing (required)


type alias Product =
    { id : String
    , name : String
    , unit : String
    , description : String
    , price : Float
    }


decode : Decoder Product
decode =
    Decode.succeed Product
        |> required "id" string
        |> required "name" string
        |> required "unit" string
        |> required "description" string
        |> required "price" float


empty : Product
empty =
    Product "" "" "" "" 0.0
