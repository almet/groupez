module Update.ProductForm exposing (..)

import Data.Msg exposing (ProductFormMsg(..))
import Data.Product exposing (Product)
import String.Extra exposing (wrapWith)


update : ProductFormMsg -> Product -> ( Product, Cmd ProductFormMsg )
update msg currentProduct =
    case msg of
        UpdateProductId id ->
            ( { currentProduct | id = id }, Cmd.none )

        UpdateProductName name ->
            ( { currentProduct | name = name }, Cmd.none )

        UpdateProductUnit unit ->
            ( { currentProduct | unit = unit }, Cmd.none )

        UpdateProductDescription description ->
            ( { currentProduct | description = description }, Cmd.none )

        UpdateProductPrice price ->
            let
                newPrice =
                    case price |> String.toFloat of
                        Just price_f ->
                            price_f

                        _ ->
                            currentProduct.price
            in
            ( { currentProduct | price = newPrice }, Cmd.none )
