//
//  MainTabCoordinator.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit

struct Place: Equatable, Identifiable {
    var id: String {
        name
    }

    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.name == rhs.name &&
            lhs.location.latitude == rhs.location.latitude &&
            lhs.location.longitude == rhs.location.longitude
    }

    let name: String
    let location: CLLocationCoordinate2D
}

@Reducer
struct MainTabCoordinator {
    enum Tab: Hashable {
        case map, profile
    }

    enum Action {
        case map(MapCoordinator.Action)
        case tabSelected(Tab)
        case onAppear
    }

    @ObservableState
    struct State: Equatable {
        static let initialState = State(
            map: .initialState,
            selectedTab: .map
        )

        var map: MapCoordinator.State
        var selectedTab: Tab
    }

    var body: some ReducerOf<Self> {
        Scope(state: \.map, action: \.map) {
            MapCoordinator()
        }
        Reduce { state, action in
            switch action {
            case let .tabSelected(tab):
                state.selectedTab = tab
            case .onAppear:
                /* state.data = [
                     Place(name: "Prague", location: .init(latitude: 50.073658, longitude: 14.418540)),
                     Place(name: "Pilsen", location: .init(latitude: 49.738430, longitude: 13.373637)),
                     Place(name: "Olomouc", location: .init(latitude: 49.593777, longitude: 17.250879)),
                 ] */
                break
            default:
                break
            }
            return .none
        }
    }
}
