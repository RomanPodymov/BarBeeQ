//
//  ResetPasswordView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 14/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct ResetPasswordView: View {
    @Bindable var store: StoreOf<FullResetPasswordReducer>

    var body: some View {
        VStack {
            TextField("Email", text: $store.custom.email.sending(\.custom.emailChanged))
                .asCustomField()
            Button(action: {
                store.send(.custom(.resetPassword(email: store.custom.email)))
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
