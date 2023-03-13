import SwiftUI

#if canImport(UIKit)
public extension UISheetPresentationController.Detent.Identifier {
    static func fraction(_ value: CGFloat) -> Self {
        .init("Fraction:\(String(format: "%.1f", value))")
    }

    static func height(_ value: CGFloat) -> Self {
        .init("Height:\(value)")
    }
}
#endif
