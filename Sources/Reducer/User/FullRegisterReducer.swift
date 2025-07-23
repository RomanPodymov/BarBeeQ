//
//  FullRegisterReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 21/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct FullRegisterReducer {
    @ObservableState
    struct State: Equatable, Hashable {
        static let initialState = State()

        var basic = BasicReducer.State.initialState
        var custom = RegisterReducer.State.initialState
    }

    enum Action {
        case basic(BasicReducer.Action)
        case custom(RegisterReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.basic, action: \.basic) {
            BasicReducer()
        }
        Scope(state: \.custom, action: \.custom) {
            RegisterReducer()
        }
        Reduce { _, action in
            switch action {
            case .custom(.register):
                .run { send in
                    await send(.basic(.startLoading))
                }
            case .custom(.registerSuccess):
                .run { send in
                    await send(.basic(.endLoading))
                }
            case .custom(.registerFailed):
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
