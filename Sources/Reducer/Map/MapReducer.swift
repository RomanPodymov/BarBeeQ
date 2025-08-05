//
//  MapReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct MapReducer {
    @ObservableState
    struct State: Equatable, Hashable {
        static let initialState = State(
            data: []
        )

        var isSignedIn: Bool?
        var data: [BarBeeQLocation]
        var isLoading = false
    }

    enum Action {
        case onAppear
        case onDisappear
        case received([BarBeeQLocation])
        case newLocationPressed
        case locationDetailPressed
        case isSignedIn(Bool)
    }

    @Dependency(\.locationsClient) var locationsClient
    var isSignedTask: Task<Void, Never>?

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    Task.detached {
                        for await isSignedIn in await locationsClient.isSignedIn() {
                            await send(.isSignedIn(isSignedIn))
                        }
                    }
                    let locations = try await locationsClient.locations()
                    await send(.received(locations))
                }
            case .onDisappear:
                return .none
            case let .received(data):
                state.isLoading = false
                state.data = data
                return .none
            case let .isSignedIn(value):
                state.isSignedIn = value
                return .none
            default:
                return .none
            }
        }
    }
}
