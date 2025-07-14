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
    @Bindable var store: StoreOf<CombinedSignOutReducer>

    var body: some View {
        VStack {
            Button(action: {
                store.send(.signOut(.signOut))
            }, label: {
                Text("Sign out")
            })
        }
        .loadingIndicator(store.signOut.isLoading)
        .alert("Error", isPresented: $store.error.showingAlert.sending(\.error.error)) {
            Button("OK", role: .cancel) {}
        }
    }
}
