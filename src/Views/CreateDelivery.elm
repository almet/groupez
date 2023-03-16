module Views.CreateDelivery exposing (view)

import Data.Model exposing (Model, NewDeliveryStatus(..))
import Data.Msg exposing (DeliveryFormMsg(..), Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onCheck, onClick, onInput, onSubmit)



-- "delivery_name": "Brasserie du Vieux Singe",
--         "handler_name": "Alexis",
--         "handler_email": "alexis@example.org",
--         "handler_phone": "0612345678",
--         "order_before": datetime(year=2023, month=5, day=1),
--         "expected_date": datetime(year=2023, month=6, day=16),
--         "products": [


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ case model.newDeliveryStatus of
            DeliveryIsEmpty ->
                viewDeliveryInfo model

            DeliveryInfosEntered ->
                viewDeliveryProducts model
        ]


viewDeliveryInfo : Model -> Html Msg
viewDeliveryInfo model =
    div []
        [ h2 [] [ text "🤗 Okay, créons cette commande !" ]
        , Html.form
            []
            [ label [ for "delivery-name" ]
                [ text "Nom de la commande"
                , input
                    [ id "delivery-name"
                    , type_ "text"
                    , placeholder "★ Le nom de la commande groupée (ou le nom des producteurs)"
                    , onInput <| UpdateDeliveryForm << UpdateDeliveryName
                    , value model.newDelivery.delivery_name
                    ]
                    []
                ]
            , div
                [ class "grid" ]
                [ label [ for "handler-name" ]
                    [ text "Prénom (ou pseudo)"
                    , input
                        [ id "handler-name"
                        , type_ "text"
                        , placeholder "Par ex: Millie"
                        , onInput <| UpdateDeliveryForm << UpdateDeliveryHandlerName
                        , value model.newDelivery.handler_name
                        ]
                        []
                    ]
                , label [ for "handler-email" ]
                    [ text "Email"
                    , input
                        [ id "handler-email"
                        , type_ "email"
                        , placeholder "Par ex: mille.rob@domain.com"
                        , onInput <| UpdateDeliveryForm << UpdateDeliveryHandlerEmail
                        , value model.newDelivery.handler_email
                        ]
                        []
                    ]
                ]
            , div
                [ class "grid" ]
                [ label [ for "order-before" ]
                    [ text "Commandes ouvertes jusqu'au"
                    , input [ id "order-before", type_ "date" ] []
                    ]
                , label [ for "expected-date" ]
                    [ text "Distribution prévue le"
                    , input [ id "expected-date", type_ "date" ] []
                    ]
                ]
            , label [ for "handler-accepts-phone" ]
                [ input
                    [ id "handler-accepts-phone"
                    , type_ "checkbox"
                    , attribute "role" "switch"
                    , checked model.newDelivery.handler_accepts_calls
                    , onCheck <| UpdateDeliveryForm << UpdateHandlerAcceptsCalls
                    ]
                    []
                , text "Je souhaite que les gens me contactent via téléphone si besoin"
                ]
            , label [ for "handler-phone" ]
                [ text "Téléphone"
                , input
                    [ id "handler-phone"
                    , type_ "tel"
                    , onInput <| UpdateDeliveryForm << UpdateDeliveryHandlerPhone
                    , value model.newDelivery.handler_phone
                    , disabled (not model.newDelivery.handler_accepts_calls)
                    ]
                    []
                ]
            , a
                [ href ""
                , attribute "role" "button"
                , onClick <| DeliveryInfosSubmitted
                ]
                [ text "Enregistrer, et passer aux produits" ]
            ]
        ]


viewDeliveryProducts : Model -> Html Msg
viewDeliveryProducts model =
    div
        []
        [ h2 [] [ text "Quels sont les produits ?" ]
        , Html.form []
            [ input
                [ id "product-id"
                , type_ "hidden"
                ]
                []
            , label [ for "product-name" ]
                [ text "Nom du produit"
                , input
                    [ id "product-name"
                    , type_ "text"
                    , placeholder "Par ex. « Lentilles vertes »"
                    ]
                    []
                ]
            , label [ for "product-unit" ]
                [ text "Unité"
                , input
                    [ id "product-unit"
                    , type_ "text"
                    , placeholder "Par ex. « Sac de 5kg »"
                    ]
                    []
                ]
            , label [ for "product-description" ]
                [ text "Description"
                , input
                    [ id "product-description"
                    , type_ "text"
                    , placeholder "Toute information complémentaire qui pourrait être utile."
                    ]
                    []
                ]
            , label [ for "product-price" ]
                [ text "Prix (TTC, pour une unité)"
                , input
                    [ id "product-price"
                    , type_ "number"
                    , placeholder ""
                    ]
                    []
                ]
            ]
        , a
            [ href ""
            , attribute "role" "button"
            , onClick <| DeliveryInfosSubmitted
            ]
            [ text "Ajouter ce produit" ]
        ]
