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
    @Bindable var store: StoreOf<MapReducer>

    var body: some View {
        ZStack {
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
            Button {
                store.send(.newLocationPressed)
            } label: {
                Text("New location")
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
