module Data.Model exposing (Model, NewDeliveryStatus(..), empty)

import Data.Delivery as Delivery exposing (Delivery)
import Data.Navigation exposing (Navigation)
import Data.Order as Order exposing (Order)


type alias Model =
    { currentOrder : Order
    , currentDelivery : Delivery
    , navigation : Navigation
    , errorMessage : Maybe String
    , newDelivery : Delivery
    , newDeliveryStatus : NewDeliveryStatus
    }


type NewDeliveryStatus
    = DeliveryIsEmpty
    | DeliveryInfosEntered


empty : Navigation -> Model
empty nav =
    { currentOrder = Order.empty
    , currentDelivery = Delivery.empty
    , errorMessage = Nothing
    , navigation = nav
    , newDelivery = Delivery.empty
    , newDeliveryStatus = DeliveryInfosEntered -- CHANGE
    }
