//
//  FullSignOutReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 17/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct FullSignOutReducer {
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
