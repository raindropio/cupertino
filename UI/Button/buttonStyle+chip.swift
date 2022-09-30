import SwiftUI

public extension ButtonStyle where Self == ChipButtonStyle {
    static var chip: Self {
        return .init()
    }
}

public struct ChipButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(ChipButtonLabelStyle())
            .background(
                .foreground
                    .opacity(configuration.isPressed ? 0.2 : (colorScheme == .light ? 0.06 : 0.1))
            )
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .opacity(isEnabled ? 1 : 0.4)
            .hoverEffect(.lift)
    }
}

fileprivate struct ChipButtonLabelStyle: LabelStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 14) {
            configuration.icon
                .frame(width: 20, height: 20)
            configuration.title
        }
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
    }
}
