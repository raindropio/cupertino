import SwiftUI
import CoreHaptics

public extension ButtonStyle where Self == ChipButtonStyle {
    static var chip: Self {
        return .init()
    }
}

public extension MenuStyle where Self == ChipMenuButtonStyle {
    static var chip: Self {
        return .init()
    }
}

fileprivate struct ChipStyleModifier: ViewModifier {
    @Environment(\.controlSize) private var controlSize
    @Environment(\.isEnabled) private var isEnabled
    private static let height: [ControlSize: CGFloat]   = [.large: 50,  .regular: 40,   .small: 30, .mini: 30]
    private static let padding: [ControlSize: CGFloat]  = [.large: 16,  .regular: 14,   .small: 10, .mini: 10]
    private static let corner: [ControlSize: CGFloat]   = [.large: 8,   .regular: 6,    .small: 15, .mini: 15]

    var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .font(controlSize == .small ? .callout : .body)
            .lineLimit(1)
            .labelStyle(ChipLabelStyle())
            .padding(.horizontal, Self.padding[controlSize])
            .frame(height: Self.height[controlSize])
            .fixedSize()
            .opacity(isEnabled ? 1 : 0.4)
            .background(
                .tint.opacity(isPressed ? 0.4 : 0.2),
                in: RoundedRectangle(cornerRadius: Self.corner[controlSize] ?? Self.corner[.small]!, style: .continuous)
            )
            .contentShape(Rectangle())
    }
}

fileprivate struct ChipLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .foregroundStyle(.tint)
            configuration.title
        }
    }
}

public struct ChipButtonStyle: ButtonStyle {    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(ChipStyleModifier(isPressed: configuration.isPressed))
    }
}

public struct ChipMenuButtonStyle: MenuStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .modifier(ChipStyleModifier())
    }
}
