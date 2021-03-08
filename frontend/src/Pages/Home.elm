module Pages.Home exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import Html.Events exposing (..)
import SharedState exposing (SharedState)

type alias Model =
    { counter : Int }

type Msg
    = Increment
    | Decrement

init : Model
init =
    { counter = 0 }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | counter = model.counter + 1 }, Cmd.none )

        Decrement ->
            ( { model | counter = model.counter - 1 }, Cmd.none )

view : SharedState -> Model -> Html Msg
view sharedState model =
    div []
        [ button [ onClick Increment ] [ text "+" ]
        , p [] [ text (String.fromInt model.counter) ]
        , button [ onClick Decrement ] [ text "-" ]
        ]
