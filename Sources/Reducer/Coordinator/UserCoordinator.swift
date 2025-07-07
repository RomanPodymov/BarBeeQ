//
//  UserCoordinator.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 07/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
@preconcurrency import TCACoordinators

@Reducer(state: .equatable, .hashable, .sendable)
enum UserScreen {
    case signIn(ProfileReducer)
}

enum UserScreenId {
    case signIn
}

extension UserScreen.State: Identifiable {
    var id: UserScreenId {
        switch self {
        case .signIn:
            .signIn
        }
    }
}

@Reducer
struct UserCoordinator {
    @ObservableState
    struct State: Equatable, Sendable {
        static let initialState = State(
            routes: [.root(.signIn(.initialState), embedInNavigationView: true)]
        )

        var routes: IdentifiedArrayOf<Route<UserScreen.State>>

        // var addLocationState = AddLocationReducer.State.initialState
        // var mapSelection = MapSelectionReducer.State.initialState
    }

    enum Action {
        case router(IdentifiedRouterActionOf<UserScreen>)
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            default:
                .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
