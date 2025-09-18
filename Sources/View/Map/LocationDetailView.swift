//
//  LocationDetailView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 10/09/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct LocationDetailView: View {
    var store: StoreOf<LocationDetailReducer>

    var body: some View {
        Text(store.location.name)
    }
}
