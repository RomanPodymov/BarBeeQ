//
//  MapReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
@preconcurrency import TCACoordinators

@Reducer
struct MapReducer {
    @ObservableState
    struct State: Equatable, Sendable {
        var data: [Place]
    }

    enum Action {
        case some
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
