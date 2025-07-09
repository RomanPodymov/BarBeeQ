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
    case signIn(SignInReducer)
    case register(RegisterReducer)
}

enum UserScreenId {
    case signIn
    case register
}

extension UserScreen.State: Identifiable {
    var id: UserScreenId {
        switch self {
        case .signIn:
            .signIn
        case .register:
            .register
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
    }

    enum Action {
        case router(IdentifiedRouterActionOf<UserScreen>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(_, action: .signIn(.onRegister))):
                state.routes.push(.register(.initialState))
                return .none
            case .router(.routeAction(_, action: .register(.onRegisterSuccess))):
                state.routes = [
                    .root(.signIn(.initialState), embedInNavigationView: true),
                ]
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
