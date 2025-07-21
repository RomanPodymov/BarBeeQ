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
    struct State: Equatable, Hashable {
        static let initialState = State()

        var email = ""
    }

    enum Action {
        case emailChanged(String)

        case resetPassword(email: String)
        case resetPasswordSuccess
        case resetPasswordFailed
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .emailChanged(value):
                state.email = value
                return .none
            case let .resetPassword(email: email):
                return .run { send in
                    do {
                        try await locationsClient.resetPassword(email)
                        await send(.resetPasswordSuccess)
                    } catch {
                        await send(.resetPasswordFailed)
                    }
                }
            default:
                return .none
            }
        }
    }
}
