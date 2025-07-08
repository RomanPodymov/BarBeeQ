//
//  SignInReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 03/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct SignInReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()

        var login = ""
        var password = ""
        var showingAlert = false
    }

    enum Action {
        case loginChanged(String)
        case passwordChanged(String)
        case onSignIn(email: String, password: String)
        case onSignInSuccess
        case onRegister
        case error(Bool)
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .loginChanged(value):
                state.login = value
                return .none
            case let .passwordChanged(value):
                state.password = value
                return .none
            case let .onSignIn(email, password):
                return .run { send in
                    do {
                        try await locationsClient.signIn(email, password)
                        await send(.onSignInSuccess)
                    } catch {
                        await send(.error(true))
                    }
                }
            case let .error(value):
                state.showingAlert = value
                return .none
            default:
                return .none
            }
        }
    }
}
