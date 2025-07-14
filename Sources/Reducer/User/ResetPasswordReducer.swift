//
//  ResetPasswordReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 14/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct ResetPasswordReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()

        var email = ""
        var isLoading = false
        var showingAlert = false
    }

    enum Action {
        case emailChanged(String)
        case onResetPassword(email: String)
        case onResetPasswordSuccess
        case error(Bool)
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .emailChanged(value):
                state.email = value
                return .none
            case let .onResetPassword(email: email):
                state.isLoading = true
                return .run { send in
                    do {
                        try await locationsClient.resetPassword(email)
                        await send(.onResetPasswordSuccess)
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
