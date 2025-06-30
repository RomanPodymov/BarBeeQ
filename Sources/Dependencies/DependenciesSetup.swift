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
        var currentState: [BarBeeQLocation] = []

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
