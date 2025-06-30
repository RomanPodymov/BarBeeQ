//
//  LocationsClient.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 26/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import MapKit

struct BarBeeQLocation: Equatable, Hashable, Identifiable, Sendable {
    var id: String {
        name
    }

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name &&
            lhs.location.latitude == rhs.location.latitude &&
            lhs.location.longitude == rhs.location.longitude
    }

    let name: String
    let location: CLLocationCoordinate2D

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@DependencyClient
struct LocationsClient {
    typealias LocationsProvider = @Sendable () async throws -> [BarBeeQLocation]
    typealias LocationAddProvider = @Sendable (BarBeeQLocation) async throws -> Void

    var locations: LocationsProvider
    var addLocation: LocationAddProvider
}

extension DependencyValues {
    var locationsClient: LocationsClient {
        get { self[LocationsClient.self] }
        set { self[LocationsClient.self] = newValue }
    }
}
