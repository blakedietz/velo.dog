module Main exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src, class)
import Keyboard
import Navigation
import Time exposing (Time, second)
import Random
import Task


---- MODEL ----


type alias Model =
    { boardSize : Int
    , veloLocation : Int
    , ballLocation : Int
    , pressedKey : Int
    , history : List Navigation.Location
    , veloArrivalTime: Time
    , time: Maybe Time
    }


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



---- UPDATE ----


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
            ( { model | ballLocation = newballLocation}, Cmd.none )
        EndGame ->
            ( model, Cmd.none )
        KeyMsg code ->
            let
                newModel = createModel code model
                distanceFromBall = abs (model.veloLocation - model.ballLocation)
                command  =
                if distanceFromBall < 2 then
                    createNewGame model.boardSize
                else
                    Navigation.modifyUrl (generateUrl newModel)

            in
                ( { newModel | pressedKey = code }, command )

---- Commands ----

createNewGame: Int -> Cmd Msg
createNewGame boardSize =
        Random.generate NewGame (Random.int 0 boardSize)


---- Subscriptions ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyMsg
        , Time.every second Tick
        ]



---- VIEW ----

createModel : Int -> Model -> Model
createModel keycode model =
    case keycode of
        37 ->
            { model | veloLocation = (model.veloLocation - 1) % model.boardSize }
        39 ->
            { model | veloLocation = (model.veloLocation + 1) % model.boardSize }
        _ ->  model


generateUrl : Model -> String
generateUrl model =
    let
        distanceFromBall = abs (model.ballLocation - model.veloLocation)
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


view : Model -> Html Msg
view model =
    div []
        [
        div [] [ counterView (model.veloArrivalTime) (convertTime model.time)]
        ]

counterView : Time -> Time -> Html Msg
counterView veloArrivalTime currentTime =
    let
        day = 8.64e7
        hour = 3.6e6
        minute = 6e4
        second = 1e3

        timeUntilArrival = veloArrivalTime - currentTime
        daysLeft = floor (timeUntilArrival / day)
        timeMinusDays = timeUntilArrival - (toFloat daysLeft * day)
        hoursLeft = floor (timeMinusDays / hour)
        timeMinusDaysAndHours = timeMinusDays - (toFloat hoursLeft * hour)
        minutesLeft = floor (timeMinusDaysAndHours / minute)
        timeMinusDaysAndHoursAndMinutes = timeMinusDaysAndHours - (toFloat minutesLeft * minute)
        secondsLeft = floor (timeMinusDaysAndHoursAndMinutes / second)

        dayText = toString daysLeft ++ " days "
        hourText = toString hoursLeft ++ " hours "
        minuteText = toString minutesLeft ++ " minutes "
        secondText = toString secondsLeft ++ " seconds "
    in
    div [class "timer"] [ text ( dayText ++ hourText ++ minuteText ++ secondText) ]

convertTime : Maybe Time -> Time
convertTime time =
    case time of
        Nothing ->
            0
        Just time ->
            time


---- CMD ----
now : Cmd Msg
now =
  Task.perform (Just >> SetTime) Time.now


---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = subscriptions
        }
