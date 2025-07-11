//
//  MapView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 19/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit
import SwiftUI
import TCACoordinators

func createImage(_ value: Data?) -> Image {
    guard let value else {
        return Image("some_default")
    }
    #if canImport(UIKit)
        let songArtwork = UIImage(data: value) ?? UIImage()
        return Image(uiImage: songArtwork)
    #elseif canImport(AppKit)
        let songArtwork = NSImage(data: value) ?? NSImage()
        return Image(nsImage: songArtwork)
    #else
        return Image(systemImage: "some_default")
    #endif
}

struct MapView: View {
    var store: StoreOf<MapReducer>

    var body: some View {
        ZStack {
            Map {
                ForEach(store.data) { place in
                    Annotation(place.name, coordinate: place.location) {
                        VStack {
                            createImage(place.photo)
                                .resizable()
                                .frame(width: 100, height: 100)
                            Button {
                                store.send(.locationDetailPressed)
                            } label: {
                                Text(place.name)
                            }
                        }
                    }
                }
            }
            .mapControlVisibility(.hidden)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        store.send(.newLocationPressed)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    .padding(.trailing, 100)
                    .padding(.bottom, 100)
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
