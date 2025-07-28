//
//  AddLocationView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
import PhotosUI
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
    @Bindable var store: StoreOf<FullAddLocationReducer>

    var body: some View {
        VStack {
            TextEditor(text: $store.custom.name.sending(\.custom.nameChanged))

            Button {
                store.send(
                    .custom(.showPhotosPicker(true))
                )
            } label: {
                Text("Select photo")
            }

            createImage(store.custom.photo)
                .resizable()
                .frame(width: 100, height: 100)

            LocationView(store.custom.location)

            Button {
                store.send(
                    .custom(.selectLocation)
                )
            } label: {
                Text("Select location")
            }

            Spacer()

            Button {
                store.send(
                    .custom(.add(
                        .init(
                            name: store.custom.name,
                            location: store.custom.location,
                            photo: store.custom.photo
                        )
                    ))
                )
            } label: {
                Text("Add location")
            }
        }
        .loadingIndicator(store.basic.isLoading)
        .alert("Error", isPresented: $store.basic.showingAlert.sending(\.basic.error)) {
            Button("OK", role: .cancel) {}
        }
        .photosPicker(
            isPresented: $store.custom.showPhotosPicker.sending(\.custom.showPhotosPicker),
            selection: $store.custom.selectedPhotos.sending(\.custom.selectedPhotos)
        )
    }
}
