//
//  DependenciesSetup.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

extension LocationsClient: DependencyKey {
    private static let dummy = {
        var currentState: [BarBeeQLocation] = [
            .init(name: "Pilsen", location: .init(latitude: 49.738430, longitude: 13.373637)),
            .init(name: "Olomouc", location: .init(latitude: 49.593777, longitude: 17.250879)),
        ]

        return LocationsClient(locations: {
            currentState
        }, addLocation: { location in
            currentState += [location]
        })
    }()

    private static let backendless = dummy

    static let liveValue = backendless
}

extension LocationsClient: TestDependencyKey {
    static let previewValue = dummy

    static let testValue = previewValue
}
