//
//  RootReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct RootReducer {
    @ObservableState
    struct State: Equatable {
        var data: String = "Hello"
    }

    enum Action {
        case onAppear
    }

    var body: some Reducer<State, Action> {
        Reduce { _, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
