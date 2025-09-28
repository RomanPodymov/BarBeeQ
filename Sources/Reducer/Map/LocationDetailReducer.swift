//
//  LocationDetailReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 10/09/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct LocationDetailReducer {
    @ObservableState
    struct State: Equatable, Hashable {
        static let initialState = State()

        var location: BarBeeQLocation = .init(name: "", location: .init(), photo: nil)
    }

    enum Action {
        case something
    }

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            default:
                .none
            }
        }
    }
}
