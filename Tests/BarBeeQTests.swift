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
    func some() async throws {
        try await locationsClient.locations()
    }
}
