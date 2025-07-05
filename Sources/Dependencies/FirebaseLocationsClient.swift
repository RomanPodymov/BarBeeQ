//
//  FirebaseLocationsClient.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 04/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

extension LocationsClient {
    static let firebase = LocationsClient(setup: {
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
        try await Auth.auth().signIn(withEmail: email, password: password)
    }, registerUser: { email, password in
        try await Auth.auth().createUser(withEmail: email, password: password)
    })
}
