module State exposing (..)

import Time exposing (Time, second)
import Keyboard
import Navigation
import Task
import Random


---- Model ----


type alias Model =
    { boardSize : Int
    , veloLocation : Int
    , ballLocation : Int
    , pressedKey : Int
    , history : List Navigation.Location
    , veloArrivalTime : Time
    , time : Maybe Time
    }


type Msg
    = NoOp
    | KeyMsg Keyboard.KeyCode
    | Tick Time
    | NewGame Int
    | EndGame
    | SetTime (Maybe Time)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Tick time ->
            ( { model | time = Maybe.Just time }, Cmd.none )

        SetTime time ->
            ( { model | time = time }, Cmd.none )

        NewGame newballLocation ->
            ( { model | ballLocation = newballLocation }, Cmd.none )

        EndGame ->
            ( model, Cmd.none )

        KeyMsg code ->
            let
                newModel =
                    createModel code model

                distanceFromBall =
                    abs (model.veloLocation - model.ballLocation)

                command =
                    if distanceFromBall < 2 then
                        createNewGame model.boardSize
                    else
                        Navigation.modifyUrl (generateUrl newModel)
            in
                ( { newModel | pressedKey = code }, command )


createModel : Int -> Model -> Model
createModel keycode model =
    case keycode of
        37 ->
            { model | veloLocation = (model.veloLocation - 1) % model.boardSize }

        39 ->
            { model | veloLocation = (model.veloLocation + 1) % model.boardSize }

        _ ->
            model


generateUrl : Model -> String
generateUrl model =
    let
        distanceFromBall =
            abs (model.ballLocation - model.veloLocation)

        updateBoard idx char =
            if (idx == model.ballLocation) && (distanceFromBall < 2) then
                '🎉'
            else if (idx == model.veloLocation) && (distanceFromBall < 2) then
                '.'
            else if model.ballLocation == idx then
                '🎾'
            else if model.veloLocation == idx then
                '🐶'
            else
                '.'

        newString =
            "."
                |> String.repeat model.boardSize
                |> String.toList
                |> List.indexedMap updateBoard
                |> String.fromList
    in
        newString



---- Commands ----


now : Cmd Msg
now =
    Task.perform (Just >> SetTime) Time.now


createNewGame : Int -> Cmd Msg
createNewGame boardSize =
    Random.generate NewGame (Random.int 0 boardSize)
