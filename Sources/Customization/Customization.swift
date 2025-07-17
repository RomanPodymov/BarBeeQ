//
//  Customization.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 17/07/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import SwiftUI

struct CustomField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 50)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .cornerRadius(16)
            .padding([.leading, .trailing], 24)
    }
}

extension View {
    func asCustomField() -> some View {
        modifier(CustomField())
    }
}
