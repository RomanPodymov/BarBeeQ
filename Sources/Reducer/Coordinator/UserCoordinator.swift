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
    case signIn(FullSignInReducer)
    case signOut(FullSignOutReducer)
    case register(FullRegisterReducer)
    case resetPassword(FullResetPasswordReducer)
    case loading(InitialLoadingReducer)
}

enum UserScreenId {
    case signIn
    case signOut
    case register
    case resetPassword
    case loading
}

extension UserScreen.State: Identifiable {
    var id: UserScreenId {
        switch self {
        case .signIn:
            .signIn
        case .signOut:
            .signOut
        case .register:
            .register
        case .resetPassword:
            .resetPassword
        case .loading:
            .loading
        }
    }
}

@Reducer
struct UserCoordinator {
    @ObservableState
    struct State: Equatable, Hashable {
        static let initialState = State(
            routes: [.root(.loading(.initialState), embedInNavigationView: true)]
        )

        var routes: IdentifiedArrayOf<Route<UserScreen.State>>
    }

    enum Action {
        case router(IdentifiedRouterActionOf<UserScreen>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(_, action: .signIn(.custom(.onRegister)))):
                state.routes.push(.register(.initialState))
                return .none
            case .router(.routeAction(_, action: .signIn(.custom(.onResetPassword)))):
                state.routes.push(.resetPassword(.initialState))
                return .none
            case .router(.routeAction(_, action: .loading(.isSignedIn(false)))),
                 .router(.routeAction(_, action: .signOut(.custom(.signOutSuccess)))):
                state.routes = [
                    .root(.signIn(.initialState), embedInNavigationView: true)
                ]
                return .none
            case .router(.routeAction(_, action: .loading(.isSignedIn(true)))),
                 .router(.routeAction(_, action: .signIn(.custom(.signInSuccess)))):
                state.routes = [
                    .root(.signOut(.initialState), embedInNavigationView: true)
                ]
                return .none
            case .router(.routeAction(_, action: .register(.custom(.registerSuccess)))),
                 .router(.routeAction(_, action: .resetPassword(.custom(.resetPasswordSuccess)))):
                state.routes = [
                    .root(.signIn(.initialState), embedInNavigationView: true)
                ]
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
