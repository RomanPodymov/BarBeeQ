//
//  ProfileView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 03/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct ProfileView: View {
    var store: StoreOf<ProfileReducer>

    var body: some View {
        Button(action: {
            store.send(.onSignIn(email: "", password: ""))
        }, label: {
            Text("Register")
        })
        .onAppear {
            store.send(.onAppear)
        }
    }
}
