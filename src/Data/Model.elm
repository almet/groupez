module Data.Model exposing (Model)

import Browser.Navigation as Nav
import Data.Delivery exposing (Delivery)
import Data.Order exposing (Order)
import Http
import Url


type alias Model =
    { delivery : Result Http.Error Delivery -- The fetched delivery info.
    , currentOrder : Order
    , currentDelivery : Delivery
    , key : Nav.Key
    , url : Url.Url
    }
