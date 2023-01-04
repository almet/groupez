module Request.Delivery exposing (fetch)

import Settings exposing (serverUrl)
import Http
import Data.Msg exposing (Msg(..))
import Data.Delivery as Delivery

fetch : Cmd Msg
fetch =
    Http.get
        { url = serverUrl ++ "/delivery/12"
        , expect = Http.expectJson GotDelivery Delivery.decode
        }