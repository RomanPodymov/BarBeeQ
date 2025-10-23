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
    var store: StoreOf<FullMapReducer>

    var body: some View {
        ZStack {
            List {
                ForEach(store.custom.data) { place in
                    Button {
                        store.send(.custom(.locationDetailPressed(place)))
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
                        store.send(.custom(.newLocationPressed))
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
        .loadingIndicator(store.basic.isLoading)
        .onAppear {
            store.send(.custom(.onAppear))
        }
        .onDisappear {
            store.send(.custom(.onDisappear))
        }
    }
}
