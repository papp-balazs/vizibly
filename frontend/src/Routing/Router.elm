module Routing.Router exposing (Model, Msg(..), initialModel, init, pageView, update, view)

import Browser
import Browser.Navigation exposing (Key)
import Pages.Home
import Pages.Settings
import Routing.Helpers exposing (Route(..), reverseRoute, parseUrl)
import SharedState exposing (SharedState, SharedStateUpdate(..))
import Url exposing (Url)
import Html exposing (..)
import Html.Attributes exposing (href)
import Html.Events exposing (onClick)

type alias Model =
    { homeModel : Pages.Home.Model
    , settingsModel : Pages.Settings.Model
    , route : Route
    }

type Msg
    = UrlChange Url
    | HomeMsg Pages.Home.Msg
    | SettingsMsg Pages.Settings.Msg

initialModel : Url -> Model
initialModel url =
    let
        ( homeModel, homeCmd ) =
            Pages.Home.init

        ( settingsModel, settingsCmd ) =
            Pages.Settings.init
    in
        { homeModel = homeModel
        , settingsModel = settingsModel
        , route = parseUrl url
        }

init : Url -> ( Model, Cmd Msg )
init url =
    let
        ( homeModel, homeCmd ) =
            Pages.Home.init

        ( settingsModel, settingsCmd ) =
            Pages.Settings.init
    in
        ( { homeModel = homeModel
          , settingsModel = settingsModel
          , route = parseUrl url
          }
        , Cmd.none
        )

update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        UrlChange location ->
            ( { model | route = parseUrl location }
            , Cmd.none
            , NoUpdate
            )

        HomeMsg homeMsg ->
            updateHome model homeMsg

        SettingsMsg settingsMsg ->
            updateSettings model settingsMsg

updateHome : Model -> Pages.Home.Msg -> ( Model, Cmd Msg, SharedStateUpdate )
updateHome model homeMsg =
    let
        ( nextHomeModel, homeCmd ) =
            Pages.Home.update homeMsg model.homeModel
    in
        ( { model | homeModel = nextHomeModel }
        , Cmd.map HomeMsg homeCmd
        , NoUpdate
        )

updateSettings : Model -> Pages.Settings.Msg -> ( Model, Cmd Msg, SharedStateUpdate )
updateSettings model settingsMsg =
    let
        ( nextSettingsModel, settingsCmd ) =
            Pages.Settings.update settingsMsg model.settingsModel
    in
        ( { model | settingsModel = nextSettingsModel }
        , Cmd.map SettingsMsg settingsCmd
        , NoUpdate
        )

view : (Msg -> msg) -> SharedState -> Model -> { body : List (Html.Html msg), title: String }
view msgMapper sharedState model =
    let
        title =
            case model.route of
                HomeRoute ->
                    ""

                SettingsRoute ->
                    "Settings"

                NotFoundRoute ->
                    "404"

        body_ =
            div []
                [ a [ href "/" ] [ text "Home" ]
                , a [ href "/settings" ] [ text "Settings" ]
                , pageView sharedState model
                ]
    in
        { title = "Vizibly"
        , body = body_ |> Html.map msgMapper |> \x -> [ x ]
        }

pageView : SharedState -> Model -> Html Msg
pageView sharedState model =
    div []
        [ case model.route of
            HomeRoute ->
                Pages.Home.view sharedState model.homeModel
                    |> Html.map HomeMsg

            SettingsRoute ->
                Pages.Settings.view sharedState model.settingsModel
                    |> Html.map SettingsMsg

            NotFoundRoute ->
                p [] [ text "There is no route like this" ]
        ]
