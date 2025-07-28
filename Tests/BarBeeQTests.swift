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
    @Test
    func testAddLocation() async throws {
        // Given
        @Dependency(\.locationsClient) var locationsClient
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

    @MainActor
    @Test
    func fullAddLocationReducerNameChanged() async throws {
        // Given
        let someName = "Hello"
        let store: StoreOf<FullAddLocationReducer> = .init(initialState: .initialState) {
            FullAddLocationReducer()
        }

        // When
        let name = await withCheckedContinuation { continuation in
            var cancellable: Any!
            cancellable = store.publisher.sink { state in
                if state.custom.name == someName, cancellable != nil {
                    continuation.resume(returning: someName)
                    cancellable = nil
                }
            }
            store.send(.custom(.nameChanged(someName)))
        }

        // Then
        #expect(name == someName)
    }
}
