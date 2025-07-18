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

        var basic = BasicReducer.State.initialState
        var signOut = SignOutReducer.State.initialState
    }

    enum Action {
        case basic(BasicReducer.Action)
        case signOut(SignOutReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.basic, action: \.basic) {
            BasicReducer()
        }
        Scope(state: \.signOut, action: \.signOut) {
            SignOutReducer()
        }
        Reduce { _, action in
            switch action {
            case .signOut(.signOut):
                .run { send in
                    await send(.basic(.startLoading))
                }
            case .signOut(.signOutFailed):
                .run { send in
                    await send(.basic(.endLoading))
                    await send(.basic(.error(true)))
                }
            default:
                .none
            }
        }
    }
}
