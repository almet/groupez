module Api exposing (fetchDelivery)

import Base64
import Http
import Json.Decode as Decode exposing (Decoder, float, int, string)
import Json.Decode.Extra exposing (datetime)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)
import Types exposing (..)


serverUrl : String
serverUrl =
    "http://localhost:8000"


deliveryDecoder : Decoder Delivery
deliveryDecoder =
    Decode.succeed Delivery
        |> required "status" string
        |> required "delivery_name" string
        |> required "handler_name" string
        |> required "handler_email" string
        |> required "handler_phone" string


fetchDelivery : Cmd Msg
fetchDelivery =
    Http.get
        { url = serverUrl ++ "/delivery/12"
        , expect = Http.expectJson GotDelivery deliveryDecoder
        }



-- |> required "order_before" datetime
-- |> optional "expected_date" (Just datetime) Nothing
