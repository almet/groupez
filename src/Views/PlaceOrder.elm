module Views.PlaceOrder exposing (view)

import Data.Delivery exposing (Delivery)
import Data.Discount exposing (Discount)
import Data.Model exposing (Model)
import Data.Msg exposing (Msg(..), OrderFormMsg(..))
import Data.Order exposing (Order, OrderQuantities)
import Data.Product exposing (Product)
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Time
import Views.Utils exposing (formatDate)


view : Model -> Html Msg
view model =
    let
        delivery =
            model.currentDelivery
    in
    div [ class "container" ]
        (case model.errorMessage of
            Nothing ->
                [ div []
                    [ h1 [] [ text delivery.delivery_name ]
                    , div [ class "grid" ]
                        [ div [ class "order-before" ]
                            [ p []
                                [ "⏳ Commandez jusqu'au " |> text
                                , mark []
                                    [ formatDate delivery.order_before |> text ]
                                ]
                            ]
                        , expectedDateView delivery
                        ]
                    ]
                , div [ class "info" ] (List.map viewDiscount delivery.discounts)
                , viewOrderTable model delivery model.currentOrder
                , div [ class "delivery-handler" ]
                    [ p []
                        [ "Cette commande est gérée par " ++ delivery.handler_name ++ ". Vous pouvez le⋅a joindre" |> text
                        , a [ title ("Joindre " ++ delivery.handler_name ++ " par email via " ++ delivery.handler_email), href ("mailto:" ++ delivery.handler_email) ] [ " par email 📨" |> text ]
                        , a [ title ("Joindre " ++ delivery.handler_name ++ " par téléphone au " ++ delivery.handler_phone), href ("tel:" ++ delivery.handler_phone) ] [ " ou par téléphone 📞." |> text ]
                        ]
                    ]
                , viewContactForm model
                ]

            Just errorMessage ->
                [ div [ class "error" ] [ text errorMessage ] ]
        )


viewDiscount : Discount -> Html msg
viewDiscount discount =
    p [] [ "💡 Réduction de " ++ (discount.percentage |> String.fromFloat) ++ "% à partir de " ++ (discount.threshold |> String.fromFloat) ++ "€ de commande" |> text ]


expectedDateView : Delivery -> Html msg
expectedDateView delivery =
    if Time.posixToMillis delivery.expected_date == 0 then
        div [] []

    else
        div [ class "expected-date" ]
            [ p []
                [ "📅 Récupération le "
                    |> text
                , mark
                    []
                    [ formatDate delivery.expected_date |> text
                    ]
                ]
            ]


viewContactForm : Model -> Html Msg
viewContactForm model =
    div [ class "contact-form" ]
        [ input
            [ placeholder "Votre nom ?"
            , onInput <| UpdateOrderForm << UpdateOrderName
            , value model.currentOrder.name
            ]
            []
        , input
            [ placeholder "Entrez un email"
            , onInput <| UpdateOrderForm << UpdateOrderEmail
            , value model.currentOrder.email
            ]
            []
        , input
            [ placeholder "Entrez un numéro de téléphone"
            , onInput <| UpdateOrderForm << UpdateOrderPhoneNumber
            , value model.currentOrder.phone_number
            ]
            []
        , button
            [ disabled (isOrderReady model.currentOrder |> not) ]
            [ text "Enregistrer la commande" ]
        ]



-- We consider the order ready if :
-- - the order has a name ;
-- - a phone number is set and complete;


isOrderReady : Order -> Bool
isOrderReady order =
    if
        order.name
            /= ""
            && order.phone_number
            /= ""
            && (order.phone_number |> String.replace " " "" |> String.length)
            >= 10
    then
        True

    else
        False


getOrderTotalAmout : List Product -> OrderQuantities -> Float
getOrderTotalAmout products order =
    let
        accu id quantity total =
            let
                price =
                    case products |> List.filter (\p -> p.id == id) |> List.head of
                        Just product ->
                            .price product

                        Nothing ->
                            toFloat 0
            in
            total + price * (quantity |> toFloat)
    in
    Dict.foldl accu 0 order


viewOrderTable : Model -> Delivery -> Order -> Html Msg
viewOrderTable model delivery currentOrder =
    let
        total =
            case getOrderTotalAmout delivery.products currentOrder.quantities |> String.fromFloat of
                "0" ->
                    ""

                amount ->
                    amount ++ "€"
    in
    table []
        [ thead
            []
            [ tr []
                [ th [ class "product" ] [ text "Produit" ]
                , th [ class "price" ] [ text "Prix" ]
                , th [ class "amount" ] [ text "Commande" ]
                , th [ class "subtotal" ] [ text "Sous-totaux" ]
                ]
            ]
        , tbody [] (delivery.products |> List.map (viewTableLine model delivery))
        , tfoot []
            [ tr []
                [ th [ class "total", colspan 3 ] [ text "Total de votre commande" ]
                , th [ class "total" ] [ total |> text ]
                ]
            ]
        ]


viewTableLine : Model -> Delivery -> Product -> Html Msg
viewTableLine model delivery product =
    let
        quantity =
            Maybe.withDefault 0 (model.currentOrder.quantities |> Dict.get product.id)

        price =
            case delivery.products |> List.filter (\r -> r.id == product.id) |> List.head of
                Just record ->
                    .price record

                Nothing ->
                    0
    in
    tr []
        [ td [] [ div [] [ text product.name, p [ class "description" ] [ text product.description ] ] ]
        , td [] [ text <| (product.price |> String.fromFloat) ++ "€" ]
        , td []
            [ input
                [ placeholder "Entrez la quantité que vous souhaitez commander"
                , class "order-input"
                , onInput <| UpdateOrderForm << UpdateOrderQuantity product.id
                , value (String.fromInt quantity)
                ]
                []
            ]
        , td []
            [ case quantity of
                0 ->
                    text "—"

                _ ->
                    text <| (toFloat quantity * price |> String.fromFloat) ++ "€"
            ]
        ]
