//
//  LocationsListCoordinatorView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 09/09/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct LocationsListCoordinatorView: View {
    var store: StoreOf<LocationsListCoordinator>

    var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .map(store):
                LocationsListView(
                    store: store
                )

            case let .newLocation(store):
                AddLocationView(
                    store: store
                )

            case let .locationDetail(store):
                LocationDetailView(
                    store: store
                )
            }
        }
    }
}
