module Main exposing (..)

import Api exposing (..)
import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Browser
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Http
import String.Extra
import Time
import Time.Format
import Time.Format.Config.Config_fr_fr exposing (config)
import Types exposing (..)
import Url



---- MODEL ----


type alias Model =
    { delivery : Result Http.Error Delivery -- The fetched delivery info.
    , currentOrder : DeliveryOrder -- Dict of ordered products quantitites.
    , orderPhoneNumber : String
    , orderEmail : String
    , orderName : String
    , key : Nav.Key
    , url : Url.Url
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { delivery = Err (Http.BadBody "Initial State")
      , currentOrder = Dict.empty
      , orderName = ""
      , orderPhoneNumber = ""
      , orderEmail = ""
      , key = key
      , url = url
      }
    , Api.fetchDelivery
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateOrderQuantity productId quantity ->
            ( { model | currentOrder = Dict.update productId (\_ -> String.toInt quantity) model.currentOrder }, Cmd.none )

        UpdateOrderName name ->
            ( { model | orderName = name }, Cmd.none )

        UpdateOrderPhoneNumber phoneNumber ->
            ( { model | orderPhoneNumber = phoneNumber |> String.filter Char.isDigit |> String.Extra.wrapWith 2 " " }, Cmd.none )

        UpdateOrderEmail email ->
            ( { model | orderEmail = email }, Cmd.none )

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )

        GotDelivery (Ok delivery) ->
            ( { model | delivery = Ok delivery }, Cmd.none )

        GotDelivery (Err err) ->
            ( { model | delivery = Err err }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Browser.Document Msg
view model =
    case model.url.path of
        "/commander" ->
            { title = "Commander", body = [ placeOrderView model ] }

        _ ->
            { title = "Groupez !"
            , body =
                [ ul []
                    [ viewLink "/commander"
                    , viewLink "/ "
                    ]
                ]
            }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]


placeOrderView : Model -> Html Msg
placeOrderView model =
    div [ class "section container" ]
        (case model.delivery of
            Ok delivery ->
                [ div []
                    [ div [ class "delivery-info" ]
                        [ h1 [] [ text delivery.delivery_name ]
                        , div [ class "order-before" ]
                            [ "⏳ Commandez avant le " ++ formatDate delivery.order_before |> text ]
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

            Err err ->
                [ div [ class "error" ] [ errorToString err |> text ] ]
        )


viewDiscount : Discount -> Html msg
viewDiscount discount =
    p [] [ "💡 Réduction de " ++ (discount.percentage |> String.fromFloat) ++ "% à partir de " ++ (discount.treshold |> String.fromFloat) ++ "€ de commande" |> text ]


formatDate : Time.Posix -> String
formatDate date =
    Time.Format.format config "%-d %B %Y" Time.utc date


expectedDateView : Delivery -> Html msg
expectedDateView delivery =
    if Time.posixToMillis delivery.expected_date == 0 then
        div [] []

    else
        div [ class "expected-date" ] [ "📅 Récupération des commandes prévue le " ++ formatDate delivery.expected_date |> text ]


errorToString : Http.Error -> String
errorToString error =
    case error of
        Http.BadUrl url ->
            "L'URL " ++ url ++ " est invalide."

        Http.Timeout ->
            "Le serveur mets trop de temps à répondre à notre demande."

        Http.NetworkError ->
            "Impossible de joindre le serveur, êtes vous bien connecté⋅e à internet ? Si vous êtes bien connecté⋅e, il est possible que l'erreur soit due à un problème de paramètrage CORS."

        Http.BadStatus 500 ->
            "Le serveur rencontre des difficultés techniques (Erreur HTTP 500)."

        Http.BadStatus 400 ->
            "Le serveur à refusé la requête (Erreur HTTP 400)"

        Http.BadStatus _ ->
            "Une erreur HTTP est survenue, mais nous n'avons pas plus d'informations à vous fournir (Bad Status)"

        Http.BadBody errorMessage ->
            "Le serveur nous as envoyé des données mal-formées. " ++ errorMessage


viewContactForm : Model -> Html Msg
viewContactForm model =
    div [ class "contact-form" ]
        [ input
            [ placeholder "Votre nom ?"
            , onInput UpdateOrderName
            , value model.orderName
            ]
            []
        , input
            [ placeholder "Entrez un email"
            , onInput UpdateOrderEmail
            , value model.orderEmail
            ]
            []
        , input
            [ placeholder "Entrez un numéro de téléphone"
            , onInput UpdateOrderPhoneNumber
            , value model.orderPhoneNumber
            ]
            []
        , case isOrderReady model of
            True ->
                button [ class "button float-right" ] [ text "Enregistrer la commande" ]

            False ->
                p [ class "float-right" ] [ text "🤔 Votre commande n'est pas encore enregistréé, renseignez votre nom et les moyens de vous contacter, vous pourrez valider ensuite." ]
        ]



-- We consider the order ready if :
-- - the order has a name ;
-- - a phone number is set and complete;


isOrderReady : Model -> Bool
isOrderReady model =
    if
        model.orderName
            /= ""
            && model.orderPhoneNumber
            /= ""
            && (model.orderPhoneNumber |> String.replace " " "" |> String.length)
            >= 10
    then
        True

    else
        False


getOrderTotalAmout : List Product -> DeliveryOrder -> Float
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


viewOrderTable : Model -> Delivery -> DeliveryOrder -> Html Msg
viewOrderTable model delivery currentOrder =
    let
        total =
            case getOrderTotalAmout delivery.products currentOrder |> String.fromFloat of
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
            Maybe.withDefault 0 (model.currentOrder |> Dict.get product.id)

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
