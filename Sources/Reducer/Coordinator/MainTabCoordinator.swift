//
//  MainTabCoordinator.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct MainTabCoordinator {
    enum Tab: Hashable {
        case map, list, user
    }

    enum Action {
        case map(MapCoordinator.Action)
        case user(UserCoordinator.Action)
        case tabSelected(Tab)
    }

    @ObservableState
    struct State: Equatable {
        static let initialState = State(
            map: .initialState,
            user: .initialState,
            selectedTab: .map
        )

        var map: MapCoordinator.State
        var user: UserCoordinator.State

        var selectedTab: Tab
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.map, action: \.map) {
            MapCoordinator()
        }
        Scope(state: \.user, action: \.user) {
            UserCoordinator()
        }
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
            default:
                break
            }
            return .none
        }
    }
}
