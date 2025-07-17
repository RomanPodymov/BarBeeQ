//
//  RegisterView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 08/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct RegisterView: View {
    @Bindable var store: StoreOf<RegisterReducer>

    var body: some View {
        VStack {
            TextField("Login", text: $store.login.sending(\.loginChanged))
                .asCustomField()
            SecureField("Password", text: $store.password.sending(\.passwordChanged))
                .asCustomField()
            Button(action: {
                store.send(.onRegister(email: store.login, password: store.password))
            }, label: {
                Text("Register")
            })
        }
        .loadingIndicator(store.isLoading)
        .alert("Error", isPresented: $store.showingAlert.sending(\.error)) {
            Button("OK", role: .cancel) {}
        }
    }
}
