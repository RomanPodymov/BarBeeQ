//
//  LocationsListCoordinator.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 09/09/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
@preconcurrency import TCACoordinators

@Reducer(state: .equatable, .hashable, .sendable)
enum LocationsListScreen {
    case map(MapReducer)
    case newLocation(FullAddLocationReducer)
    case locationDetail(LocationDetailReducer)
}

enum LocationsListScreenId {
    case map
    case newLocation
    case locationDetail
}

extension LocationsListScreen.State: Identifiable {
    var id: LocationsListScreenId {
        switch self {
        case .map:
            .map
        case .newLocation:
            .newLocation
        case .locationDetail:
            .locationDetail
        }
    }
}

@Reducer
struct LocationsListCoordinator {
    @ObservableState
    struct State: Equatable, Hashable {
        static let initialState = State(
            routes: [.root(.map(.initialState), embedInNavigationView: true)]
        )

        var routes: IdentifiedArrayOf<Route<LocationsListScreen.State>>

        var addLocationState = FullAddLocationReducer.State.initialState
        var locationDetailState = LocationDetailReducer.State.initialState
    }

    enum Action {
        case router(IdentifiedRouterActionOf<LocationsListScreen>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(_, action: .map(.newLocationPressed))):
                state.addLocationState = .initialState
                state.routes.push(.newLocation(state.addLocationState))
                return .none
            case let .router(.routeAction(_, action: .map(.locationDetailPressed(location)))):
                state.locationDetailState.location = location
                state.routes.push(.locationDetail(state.locationDetailState))
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
