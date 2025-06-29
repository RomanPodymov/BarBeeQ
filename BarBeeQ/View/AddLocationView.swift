//
//  AddLocationView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
import SwiftUI
import TCACoordinators

struct AddLocationView: View {
    @Bindable var store: StoreOf<AddLocationReducer>

    var body: some View {
        VStack {
            TextEditor(text: $store.name.sending(\.nameChanged))

            Text("\(store.location)")

            Button {
                store.send(
                    .selectLocation
                )
            } label: {
                Text("Select location")
            }

            Spacer()

            Button {
                store.send(
                    .add(
                        .init(
                            name: store.name,
                            location: store.location
                        )
                    )
                )
            } label: {
                Text("Add location")
            }
        }
    }
}
