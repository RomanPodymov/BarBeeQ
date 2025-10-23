//
//  FullMapReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 13/10/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct FullMapReducer {
    @ObservableState
    struct State: Equatable, Hashable {
        static let initialState = State()

        var basic = BasicReducer.State.initialState
        var custom = MapReducer.State.initialState
    }

    enum Action {
        case basic(BasicReducer.Action)
        case custom(MapReducer.Action)
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.basic, action: \.basic) {
            BasicReducer()
        }
        Scope(state: \.custom, action: \.custom) {
            MapReducer()
        }
        Reduce { _, action in
            switch action {
            case .custom(.onAppear):
                .run { send in
                    await send(.basic(.startLoading))
                }
            case .custom(.received):
                .run { send in
                    await send(.basic(.endLoading))
                }
            case .custom(.loadLocationsFailed):
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
