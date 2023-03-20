module Update.DeliveryForm exposing (update)

import Data.Delivery exposing (Delivery)
import Data.Msg exposing (DeliveryFormMsg(..))
import String.Extra exposing (wrapWith)


update : DeliveryFormMsg -> Delivery -> ( Delivery, Cmd DeliveryFormMsg )
update msg currentDelivery =
    case msg of
        UpdateDeliveryName name ->
            ( { currentDelivery | delivery_name = name }, Cmd.none )

        UpdateDeliveryHandlerName name ->
            ( { currentDelivery | handler_name = name }, Cmd.none )

        UpdateDeliveryHandlerPhone phoneNumber ->
            ( { currentDelivery
                | handler_phone = phoneNumber |> String.filter Char.isDigit |> wrapWith 2 " "
              }
            , Cmd.none
            )

        UpdateDeliveryHandlerEmail email ->
            ( { currentDelivery | handler_email = email }, Cmd.none )

        UpdateDeliveryOrderBefore newDate ->
            ( currentDelivery, Cmd.none )

        UpdateDeliveryExpectedDate newDate ->
            ( currentDelivery, Cmd.none )

        UpdateHandlerAcceptsCalls accepts ->
            ( { currentDelivery | handler_accepts_calls = accepts }, Cmd.none )



-- UpdateDeliveryUpdateProduct product ->
--     ( { currentDelivery | products = accepts }, Cmd.none )
