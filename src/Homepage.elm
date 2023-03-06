module Homepage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


homeView =
    div []
        [ div
            [ class "hero"
            ]
            [ nav
                [ class "container-fluid"
                ]
                [ ul []
                    [ li []
                        [ a
                            [ href "/"
                            , class "contrast"
                            ]
                            [ strong []
                                [ text "Groupez" ]
                            ]
                        ]
                    ]
                , ul []
                    [ li []
                        [ details
                            [ attribute "role" "list"
                            , dir "rtl"
                            ]
                            [ summary
                                [ attribute "aria-haspopup" "listbox"
                                , attribute "role" "link"
                                , class "contrast"
                                ]
                                [ text "Theme" ]
                            , ul
                                [ attribute "role" "listbox"
                                ]
                                [ li []
                                    [ a
                                        [ href "#"
                                        , attribute "data-theme-switcher" "auto"
                                        ]
                                        [ text "Auto" ]
                                    ]
                                , li []
                                    [ a
                                        [ href "#"
                                        , attribute "data-theme-switcher" "light"
                                        ]
                                        [ text "Light" ]
                                    ]
                                , li []
                                    [ a
                                        [ href "#"
                                        , attribute "data-theme-switcher" "dark"
                                        ]
                                        [ text "Dark" ]
                                    ]
                                ]
                            ]
                        ]
                    ]
                ]
            , header
                [ class "container"
                ]
                [ node "hgroup"
                    []
                    [ h1 []
                        [ text "Groupez" ]
                    , h2 []
                        [ text "Simplifiez vos commandes groupées." ]
                    ]
                , p []
                    [ a
                        [ href "#"
                        , attribute "role" "button"
                        , attribute "onclick" "event.preventDefault()"
                        ]
                        [ text "Créez votre prochaine distribution" ]
                    ]
                ]
            ]
        , section
            [ id "principles"
            ]
            [ div
                [ class "container"
                ]
                [ node "hgroup"
                    []
                    [ h2 []
                        [ text "Simplifiez vous la vie, et celle de vos producteurs" ]
                    , h3 []
                        [ text "Fait par et pour des producteurs, ce outil permet de gérer les commandes groupées de manière simple et efficace." ]
                    ]
                , div
                    [ class "grid"
                    ]
                    [ div []
                        [ "🤩" |> text
                        , h4 []
                            [ text "Adieu les tableaux excel" ]
                        , p []
                            [ text "Remplacez vos tableaux excel par un lien à envoyer à tout le monde." ]
                        ]
                    , div []
                        [ "💸" |> text
                        , h4 []
                            [ text "Gestion des palliers de prix" ]
                        , p []
                            [ text "Appliquez des rabais en fonction de la quantité commandée." ]
                        ]
                    , div []
                        [ "😇" |> text
                        , h4 []
                            [ text "Open Source" ]
                        , p []
                            [ text "" ]
                        ]
                    ]
                ]
            ]
        ]
