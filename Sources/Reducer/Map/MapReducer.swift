//
//  MapReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import Combine
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
        case locationDetailPressed(BarBeeQLocation)
        case isSignedIn(Bool)
    }

    enum CancelID { case locations }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .publisher {
                    @Dependency(\.locationsClient) var locationsClient
                    return locationsClient.isSignedIn().map {
                        Action.isSignedIn($0)
                    }
                }.merge(with: .run { send in
                    @Dependency(\.locationsClient) var locationsClient
                    let locations = try await locationsClient.locations()
                    await send(.received(locations))
                }).cancellable(id: CancelID.locations, cancelInFlight: true)
            case .onDisappear:
                return .cancel(id: CancelID.locations)
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
