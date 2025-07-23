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

        var data: [BarBeeQLocation]
        var isLoading = false
    }

    enum Action {
        case onAppear
        case received([BarBeeQLocation])
        case newLocationPressed
        case locationDetailPressed
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    let locations = try await locationsClient.locations()
                    await send(.received(locations))
                }
            case let .received(data):
                state.isLoading = false
                state.data = data
                return .none
            default:
                return .none
            }
        }
    }
}
