//
//  DependenciesSetup.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

actor TheWrapper {
    var currentState: [BarBeeQLocation] = []

    func set(currentState: [BarBeeQLocation]) {
        self.currentState = currentState
    }
}

extension LocationsClient: DependencyKey {
    private static let dummy = {
        let theWrapper = TheWrapper()

        return LocationsClient(locations: { [theWrapper] in
            await theWrapper.currentState
        }, addLocation: { [theWrapper] location in
            let locations = await theWrapper.currentState
            await theWrapper.set(currentState: locations + [location])
        })
    }()

    private static let backendless = dummy

    static let liveValue = backendless
}

extension LocationsClient: TestDependencyKey {
    static let previewValue = dummy

    static let testValue = previewValue
}
