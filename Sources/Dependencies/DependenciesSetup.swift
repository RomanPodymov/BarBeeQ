//
//  DependenciesSetup.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture

actor ThreadSafeArray<T> {
    private var rawData: [T] = []

    var data: [T] {
        rawData
    }

    func set(data: [T]) {
        rawData = data
    }
}

extension LocationsClient: DependencyKey {
    private static let dummy = {
        let locationsStorage = ThreadSafeArray<BarBeeQLocation>()

        return LocationsClient(setup: {}, locations: {
            await locationsStorage.data
        }, addLocation: { location in
            let locations = await locationsStorage.data
            await locationsStorage.set(data: locations + [location])
        }, signIn: { _, _ in
        }, isSignedIn: {
            true
        }, registerUser: { _, _ in
        }, resetPassword: { _ in })
    }()

    static let liveValue = firebase
}

extension LocationsClient: TestDependencyKey {
    static let previewValue = dummy

    static let testValue = previewValue
}
