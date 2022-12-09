import SwiftUI

public extension Backport where Wrapped: View {
    @available(iOS, deprecated: 16.0)
    @ViewBuilder
    func fontWeight(_ weight: Font.Weight?) -> some View {
        if #available(iOS 16, *) {
            content.fontWeight(weight)
        } else if let weight {
            content.modifier(FontWeight(weight: weight))
        } else {
            content
        }
    }
}

fileprivate struct FontWeight: ViewModifier {
    @Environment(\.font) private var font
    var weight: Font.Weight
    
    func body(content: Content) -> some View {
        content
            .font((font ?? .body).weight(weight))
    }
}
