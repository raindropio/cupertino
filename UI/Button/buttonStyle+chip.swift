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
    var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .labelStyle(ChipLabelStyle())
            .modifier(ButtonBaseModifier())
            .background(
                .tint.opacity(isPressed ? 0.4 : 0.2),
                in: RoundedRectangle(cornerRadius: ButtonBaseModifier.corner[controlSize]!, style: .continuous)
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
