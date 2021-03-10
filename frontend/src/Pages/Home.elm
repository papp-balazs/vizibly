module Pages.Home exposing (Model, Msg(..), init, update, view)

import Components.SVGs.ViziblyLogo exposing (viewViziblyLogo)
import Html exposing (..)
import Html.Attributes exposing (..)
import SharedState exposing (SharedState)

type alias Model =
    {}

type Msg
    = NoOp

init : Model
init =
    {}

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

view : SharedState -> Model -> Html Msg
view sharedState model =
    case sharedState.userToken of
        Just _ ->
            text "You are authorized"

        Nothing ->
            viewLandingPage

viewLandingPage : Html Msg
viewLandingPage =
    div [ class "landing-page" ]
        [ viewViziblyLogo
        , h1 [ class "landing-page__slogan" ] [ text "Fast. Simple. Start using it today!" ]
        , div [ class "landing-page__buttons" ]
            [ a
                [ href "/register"
                , class "landing-page__button--primary"
                ]
                [ text "Get Started" ]
            , a
                [ href "/login"
                , class "landing-page__button--secondary"
                ]
                [ text "I already have an account" ]
            ]
        ]
