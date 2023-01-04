module Update.OrderForm exposing (update)

import Data.Msg exposing (OrderFormMsg(..))
import Data.Order exposing (Order)
import Dict
import String.Extra exposing (wrapWith)


update : OrderFormMsg -> Order -> ( Order, Cmd OrderFormMsg )
update msg currentOrder =
    case msg of
        UpdateQuantity productId quantity ->
            ( { currentOrder
                | quantities =
                    currentOrder.quantities
                        |> Dict.update productId (\_ -> String.toInt quantity)
              }
            , Cmd.none
            )

        UpdateName name ->
            ( { currentOrder | name = name }, Cmd.none )

        UpdatePhoneNumber phoneNumber ->
            ( { currentOrder
                | phone_number = phoneNumber |> String.filter Char.isDigit |> wrapWith 2 " "
              }
            , Cmd.none
            )

        UpdateEmail email ->
            ( { currentOrder | email = email }, Cmd.none )
