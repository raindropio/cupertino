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
    
    private var size: Double {
        switch controlSize {
        case .large: return 8
        case .regular: return 0
        case .mini, .small: return -4
        @unknown default: return 0
        }
    }
    
    func body(content: Content) -> some View {
        content
            .font(controlSize == .small ? .callout : .body)
            .labelStyle(ChipLabelStyle())
            .padding(.horizontal, 14 + size)
            .padding(.vertical, 8 + size)
            .fixedSize()
            .background(.tint.opacity(0.2), in: Capsule())
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
