//
//  BarBeeQTests.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 29/06/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

@testable import BarBeeQApp
import ComposableArchitecture
import Testing

@Suite
struct BarBeeQTests {
    @Dependency(\.locationsClient) var locationsClient

    @Test
    func test() async throws {
        // Given
        let nextLocation = BarBeeQLocation(
            name: "name",
            location: .init(latitude: 1, longitude: 2),
            photo: nil
        )

        // When
        let locationsBeforeAdd = try await locationsClient.locations()
        try await locationsClient.addLocation(nextLocation)
        let locationsAfterAdd = try await locationsClient.locations()

        // Then
        #expect(!locationsBeforeAdd.contains(nextLocation))
        #expect(locationsAfterAdd.contains(nextLocation))
    }
}
