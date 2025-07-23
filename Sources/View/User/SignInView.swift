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
    @Bindable var store: StoreOf<FullSignInReducer>

    var body: some View {
        VStack {
            TextField("Login", text: $store.custom.login.sending(\.custom.loginChanged))
                .asCustomField()
            SecureField("Password", text: $store.custom.password.sending(\.custom.passwordChanged))
                .asCustomField()
            Button(action: {
                store.send(.custom(.signIn(email: store.custom.login, password: store.custom.password)))
            }, label: {
                Text("Sign in")
            })
            Button(action: {
                store.send(.custom(.onRegister))
            }, label: {
                Text("Register")
            })
            Button(action: {
                store.send(.custom(.onResetPassword))
            }, label: {
                Text("Reset password")
            })
        }
        .loadingIndicator(store.basic.isLoading)
        .alert("Error", isPresented: $store.basic.showingAlert.sending(\.basic.error)) {
            Button("OK", role: .cancel) {}
        }
    }
}
