# Groupez

« Groupez » est la partie « frontend » d'une application de commande groupée appelée
[copanier](https://gitlab.com/ybon/copanier), et plus précisément de sa version 2.

L'idée est de simplifier les prises de commandes groupées, à la fois pour les
groupes de consommateurs⋅ices, et les producteurs⋅ices.

**Attention : ceci est un travail en cours**, et donc n'est pas utilisable en l'état.

## Comment travailler sur ce projet ?

L'outil est écrit avec le language [Elm](https://elm-lang.org).

Sur Arch Linux, vous pouvez installer les paquets `aur/elm-bin` et
`aur/create-elm-app`, par exemple avec la commande suivante :

  yay aur/elm-bin aur/create-elm-app

Une fois installés, (et les sources récupérées, bien sur), vous pouvez lancer
l'application avec la commande:

  elm-app start

Puis pointer votre navigateur web sur http://localhost:3000

## Philosophie de projet

L'idée de copanier est de faire un outil simple, qui ne couvre pas tous les
besoins spécifiques, mais se concentre sur l'essentiel. Nous faisons peu de
choses, mais le faisons correctement.

Donc :

- Autant que possible, ne pas réinventer la poudre. La liste des produits est
  par exemple gérée via un tableur.
- Avoir une interface claire, avec peu de choix, qui va à l'essentiel.
- Avoir un code simple et concis, autant que possible.
