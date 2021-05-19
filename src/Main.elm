module Main exposing (..)

import Browser
import Dict exposing (Dict)
import Html exposing (Html, div, h1, input, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onInput)
import Time



---- MODEL ----


type alias Model =
    { commandName : String
    , commandStartDate : Time.Posix
    , products : List Product
    , currentOrder : Dict String Int
    }


type alias Product =
    { id : String
    , name : String
    , price : Float
    }


init : ( Model, Cmd Msg )
init =
    ( { commandName = "Commande chez Hervé"
      , commandStartDate = Time.millisToPosix 0
      , products =
            [ Product "vin-orange" "Vin Orange" 12.3
            , Product "vin-rouge" "Vin rouge" 13
            ]
      , currentOrder = Dict.empty
      }
    , Cmd.none
    )



---- UPDATE ----


type Msg
    = UpdateOrderQuantity String String
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateOrderQuantity productId quantity ->
            ( { model | currentOrder = Dict.update productId (\_ -> String.toInt quantity) model.currentOrder }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ h1 [] [ text model.commandName ]
        , viewOrderProducts model model.products
        ]


viewOrderProducts : Model -> List Product -> Html Msg
viewOrderProducts model products =
    table []
        [ thead
            []
            [ tr []
                [ th [ class "product" ]
                    [ text "Produit" ]
                , th [ class "price" ]
                    [ text "Prix" ]
                , th [ class "amount" ]
                    [ text "Commande" ]
                ]
            ]
        , tbody [] (products |> List.map (viewTableLine model))
        ]


viewTableLine : Model -> Product -> Html Msg
viewTableLine model product =
    let
        quantity =
            Maybe.withDefault 0 (model.currentOrder |> Dict.get product.id)
    in
    tr []
        [ td [] [ text product.name ]
        , td [] [ product.price |> String.fromFloat |> text ]
        , td []
            [ input
                [ placeholder "Entrez la quantité que vous souhaitez commander"
                , class "order-input"
                , onInput (UpdateOrderQuantity product.id)
                , value (String.fromInt quantity)
                ]
                []
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
