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
        static let initialState = State(
            data: []
        )
        var data: [Place]
    }

    enum Action {
        case onAppear
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.data = [
                    Place(name: "Prague", location: .init(latitude: 50.073658, longitude: 14.418540)),
                    Place(name: "Pilsen", location: .init(latitude: 49.738430, longitude: 13.373637)),
                    Place(name: "Olomouc", location: .init(latitude: 49.593777, longitude: 17.250879)),
                ]
                return .none
            }
        }
    }
}
