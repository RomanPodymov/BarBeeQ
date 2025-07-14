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
            TextField("Login", text: $store.login.sending(\.loginChanged))
                .asCustomField()
            SecureField("Password", text: $store.password.sending(\.passwordChanged))
                .asCustomField()
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

struct CustomField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 200)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .cornerRadius(16)
            .padding([.leading, .trailing], 24)
    }
}

extension View {
    func asCustomField() -> some View {
        modifier(CustomField())
    }
}
