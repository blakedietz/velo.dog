module Subscriptions exposing (..)

import Keyboard
import Time exposing (Time, second)
import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src, class)
import Keyboard
import State exposing (..)


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyMsg
        , Time.every second Tick
        ]
