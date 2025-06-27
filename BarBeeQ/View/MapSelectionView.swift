//
//  MapSelectionView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
import SwiftUI
import TCACoordinators

struct MapSelectionView: View {
    var store: StoreOf<MapSelectionReducer>

    var body: some View {
        MapReader { proxy in
            Map {}
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        print("Tapped at \(coordinate)")
                        store.send(.locationSelected(coordinate))
                    }
                }
        }
    }
}
