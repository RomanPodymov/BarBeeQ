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
    struct State: Equatable, Hashable {
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
    }

    enum Action {
        case nameChanged(String)
        case selectLocation
        case showPhotosPicker(Bool)
        case selectedPhotos(PhotosPickerItem?)
        case photoLoaded(Data?)
        case add(BarBeeQLocation)
        case locationAdded

        case addLocationFailed
        case selectPhotoFailed
    }

    @Dependency(\.locationsClient) var locationsClient
    static let imageLimit = 1_048_487

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .add(location):
                return .run { send in
                    do {
                        try await locationsClient.addLocation(location)
                        await send(.locationAdded)
                    } catch {
                        await send(.addLocationFailed)
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
                        guard let photo = try await value?.loadTransferable(type: Data.self) else {
                            await send(.selectPhotoFailed)
                            return
                        }
                        await send(.photoLoaded(photo))
                    } catch {
                        await send(.selectPhotoFailed)
                    }
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
