//
//  AddLocationReducer.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
import Photos
import PhotosUI
import SwiftUI

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
        var photo: Data?

        var showingAlert = false
    }

    enum Action {
        case nameChanged(String)
        case selectLocation
        case showPhotosPicker(Bool)
        case selectedPhotos(PhotosPickerItem?)
        case photoLoaded(Data?)
        case add(BarBeeQLocation)
        case locationAdded
        case error(Bool)
    }

    @Dependency(\.locationsClient) var locationsClient

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .add(location):
                return .run { send in
                    do {
                        try await locationsClient.addLocation(location)
                        await send(.locationAdded)
                    } catch {
                        await send(.error(true))
                    }
                }
            case let .nameChanged(name):
                state.name = name
                return .none
            case let .showPhotosPicker(value):
                state.showPhotosPicker = value
                return .none
            case let .selectedPhotos(value):
                return .run { send in
                    do {
                        let photo = try await value?.loadTransferable(type: Data.self)
                        await send(.photoLoaded(photo))
                    } catch {
                        await send(.error(true))
                    }
                }
            case let .photoLoaded(value):
                state.photo = value
                return .none
            case let .error(value):
                state.showingAlert = value
                return .none
            default:
                return .none
            }
        }
    }
}
