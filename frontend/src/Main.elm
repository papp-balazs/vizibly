module Main exposing (main)

import Browser exposing (UrlRequest(..))
import Browser.Navigation
import Html exposing (..)
import Routing.Router as Router
import SharedState exposing (SharedState, SharedStateUpdate(..), initialSharedState)
import Url exposing (Url)

main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , onUrlChange = UrlChange
        , onUrlRequest = LinkClicked
        , subscriptions = \_ -> Sub.none
        }

type alias Model =
    { appState : AppState
    , navKey : Browser.Navigation.Key
    , url: Url
    }

type alias Flags =
    { theme : String
    , userToken : Maybe String
    }

type AppState
    = NotReady
    | Ready SharedState Router.Model
    | FailedToInitialize

type Msg
    = UrlChange Url
    | LinkClicked UrlRequest
    | RouterMsg Router.Msg

init : Flags -> Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        ( routerModel, routerCommand ) =
            Router.init url
    in
        ( { appState =
                Ready
                    (initialSharedState navKey flags.theme flags.userToken)
                    routerModel
          , navKey = navKey
          , url = url
          }
        , Cmd.map RouterMsg routerCommand
        )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange url ->
            updateRouter { model | url = url } (Router.UrlChange url)

        RouterMsg routerMsg ->
            updateRouter model routerMsg

        LinkClicked urlRequest ->
            case urlRequest of
                Internal url ->
                    ( model, Browser.Navigation.pushUrl model.navKey (Url.toString url) )

                External url ->
                    ( model, Browser.Navigation.load url )

updateRouter : Model -> Router.Msg -> ( Model, Cmd Msg )
updateRouter model routerMsg =
    case model.appState of
        Ready sharedState routerModel ->
            let
                nextSharedState =
                    SharedState.update sharedState sharedStateUpdate

                ( nextRouterModel, routerCmd, sharedStateUpdate ) =
                    Router.update sharedState routerMsg routerModel
            in
                ( { model | appState = Ready nextSharedState nextRouterModel }
                , Cmd.map RouterMsg routerCmd
                )

        _ ->
            ( model, Cmd.none )

view : Model -> Browser.Document Msg
view model =
    case model.appState of
        Ready sharedState routerModel ->
            Router.view RouterMsg sharedState routerModel

        NotReady ->
            { title = "Vizibly"
            , body = [ text "Loading" ]
            }

        FailedToInitialize ->
            { title = "Failure"
            , body = [ text "The application failed to initialize." ]
            }
