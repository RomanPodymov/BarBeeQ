//
//  InitialLoadingReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 09/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct InitialLoadingReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()
    }

    enum Action {
        case onAppear
        case isSignedIn(Bool)
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { store, action in
            switch action {
            case .onAppear:
                .run { send in
                    await send(.isSignedIn(true))
                }
            default:
                .none
            }
        }
    }
}
