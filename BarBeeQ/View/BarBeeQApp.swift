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
    let store: Store<MainTabCoordinator.State, MainTabCoordinator.Action>

    init() {
        store = Store(initialState: .initialState) {
            MainTabCoordinator()
        }
    }

    var body: some Scene {
        WindowGroup {
            MainTabCoordinatorView(store: store)
        }
    }
}
