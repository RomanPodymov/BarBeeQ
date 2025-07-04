//
//  DependenciesSetup.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

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
        })
    }()

    private static let firebase = LocationsClient(setup: {
        FirebaseApp.configure()
    }, locations: {
        let collection = Firestore.firestore().collection("BBQLocation")
        return try await collection.getDocuments().documents.map {
            let data = $0.data()
            return BarBeeQLocation(
                name: (data["name"] as? String) ?? "",
                location: .init(
                    latitude: (data["location"] as? GeoPoint)?.latitude ?? .zero,
                    longitude: (data["location"] as? GeoPoint)?.longitude ?? .zero
                )
            )
        }
    }, addLocation: { location in
        let collection = Firestore.firestore().collection("BBQLocation")
        try await collection.addDocument(data: [
            "name": location.name,
            "location": GeoPoint(
                latitude: location.location.latitude,
                longitude: location.location.longitude
            ),
        ])
    }, signIn: { email, password in
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            print(error)
        }
    })

    static let liveValue = firebase
}

extension LocationsClient: TestDependencyKey {
    static let previewValue = dummy

    static let testValue = previewValue
}
