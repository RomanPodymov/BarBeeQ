//
//  MapView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 19/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
import SwiftUI
import TCACoordinators

struct MapView: View {
    let store: StoreOf<MapReducer>

    var body: some View {
        Map {
            ForEach(store.data) { place in
                Annotation(place.name, coordinate: place.location) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.yellow)
                        Text(place.name)
                            .padding(5)
                    }
                }
            }
        }
        .mapControlVisibility(.hidden)
        .onAppear {
            store.send(.onAppear)
        }
    }
}
