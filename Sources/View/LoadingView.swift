//
//  LoadingView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 09/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
import SwiftUI
import TCACoordinators

struct LoadingView: View {
    var store: StoreOf<LoadingReducer>

    var body: some View {
        ProgressView()
            .onAppear {
                store.send(.onAppear)
            }
    }
}
