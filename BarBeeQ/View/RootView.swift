//
//  RootView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
import SwiftUI
import TCACoordinators

struct RootView: View {
    var store: StoreOf<RootReducer>

    var body: some View {
        MainTabCoordinatorView(
            store: .init(
                initialState: .init(
                    data: [
                        Place(name: "Prague", location: .init(latitude: 50.073658, longitude: 14.418540)),
                        Place(name: "Pilsen", location: .init(latitude: 49.738430, longitude: 13.373637)),
                        Place(name: "Olomouc", location: .init(latitude: 49.593777, longitude: 17.250879)),
                    ],
                    selectedTab: .map
                ), reducer: {
                    MainTabCoordinator()
                }
            )
        )
    }
}

@Reducer
struct MainTabCoordinator {
    enum Tab: Hashable {
        case map, profile
    }

    enum Action {
        case tabSelected(Tab)
        case onAppear
    }

    @ObservableState
    struct State: Equatable {
        static let initialState = State(
            data: [],
            selectedTab: .map
        )

        var data: [Place]
        var selectedTab: Tab
    }

    var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}

struct MainTabCoordinatorView: View {
    @Bindable var store: StoreOf<MainTabCoordinator>

    var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
                Map {
                    ForEach(store.data) { place in
                        Annotation(place.name, coordinate: place.location) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.yellow)
                                Text(place.name)
                                    .padding(5)
                            }
                        }
                    }
                }
                .mapControlVisibility(.hidden)
                .tabItem { Text("Map") }
                .tag(MainTabCoordinator.Tab.map)

                Text("Profile")
                    .tabItem { Text("Profile") }
                    .tag(MainTabCoordinator.Tab.profile)
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}
