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
    struct State: Equatable, Hashable {
        static let initialState = State()

        var login = ""
        var password = ""
    }

    enum Action {
        case loginChanged(String)
        case passwordChanged(String)

        case signIn(email: String, password: String)
        case signInSuccess
        case signInFailed

        case onRegister
        case onResetPassword
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
            case let .signIn(email, password):
                return .run { send in
                    do {
                        try await locationsClient.signIn(email, password)
                        await send(.signInSuccess)
                    } catch {
                        await send(.signInFailed)
                    }
                }
            default:
                return .none
            }
        }
    }
}
