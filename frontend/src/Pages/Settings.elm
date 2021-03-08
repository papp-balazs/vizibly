module Pages.Settings exposing (Model, Msg(..), init, update, view)

import Html exposing (..)
import SharedState exposing (SharedState)

type alias Model =
    { currentUser : String }

type Msg
    = InitData

init :  Model
init =
    { currentUser = "" }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        InitData ->
            ( { model | currentUser = "pappbalazs" }, Cmd.none )

view : SharedState -> Model -> Html Msg
view sharedState model =
    div []
        [ div [] [ text "This is the settings page." ]
        , div [] [ text ("The current user is " ++ model.currentUser) ]
        ]
