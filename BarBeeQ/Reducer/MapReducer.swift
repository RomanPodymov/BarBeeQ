//
//  MapReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit

struct Place: Equatable, Identifiable {
    var id: String {
        name
    }

    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.name == rhs.name &&
            lhs.location.latitude == rhs.location.latitude &&
            lhs.location.longitude == rhs.location.longitude
    }

    let name: String
    let location: CLLocationCoordinate2D
}

@Reducer
struct MapReducer {
    @ObservableState
    struct State: Equatable, Sendable {
        var data: [Place]
    }

    enum Action {
        case onAppear
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
