module Types exposing
    ( Authentication(..)
    , Delivery
    , DeliveryOrder
    , Discount
    , Msg(..)
    , OrderQuantities
    , Product
    )

import Browser
import Dict exposing (Dict)
import Http
import Time
import Url


type alias Product =
    { id : String
    , name : String
    , description : String
    , price : Float
    }


type alias Delivery =
    { status : String
    , delivery_name : String
    , handler_name : String
    , handler_email : String
    , handler_phone : String
    , order_before : Time.Posix
    , expected_date : Time.Posix
    , products : List Product
    , discounts : List Discount
    , orders : List DeliveryOrder
    }


type alias DeliveryOrder =
    { name : String
    , phone_number : String
    , email : String
    , quantities : OrderQuantities
    }


type alias OrderQuantities =
    Dict String Int


type alias Discount =
    { treshold : Float
    , percentage : Float
    }


type Msg
    = UpdateOrderQuantity String String
    | UpdateOrderName String
    | UpdateOrderPhoneNumber String
    | UpdateOrderEmail String
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotDelivery (Result Http.Error Delivery)
    | NoOp


type Authentication
    = Basic String String
    | Unauthenticated
