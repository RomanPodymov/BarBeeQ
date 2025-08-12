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
import UIKit

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
                        let image = UIImage(data: photo)
                        guard let compressed = image?.compress(to: 800) else {
                            await send(.selectPhotoFailed)
                            return
                        }
                        await send(.photoLoaded(compressed))
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

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * percentage, height: size.height * percentage)

        return preparingThumbnail(of: newSize)
    }

    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data? {
        let bytes = kb * 1024
        let threshold = Int(CGFloat(bytes) * (1 + allowedMargin))
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        while let data = holderImage.pngData() {
            let ratio = data.count / bytes
            if data.count < threshold {
                return data
            } else {
                let multiplier = CGFloat((ratio / 5) + 1)
                compression -= (step * multiplier)

                guard let newImage = resized(withPercentage: compression) else { break }
                holderImage = newImage
            }
        }

        return nil
    }
}
