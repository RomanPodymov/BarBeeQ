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

        var isLoading = false
        var showingAlert = false
    }

    enum Action {
        case startLoading
        case endLoading
        case error(Bool)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startLoading:
                state.isLoading = true
                return .none
            case .endLoading:
                state.isLoading = false
                return .none
            case let .error(value):
                state.showingAlert = value
                return .none
            }
        }
    }
}

@Reducer
struct SignOutReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()
    }

    enum Action {
        case signOut
        case signOutSuccess
        case signOutFailed
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .signOut:
                .run { send in
                    do {
                        try await locationsClient.signOut()
                        await send(.signOutSuccess)
                    } catch {
                        await send(.signOutFailed)
                    }
                }
            default:
                .none
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
        Reduce { _, action in
            switch action {
            case .signOut(.signOut):
                .run { send in
                    await send(.error(.startLoading))
                }
            case .signOut(.signOutFailed):
                .run { send in
                    await send(.error(.endLoading))
                    await send(.error(.error(true)))
                }
            default:
                .none
            }
        }
    }
}
