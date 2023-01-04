module Data.Msg exposing (Msg(..))

-- To expose all the types

import Browser
import Data.Delivery exposing (Delivery)
import Http
import Url


type Msg
    = UpdateOrderQuantity String String
    | UpdateOrderName String
    | UpdateOrderPhoneNumber String
    | UpdateOrderEmail String
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotDelivery (Result Http.Error Delivery)
