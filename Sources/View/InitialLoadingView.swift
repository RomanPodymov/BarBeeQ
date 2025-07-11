//
//  InitialLoadingView.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 09/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

struct InitialLoadingView: View {
    var store: StoreOf<InitialLoadingReducer>

    var body: some View {
        ProgressView()
            .onAppear {
                store.send(.onAppear)
            }
    }
}
