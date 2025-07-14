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
    @Bindable var store: StoreOf<ResetPasswordReducer>

    var body: some View {
        VStack {
            TextEditor(text: $store.email.sending(\.emailChanged))
            Button(action: {
                store.send(.onResetPassword(email: store.email))
            }, label: {
                Text("Reset password")
            })
        }
        .alert("Error", isPresented: $store.showingAlert.sending(\.error)) {
            Button("OK", role: .cancel) {}
        }
    }
}
