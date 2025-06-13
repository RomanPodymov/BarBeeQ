//
//  BarBeeQApp.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

@main
struct BarBeeQApp: App {
    let store: Store<RootReducer.State, RootReducer.Action>

    init() {
        store = Store(initialState: RootReducer.State()) {
            RootReducer()
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView(store: store)
        }
    }
}
