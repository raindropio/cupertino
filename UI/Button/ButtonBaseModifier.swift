import SwiftUI

struct ButtonBaseModifier: ViewModifier {
    @Environment(\.controlSize) private var controlSize
    @Environment(\.isEnabled) private var isEnabled
    
    #if canImport(UIKit)
    static let height: [ControlSize: CGFloat]           = [.large: 50,  .regular: 38,   .small: 30, .mini: 30]
    static let padding: [ControlSize: CGFloat]          = [.large: 16,  .regular: 14,   .small: 10, .mini: 10]
    static let corner: [ControlSize?: CGFloat]          = [.large: 10,  .regular: 8,    .small: 15, .mini: 15, nil: 15]
    #else
    static let height: [ControlSize: CGFloat]           = [.large: 28,  .regular: 20,   .small: 16, .mini: 12]
    static let padding: [ControlSize: CGFloat]          = [.large: 8,   .regular: 8,    .small: 6,  .mini: 4]
    static let corner: [ControlSize?: CGFloat]          = [.large: 6,   .regular: 6,    .small: 4,  .mini: 2, nil: 2]
    #endif
    static let font: [ControlSize: Font]                = [.large: .body,   .regular: .body,    .small: .callout,   .mini: .subheadline]
    static let imageScale: [ControlSize?: Image.Scale]  = [.large: .medium, .regular: .medium,  .small: .medium,    .mini: .small, nil: .medium]
    
    var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .font(Self.font[controlSize])
            .imageScale(Self.imageScale[controlSize]!)
            .lineLimit(1)
            .padding(.horizontal, Self.padding[controlSize])
            .frame(height: Self.height[controlSize])
            .fixedSize()
            .opacity(isEnabled ? 1 : 0.4)
    }
}
