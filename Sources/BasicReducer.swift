//
//  BasicReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 17/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct BasicReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()

        var isLoading = false
        var showingAlert = false
    }

    enum Action {
        case startLoading
        case endLoading
        case error(Bool)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .startLoading:
                state.isLoading = true
                return .none
            case .endLoading:
                state.isLoading = false
                return .none
            case let .error(value):
                state.showingAlert = value
                return .none
            }
        }
    }
}
