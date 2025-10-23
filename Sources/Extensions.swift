//
//  Extensions.swift
//  BarBeeQ
//
//  Created by Roman Podymov on 12/08/2025.
//  Copyright © 2025 BarBeeQ. All rights reserved.
//

import SwiftUI
import UIKit

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let newSize = CGSize(width: size.width * percentage, height: size.height * percentage)

        return preparingThumbnail(of: newSize)
    }

    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data? {
        let bytes = kb * 1024
        let threshold = Int(CGFloat(bytes) * (1 + allowedMargin))
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        while let data = holderImage.pngData() {
            let ratio = data.count / bytes
            if data.count < threshold {
                return data
            } else {
                let multiplier = CGFloat((ratio / 5) + 1)
                compression -= (step * multiplier)

                guard let newImage = resized(withPercentage: compression) else { break }
                holderImage = newImage
            }
        }

        return nil
    }
}

/// https://stackoverflow.com/a/79779122/2229783
extension View {
    /// ios26 is not responding to Map tap gestures - this is a workaround
    func onTapGestureBugFix(_ action: @escaping (CGPoint) -> Void) -> some View {
        modifier(TapGestureModifier(action: action))
    }
}

struct TapGestureModifier: ViewModifier {
    var action: (CGPoint) -> Void
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.simultaneousGesture(SpatialTapGesture().onEnded { event in
                action(event.location)
            })
        } else {
            content.onTapGesture { location in
                action(location)
            }
        }
    }
}
