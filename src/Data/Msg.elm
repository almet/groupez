module Data.Msg exposing (DeliveryFormMsg(..), Msg(..), OrderFormMsg(..), ProductFormMsg(..))

-- To expose all the types

import Browser
import Data.Delivery exposing (Delivery)
import Http
import Url


type Msg
    = UpdateOrderForm OrderFormMsg
    | UpdateDeliveryForm DeliveryFormMsg
    | UpdateProductForm ProductFormMsg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | GotDelivery (Result Http.Error Delivery)
    | DeliveryInfosSubmitted
    | UpdateDeliveryProduct
    | GenerateRandomProductID
    | ProductIDGenerated String


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


type ProductFormMsg
    = UpdateProductId String
    | UpdateProductName String
    | UpdateProductUnit String
    | UpdateProductDescription String
    | UpdateProductPrice String
