module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Data.Delivery as Delivery
import Data.Model as Model exposing (Model, NewDeliveryStatus(..))
import Data.Msg exposing (Msg(..), OrderFormMsg(..))
import Data.Navigation exposing (Navigation)
import Html exposing (..)
import Html.Attributes exposing (..)
import List.Extra exposing (updateIf)
import Random
import Random.Char
import Random.String exposing (string)
import Request.Client as Client
import Request.Delivery as Delivery
import Task
import Update.DeliveryForm as DeliveryForm
import Update.OrderForm as OrderForm
import Update.ProductForm as ProductForm
import Url
import Views.CreateDelivery exposing (view)
import Views.Homepage exposing (view)
import Views.PlaceOrder exposing (view)



---- MODEL ----


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( Navigation key url |> Model.empty
    , Cmd.batch
        [ Delivery.fetch
        , Task.perform (always <| GenerateRandomProductID) (Task.succeed ())
        ]
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ navigation } as model) =
    case msg of
        UpdateOrderForm orderFormMsg ->
            let
                ( currentOrder, orderFormCmd ) =
                    OrderForm.update orderFormMsg model.currentOrder
            in
            ( { model | currentOrder = currentOrder }, Cmd.map UpdateOrderForm orderFormCmd )

        UpdateDeliveryForm deliveryFormMsg ->
            let
                ( newDelivery, deliveryFormCmd ) =
                    DeliveryForm.update deliveryFormMsg model.newDelivery
            in
            ( { model | newDelivery = newDelivery }, Cmd.map UpdateDeliveryForm deliveryFormCmd )

        UpdateProductForm productFormMsg ->
            let
                ( newProduct, productFormCmd ) =
                    ProductForm.update productFormMsg model.currentProduct
            in
            ( { model | currentProduct = newProduct }, Cmd.map UpdateProductForm productFormCmd )

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

        DeliveryInfosSubmitted ->
            ( { model | newDeliveryStatus = DeliveryInfosEntered }, Cmd.none )

        UpdateDeliveryProduct ->
            -- Get the ID from model.currentProduct.id
            -- update the model.currentDelivery.products that matches
            -- Or push the produt at the end.
            let
                delivery =
                    model.newDelivery

                product =
                    model.currentProduct

                products =
                    if delivery.products |> List.any (\p -> p.id == model.currentProduct.id) then
                        delivery.products
                            |> List.Extra.updateIf
                                (\p -> p.id == product.id)
                                (\_ -> model.currentProduct)

                    else
                        [ product ] |> List.append delivery.products

                newDelivery =
                    { delivery | products = products }
            in
            ( { model | newDelivery = newDelivery }, Cmd.none )

        GenerateRandomProductID ->
            ( model, Random.generate ProductIDGenerated (string 10 Random.Char.english) )

        ProductIDGenerated randomID ->
            let
                product =
                    model.currentProduct

                newProduct =
                    { product | id = randomID }
            in
            ( { model | currentProduct = newProduct }, Cmd.none )



---- VIEW ----


view : Model -> Browser.Document Msg
view ({ navigation } as model) =
    case navigation.url.path of
        "/place-order" ->
            { title = "Commander", body = [ Views.PlaceOrder.view model ] }

        "/" ->
            { title = "Groupez", body = [ Views.Homepage.view model ] }

        "/create" ->
            { title = "Créer une nouvelle distribution", body = [ Views.CreateDelivery.view model ] }

        _ ->
            { title = "Groupez !"
            , body =
                [ ul []
                    [ viewLink "/place-order"
                    , viewLink "/ "
                    , viewLink "/create"
                    ]
                ]
            }


viewLink : String -> Html msg
viewLink path =
    li [] [ a [ href path ] [ text path ] ]



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
