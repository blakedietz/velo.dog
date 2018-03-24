module Views exposing (..)

import Html exposing (Html, text, div, h1, img)
import Html.Attributes exposing (src, class)
import Time exposing (Time, second)
import State exposing (..)


view : Model -> Html msg
view model =
    div []
        [ div [] [ counterView (model.veloArrivalTime) (convertTime model.time) ]
        ]


counterView : Time -> Time -> Html msg
counterView veloArrivalTime currentTime =
    let
        day =
            8.64e7

        hour =
            3.6e6

        minute =
            6.0e4

        second =
            1.0e3

        timeUntilArrival =
            veloArrivalTime - currentTime

        daysLeft =
            floor (timeUntilArrival / day)

        timeMinusDays =
            timeUntilArrival - (toFloat daysLeft * day)

        hoursLeft =
            floor (timeMinusDays / hour)

        timeMinusDaysAndHours =
            timeMinusDays - (toFloat hoursLeft * hour)

        minutesLeft =
            floor (timeMinusDaysAndHours / minute)

        timeMinusDaysAndHoursAndMinutes =
            timeMinusDaysAndHours - (toFloat minutesLeft * minute)

        secondsLeft =
            floor (timeMinusDaysAndHoursAndMinutes / second)

        dayText =
            toString daysLeft ++ " days "

        hourText =
            toString hoursLeft ++ " hours "

        minuteText =
            toString minutesLeft ++ " minutes "

        secondText =
            toString secondsLeft ++ " seconds "
    in
        div [ class "timer" ] [ text (dayText ++ hourText ++ minuteText ++ secondText) ]


convertTime : Maybe Time -> Time
convertTime time =
    case time of
        Nothing ->
            0

        Just time ->
            time
