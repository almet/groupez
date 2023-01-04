module Data.Navigation exposing (Navigation)

import Browser.Navigation exposing (Key)
import Url exposing (Url)


type alias Navigation =
    { key : Key, url : Url }
