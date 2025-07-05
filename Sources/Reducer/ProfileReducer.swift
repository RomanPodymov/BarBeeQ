//
//  ProfileReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 03/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct ProfileReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State(
            data: ""
        )
        var data = ""
        var showingAlert = false
    }

    enum Action {
        case onAppear
        case onSignIn(email: String, password: String)
        case onRegister(email: String, password: String)
        case error(Bool)
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case let .onSignIn(email, password):
                return .run { send in
                    do {
                        try await locationsClient.signIn(email, password)
                    } catch {
                        await send(.error(true))
                    }
                }
            case let .onRegister(email: email, password: password):
                return .run { send in
                    do {
                        try await locationsClient.registerUser(email, password)
                    } catch {
                        await send(.error(true))
                    }
                }
            case let .error(value):
                state.showingAlert = value
                return .none
            }
        }
    }
}
