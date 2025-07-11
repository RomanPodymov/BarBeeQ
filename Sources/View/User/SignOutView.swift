//
//  SignOutView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 09/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

struct SignOutView: View {
    @Bindable var store: StoreOf<SignOutReducer>

    var body: some View {
        VStack {
            Button(action: {
                store.send(.signOut)
            }, label: {
                Text("Sign out")
            })
        }
        .alert("Error", isPresented: $store.showingAlert.sending(\.error)) {
            Button("OK", role: .cancel) {}
        }
    }
}
