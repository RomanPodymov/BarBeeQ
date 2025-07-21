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
    struct State: Equatable, Hashable {
        static let initialState = State()

        var basic = BasicReducer.State.initialState
        var custom = SignOutReducer.State.initialState
    }

    enum Action {
        case basic(BasicReducer.Action)
        case custom(SignOutReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.basic, action: \.basic) {
            BasicReducer()
        }
        Scope(state: \.custom, action: \.custom) {
            SignOutReducer()
        }
        Reduce { _, action in
            switch action {
            case .custom(.signOut):
                .run { send in
                    await send(.basic(.startLoading))
                }
            case .custom(.signOutSuccess):
                .run { send in
                    await send(.basic(.endLoading))
                }
            case .custom(.signOutFailed):
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
