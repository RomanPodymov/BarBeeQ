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
    var store: StoreOf<MapReducer>

    var body: some View {
        ZStack {
            Map {
                ForEach(store.data) { place in
                    Annotation(place.name, coordinate: place.location) {
                        ZStack {
                            Button {
                                store.send(.locationDetailPressed)
                            } label: {
                                Text(place.name)
                            }
                        }
                    }
                }
            }
            .mapControlVisibility(.hidden)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        store.send(.newLocationPressed)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    .padding(.trailing, 100)
                    .padding(.bottom, 100)
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
