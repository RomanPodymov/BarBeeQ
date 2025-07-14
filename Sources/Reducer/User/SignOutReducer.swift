//
//  SignOutReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 09/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct ErrorReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()

        var showingAlert = false
    }

    enum Action {
        case error(Bool)
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

@Reducer
struct SignOutReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()

        var isLoading = false
        var showingAlert = false
    }

    enum Action {
        case signOut
        case signOutSuccess
        case error(Bool)
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .signOut:
                state.isLoading = true
                return .run { send in
                    do {
                        try await locationsClient.signOut()
                        await send(.signOutSuccess)
                    } catch {
                        await send(.error(true))
                    }
                }
            case let .error(value):
                state.isLoading = false
                state.showingAlert = value
                return .none
            default:
                return .none
            }
        }
    }
}

@Reducer
struct CombinedSignOutReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()

        var error = ErrorReducer.State.initialState
        var signOut = SignOutReducer.State.initialState
    }

    enum Action {
        case error(ErrorReducer.Action)
        case signOut(SignOutReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.error, action: \.error) {
            ErrorReducer()
        }
        Scope(state: \.signOut, action: \.signOut) {
            SignOutReducer()
        }
    }
}
