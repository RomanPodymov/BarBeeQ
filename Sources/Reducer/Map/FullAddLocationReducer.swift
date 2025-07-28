//
//  FullAddLocationReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 28/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct FullAddLocationReducer {
    @ObservableState
    struct State: Equatable, Hashable {
        static let initialState = State()

        var basic = BasicReducer.State.initialState
        var custom = AddLocationReducer.State.initialState
    }

    enum Action {
        case basic(BasicReducer.Action)
        case custom(AddLocationReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.basic, action: \.basic) {
            BasicReducer()
        }
        Scope(state: \.custom, action: \.custom) {
            AddLocationReducer()
        }
        /* Reduce { _, action in
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
         } */
    }
}
