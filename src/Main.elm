module Main exposing (..)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, button, div, h1, h2, input, p, table, tbody, td, text, tfoot, th, thead, tr)
import Html.Attributes exposing (class, colspan, placeholder, value)
import Html.Events exposing (onInput)
import String.Extra
import Time
import Time.Format
import Time.Format.Config.Config_fr_fr exposing (config)



---- MODEL ----


type alias Model =
    { commandName : String
    , orderBefore : Time.Posix
    , expectedDeliveryDate : Time.Posix
    , products : List Product
    , currentOrder : Order
    , orderPhoneNumber : String
    , orderEmail : String
    , orderName : String
    }


type alias Order =
    Dict String Int


type alias Product =
    { id : String
    , name : String
    , description : String
    , price : Float
    }


init : ( Model, Cmd Msg )
init =
    ( { commandName = "Commande chez Hervé"
      , orderBefore = Time.millisToPosix 1652983709000
      , expectedDeliveryDate = Time.millisToPosix 0
      , products =
            [ Product "vent-se-leve-blanc" "Vent se lève Blanc" "100% Macabeu,  Nez fruité, fruits blancs. Arômes : Fraicheur, Anis, Finale fumée" 12.3
            , Product "vin-rouge" "Vin rouge" "" 13
            ]
      , currentOrder = Dict.empty
      , orderName = ""
      , orderPhoneNumber = ""
      , orderEmail = ""
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = UpdateOrderQuantity String String
    | UpdateOrderName String
    | UpdateOrderPhoneNumber String
    | UpdateOrderEmail String
    | NoOp


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

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text model.commandName ]
        , div [ class "date" ]
            [ "📅 Commandez avant le " ++ Time.Format.format config "%-d %B %Y" Time.utc model.orderBefore |> text
            ]
        , viewOrderTable model model.products
        , viewContactForm model
        ]


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
                button [ class "button float-right" ] [ text "Enregistrer" ]

            False ->
                p [] []
        ]


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


getOrderTotalAmout : Model -> Order -> Float
getOrderTotalAmout model order =
    let
        accu id quantity total =
            let
                price =
                    case model.products |> List.filter (\p -> p.id == id) |> List.head of
                        Just product ->
                            .price product

                        Nothing ->
                            toFloat 0
            in
            total + price * (quantity |> toFloat)
    in
    Dict.foldl accu 0 order


viewOrderTable : Model -> List Product -> Html Msg
viewOrderTable model products =
    let
        total =
            case getOrderTotalAmout model model.currentOrder |> String.fromFloat of
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
        , tbody [] (products |> List.map (viewTableLine model))
        , tfoot []
            [ tr []
                [ th [ class "total", colspan 3 ] [ text "Total de votre commande" ]
                , th [ class "total" ] [ total |> text ]
                ]
            ]
        ]


viewTableLine : Model -> Product -> Html Msg
viewTableLine model product =
    let
        quantity =
            Maybe.withDefault 0 (model.currentOrder |> Dict.get product.id)

        price =
            case model.products |> List.filter (\r -> r.id == product.id) |> List.head of
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
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
