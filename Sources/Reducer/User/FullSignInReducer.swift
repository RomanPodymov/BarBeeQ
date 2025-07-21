//
//  FullSignInReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 21/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct FullSignInReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()

        var basic = BasicReducer.State.initialState
        var custom = SignInReducer.State.initialState
    }

    enum Action {
        case basic(BasicReducer.Action)
        case custom(SignInReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.basic, action: \.basic) {
            BasicReducer()
        }
        Scope(state: \.custom, action: \.custom) {
            SignInReducer()
        }
        Reduce { _, action in
            switch action {
            default:
                .none
            }
        }
    }
}
