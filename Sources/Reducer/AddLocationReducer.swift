//
//  AddLocationReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import _PhotosUI_SwiftUI
import ComposableArchitecture
import MapKit
import Photos
import PhotosUI

@Reducer
struct AddLocationReducer {
    @ObservableState
    struct State: Equatable, Hashable, Sendable {
        static func == (lhs: AddLocationReducer.State, rhs: AddLocationReducer.State) -> Bool {
            lhs.name == rhs.name
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }

        static let initialState = State()

        var name = ""
        var location = CLLocationCoordinate2D()

        var showPhotosPicker = false
        var selectedPhotos: PhotosPickerItem?
        var photo = Data()
    }

    enum Action {
        case add(BarBeeQLocation)
        case locationAdded
        case nameChanged(String)
        case selectLocation
        case showPhotosPicker(Bool)
        case selectedPhotos(PhotosPickerItem?)
        case photoLoaded(Data)
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .add(location):
                return .run { send in
                    try await locationsClient.addLocation(location)
                    await send(.locationAdded)
                }
            case let .nameChanged(name):
                state.name = name
                return .none
            case let .showPhotosPicker(value):
                state.showPhotosPicker = value
                return .none
            case let .selectedPhotos(value):
                return .run { send in
                    let photo = try await value?.loadTransferable(type: Data.self) ?? .init()
                    await send(.photoLoaded(photo))
                }
            case let .photoLoaded(value):
                state.photo = value
                return .none
            default:
                return .none
            }
        }
    }
}
