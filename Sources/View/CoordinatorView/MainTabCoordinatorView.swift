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
        TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
            MapCoordinatorView(store: store.scope(state: \.map, action: \.map))
                .tabItem { Text("tab.map.title") }
                .tag(MainTabCoordinator.Tab.map)

            LocationsListCoordinatorView(store: store.scope(state: \.list, action: \.list))
                .tabItem { Text("tab.list.title") }
                .tag(MainTabCoordinator.Tab.list)

            UserCoordinatorView(store: store.scope(state: \.user, action: \.user))
                .tabItem { Text("tab.profile.title") }
                .tag(MainTabCoordinator.Tab.user)
        }
    }
}
