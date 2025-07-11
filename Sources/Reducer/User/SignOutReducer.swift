//
//  SignOutReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 09/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct SignOutReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()

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
                return .run { send in
                    do {
                        try await locationsClient.signOut()
                        await send(.signOutSuccess)
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
