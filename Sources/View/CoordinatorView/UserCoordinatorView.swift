//
//  UserCoordinatorView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 07/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct UserCoordinatorView: View {
    var store: StoreOf<UserCoordinator>

    var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .signIn(store):
                SignInView(
                    store: store
                )

            case let .signOut(store):
                SignOutView(
                    store: store
                )

            case let .register(store):
                RegisterView(
                    store: store
                )

            case let .loading(store):
                InitialLoadingView(
                    store: store
                )
            }
        }
    }
}
