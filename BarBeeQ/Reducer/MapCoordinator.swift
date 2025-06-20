//
//  MapCoordinator.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
@preconcurrency import TCACoordinators

@Reducer(state: .equatable, .hashable)
enum MapScreen {
    case step1
}

extension MapScreen.State: Identifiable {
    var id: String {
        ""
    }
}

@Reducer
struct MapCoordinator {
    @ObservableState
    struct State: Equatable, Sendable {
        static let initialState = State(
            routes: [.root(.step1)]
        )
        var routes: IdentifiedArrayOf<Route<MapScreen.State>>
    }

    enum Action {
        case router(IdentifiedRouterActionOf<MapScreen>)
    }

    var body: some ReducerOf<Self> {
        Reduce { _, _ in
            .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
