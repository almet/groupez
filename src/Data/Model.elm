module Data.Model exposing (Model, empty)

import Data.Delivery as Delivery exposing (Delivery)
import Data.Navigation exposing (Navigation)
import Data.Order as Order exposing (Order)


type alias Model =
    { currentOrder : Order
    , currentDelivery : Delivery
    , navigation : Navigation
    , errorMessage : Maybe String
    }


empty : Navigation -> Model
empty nav =
    { currentOrder = Order.empty
    , currentDelivery = Delivery.empty
    , errorMessage = Nothing
    , navigation = nav
    }
