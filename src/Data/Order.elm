module Data.Order exposing (Order, OrderQuantities, decode)

import Dict exposing (Dict)
import Json.Decode as Decode exposing (Decoder, dict, int, string)
import Json.Decode.Pipeline exposing (required)


type alias Order =
    { name : String
    , phone_number : String
    , email : String
    , quantities : OrderQuantities
    }


type alias OrderQuantities =
    Dict String Int


decode : Decoder Order
decode =
    Decode.succeed Order
        |> required "name" string
        |> required "phone_number" string
        |> required "email" string
        |> required "quantities" (dict int)
