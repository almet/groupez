# Groupez

« Groupez » cherche à faciliter les commandes groupées ponctuelles, en proposant
une interface claire et simple.

**Attention : ceci est un travail en cours**, et donc n'est pas utilisable en l'état.

## Comment travailler sur ce projet ?

L'outil est écrit avec le language [Elm](https://elm-lang.org) et l'outil
[Create Elm App](https://github.com/halfzebra/create-elm-app).

Sur Arch Linux, vous pouvez les installer avec les commandes suivantes :

```bash
yay aur/elm-bin aur/create-elm-app
```

Une fois installés, (et les sources récupérées bien sur), vous pouvez lancer
l'application avec la commande:

```bash
make
```

Cela devrait lancer un serveur en local et vous ouvrir une page web avec
l'application.

## Philosophie de projet

L'idée est de faire un outil qui se concentre sur l'essentiel, au détriment des
cas spécifiques. Le logiciel à peu de fonctionnalités, par *design*.

- Nous essayons de ne pas « réinventer la poudre ». La liste des produits est
  par exemple gérée via un tableur, qui fait déjà bien ce travail ;
- Avoir une interface claire, avec peu de choix, qui va à l'essentiel ;
- Avoir un code simple et concis pour faciliter la maintenance. Le choix du
langage Elm est fait dans l'optique de réduire la maintenance.

## Flux d'utilisation

J'imagine le flow comme ça :

### Gestionnaire de distribution

Je veux créer une distribution pour des ami⋅es, j'ai une interface assez simple d'accès qui me permet de créer les produits et règles.

1. Je me connecte sur groupez, on me propose de crééer une nouvelle distribution
2. Sur la page de création de la distribution, je précise les conditions, ainsi que les produits.
3. Je reçois par email un lien d'administration ainsi qu'un lien à fournir aux utilisateur⋅ices

- Quand un bénéficiaire fait une commande, je suis notifié
- Lorsque la date de commande approche (durée à préciser) les bénéficiaires qui n'ont pas passé de commande peuvent être relancés automatiquement

- Je peux éditer la commande d'un autre bénéficiaire
- Je peux accéder simplement aux sommes à donner au producteur.
- Je peux prévenir tout le monde que c'est bien reçu en cliquant sur un bouton.
- Je peux suivre l'état des paiements

### Bénéficiaire

Je reçois un lien, lorsque je clique dessus je peux commander.

- Ajouter un texte « infos » pour préciser par exemple que ce sont des cartons de 12 bouteilles.
- Je peux éditer ma commande
- Je suis prévenu quand la commande est prête / récupérée par le gestionnaire
