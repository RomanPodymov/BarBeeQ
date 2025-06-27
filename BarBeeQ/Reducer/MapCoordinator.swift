//
//  MapCoordinator.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
@preconcurrency import TCACoordinators

@Reducer(state: .equatable, .hashable)
enum MapScreen {
    case map(MapReducer)
    case newLocation
}

extension MapScreen.State: Identifiable {
    var id: String {
        switch self {
        case .map:
            "map"
        case .newLocation:
            "new"
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
    }

    enum Action {
        case router(IdentifiedRouterActionOf<MapScreen>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(_, action: .map(.newLocationPressed))):
                state.routes.presentSheet(.newLocation)
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
