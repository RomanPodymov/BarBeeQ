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

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .onAppear:
                .run { send in
                    @Dependency(\.locationsClient) var locationsClient
                    for await isSignedIn in await locationsClient.isSignedIn() {
                        await send(.isSignedIn(isSignedIn))
                        break
                    }
                }
            default:
                .none
            }
        }
    }
}
