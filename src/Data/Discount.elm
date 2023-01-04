module Data.Discount exposing (Discount, decode)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra exposing (parseFloat)
import Json.Decode.Pipeline exposing (requiredAt)


type alias Discount =
    { threshold : Float
    , percentage : Float
    }


decode : Decoder Discount
decode =
    Decode.succeed Discount
        |> requiredAt [ "rules", "threshold" ] parseFloat
        |> requiredAt [ "rules", "percentage" ] parseFloat
