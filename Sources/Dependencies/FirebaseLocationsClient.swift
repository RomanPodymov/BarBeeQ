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
                ),
                photo: {
                    if let data = data["photo"] as? String {
                        return Data(base64Encoded: data) ?? .init()
                    }
                    return .init()
                }()
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
            "photo": {
                let encodedImage = location.photo?.base64EncodedString() ?? ""
                return encodedImage
            }()
        ])
    }, signIn: { email, password in
        try await Auth.auth().signIn(withEmail: email, password: password)
    }, isSignedIn: {
        Auth.auth().currentUser != nil
    }, signOut: {
        try Auth.auth().signOut()
    }, registerUser: { email, password in
        try await Auth.auth().createUser(withEmail: email, password: password)
    }, resetPassword: { email in
        try await Auth.auth().sendPasswordReset(withEmail: email)
    })
}
