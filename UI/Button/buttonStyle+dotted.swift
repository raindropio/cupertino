import SwiftUI
import CoreHaptics

public extension ButtonStyle where Self == DottedButtonStyle {
    static var dotted: Self {
        return .init()
    }
}

public extension MenuStyle where Self == DottedMenuButtonStyle {
    static var dotted: Self {
        return .init()
    }
}

fileprivate struct DottedStyleModifier: ViewModifier {
    @Environment(\.controlSize) private var controlSize
    var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .labelStyle(DottedLabelStyle())
            .modifier(ButtonBaseModifier())
            .background(
                RoundedRectangle(cornerRadius: ButtonBaseModifier.corner[controlSize]!, style: .continuous)
                    .strokeBorder(style: StrokeStyle(lineWidth: 0.5, dash: [2]))
                    .foregroundStyle(.tint.opacity(isPressed ? 1 : 0.5))
            )
            .contentShape(Rectangle())
    }
}

fileprivate struct DottedLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.icon
                .foregroundStyle(.tint)
            configuration.title
        }
    }
}

public struct DottedButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .modifier(DottedStyleModifier(isPressed: configuration.isPressed))
    }
}

public struct DottedMenuButtonStyle: MenuStyle {
    public func makeBody(configuration: Configuration) -> some View {
        Menu(configuration)
            .modifier(DottedStyleModifier())
    }
}
