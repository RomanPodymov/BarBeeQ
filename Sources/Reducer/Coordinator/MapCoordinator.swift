//
//  MapCoordinator.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
@preconcurrency import TCACoordinators

@Reducer(state: .equatable, .hashable, .sendable)
enum MapScreen {
    case map(MapReducer)
    case newLocation(AddLocationReducer)
    case mapSelection(MapSelectionReducer)
}

enum MapScreenId {
    case map
    case newLocation
    case mapSelection
}

extension MapScreen.State: Identifiable {
    var id: MapScreenId {
        switch self {
        case .map:
            .map
        case .newLocation:
            .newLocation
        case .mapSelection:
            .mapSelection
        }
    }
}

@Reducer
struct MapCoordinator {
    @ObservableState
    struct State: Equatable, Sendable {
        static let initialState = State(
            routes: [.root(.map(.initialState), embedInNavigationView: true)]
        )

        var routes: IdentifiedArrayOf<Route<MapScreen.State>>

        var addLocationState = AddLocationReducer.State.initialState
        var mapSelection = MapSelectionReducer.State.initialState
    }

    enum Action {
        case router(IdentifiedRouterActionOf<MapScreen>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(_, action: .map(.newLocationPressed))):
                state.addLocationState = .initialState
                state.routes.push(.newLocation(state.addLocationState))
                return .none
            case .router(.routeAction(_, action: .newLocation(.selectLocation))):
                state.routes.push(.mapSelection(state.mapSelection))
                return .none
            case .router(.routeAction(_, action: .newLocation(.locationAdded))):
                state.routes.goBackTo(id: .map)
                return .none
            case let .router(.routeAction(_, action: .newLocation(.nameChanged(name)))):
                state.addLocationState.name = name
                return .none
            case let .router(.routeAction(_, action: .newLocation(.photoLoaded(photo)))):
                state.addLocationState.photo = photo
                return .none
            case let .router(.routeAction(_, action: .mapSelection(.locationSelected(location)))):
                state.addLocationState.location = location
                state.routes = State.initialState.routes + [
                    .push(.newLocation(state.addLocationState)),
                ]
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
