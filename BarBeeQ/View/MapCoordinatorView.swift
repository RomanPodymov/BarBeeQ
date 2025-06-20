//
//  MapCoordinatorView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 19/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
import SwiftUI
import TCACoordinators

struct MapCoordinatorView: View {
    let store: StoreOf<MapCoordinator>

    var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { _ in
            MapView(
                store: .init(
                    initialState: .init(
                        data: [
                            Place(name: "Prague", location: .init(latitude: 50.073658, longitude: 14.418540)),
                            Place(name: "Pilsen", location: .init(latitude: 49.738430, longitude: 13.373637)),
                            Place(name: "Olomouc", location: .init(latitude: 49.593777, longitude: 17.250879)),
                        ]),
                    reducer: {
                        MapReducer()
                    }
                )
            )
        }
    }
}
