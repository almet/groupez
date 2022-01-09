# Groupez

« Groupez » cherche à faciliter les commandes groupées, en proposant une
interface simple et concise.

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
elm-app start
```

Puis pointez votre navigateur web sur http://localhost:3000

## Philosophie de projet

L'idée est de faire un outil qui se concentre sur l'essentiel, au détriment des
cas spécifiques. Le logiciel à peu de fonctionnalités, par *design*.

- Nous essayons de ne pas « réinventer la poudre ». La liste des produits est
  par exemple gérée via un tableur, qui fait déjà bien ce travail ;
- Avoir une interface claire, avec peu de choix, qui va à l'essentiel ;
- Avoir un code simple et concis pour faciliter la maintenance. Le choix du
langage Elm est fait dans l'optique de réduire le coût de maintenance. 
