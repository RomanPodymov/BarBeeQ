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
    case newLocation(FullAddLocationReducer)
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
    struct State: Equatable, Hashable {
        static let initialState = State(
            routes: [.root(.map(.initialState), embedInNavigationView: true)]
        )

        var routes: IdentifiedArrayOf<Route<MapScreen.State>>

        var addLocationState = FullAddLocationReducer.State.initialState
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
            case .router(.routeAction(_, action: .newLocation(.custom(.selectLocation)))):
                state.routes.push(.mapSelection(state.mapSelection))
                return .none
            case .router(.routeAction(_, action: .newLocation(.custom(.locationAdded)))):
                state.routes.goBackTo(id: .map)
                return .none
            case let .router(.routeAction(_, action: .newLocation(.custom(.nameChanged(name))))):
                state.addLocationState.custom.name = name
                return .none
            case let .router(.routeAction(_, action: .newLocation(.custom(.photoLoaded(photo))))):
                state.addLocationState.custom.photo = photo
                return .none
            case let .router(.routeAction(_, action: .mapSelection(.locationSelected(location)))):
                state.addLocationState.custom.location = location
                state.routes = State.initialState.routes + [
                    .push(.newLocation(state.addLocationState))
                ]
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
