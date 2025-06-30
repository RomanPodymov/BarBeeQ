//
//  MapSelectionReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit

@Reducer
struct MapSelectionReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State()
    }

    enum Action {
        case locationSelected(CLLocationCoordinate2D)
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
