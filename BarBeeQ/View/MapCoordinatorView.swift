//
//  MapCoordinatorView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 19/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct MapCoordinatorView: View {
    @Bindable var store: StoreOf<MapCoordinator>

    var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case .map:
                MapView(
                    store: .init(
                        initialState: .initialState,
                        reducer: {
                            MapReducer()
                        }
                    )
                )
            default:
                Text("Unknown case")
            }
        }
    }
}
