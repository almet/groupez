module Request.Client exposing (..)

import Http


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
