//
//  ProfileReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 03/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct ProfileReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static let initialState = State(
            data: ""
        )
        var data: String = ""
    }

    enum Action {
        case onAppear
        case onSignIn(email: String, password: String)
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .onAppear:
                .run { _ in
                }
            case let .onSignIn(email, password):
                .run { _ in
                    try await locationsClient.signIn(email, password)
                }
            }
        }
    }
}
