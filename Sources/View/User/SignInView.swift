//
//  SignInView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 03/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct SignInView: View {
    @Bindable var store: StoreOf<SignInReducer>

    var body: some View {
        VStack {
            TextEditor(text: $store.login.sending(\.loginChanged))
            SecureField("Password", text: $store.password.sending(\.passwordChanged))
            Button(action: {
                store.send(.onSignIn(email: store.login, password: store.password))
            }, label: {
                Text("Sign in")
            })
            Button(action: {
                store.send(.onRegister)
            }, label: {
                Text("Register")
            })
            Button(action: {
                store.send(.onResetPassword)
            }, label: {
                Text("Reset password")
            })
        }
        .alert("Error", isPresented: $store.showingAlert.sending(\.error)) {
            Button("OK", role: .cancel) {}
        }
    }
}
