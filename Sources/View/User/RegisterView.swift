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
    @Bindable var store: StoreOf<FullRegisterReducer>

    var body: some View {
        VStack {
            TextField("Login", text: $store.custom.login.sending(\.custom.loginChanged))
                .asCustomField()
            SecureField("Password", text: $store.custom.password.sending(\.custom.passwordChanged))
                .asCustomField()
            Button(action: {
                store.send(.custom(.register(email: store.custom.login, password: store.custom.password)))
            }, label: {
                Text("Register")
            })
        }
        .loadingIndicator(store.basic.isLoading)
        .alert("Error", isPresented: $store.basic.showingAlert.sending(\.basic.error)) {
            Button("OK", role: .cancel) {}
        }
    }
}
