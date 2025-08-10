//
//  LocationsListView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
import SwiftUI
import TCACoordinators

struct LocationsListView: View {
    var store: StoreOf<MapReducer>

    var body: some View {
        ZStack {
            List {
                ForEach(store.data) { place in
                    Button {
                        store.send(.locationDetailPressed)
                    } label: {
                        Text(place.name)
                    }
                }
            }
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
        .loadingIndicator(store.isLoading)
        .onAppear {
            store.send(.onAppear)
        }
        .onDisappear {
            store.send(.onDisappear)
        }
    }
}
