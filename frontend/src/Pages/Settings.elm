module Pages.Settings exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import SharedState exposing (SharedState)

type alias Model =
    { currentUser : String }

type Msg
    = NoOp

init : ( Model, Cmd Msg )
init =
    ( { currentUser = "" }
    , Cmd.none
    )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

view : SharedState -> Model -> Html Msg
view sharedState model =
    div [] [ text "This is the settings page." ]
