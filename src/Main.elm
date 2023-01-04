module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Data.Delivery as Delivery exposing (Delivery)
import Data.Discount exposing (Discount)
import Data.Model as Model exposing (Model)
import Data.Msg exposing (Msg(..))
import Data.Navigation exposing (Navigation)
import Data.Order exposing (Order, OrderQuantities)
import Data.Product exposing (Product)
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Request.Client as Client
import Request.Delivery as Delivery
import String.Extra
import Time
import Time.Format
import Time.Format.Config.Config_fr_fr exposing (config)
import Url



---- MODEL ----


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Navigation key url |> Model.empty
    , Delivery.fetch
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ navigation } as model) =
    case msg of
        UpdateOrderQuantity productId quantity ->
            let
                updateOrderQuantity order =
                    { order | quantities = Dict.update productId (\_ -> String.toInt quantity) model.currentOrder.quantities }
            in
            ( { model | currentOrder = updateOrderQuantity model.currentOrder }, Cmd.none )

        UpdateOrderName name ->
            let
                updateName order =
                    { order | name = name }
            in
            ( { model | currentOrder = updateName model.currentOrder }, Cmd.none )

        UpdateOrderPhoneNumber phoneNumber ->
            let
                updatePhoneNumber order =
                    { order | phone_number = phoneNumber |> String.filter Char.isDigit |> String.Extra.wrapWith 2 " " }
            in
            ( { model | currentOrder = updatePhoneNumber model.currentOrder }, Cmd.none )

        UpdateOrderEmail email ->
            let
                updateEmail order =
                    { order | email = email }
            in
            ( { model | currentOrder = updateEmail model.currentOrder }, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.navigation.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | navigation = { navigation | url = url } }
            , Cmd.none
            )

        GotDelivery (Ok delivery) ->
            ( { model
                | currentDelivery = delivery
                , errorMessage = Nothing
              }
            , Cmd.none
            )

        GotDelivery (Err err) ->
            ( { model
                | currentDelivery = Delivery.empty
                , errorMessage = Client.errorToString err |> Just
              }
            , Cmd.none
            )



---- VIEW ----


view : Model -> Browser.Document Msg
view ({ navigation } as model) =
    case navigation.url.path of
        "/commander" ->
            { title = "Commander", body = [ placeOrderView model ] }

        -- "/créer" ->
        --     { title = "Créer une nouvelle distribution", body = [ createDeliveryView model ] }
        _ ->
            { title = "Groupez !"
            , body =
                [ ul []
                    [ viewLink "/commander"
                    , viewLink "/ "
                    , viewLink "/créer"
                    ]
                ]
            }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]



-- createDeliveryView : Model -> Html Msg
-- createDeliveryView model =
--     div [ class "section container" ]
--         [ div []
--             [ div [ class "delivery-info" ]
--                 [ [ input
--                         [ placeholder "Entrez un nom pour cette commande"
--                         , class ""
--
--                         --, onInput UpdateDeliveryName
--                         , value model.currentDelivery.name
--                         ]
--                         []
--                   ]
--                 ]
--             ]
--         ]


placeOrderView : Model -> Html Msg
placeOrderView model =
    let
        isLoaded =
            model.currentDelivery /= Delivery.empty

        delivery =
            model.currentDelivery

        numberOfOrders =
            if isLoaded then
                model.currentDelivery.orders |> List.length

            else
                0
    in
    div [ class "section container" ]
        (case model.errorMessage of
            Nothing ->
                [ div []
                    [ div [ class "delivery-info" ]
                        [ h1 [] [ text delivery.delivery_name ]
                        , div [ class "order-before" ]
                            [ "⏳ Commandez avant le " ++ formatDate delivery.order_before |> text ]
                        , case numberOfOrders of
                            0 ->
                                p [] []

                            1 ->
                                div [] [ "🤓 " ++ "Une commande déjà enregistrée" |> text ]

                            _ ->
                                div [] [ "🤓 " ++ (numberOfOrders |> String.fromInt) ++ " commandes déjà enregistrées" |> text ]
                        ]
                    , expectedDateView delivery
                    ]
                , div [ class "discounts" ] (List.map viewDiscount delivery.discounts)
                , viewOrderTable model delivery model.currentOrder
                , div [ class "delivery-handler" ]
                    [ "Cette commande est gérée par " ++ delivery.handler_name ++ ". Vous pouvez le⋅a joindre" |> text
                    , a [ title ("Joindre " ++ delivery.handler_name ++ " par email via " ++ delivery.handler_email), href ("mailto:" ++ delivery.handler_email) ] [ "par email 📨" |> text ]
                    , a [ title ("Joindre " ++ delivery.handler_name ++ " par téléphone au " ++ delivery.handler_phone), href ("tel:" ++ delivery.handler_phone) ] [ "ou par téléphone 📞." |> text ]
                    ]
                , viewContactForm model
                ]

            Just errorMessage ->
                [ div [ class "error" ] [ text errorMessage ] ]
        )


viewDiscount : Discount -> Html msg
viewDiscount discount =
    p [] [ "💡 Réduction de " ++ (discount.percentage |> String.fromFloat) ++ "% à partir de " ++ (discount.threshold |> String.fromFloat) ++ "€ de commande" |> text ]


formatDate : Time.Posix -> String
formatDate date =
    Time.Format.format config "%-d %B %Y" Time.utc date


expectedDateView : Delivery -> Html msg
expectedDateView delivery =
    if Time.posixToMillis delivery.expected_date == 0 then
        div [] []

    else
        div [ class "expected-date" ] [ "📅 Récupération des commandes prévue le " ++ formatDate delivery.expected_date |> text ]


viewContactForm : Model -> Html Msg
viewContactForm model =
    div [ class "contact-form" ]
        [ input
            [ placeholder "Votre nom ?"
            , onInput UpdateOrderName
            , value model.currentOrder.name
            ]
            []
        , input
            [ placeholder "Entrez un email"
            , onInput UpdateOrderEmail
            , value model.currentOrder.email
            ]
            []
        , input
            [ placeholder "Entrez un numéro de téléphone"
            , onInput UpdateOrderPhoneNumber
            , value model.currentOrder.phone_number
            ]
            []
        , if isOrderReady model.currentOrder then
            button [ class "button float-right" ] [ text "Enregistrer la commande" ]

          else
            p [ class "float-right" ] [ text "🤔 Votre commande n'est pas encore enregistréé, renseignez votre nom et les moyens de vous contacter, vous pourrez valider ensuite." ]
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
                , onInput (UpdateOrderQuantity product.id)
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



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = always Sub.none
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }
