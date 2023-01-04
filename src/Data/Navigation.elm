module Data.Navigation exposing (Navigation)

import Browser.Navigation as Nav exposing (Key)
import Url


type alias Navigation =
    { key : Key, url : Url.Url }
