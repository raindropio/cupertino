import SwiftUI

struct ButtonBaseModifier: ViewModifier {
    @Environment(\.controlSize) private var controlSize
    @Environment(\.isEnabled) private var isEnabled
    
    static let height: [ControlSize: CGFloat]   = [.large: 50,  .regular: 38,   .small: 30, .mini: 30]
    static let padding: [ControlSize: CGFloat]  = [.large: 16,  .regular: 14,   .small: 10, .mini: 10]
    static let corner: [ControlSize?: CGFloat]  = [.large: 10,  .regular: 8,    .small: 15, .mini: 15, nil: 15]

    var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .font(controlSize == .small ? .callout : .body)
            .lineLimit(1)
            .padding(.horizontal, Self.padding[controlSize])
            .frame(height: Self.height[controlSize])
            .fixedSize()
            .opacity(isEnabled ? 1 : 0.4)
    }
}
