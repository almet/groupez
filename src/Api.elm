module Api exposing (fetchDelivery)

import Base64
import Http
import Json.Decode as Decode exposing (Decoder, dict, float, int, list, string)
import Json.Decode.Extra exposing (datetime, parseFloat)
import Json.Decode.Pipeline exposing (hardcoded, optional, required, requiredAt)
import Time exposing (millisToPosix)
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
        |> required "order_before" datetime
        |> optional "expected_date" datetime (millisToPosix 0)
        |> required "products" (list productDecoder)
        |> required "discounts" (list discountDecoder)
        |> required "orders" (list orderDecoder)


productDecoder : Decoder Product
productDecoder =
    Decode.succeed Product
        |> required "id" string
        |> required "name" string
        |> required "description" string
        |> required "price" float


discountDecoder : Decoder Discount
discountDecoder =
    Decode.succeed Discount
        |> requiredAt [ "rules", "treshold" ] parseFloat
        |> requiredAt [ "rules", "percentage" ] parseFloat


orderDecoder : Decoder DeliveryOrder
orderDecoder =
    Decode.succeed DeliveryOrder
        |> required "name" string
        |> required "phone_number" string
        |> required "email" string
        |> required "quantities" (dict int)


fetchDelivery : Cmd Msg
fetchDelivery =
    Http.get
        { url = serverUrl ++ "/delivery/12"
        , expect = Http.expectJson GotDelivery deliveryDecoder
        }



-- |> optional "expected_date" (Just datetime) Nothing
