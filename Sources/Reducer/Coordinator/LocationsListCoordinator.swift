//
//  LocationsListCoordinator.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 09/09/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import RPMacro
@preconcurrency import TCACoordinators

@Reducer(state: .equatable, .hashable, .sendable)
enum LocationsListScreen {
    case map(FullMapReducer)
    case newLocation(FullAddLocationReducer)
    case mapSelection(MapSelectionReducer)
    case locationDetail(LocationDetailReducer)
}

enum Global {
    #generateEnum(name: "LocationsListScreenId", ["map", "newLocation", "mapSelection", "locationDetail"])
}

extension LocationsListScreen.State: Identifiable {
    var id: Global.LocationsListScreenId {
        switch self {
        case .map:
            .map
        case .newLocation:
            .newLocation
        case .mapSelection:
            .mapSelection
        case .locationDetail:
            .locationDetail
        }
    }
}

@Reducer
struct LocationsListCoordinator {
    @ObservableState
    struct State: Equatable, Hashable {
        static let initialState = State(
            routes: [.root(.map(.initialState), embedInNavigationView: true)]
        )

        var routes: IdentifiedArrayOf<Route<LocationsListScreen.State>>

        var addLocationState = FullAddLocationReducer.State.initialState
        var mapSelection = MapSelectionReducer.State.initialState
        var locationDetailState = LocationDetailReducer.State.initialState
    }

    enum Action {
        case router(IdentifiedRouterActionOf<LocationsListScreen>)
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(_, action: .map(.custom(.newLocationPressed)))):
                state.addLocationState = .initialState
                state.routes.push(.newLocation(state.addLocationState))
                return .none
            case let .router(.routeAction(_, action: .map(.custom(.locationDetailPressed(location))))):
                state.locationDetailState.location = location
                state.routes.push(.locationDetail(state.locationDetailState))
                return .none
            case .router(.routeAction(_, action: .newLocation(.custom(.selectLocation)))):
                state.routes.push(.mapSelection(state.mapSelection))
                return .none
            case let .router(.routeAction(_, action: .mapSelection(.locationSelected(location)))):
                state.addLocationState.custom.location = location
                state.routes = State.initialState.routes + [
                    .push(.newLocation(state.addLocationState))
                ]
                return .none
            case let .router(.routeAction(_, action: .newLocation(.custom(.nameChanged(name))))):
                state.addLocationState.custom.name = name
                return .none
            case let .router(.routeAction(_, action: .newLocation(.custom(.photoLoaded(photo))))):
                state.addLocationState.custom.photo = photo
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
