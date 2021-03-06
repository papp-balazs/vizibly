module SharedState exposing (SharedState, SharedStateUpdate(..), initialSharedState, update)

import Browser.Navigation

type alias SharedState =
    { navKey : Browser.Navigation.Key }

type SharedStateUpdate
    = NoUpdate

initialSharedState : Browser.Navigation.Key -> SharedState
initialSharedState navKey =
    { navKey = navKey }

update : SharedState -> SharedStateUpdate -> SharedState
update sharedState sharedStateUpdate =
    case sharedStateUpdate of
        NoUpdate ->
            sharedState
