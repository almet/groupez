module Data.Msg exposing (Msg(..), OrderFormMsg(..))

-- To expose all the types

import Browser
import Data.Delivery exposing (Delivery)
import Http
import Url


type Msg
    = UpdateOrderForm OrderFormMsg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotDelivery (Result Http.Error Delivery)


type OrderFormMsg
    = UpdateName String
    | UpdatePhoneNumber String
    | UpdateEmail String
    | UpdateQuantity String String
