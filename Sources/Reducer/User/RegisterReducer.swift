//
//  RegisterReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 08/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct RegisterReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()

        var login = ""
        var password = ""
    }

    enum Action {
        case loginChanged(String)
        case passwordChanged(String)

        case register(email: String, password: String)
        case registerSuccess
        case registerFailed
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
            case let .register(email: email, password: password):
                return .run { send in
                    do {
                        try await locationsClient.registerUser(email, password)
                        await send(.registerSuccess)
                    } catch {
                        await send(.registerFailed)
                    }
                }
            default:
                return .none
            }
        }
    }
}
