module Types exposing
    ( Authentication(..)
    , Delivery
    , DeliveryOrder
    , Msg(..)
    , Product
    )

import Browser
import Dict exposing (Dict)
import Http
import Time
import Url


type alias DeliveryOrder =
    Dict String Int


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

    -- , order_before : Time.Posix
    -- , expected_date : Maybe Time.Posix
    -- , products : List Product
    -- , orders : List Order
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
