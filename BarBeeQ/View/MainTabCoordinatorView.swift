//
//  MainTabCoordinatorView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct MainTabCoordinatorView: View {
    @Bindable var store: StoreOf<MainTabCoordinator>

    var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
                MapCoordinatorView(store: store.scope(state: \.map, action: \.map))
                    .tabItem { Text("Map") }
                    .tag(MainTabCoordinator.Tab.map)

                Text("Profile")
                    .tabItem { Text("Profile") }
                    .tag(MainTabCoordinator.Tab.profile)
            }
        }
    }
}
