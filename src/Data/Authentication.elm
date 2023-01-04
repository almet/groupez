module Data.Authentication exposing (Authentication(..))


type Authentication
    = Basic String String
    | Unauthenticated
