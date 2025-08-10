//
//  SignOutReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 09/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

@Reducer
struct SignOutReducer {
    @ObservableState
    struct State: Hashable {
        static let initialState = State()
    }

    enum Action {
        case signOut
        case signOutSuccess
        case signOutFailed

        case deleteAccount
        case deleteAccountSuccess
        case deleteAccountFailed
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .signOut:
                .run { send in
                    do {
                        try await locationsClient.signOut()
                        await send(.signOutSuccess)
                    } catch {
                        await send(.signOutFailed)
                    }
                }
            case .deleteAccount:
                .run { send in
                    do {
                        try await locationsClient.deleteAccount()
                        await send(.deleteAccountSuccess)
                    } catch {
                        await send(.deleteAccountFailed)
                    }
                }
            default:
                .none
            }
        }
    }
}
