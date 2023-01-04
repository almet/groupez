module Data.Delivery exposing (Delivery, decode, empty)

import Data.Discount as Discount exposing (Discount)
import Data.Order as Order exposing (Order)
import Data.Product as Product exposing (Product)
import Json.Decode as Decode exposing (Decoder, list, string)
import Json.Decode.Extra exposing (datetime)
import Json.Decode.Pipeline exposing (optional, required)
import Time exposing (Posix, millisToPosix)


type alias Delivery =
    { status : String
    , delivery_name : String
    , handler_name : String
    , handler_email : String
    , handler_phone : String
    , order_before : Posix
    , expected_date : Posix
    , products : List Product
    , discounts : List Discount
    , orders : List Order
    }


empty : Delivery
empty =
    { status = ""
    , delivery_name = ""
    , handler_name = ""
    , handler_email = ""
    , handler_phone = ""
    , order_before = Time.millisToPosix 0
    , expected_date = Time.millisToPosix 0
    , products = []
    , discounts = []
    , orders = []
    }


decode : Decoder Delivery
decode =
    Decode.succeed Delivery
        |> required "status" string
        |> required "delivery_name" string
        |> required "handler_name" string
        |> required "handler_email" string
        |> required "handler_phone" string
        |> required "order_before" datetime
        |> optional "expected_date" datetime (millisToPosix 0)
        |> required "products" (list Product.decode)
        |> required "discounts" (list Discount.decode)
        |> required "orders" (list Order.decode)
