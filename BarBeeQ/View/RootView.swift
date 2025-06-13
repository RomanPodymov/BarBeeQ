//
//  RootView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct RootView: View {
    var store: StoreOf<RootReducer>

    var body: some View {
        Text(store.state.data)
            .onAppear {
                store.send(.onAppear)
            }
    }
}
