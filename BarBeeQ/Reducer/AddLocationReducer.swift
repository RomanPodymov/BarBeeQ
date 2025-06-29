//
//  AddLocationReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit

@Reducer
struct AddLocationReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static func == (lhs: AddLocationReducer.State, rhs: AddLocationReducer.State) -> Bool {
            lhs.name == rhs.name
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }

        static let initialState = State()

        var name = ""
        var location = CLLocationCoordinate2D()
    }

    enum Action {
        case add(BarBeeQLocation)
        case locationAdded
        case nameChanged(String)
        case selectLocation
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .add(location):
                return .run { send in
                    try await locationsClient.addLocation(location)
                    await send(.locationAdded)
                }
            case let .nameChanged(name):
                state.name = name
                return .none
            default:
                return .none
            }
        }
    }
}
