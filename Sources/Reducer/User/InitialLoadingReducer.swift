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
    struct State: Equatable, Hashable {
        static let initialState = State()
    }

    enum Action {
        case onAppear
        case isSignedIn(Bool)
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .onAppear:
                .run { send in
                    let isSignedInValue = locationsClient.isSignedIn()
                    for await isSignedIn in isSignedInValue {
                        await send(.isSignedIn(isSignedIn))
                    }
                }
            default:
                .none
            }
        }
    }
}
