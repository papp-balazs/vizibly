module SharedState exposing (SharedState, SharedStateUpdate(..), initialSharedState, update)

import Browser.Navigation

type alias SharedState =
    { navKey : Browser.Navigation.Key
    , theme : String
    , userToken : Maybe String
    }

type SharedStateUpdate
    = NoUpdate
    | UpdateTheme String
    | UpdateUserToken String

initialSharedState : Browser.Navigation.Key -> String -> Maybe String -> SharedState
initialSharedState navKey theme userToken =
    { navKey = navKey
    , theme = theme
    , userToken = userToken
    }

update : SharedState -> SharedStateUpdate -> SharedState
update sharedState sharedStateUpdate =
    case sharedStateUpdate of
        UpdateTheme theme ->
            { sharedState | theme = theme }

        UpdateUserToken userToken ->
            { sharedState | userToken = Just userToken }

        NoUpdate ->
            sharedState
