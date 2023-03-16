module Data.Msg exposing (DeliveryFormMsg(..), Msg(..), OrderFormMsg(..))

-- To expose all the types

import Browser
import Data.Delivery exposing (Delivery)
import Http
import Url


type Msg
    = UpdateOrderForm OrderFormMsg
    | UpdateDeliveryForm DeliveryFormMsg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotDelivery (Result Http.Error Delivery)
    | DeliveryInfosSubmitted


type OrderFormMsg
    = UpdateOrderName String
    | UpdateOrderPhoneNumber String
    | UpdateOrderEmail String
    | UpdateOrderQuantity String String


type DeliveryFormMsg
    = UpdateDeliveryName String
    | UpdateDeliveryHandlerName String
    | UpdateDeliveryHandlerPhone String
    | UpdateDeliveryHandlerEmail String
    | UpdateDeliveryOrderBefore String
    | UpdateDeliveryExpectedDate String
    | UpdateHandlerAcceptsCalls Bool
