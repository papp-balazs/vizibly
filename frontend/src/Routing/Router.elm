module Routing.Router exposing (Model, Msg(..), init, pageView, update, view)

import Browser
import Browser.Navigation exposing (Key)
import Pages.Home
import Pages.Settings
import Routing.Helpers exposing (Route(..), reverseRoute, parseUrl)
import SharedState exposing (SharedState, SharedStateUpdate(..))
import Task
import Url exposing (Url)
import Html exposing (..)
import Html.Attributes exposing (class, href)

type alias Model =
    { homeModel : Pages.Home.Model
    , settingsModel : Pages.Settings.Model
    , route : Route
    }

type Msg
    = UrlChange Url
    | HomeMsg Pages.Home.Msg
    | SettingsMsg Pages.Settings.Msg

init : Url -> ( Model, Cmd Msg )
init url =
    let
        homeModel =
            Pages.Home.init

        settingsModel =
            Pages.Settings.init

        command =
            getRouteInitCommand (parseUrl url)
    in
        ( { homeModel = homeModel
          , settingsModel = settingsModel
          , route = parseUrl url
          }
        , command
        )

getRouteInitCommand : Route -> Cmd Msg
getRouteInitCommand route =
    case route of
        SettingsRoute ->
            convertMsg (SettingsMsg Pages.Settings.InitData)

        _ ->
            Cmd.none

convertMsg : Msg -> Cmd Msg
convertMsg msg =
    Task.succeed msg
    |> Task.perform identity

update : SharedState -> Msg -> Model -> ( Model, Cmd Msg, SharedStateUpdate )
update sharedState msg model =
    case msg of
        UrlChange location ->
            let
                command =
                    getRouteInitCommand (parseUrl location)
            in
                ( { model | route = parseUrl location }
                , command
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
                    "Vizibly"

                SettingsRoute ->
                    "Settings"

                NotFoundRoute ->
                    "404"
        
        body_ =
            main_ [ class sharedState.theme ]
                [ a [ href "/" ] [ text "Home" ]
                , a [ href "/settings" ] [ text "Settings" ]
                , pageView sharedState model
                ]
    in
        { title = title
        , body = body_ |> Html.map msgMapper |> \x -> [ x ]
        }

pageView : SharedState -> Model -> Html Msg
pageView sharedState model =
    case model.route of
        HomeRoute ->
            Pages.Home.view sharedState model.homeModel
                |> Html.map HomeMsg

        SettingsRoute ->
            Pages.Settings.view sharedState model.settingsModel
                |> Html.map SettingsMsg

        NotFoundRoute ->
            p [] [ text "There is no route like this" ]
