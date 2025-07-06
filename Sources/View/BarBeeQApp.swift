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
    let store = Store(initialState: .initialState) {
        MainTabCoordinator()
    }

    @Dependency(\.locationsClient) var locationsClient

    init() {
        locationsClient.setup()
    }

    var body: some Scene {
        WindowGroup {
            MainTabCoordinatorView(store: store)
        }
    }
}
