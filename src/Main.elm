module Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src, class)
import Keyboard
import Navigation
import Time exposing (Time, second)
import Views exposing (..)
import Subscriptions exposing (..)
import State exposing (..)


---- Subscriptions ----


init : ( Model, Cmd Msg )
init =
    ( { boardSize = 40
      , veloLocation = 0
      , ballLocation = 10
      , pressedKey = 0
      , history = []
      , time = Nothing
      , veloArrivalTime = 1522207800000
      }
    , now
    )


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
