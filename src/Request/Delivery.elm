module Request.Delivery exposing (fetch)

import Data.Delivery as Delivery
import Data.Msg exposing (Msg(..))
import Http
import Settings exposing (serverUrl)


fetch : Cmd Msg
fetch =
    Http.get
        { url = serverUrl ++ "/delivery/12"
        , expect = Http.expectJson GotDelivery Delivery.decode
        }
