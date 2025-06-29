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

struct LocationView: View {
    let text: String

    init(_ location: CLLocationCoordinate2D) {
        text = "\(location.latitude), \(location.longitude)"
    }

    var body: some View {
        Text(text)
    }
}

struct AddLocationView: View {
    @Bindable var store: StoreOf<AddLocationReducer>

    var body: some View {
        VStack {
            TextEditor(text: $store.name.sending(\.nameChanged))

            LocationView(store.location)

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
