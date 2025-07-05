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
    @Bindable var store: StoreOf<ProfileReducer>

    var body: some View {
        VStack {
            Button(action: {
                store.send(.onSignIn(email: "", password: ""))
            }, label: {
                Text("Sign in")
            })
            Button(action: {
                store.send(.onRegister(email: "", password: ""))
            }, label: {
                Text("Register")
            })
        }
        .alert("Error", isPresented: $store.showingAlert.sending(\.error)) {
            Button("OK", role: .cancel) {}
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
